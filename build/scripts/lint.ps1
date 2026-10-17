#requires -Version 7
<#
.SYNOPSIS
  Structure lint for the DITA sources: files, identifiers, metadata, platform tokens, keys,
  images, diagram links, disclosure patterns and help-map coverage.

.DESCRIPTION
  The checks the plan puts in scripts (authoring standards, section 13; platform strategy,
  section 10; build and quality, section 4). Prose rules are Vale's job (.vale.ini). Each manual
  is read as its DITAVAL filter would read it, so keys and images are checked per manual, and
  the applicability matrix (topic by manual) is written as CSV.

  Exits 1 on any failure. Copyright 2026 Oughtibridge Ltd, Apache-2.0.

.PARAMETER Source
  Folders holding DITA sources. Default: build/fixtures/wp1 and content. A folder with no
  maps is skipped.

.PARAMETER Matrix
  Where to write the applicability matrix. Default out/applicability-matrix.csv.
#>
[CmdletBinding()]
param(
    [string[]]$Source = @('build/fixtures/wp1', 'content'),
    [string]$Matrix = 'out/applicability-matrix.csv'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'UftiBuild.psm1') -Force
$root = Get-UftiRepoRoot
$failures = [System.Collections.Generic.List[string]]::new()
$notes = [System.Collections.Generic.List[string]]::new()
function Fail { param([string]$Message, [string]$File) $failures.Add($(if ($File) { "$File`: $Message" } else { $Message })); Write-UftiProblem $Message -File $File }
function Note { param([string]$Message) $notes.Add($Message); Write-Host "  note: $Message" }
function Rel { param([string]$Path) [System.IO.Path]::GetRelativePath($root, $Path) -replace '\\', '/' }

# ---- The platform catalogue, read from the DITAVAL filters (one per manual) -------------------

$deviceTokens = @('AndroidPhone', 'AndroidTablet', 'iPhone', 'iPad', 'WindowsWinUI')
$osTokens = @('Android', 'iOS')
$groupTokens = @('Phone', 'Tablet', 'Mobile', 'Touch', 'Desktop', 'Pointer')
$catalogue = $deviceTokens + $osTokens + $groupTokens
$manuals = [ordered]@{}
foreach ($dv in Get-ChildItem -LiteralPath (Join-Path $root 'build' 'ditaval') -Filter '*.ditaval' | Sort-Object Name) {
    [xml]$x = Get-Content -LiteralPath $dv.FullName -Raw
    $tokens = @($x.val.prop | Where-Object { $_.action -eq 'include' -and $_.val } | ForEach-Object { $_.val })
    foreach ($t in $tokens) { if ($catalogue -notcontains $t) { Fail "token '$t' is not in the platform catalogue" (Rel $dv.FullName) } }
    $manuals[$dv.BaseName] = $tokens
}

# ---- XML reading without DTDs (the DOCTYPEs point at the toolkit's DTDs) ---------------------

function Read-Xml {
    param([string]$Path)
    $settings = [System.Xml.XmlReaderSettings]::new()
    $settings.DtdProcessing = [System.Xml.DtdProcessing]::Ignore
    $settings.XmlResolver = $null
    $reader = [System.Xml.XmlReader]::Create($Path, $settings)
    try { $doc = [System.Xml.XmlDocument]::new(); $doc.Load($reader); $doc } finally { $reader.Dispose() }
}

function Test-Included {
    # Is an element kept by a manual's filter? No @platform: yes. Otherwise any of its tokens
    # must be one the manual includes (DITA's rule: an element with several values is kept if
    # any is included).
    param([System.Xml.XmlElement]$Element, [string[]]$Tokens)
    $p = $Element.GetAttribute('platform')
    if (-not $p) { return $true }
    foreach ($t in ($p -split '\s+' | Where-Object { $_ })) { if ($Tokens -contains $t) { return $true } }
    $false
}

# ---- Walk one manual's maps as its filter sees them ------------------------------------------

function Read-Manual {
    param([string]$MapPath, [string[]]$Tokens)
    $m = [pscustomobject]@{
        Topics = [System.Collections.Generic.List[string]]::new()     # topic files in the navigation or reachable
        Keys = [ordered]@{}                                            # key -> @{ Href; File; Alt; Keyword; Map }
        KeyRefs = [System.Collections.Generic.List[object]]::new()    # @{ Key; File } from maps (reltable and the like)
        Maps = [System.Collections.Generic.List[string]]::new()
    }
    $script:walk = $null
    $walk = {
        param([string]$Path)
        if ($m.Maps -contains $Path) { return }
        $m.Maps.Add($Path)
        $doc = Read-Xml $Path
        $dir = Split-Path -Parent $Path
        # every element with keys, href or keyref, in document order, kept by the filter and by
        # its filtered ancestors
        foreach ($e in $doc.SelectNodes('//*[@keys or @href or @keyref]')) {
            $skip = $false
            $a = $e
            while ($a -is [System.Xml.XmlElement]) { if (-not (Test-Included $a $Tokens)) { $skip = $true; break }; $a = $a.ParentNode }
            if ($skip) { continue }
            $name = $e.LocalName
            $href = $e.GetAttribute('href')
            $keys = $e.GetAttribute('keys')
            $keyref = $e.GetAttribute('keyref')
            $format = $e.GetAttribute('format')
            $target = if ($href -and $e.GetAttribute('scope') -ne 'external') { [System.IO.Path]::GetFullPath((Join-Path $dir ($href -split '#')[0])) } else { $null }
            if ($name -eq 'mapref' -or $format -eq 'ditamap') {
                if ($keyref) { Fail "mapref by key is forbidden (DITA-OT 4.4 does not resolve keys inside it)" (Rel $Path) }
                if ($name -ne 'mapref' -and $keys) { Fail "a key that names a map ('$keys') is forbidden" (Rel $Path) }
                if ($target) { if (Test-Path -LiteralPath $target) { & $walk $target } else { Fail "map not found: $href" (Rel $Path) } }
                continue
            }
            if ($keys) {
                foreach ($k in ($keys -split '\s+' | Where-Object { $_ })) {
                    if ($m.Keys.Contains($k)) { continue }   # first definition wins
                    $alt = $null; $kw = $null
                    $lt = $e.SelectSingleNode('topicmeta/linktext'); if ($lt) { $alt = $lt.InnerText.Trim() }
                    $kn = $e.SelectSingleNode('topicmeta/keywords/keyword'); if ($kn) { $kw = $kn.InnerText.Trim() }
                    $m.Keys[$k] = @{ Href = $href; File = $target; Alt = $alt; Keyword = $kw; Map = $Path; Element = $name }
                }
            }
            if ($keyref -and -not $keys) { $m.KeyRefs.Add(@{ Key = $keyref; File = $Path }) }
            if ($target -and $href -match '\.dita$' -and $e.GetAttribute('processing-role') -ne 'resource-only' -and $name -ne 'keydef') {
                if (-not (Test-Path -LiteralPath $target)) { Fail "topic not found: $href" (Rel $Path) }
                elseif ($m.Topics -notcontains $target) { $m.Topics.Add($target) }
            }
        }
    }
    & $walk $MapPath
    $m
}

# ---- Topic checks ----------------------------------------------------------------------------

$categories = @('Get started', 'How-to', 'Concept', 'Reference', 'Troubleshooting', 'Good practice', 'Glossary')
$topicTypes = @('concept', 'task', 'reference', 'troubleshooting', 'glossentry')
$disclosure = @(
    @{ Pattern = '[A-Za-z]:\\Users\\|/home/[a-z]|/Users/[a-z]'; Why = 'a local path' },
    @{ Pattern = 'github\.com/(?!oughnic/uFTi-Docs)[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+'; Why = 'another repository' },
    @{ Pattern = '(?<![\w/])#\d+\b'; Why = 'an issue or pull request number' },
    @{ Pattern = '\b(TODO|FIXME|XXX)\b'; Why = 'a work marker' }
)

function Test-Topic {
    param([string]$Path, [string]$SourceRoot)
    $rel = Rel $Path
    $stem = [System.IO.Path]::GetFileNameWithoutExtension($Path)
    $doc = Read-Xml $Path
    $rootEl = $doc.DocumentElement
    if ($topicTypes -notcontains $rootEl.LocalName) { Fail "root element '$($rootEl.LocalName)' is not one of $($topicTypes -join ', ')" $rel; return $null }
    if ($rootEl.GetAttribute('id') -ne $stem) { Fail "id '$($rootEl.GetAttribute('id'))' does not match the file name '$stem'" $rel }
    if ($rootEl.GetAttribute('xml:lang') -ne 'en-GB') { Fail "xml:lang is not en-GB on the root element" $rel }
    $isGloss = $rootEl.LocalName -eq 'glossentry'
    $titleNode = if ($isGloss) { $rootEl.SelectSingleNode('glossterm') } else { $rootEl.SelectSingleNode('title') }
    if (-not $titleNode -or -not $titleNode.InnerText.Trim()) { Fail "no title" $rel }
    elseif ($titleNode.InnerText.Trim().Length -gt 70) { Fail "title is longer than 70 characters" $rel }
    elseif ($titleNode.InnerText.Trim() -match '\.$') { Fail "title ends with a full stop" $rel }
    if (-not $isGloss) {
        $sd = $rootEl.SelectSingleNode('shortdesc')
        if (-not $sd -or -not $sd.InnerText.Trim()) { Fail "no shortdesc" $rel }
        elseif (($sd.InnerText.Trim() -split '\s+').Count -gt 30) { Fail "shortdesc is over 30 words; aim for 25 or fewer" $rel }
        $cat = $rootEl.SelectSingleNode('prolog/metadata/category')
        if (-not $cat) { Fail "no category in prolog/metadata (one of: $($categories -join ', '))" $rel }
        elseif ($categories -notcontains $cat.InnerText.Trim()) { Fail "category '$($cat.InnerText.Trim())' is not in the controlled list" $rel }
        $titleWords = @(($titleNode.InnerText.ToLowerInvariant() -split '[^a-z0-9]+') | Where-Object { $_ })
        foreach ($kw in $rootEl.SelectNodes('prolog/metadata/keywords/keyword')) {
            $w = @(($kw.InnerText.ToLowerInvariant() -split '[^a-z0-9]+') | Where-Object { $_ })
            if ($w.Count -eq 1 -and $titleWords -contains $w[0]) { Fail "keyword '$($kw.InnerText)' only repeats a word of the title" $rel }
        }
    }
    # metadata never names a person; a screen identifier is ours
    foreach ($r in $rootEl.SelectNodes('prolog/resourceid')) { if ($r.GetAttribute('appname') -ne 'ufti') { Fail "resourceid appname must be 'ufti'" $rel } }
    foreach ($a in $rootEl.SelectNodes('prolog/author')) { Fail "a person or author in metadata ('$($a.InnerText)'): metadata names nobody" $rel }
    # markup rules
    foreach ($e in $rootEl.SelectNodes('//*[@chunk]')) { if ($e.GetAttribute('chunk') -match 'to-content') { Fail "chunk='to-content' is forbidden" $rel } }
    foreach ($x in $rootEl.SelectNodes('//xref[@href] | //link[@href]')) {
        if ($x.GetAttribute('scope') -ne 'external' -and $x.GetAttribute('href') -match '\.dita') { Fail "link to a topic by href ('$($x.GetAttribute('href'))'): link by keyref" $rel }
        if ($x.GetAttribute('scope') -eq 'external' -and $x.GetAttribute('format') -ne 'html') { Fail "external link without format='html'" $rel }
    }
    foreach ($img in $rootEl.SelectNodes('//image')) {
        $alt = $img.SelectSingleNode('alt')
        if (-not $img.GetAttribute('keyref') -and (-not $alt -or -not $alt.InnerText.Trim())) { Fail "image without alternative text (an alt element, or a keyref whose key has linktext)" $rel }
        if ($alt -and $alt.InnerText -match '^\s*(Image|Screenshot|Picture) of') { Fail "alternative text starts 'Image of' or 'Screenshot of'" $rel }
    }
    # platform tokens
    $platforms = [System.Collections.Generic.HashSet[string]]::new()
    $underPlatforms = $rel -match '/platforms/'
    foreach ($e in $rootEl.SelectNodes('//*[@platform]')) {
        foreach ($t in ($e.GetAttribute('platform') -split '\s+' | Where-Object { $_ })) {
            [void]$platforms.Add($t)
            if ($catalogue -notcontains $t) { Fail "platform token '$t' is not in the catalogue" $rel }
            elseif (($deviceTokens + $osTokens) -contains $t -and -not $underPlatforms) { Fail "platform or device token '$t' used outside platforms/ (DEC-032: idiom first, platform at the edges)" $rel }
        }
    }
    foreach ($e in $rootEl.SelectNodes('//*[@props or @otherprops or @audience or @rev]')) { Fail "conditional attribute other than @platform on <$($e.LocalName)> (platform strategy, section 2.1)" $rel }
    if ($platforms.Count -gt 3) { Fail "more than three @platform variants in one topic ($($platforms.Count)): split it (variant budget)" $rel }
    # disclosure patterns, in text and comments alike
    $raw = Get-Content -LiteralPath $Path -Raw
    foreach ($d in $disclosure) { $mm = [regex]::Match($raw, $d.Pattern); if ($mm.Success) { Fail "looks like $($d.Why): '$($mm.Value)'" $rel } }
    # what the topic needs: keys, diagrams
    $keyrefs = @($rootEl.SelectNodes('//*[@keyref]') | ForEach-Object { $_.GetAttribute('keyref') -replace '/.*$', '' } | Sort-Object -Unique)
    $svgs = @($rootEl.SelectNodes('//svgref[@href]') | ForEach-Object { $_.GetAttribute('href') })
    [pscustomobject]@{ Path = $Path; Rel = $rel; KeyRefs = $keyrefs; Svgs = $svgs; ResourceIds = @($rootEl.SelectNodes('prolog/resourceid') | ForEach-Object { $_.GetAttribute('appid') }); Platforms = @($platforms) }
}

function Test-Svg {
    # A diagram: a title and a description, real text, and links that resolve from the page that
    # shows it (the plugin inlines the file and leaves cross-document links as written).
    param([string]$SvgPath, [string]$FromTopic)
    $rel = Rel $SvgPath
    $doc = Read-Xml $SvgPath
    $ns = [System.Xml.XmlNamespaceManager]::new($doc.NameTable); $ns.AddNamespace('s', 'http://www.w3.org/2000/svg'); $ns.AddNamespace('xlink', 'http://www.w3.org/1999/xlink')
    if (-not $doc.SelectSingleNode('/s:svg/s:title', $ns)) { Fail "diagram has no title" $rel }
    if (-not $doc.SelectSingleNode('/s:svg/s:desc', $ns)) { Fail "diagram has no desc" $rel }
    if (-not $doc.SelectSingleNode('//s:text', $ns)) { Fail "diagram has no text element: text must be real text, not outlines" $rel }
    if ($doc.SelectSingleNode('//s:script | //s:foreignObject', $ns)) { Fail "diagram carries a script or foreignObject" $rel }
    foreach ($a in 'aria-labelledby', 'aria-describedby') { if ($doc.SelectSingleNode("//*[@$a]")) { Fail "diagram uses $a, which points at nothing once the plugin prefixes the ids: use title and desc, and let the figure title name it" $rel } }
    $ids = @($doc.SelectNodes('//*[@id]') | ForEach-Object { $_.GetAttribute('id') })
    $pageDir = Split-Path -Parent $FromTopic
    foreach ($a in $doc.SelectNodes('//s:a', $ns)) {
        $h = $a.GetAttribute('href'); if (-not $h) { $h = $a.GetAttribute('href', 'http://www.w3.org/1999/xlink') }
        if (-not $h) { Fail "a link in the diagram has no href" $rel; continue }
        if ($h -match '^(https?:|mailto:)') { Note "$rel links outside the site: $h (checked by the link check on the built site)"; continue }
        if ($h -match '^javascript:') { Fail "a link that runs code: $h" $rel; continue }
        $file, $frag = $h -split '#', 2
        if (-not $file) { if ($ids -notcontains $frag) { Fail "fragment link #$frag has no target in the diagram" $rel }; continue }
        $target = [System.IO.Path]::GetFullPath((Join-Path $pageDir ($file -replace '\.html$', '.dita')))
        if (-not (Test-Path -LiteralPath $target)) { Fail "link '$h' does not reach a topic from $(Rel $FromTopic) (written as an .html address relative to that page)" $rel }
    }
}

# ---- Run over each source root ---------------------------------------------------------------

$matrixRows = [System.Collections.Generic.List[string]]::new()
$matrixRows.Add('topic,' + ($manuals.Keys -join ','))
$checked = 0

foreach ($src in $Source) {
    $srcRoot = if ([System.IO.Path]::IsPathRooted($src)) { $src } else { Join-Path $root $src }
    if (-not (Test-Path -LiteralPath $srcRoot)) { continue }
    $maps = @(Get-ChildItem -LiteralPath $srcRoot -Recurse -Filter '*.ditamap')
    if ($maps.Count -eq 0) { Write-Host "  $src`: no maps, skipped"; continue }
    Write-UftiStep "Lint $src"
    # file and folder names
    foreach ($f in Get-ChildItem -LiteralPath $srcRoot -Recurse -File | Where-Object { $_.Extension -ne '.md' }) {   # Markdown documents (README.md, the dataset) are not DITA sources
        if ($f.Name -notmatch '^[a-z0-9][a-z0-9-]*(\.[a-z0-9]+)+$') { Fail "file name is not lower case with hyphens" (Rel $f.FullName) }
    }
    foreach ($d in Get-ChildItem -LiteralPath $srcRoot -Recurse -Directory) {
        if ($d.Name -notmatch '^[a-z0-9][a-z0-9-]*$') { Fail "folder name is not lower case with hyphens" (Rel $d.FullName) }
    }
    # topics
    $topics = @{}
    foreach ($f in Get-ChildItem -LiteralPath $srcRoot -Recurse -Filter '*.dita') {
        $t = Test-Topic $f.FullName $srcRoot
        if ($t) { $topics[$f.FullName] = $t }
        $checked++
    }
    # maps that are not a manual's root: the rules that apply to every map
    foreach ($mp in $maps) {
        $raw = Get-Content -LiteralPath $mp.FullName -Raw
        if ($raw -match 'chunk="[^"]*to-content') { Fail "chunk='to-content' is forbidden" (Rel $mp.FullName) }
        if ($raw -match '<mapref[^>]*\skeyref=') { Fail "mapref by key is forbidden" (Rel $mp.FullName) }
        if ($raw -match 'xml:lang="(?!en-GB)') { Fail "xml:lang is not en-GB" (Rel $mp.FullName) }
        foreach ($d in $disclosure) { $mm = [regex]::Match($raw, $d.Pattern); if ($mm.Success) { Fail "looks like $($d.Why): '$($mm.Value)'" (Rel $mp.FullName) } }
    }
    # each manual: its root bookmap is named for its slug
    $used = [System.Collections.Generic.HashSet[string]]::new()
    $usedImages = [System.Collections.Generic.HashSet[string]]::new()
    $usedSvgs = [System.Collections.Generic.HashSet[string]]::new()
    $imageKeysByManual = [ordered]@{}
    $included = @{}
    # a manual may have several root maps at the publication root (its manual, its Quick Start):
    # each is a publication of its own, so each is read on its own and the topics are pooled
    $roots = foreach ($slug in $manuals.Keys) {
        foreach ($rm in @($maps | Where-Object { $_.Name -like "*-$slug.ditamap" -and $_.Directory.FullName -eq $srcRoot } | Sort-Object Name)) { [pscustomobject]@{ Slug = $slug; Map = $rm } }
    }
    foreach ($r in $roots) {
        $slug = $r.Slug
        $tokens = $manuals[$slug]
        $m = Read-Manual $r.Map.FullName $tokens
        Write-Host "  $slug`: $($r.Map.Name): $($m.Topics.Count) topics, $($m.Keys.Count) keys ($($tokens -join ' '))"
        $included[$slug] = @(@($(if ($included.ContainsKey($slug)) { $included[$slug] })) + @($m.Topics) | Where-Object { $_ } | Select-Object -Unique)
        foreach ($t in $m.Topics) { [void]$used.Add($t) }
        # keys the maps themselves use (relationship tables, keyref topicrefs)
        foreach ($kr in $m.KeyRefs) { if (-not $m.Keys.Contains($kr.Key)) { Fail "key '$($kr.Key)' is not defined in the $slug manual" (Rel $kr.File) } }
        # keys the topics use, and images
        foreach ($tp in $m.Topics) {
            if (-not $topics.ContainsKey($tp)) { continue }
            $info = $topics[$tp]
            foreach ($k in $info.KeyRefs) {
                if (-not $m.Keys.Contains($k)) { Fail "key '$k' is not defined in the $slug manual" $info.Rel; continue }
                $def = $m.Keys[$k]
                if ($k -like 'img-*') {
                    if (-not $def.File -or -not (Test-Path -LiteralPath $def.File)) { Fail "image key '$k' points at a missing file in the $slug manual ($($def.Href))" (Rel $def.Map) }
                    else { [void]$usedImages.Add($def.File) }
                    if (-not $def.Alt) { Fail "image key '$k' has no linktext, so the picture would have no alternative text in the $slug manual" (Rel $def.Map) }
                    elseif ($def.Alt -match '^(Image|Screenshot|Picture) of') { Fail "image key '$k' linktext starts 'Screenshot of'" (Rel $def.Map) }
                }
                elseif ($k -like 'ui-*' -or $k -like 'product-*') { if (-not $def.Keyword) { Fail "key '$k' has no keyword text in the $slug manual" (Rel $def.Map) } }
            }
            foreach ($s in $info.Svgs) {
                $svgPath = [System.IO.Path]::GetFullPath((Join-Path (Split-Path -Parent $tp) $s))
                if (-not (Test-Path -LiteralPath $svgPath)) { Fail "diagram not found: $s" $info.Rel; continue }
                [void]$usedSvgs.Add($svgPath)
                Test-Svg $svgPath $tp
            }
        }
        $imageKeysByManual[$slug] = @(@($(if ($imageKeysByManual.Contains($slug)) { $imageKeysByManual[$slug] })) + @($m.Keys.Keys | Where-Object { $_ -like 'img-*' }) | Where-Object { $_ } | Select-Object -Unique)
    }
    if ($included.Count -eq 0) { Fail "no root bookmap named ufti-*-<slug>.ditamap at the publication root" (Rel $srcRoot); continue }
    # the applicability matrix, orphans, image key parity
    foreach ($tp in ($topics.Keys | Sort-Object)) {
        $cells = foreach ($slug in $manuals.Keys) { if ($included.ContainsKey($slug) -and $included[$slug] -contains $tp) { 'included' } elseif ($included.ContainsKey($slug)) { 'excluded' } else { 'no manual' } }
        $matrixRows.Add((Rel $tp) + ',' + ($cells -join ','))
        if (-not $used.Contains($tp)) { Fail "orphan: the topic is in no manual's navigation" (Rel $tp) }
    }
    foreach ($png in Get-ChildItem -LiteralPath $srcRoot -Recurse -Filter '*.png') { if (-not $usedImages.Contains($png.FullName)) { Fail "orphan: no key uses this picture" (Rel $png.FullName) } }
    foreach ($svg in Get-ChildItem -LiteralPath $srcRoot -Recurse -Filter '*.svg') { if (-not $usedSvgs.Contains($svg.FullName)) { Fail "orphan: no topic shows this diagram" (Rel $svg.FullName) } }
    $allImageKeys = @($imageKeysByManual.Values | ForEach-Object { $_ } | Sort-Object -Unique)
    foreach ($slug in $imageKeysByManual.Keys) { $missing = @($allImageKeys | Where-Object { $imageKeysByManual[$slug] -notcontains $_ }); if ($missing) { Note "$slug defines no image key for: $($missing -join ', ')" } }
    # idiom parity for one operating system: expected only for idiom-specific topics
    if ($included.ContainsKey('android-phone') -and $included.ContainsKey('android-tablet')) {
        $onlyPhone = @($included['android-phone'] | Where-Object { $included['android-tablet'] -notcontains $_ } | ForEach-Object { Rel $_ })
        $onlyTablet = @($included['android-tablet'] | Where-Object { $included['android-phone'] -notcontains $_ } | ForEach-Object { Rel $_ })
        if ($onlyPhone) { Note "Android phone only: $($onlyPhone -join ', ')" }
        if ($onlyTablet) { Note "Android tablet only: $($onlyTablet -join ', ')" }
    }
    # help-map coverage (DEC-028): every screen in the inventory has a topic with its identifier
    $screens = Join-Path $srcRoot 'screens.csv'
    if (Test-Path -LiteralPath $screens) {
        $ids = @($topics.Values | ForEach-Object { $_.ResourceIds } | Where-Object { $_ })
        foreach ($row in (Import-Csv -LiteralPath $screens)) {
            if ($ids -notcontains $row.screen_id) { Fail "screen '$($row.screen_id)' ($($row.screen_name)) has no topic with resourceid appid='$($row.screen_id)'" (Rel $screens) }
        }
        Write-Host "  help map: $((Import-Csv -LiteralPath $screens).Count) screen(s) in the inventory, $($ids.Count) topic identifier(s)"
    }
}

# ---- Report ----------------------------------------------------------------------------------

$matrixPath = if ([System.IO.Path]::IsPathRooted($Matrix)) { $Matrix } else { Join-Path $root $Matrix }
New-Item -ItemType Directory -Path (Split-Path -Parent $matrixPath) -Force | Out-Null
[System.IO.File]::WriteAllLines($matrixPath, $matrixRows)
Write-Host "`n  applicability matrix: $(Rel $matrixPath) ($($matrixRows.Count - 1) topics)"
if ($checked -eq 0) { Fail "no DITA topics found under $($Source -join ', '): nothing was checked" }
if ($failures.Count -eq 0) { Write-Host "PASS: lint found no problems in $checked topic(s)." -ForegroundColor Green; exit 0 }
Write-Host "FAIL: $($failures.Count) problem(s)." -ForegroundColor Red
exit 1
