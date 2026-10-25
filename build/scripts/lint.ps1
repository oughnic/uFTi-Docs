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

.PARAMETER Strict
  Also apply the rules that only real content must meet: labels by key (DEC-090) and the
  terminology list's coverage of every label key. The `content` folder is always strict. The
  throwaway fixture is not. test-source-rules.ps1 passes this switch for its small publications.

.PARAMETER Terminology
  The terminology list that every ui-* label key must appear in (strict sources only).
  Default authoring/terminology.md.

.PARAMETER ThemeCss
  The stylesheet whose tokens block holds the colours a diagram may use. Default build/theme/ufti.css.
#>
[CmdletBinding()]
param(
    [string[]]$Source = @('build/fixtures/wp1', 'content'),
    [string]$Matrix = 'out/applicability-matrix.csv',
    [switch]$Strict,
    [string]$Terminology = 'authoring/terminology.md',
    [string]$ThemeCss = 'build/theme/ufti.css'
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

$deviceTokens = @('AndroidPhone', 'AndroidTablet', 'iPhone', 'iPad', 'MacAppKit', 'WindowsWinUI')
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
$doctypes = @{ concept = 'DITA Concept'; task = 'DITA Task'; reference = 'DITA Reference'; troubleshooting = 'DITA Troubleshooting'; glossentry = 'DITA Glossary Entry'; map = 'DITA Map'; bookmap = 'DITA BookMap' }
$outputclasses = @('search-ignore', 'search-demote', 'landscape')                       # authoring standards, section 1
$experienceLevels = @('novice', 'general', 'expert')                                    # metadata vocabulary
$guideSections = @('Why it matters', 'What to do', 'Example', 'Common mistakes', 'In uFTi', 'Further reading')   # good practice strategy, section 8
$forbiddenElements = @('object', 'video', 'audio', 'draft-comment', 'required-cleanup')  # DEC-034 and no workflow in the source
$weakLinkText = '^(click here|here|read more|more|link|this link|this page|this)$'
$shortdescOpeners = '^(This|In this|Here)\s+(topic|task|page|section|chapter|guide|article)\b'
$helpIdPattern = '^[a-z][a-z0-9-]*(\.[a-z][a-z0-9-]*)*$'                               # area.screen, lower case (metadata vocabulary)
$disclosure = @(
    @{ Pattern = '[A-Za-z]:\\Users\\|/home/[a-z]|/Users/[a-z]'; Why = 'a local path' },
    @{ Pattern = 'github\.com/(?!oughnic/uFTi-Docs)[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+'; Why = 'another repository' },
    @{ Pattern = '(?<![\w/])#\d+\b'; Why = 'an issue or pull request number' },
    @{ Pattern = '\b(TODO|FIXME|XXX)\b'; Why = 'a work marker' }
)

function Get-Words { param([string]$Text) @(($Text -split '\s+') | Where-Object { $_ }).Count }

# the colours a diagram may use: the theme's tokens block, and nowhere else
$tokensPath = if ([System.IO.Path]::IsPathRooted($ThemeCss)) { $ThemeCss } else { Join-Path $root $ThemeCss }
$tokenColours = @()
if (Test-Path -LiteralPath $tokensPath) {
    $css = Get-Content -LiteralPath $tokensPath -Raw
    $block = [regex]::Match($css, '(?s)BEGIN TOKENS.*?END TOKENS').Value
    $tokenColours = @([regex]::Matches($block, '#[0-9A-Fa-f]{6}(?![0-9A-Fa-f])') | ForEach-Object { $_.Value.ToUpperInvariant() } | Sort-Object -Unique)
}

function Test-FileHeader {
    # The XML declaration, and a standard OASIS DOCTYPE that names the root element (DITA 1.3,
    # no specialisation).
    param([string]$Raw, [string]$RootName, [string]$Rel)
    if ($Raw -notmatch '^﻿?<\?xml version="1\.0" encoding="UTF-8"\?>') { Fail "the file does not start with the XML declaration <?xml version=""1.0"" encoding=""UTF-8""?>" $Rel }
    $m = [regex]::Match($Raw, '<!DOCTYPE\s+(\S+)\s+PUBLIC\s+"([^"]*)"')
    if (-not $m.Success) { Fail "no standard DOCTYPE: DITA 1.3 is written with the OASIS DTD (authoring standards, section 1)" $Rel; return }
    if ($m.Groups[1].Value -ne $RootName) { Fail "the DOCTYPE names '$($m.Groups[1].Value)' but the root element is '$RootName'" $Rel }
    elseif ($doctypes.ContainsKey($RootName) -and $m.Groups[2].Value -ne "-//OASIS//DTD $($doctypes[$RootName])//EN") { Fail "the DOCTYPE '$($m.Groups[2].Value)' is not the standard one for '$RootName' (no specialisation)" $Rel }
}

function Test-Topic {
    param([string]$Path, [string]$SourceRoot, [bool]$IsStrict)
    $rel = Rel $Path
    $stem = [System.IO.Path]::GetFileNameWithoutExtension($Path)
    $doc = Read-Xml $Path
    $rootEl = $doc.DocumentElement
    if ($topicTypes -notcontains $rootEl.LocalName) { Fail "root element '$($rootEl.LocalName)' is not one of $($topicTypes -join ', ')" $rel; return $null }
    $rawText = Get-Content -LiteralPath $Path -Raw
    Test-FileHeader $rawText $rootEl.LocalName $rel
    if ($rootEl.GetAttribute('id') -ne $stem) { Fail "id '$($rootEl.GetAttribute('id'))' does not match the file name '$stem'" $rel }
    if ($rootEl.GetAttribute('xml:lang') -ne 'en-GB') { Fail "xml:lang is not en-GB on the root element" $rel }
    $isGloss = $rootEl.LocalName -eq 'glossentry'
    $titleNode = if ($isGloss) { $rootEl.SelectSingleNode('glossterm') } else { $rootEl.SelectSingleNode('title') }
    $titleText = ''
    if (-not $titleNode -or -not $titleNode.InnerText.Trim()) { Fail "no title" $rel }
    else {
        $titleText = $titleNode.InnerText.Trim()
        if ($titleText.Length -gt 70) { Fail "title is longer than 70 characters" $rel }
        if ($titleText -match '\.$') { Fail "title ends with a full stop" $rel }
        if ($titleText -match '^(\d+[\.\)]?\s|(chapter|section|part|step)\s+\d+\b)') { Fail "title starts with a number ('$titleText'): the build numbers chapters and sections" $rel }
    }
    $body = $rootEl.SelectSingleNode('conbody|taskbody|refbody|troublebody')
    $category = $null
    if (-not $isGloss) {
        $sd = $rootEl.SelectSingleNode('shortdesc')
        if (-not $sd -or -not $sd.InnerText.Trim()) { Fail "no shortdesc" $rel }
        else {
            $sdText = ($sd.InnerText.Trim() -replace '\s+', ' ')
            if ((Get-Words $sdText) -gt 30) { Fail "shortdesc is over 30 words; aim for 25 or fewer" $rel }
            if ($sdText -match $shortdescOpeners) { Fail "shortdesc begins 'This topic' or the like: say what the topic is or does (authoring standards, section 4)" $rel }
            if ($titleText -and $sdText.TrimEnd('.') -ieq $titleText) { Fail "shortdesc only repeats the title" $rel }
            if ($sdText -match '[.!?]\s+\S') { Fail "shortdesc is more than one sentence (authoring standards, section 4)" $rel }
        }
        $cat = $rootEl.SelectSingleNode('prolog/metadata/category')
        if (-not $cat) { Fail "no category in prolog/metadata (one of: $($categories -join ', '))" $rel }
        elseif ($categories -notcontains $cat.InnerText.Trim()) { Fail "category '$($cat.InnerText.Trim())' is not in the controlled list" $rel }
        else { $category = $cat.InnerText.Trim() }
        $titleWords = @(($titleText.ToLowerInvariant() -split '[^a-z0-9]+') | Where-Object { $_ })
        foreach ($kw in $rootEl.SelectNodes('prolog/metadata/keywords/keyword')) {
            $w = @(($kw.InnerText.ToLowerInvariant() -split '[^a-z0-9]+') | Where-Object { $_ })
            if ($w.Count -eq 1 -and $titleWords -contains $w[0]) { Fail "keyword '$($kw.InnerText)' only repeats a word of the title" $rel }
        }
        foreach ($au in $rootEl.SelectNodes('prolog/metadata/audience')) {
            if ($au.GetAttribute('type') -and $au.GetAttribute('type') -ne 'user') { Fail "audience type '$($au.GetAttribute('type'))': use type=""user""" $rel }
            $lvl = $au.GetAttribute('experiencelevel')
            if ($lvl -and $experienceLevels -notcontains $lvl) { Fail "audience experiencelevel '$lvl' is not one of $($experienceLevels -join ', ')" $rel }
        }
    }
    # dates only when true: a real date, not in the future, and revised no earlier than created
    $created = $null
    foreach ($d in $rootEl.SelectNodes('prolog/critdates/created | prolog/critdates/revised')) {
        $v = if ($d.LocalName -eq 'created') { $d.GetAttribute('date') } else { $d.GetAttribute('modified') }
        $parsed = [datetime]::MinValue
        if (-not [datetime]::TryParseExact($v, 'yyyy-MM-dd', [cultureinfo]::InvariantCulture, [System.Globalization.DateTimeStyles]::None, [ref]$parsed)) { Fail "critdates $($d.LocalName) '$v' is not a date written YYYY-MM-DD" $rel; continue }
        if ($parsed.Date -gt [datetime]::UtcNow.Date) { Fail "critdates $($d.LocalName) '$v' is in the future" $rel }
        if ($d.LocalName -eq 'created') { $created = $parsed } elseif ($created -and $parsed -lt $created) { Fail "critdates revised '$v' is before created" $rel }
    }
    # metadata never names a person; a screen identifier is ours
    $helpIds = @()
    foreach ($r in $rootEl.SelectNodes('prolog/resourceid')) {
        if ($r.GetAttribute('appname') -ne 'ufti') { Fail "resourceid appname must be 'ufti'" $rel }
        $aid = $r.GetAttribute('appid')
        if ($aid -notmatch $helpIdPattern) { Fail "help identifier '$aid' is not area.screen in lower case with hyphens (metadata vocabulary)" $rel } else { $helpIds += $aid }
    }
    foreach ($a in $rootEl.SelectNodes('prolog/author')) { Fail "a person or author in metadata ('$($a.InnerText)'): metadata names nobody" $rel }
    # markup rules
    foreach ($e in $rootEl.SelectNodes('//*[@chunk]')) { if ($e.GetAttribute('chunk') -match 'to-content') { Fail "chunk='to-content' is forbidden" $rel } }
    foreach ($e in $rootEl.SelectNodes('//*[@outputclass]')) {
        foreach ($c in ($e.GetAttribute('outputclass') -split '\s+' | Where-Object { $_ })) { if ($outputclasses -notcontains $c) { Fail "outputclass '$c' is not one the plugin documents ($($outputclasses -join ', '))" $rel } }
    }
    foreach ($e in $rootEl.SelectNodes('//*[@status]')) { Fail "@status on <$($e.LocalName)>: workflow is recorded in issues and pull requests, never in the source" $rel }
    foreach ($name in $forbiddenElements) { if ($rootEl.SelectNodes("//$name").Count) { Fail "<$name> is not used (video and objects: DEC-034; comments and clean-up markers are workflow)" $rel } }
    foreach ($x in $rootEl.SelectNodes('//xref[@href] | //link[@href]')) {
        if ($x.GetAttribute('scope') -ne 'external' -and $x.GetAttribute('href') -match '\.dita') { Fail "link to a topic by href ('$($x.GetAttribute('href'))'): link by keyref" $rel }
        if ($x.GetAttribute('scope') -eq 'external' -and $x.GetAttribute('format') -ne 'html') { Fail "external link without format='html'" $rel }
    }
    foreach ($x in $rootEl.SelectNodes('//xref')) {
        $lt = ($x.InnerText -replace '\s+', ' ').Trim()
        if ($lt -match $weakLinkText) { Fail "link text '$lt' means nothing out of context (authoring standards, section 8)" $rel }
        if ($lt -match '^https?://') { Fail "link text is a bare address ('$lt')" $rel }
    }
    foreach ($img in $rootEl.SelectNodes('//image')) {
        $alt = $img.SelectSingleNode('alt')
        if (-not $img.GetAttribute('keyref') -and (-not $alt -or -not $alt.InnerText.Trim())) { Fail "image without alternative text (an alt element, or a keyref whose key has linktext)" $rel }
        if ($alt -and $alt.InnerText -match '^\s*(Image|Screenshot|Picture) of') { Fail "alternative text starts 'Image of' or 'Screenshot of'" $rel }
        if ($img.GetAttribute('href')) { Fail "image by href ('$($img.GetAttribute('href'))'): pictures are referenced by key (platform strategy, section 4)" $rel }
        if ($img.GetAttribute('placement') -ne 'inline' -and -not $img.SelectSingleNode('ancestor::fig')) { Fail "image outside a fig: the theme caps the height of a figure's picture in the PDF (DEC-082)" $rel }
    }
    foreach ($tb in $rootEl.SelectNodes('//table')) {
        if (-not $tb.SelectSingleNode('title')) { Fail "table without a title (authoring standards, section 7)" $rel }
        if (-not $tb.SelectSingleNode('tgroup/thead')) { Fail "table without a header row (thead)" $rel }
    }
    foreach ($tb in $rootEl.SelectNodes('//simpletable')) { if (-not $tb.SelectSingleNode('sthead')) { Fail "simple table without a header row (sthead)" $rel } }
    # the shape of each topic type (authoring standards, section 5)
    switch ($rootEl.LocalName) {
        'task' {
            $steps = @($rootEl.SelectNodes('taskbody/steps/step | taskbody/steps-unordered/step'))
            if (-not $rootEl.SelectSingleNode('taskbody/steps | taskbody/steps-unordered')) { Fail "a task has steps: put them first (authoring standards, section 5)" $rel }
            if ($steps.Count -gt 9) { Fail "$($steps.Count) steps: at most nine, so split the task" $rel }
            foreach ($cmd in $rootEl.SelectNodes('taskbody/steps/step/cmd | taskbody/steps-unordered/step/cmd')) {
                $n = Get-Words $cmd.InnerText
                if ($n -gt 25) { Fail "a step command of $n words: keep it to 25 or fewer and move detail to info" $rel }
            }
            foreach ($tb in $rootEl.SelectNodes('taskbody/steps//table | taskbody/steps//simpletable')) { Fail "a table inside a step (authoring standards, section 5)" $rel; break }
        }
        'concept' {
            if ($body -and (Get-Words $body.InnerText) -gt 500) { Fail "a concept of $(Get-Words $body.InnerText) words: aim for 500 or fewer, and split it" $rel }
            if ($category -eq 'Good practice') {
                foreach ($s in $rootEl.SelectNodes('conbody/section/title')) { if ($guideSections -notcontains $s.InnerText.Trim()) { Fail "good practice section title '$($s.InnerText.Trim())' is not one of: $($guideSections -join ', ')" $rel } }
            }
        }
        'troubleshooting' {
            if (-not $rootEl.SelectSingleNode('troublebody/condition')) { Fail "a troubleshooting topic needs a condition: what the reader sees" $rel }
            if (-not $rootEl.SelectSingleNode('troublebody/troubleSolution/cause') -or -not $rootEl.SelectSingleNode('troublebody/troubleSolution/remedy')) { Fail "a troubleshooting topic needs a troubleSolution with a cause and a remedy" $rel }
        }
        'glossentry' { if (-not $rootEl.SelectSingleNode('glossdef')) { Fail "a glossary entry needs a glossdef" $rel } }
    }
    if ($category -eq 'Get started' -and $body -and (Get-Words $body.InnerText) -gt 150) { Fail "a Get started page of $(Get-Words $body.InnerText) words: Quick Start pages stay under 150" $rel }
    # a task that tells the reader what to select on a screen documents that screen: it carries the help identifier (DEC-028)
    if ($rootEl.LocalName -eq 'task' -and $helpIds.Count -eq 0 -and $rootEl.SelectSingleNode('//uicontrol | //wintitle')) { Fail "a task that names controls on a screen has no resourceid help identifier (DEC-028)" $rel }
    # labels come from keys, so a label that changes is corrected once (DEC-090)
    if ($IsStrict) {
        foreach ($u in $rootEl.SelectNodes('//uicontrol[not(@keyref)] | //wintitle[not(@keyref)]')) { Fail "label typed inline ('$($u.InnerText.Trim())'): use a keyref to ui-* (DEC-090)" $rel; break }
    }
    # platform tokens (a picture differs by device whatever the text says, so a fig may carry a device token in a shared topic: DEC-129)
    $platforms = [System.Collections.Generic.HashSet[string]]::new()
    $underPlatforms = $rel -match '/platforms/'
    foreach ($e in $rootEl.SelectNodes('//*[@platform]')) {
        foreach ($t in ($e.GetAttribute('platform') -split '\s+' | Where-Object { $_ })) {
            [void]$platforms.Add($t)
            if ($catalogue -notcontains $t) { Fail "platform token '$t' is not in the catalogue" $rel }
            elseif (($deviceTokens + $osTokens) -contains $t -and -not $underPlatforms -and $e.LocalName -ne 'fig') { Fail "platform or device token '$t' used outside platforms/ (DEC-032: idiom first, platform at the edges)" $rel }
        }
    }
    foreach ($e in $rootEl.SelectNodes('//*[@props or @otherprops or @audience or @rev]')) { Fail "conditional attribute other than @platform on <$($e.LocalName)> (platform strategy, section 2.1)" $rel }
    if ($platforms.Count -gt 3) { Fail "more than three @platform variants in one topic ($($platforms.Count)): split it (variant budget)" $rel }
    # disclosure patterns, in text and comments alike
    $raw = $rawText
    foreach ($d in $disclosure) { $mm = [regex]::Match($raw, $d.Pattern); if ($mm.Success) { Fail "looks like $($d.Why): '$($mm.Value)'" $rel } }
    # what the topic needs: keys, diagrams
    $keyrefs = @($rootEl.SelectNodes('//*[@keyref]') | ForEach-Object { $_.GetAttribute('keyref') -replace '/.*$', '' } | Sort-Object -Unique)
    # where each key is used: under which @platform values, so a manual that filters the element out does not need the key (DEC-129)
    $keyScopes = @{}
    foreach ($ke in $rootEl.SelectNodes('//*[@keyref]')) {
        $kk = $ke.GetAttribute('keyref') -replace '/.*$', ''
        $scopes = @($ke.SelectNodes('ancestor-or-self::*[@platform]') | ForEach-Object { , @($_.GetAttribute('platform') -split '\s+' | Where-Object { $_ }) })
        if (-not $keyScopes.ContainsKey($kk)) { $keyScopes[$kk] = [System.Collections.Generic.List[object]]::new() }
        $keyScopes[$kk].Add($scopes)
    }
    $svgs = @($rootEl.SelectNodes('//svgref[@href]') | ForEach-Object { $_.GetAttribute('href') })
    [pscustomobject]@{ Path = $Path; Rel = $rel; Title = $titleText; KeyRefs = $keyrefs; KeyScopes = $keyScopes; Svgs = $svgs; XrefCount = @($rootEl.SelectNodes('//xref[@keyref or @href] | //link[@keyref or @href]')).Count; ResourceIds = $helpIds; Platforms = @($platforms) }
}

function Test-KeyExcluded {
    # A key used only inside elements that the manual's filter removes is not used in that manual (DEC-129).
    # An element is removed when one of its ancestors' @platform lists names none of the manual's tokens.
    param($Occurrences, [string[]]$Tokens)
    foreach ($scopes in $Occurrences) {
        $kept = $true
        foreach ($sc in $scopes) { if (@($sc | Where-Object { $Tokens -contains $_ }).Count -eq 0) { $kept = $false; break } }
        if ($kept) { return $false }
    }
    return $true
}

function Test-Svg {
    # A diagram: a title and a description, real text, theme colours, and links that resolve from the
    # page that shows it (the plugin inlines the file and leaves cross-document links as written).
    # Every link also appears in the topic's text list, because the PDF loses the links.
    param([string]$SvgPath, [string]$FromTopic, [int]$ListedLinks)
    $rel = Rel $SvgPath
    $doc = Read-Xml $SvgPath
    $ns = [System.Xml.XmlNamespaceManager]::new($doc.NameTable); $ns.AddNamespace('s', 'http://www.w3.org/2000/svg'); $ns.AddNamespace('xlink', 'http://www.w3.org/1999/xlink')
    if (-not $doc.SelectSingleNode('/s:svg/s:title', $ns)) { Fail "diagram has no title" $rel }
    if (-not $doc.SelectSingleNode('/s:svg/s:desc', $ns)) { Fail "diagram has no desc" $rel }
    if (-not $doc.SelectSingleNode('//s:text', $ns)) { Fail "diagram has no text element: text must be real text, not outlines" $rel }
    if ($doc.SelectSingleNode('//s:script | //s:foreignObject', $ns)) { Fail "diagram carries a script or foreignObject" $rel }
    foreach ($a in 'aria-labelledby', 'aria-describedby') { if ($doc.SelectSingleNode("//*[@$a]")) { Fail "diagram uses $a, which points at nothing once the plugin prefixes the ids: use title and desc, and let the figure title name it" $rel } }
    $svgRaw = Get-Content -LiteralPath $SvgPath -Raw
    if ($tokenColours.Count) {
        foreach ($c in ([regex]::Matches($svgRaw, '#[0-9A-Fa-f]{3,8}(?![0-9A-Za-z])') | ForEach-Object { $_.Value.ToUpperInvariant() } | Sort-Object -Unique)) {
            if ($tokenColours -notcontains $c) { Fail "colour $c is not a token of the theme (build/theme/ufti.css): use the tokens' values as written" $rel }
        }
    }
    if ($svgRaw -match '(?i)\brgba?\(|\bhsla?\(|(fill|stroke|color)\s*[:=]\s*"?(red|green|blue|yellow|orange|purple|pink|brown|black|white|gr[ae]y)\b') { Fail "a colour that is not written as one of the theme's hex values" $rel }
    $ids = @($doc.SelectNodes('//*[@id]') | ForEach-Object { $_.GetAttribute('id') })
    $pageDir = Split-Path -Parent $FromTopic
    $targets = [System.Collections.Generic.HashSet[string]]::new()
    foreach ($a in $doc.SelectNodes('//s:a', $ns)) {
        $h = $a.GetAttribute('href'); if (-not $h) { $h = $a.GetAttribute('href', 'http://www.w3.org/1999/xlink') }
        if (-not $h) { Fail "a link in the diagram has no href" $rel; continue }
        if ($h -match '^(https?:|mailto:)') { Note "$rel links outside the site: $h (checked by the link check on the built site)"; continue }
        if ($h -match '^javascript:') { Fail "a link that runs code: $h" $rel; continue }
        $file, $frag = $h -split '#', 2
        if (-not $file) { if ($ids -notcontains $frag) { Fail "fragment link #$frag has no target in the diagram" $rel }; continue }
        [void]$targets.Add($file)
        $target = [System.IO.Path]::GetFullPath((Join-Path $pageDir ($file -replace '\.html$', '.dita')))
        if (-not (Test-Path -LiteralPath $target)) { Fail "link '$h' does not reach a topic from $(Rel $FromTopic) (written as an .html address relative to that page)" $rel }
    }
    if ($ListedLinks -lt $targets.Count) { Fail "the diagram links to $($targets.Count) page(s) but $(Rel $FromTopic) lists ${ListedLinks}: a text list of the same links must follow the diagram (the PDF loses the links)" $rel }
}

function Test-KeyNames {
    # Key naming (authoring standards, section 3): a topic's key is its file name, a glossary entry's
    # is term- and its file name, a picture's starts img-, and a word or fact starts ui- or product-.
    param([string]$MapPath)
    $rel = Rel $MapPath
    $doc = Read-Xml $MapPath
    foreach ($e in $doc.SelectNodes('//*[@keys]')) {
        $href = $e.GetAttribute('href')
        foreach ($k in ($e.GetAttribute('keys') -split '\s+' | Where-Object { $_ })) {
            if ($href -match '\.dita(#.*)?$') {
                $stem = [System.IO.Path]::GetFileNameWithoutExtension(($href -split '#')[0])
                if ($k -ne $stem -and $k -ne "term-$stem") { Fail "key '$k' on '$href': a topic's key is its file name ('$stem'), or term-$stem for a glossary entry" $rel }
            }
            elseif ($href -match '\.(png|svg|jpg|jpeg)$') { if ($k -notlike 'img-*') { Fail "key '$k' names a picture: picture keys start img-" $rel } }
            elseif (-not $href -and $e.SelectSingleNode('topicmeta/keywords/keyword')) { if ($k -notlike 'ui-*' -and $k -notlike 'product-*') { Fail "key '$k' holds a word: label keys start ui-, product facts start product-" $rel } }
        }
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
    $strictSource = $Strict.IsPresent -or ((Rel $srcRoot) -eq 'content')
    $templateDir = (Join-Path $srcRoot 'templates') + [System.IO.Path]::DirectorySeparatorChar   # templates are checked as topics but belong to no manual (DEC-073)
    $siteDir = (Join-Path $srcRoot 'site') + [System.IO.Path]::DirectorySeparatorChar   # the pages of the site's root (accessibility statement, privacy policy)
    function Test-IsTemplate { param([string]$Path) $Path.StartsWith($templateDir, [System.StringComparison]::OrdinalIgnoreCase) }
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
        $t = Test-Topic $f.FullName $srcRoot $strictSource
        if ($t) { $topics[$f.FullName] = $t }
        $checked++
    }
    # maps that are not a manual's root: the rules that apply to every map
    foreach ($mp in $maps) {
        $raw = Get-Content -LiteralPath $mp.FullName -Raw
        if ($raw -match 'chunk="[^"]*to-content') { Fail "chunk='to-content' is forbidden" (Rel $mp.FullName) }
        if ($raw -match '<mapref[^>]*\skeyref=') { Fail "mapref by key is forbidden" (Rel $mp.FullName) }
        if ($raw -match 'xml:lang="(?!en-GB)') { Fail "xml:lang is not en-GB" (Rel $mp.FullName) }
        $mapDoc = Read-Xml $mp.FullName
        if ($mapDoc.DocumentElement.GetAttribute('xml:lang') -ne 'en-GB') { Fail "the root element has no xml:lang=""en-GB""" (Rel $mp.FullName) }
        Test-FileHeader $raw $mapDoc.DocumentElement.LocalName (Rel $mp.FullName)
        Test-KeyNames $mp.FullName
        if ($mapDoc.SelectSingleNode('//authorinformation | //person | //personname')) { Fail "a person in a map's metadata: metadata names nobody (authoring standards, section 9.3)" (Rel $mp.FullName) }
        if ($mapDoc.DocumentElement.LocalName -eq 'bookmap' -and -not (Test-IsTemplate $mp.FullName)) {
            if (-not $mapDoc.SelectSingleNode('/bookmap/bookmeta/publisherinformation/organization')) { Fail "a bookmap names its publisher organisation in bookmeta (authoring standards, section 9.2)" (Rel $mp.FullName) }
            if (-not $mapDoc.SelectSingleNode('/bookmap/bookmeta/bookrights/bookowner')) { Fail "a bookmap names the owner of its copyright in bookmeta/bookrights (authoring standards, section 9.2)" (Rel $mp.FullName) }
        }
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
        # titles are unique within a publication, and a help identifier names one topic (DEC-028)
        $titlesSeen = @{}
        $helpIdsSeen = @{}
        foreach ($tp in $m.Topics) {
            if (-not $topics.ContainsKey($tp)) { continue }
            $info = $topics[$tp]
            if ($info.Title) {
                if ($titlesSeen.ContainsKey($info.Title)) { Fail "title '$($info.Title)' is also the title of $($titlesSeen[$info.Title]) in the $slug manual" $info.Rel } else { $titlesSeen[$info.Title] = $info.Rel }
            }
            foreach ($hid in $info.ResourceIds) {
                if ($helpIdsSeen.ContainsKey($hid)) { Fail "help identifier '$hid' is also claimed by $($helpIdsSeen[$hid]) in the $slug manual: one identifier, one topic" $info.Rel } else { $helpIdsSeen[$hid] = $info.Rel }
            }
        }
        # keys the topics use, and images
        foreach ($tp in $m.Topics) {
            if (-not $topics.ContainsKey($tp)) { continue }
            $info = $topics[$tp]
            foreach ($k in $info.KeyRefs) {
                if (-not $m.Keys.Contains($k) -and (Test-KeyExcluded $info.KeyScopes[$k] $tokens)) { continue }
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
                Test-Svg $svgPath $tp $info.XrefCount
            }
        }
        $imageKeysByManual[$slug] = @(@($(if ($imageKeysByManual.Contains($slug)) { $imageKeysByManual[$slug] })) + @($m.Keys.Keys | Where-Object { $_ -like 'img-*' }) | Where-Object { $_ } | Select-Object -Unique)
    }
    if ($included.Count -eq 0) { Fail "no root bookmap named ufti-*-<slug>.ditamap at the publication root" (Rel $srcRoot); continue }
    # the applicability matrix, orphans, image key parity
    foreach ($tp in ($topics.Keys | Sort-Object)) {
        if (Test-IsTemplate $tp) {
            # a template is never published: it is in no manual's navigation (DEC-073)
            if ($used.Contains($tp)) { Fail "a template is in a manual's navigation, so it would be published" (Rel $tp) }
            $info = $topics[$tp]
            foreach ($s in $info.Svgs) {
                $svgPath = [System.IO.Path]::GetFullPath((Join-Path (Split-Path -Parent $tp) $s))
                if (-not (Test-Path -LiteralPath $svgPath)) { Fail "diagram not found: $s" $info.Rel; continue }
                [void]$usedSvgs.Add($svgPath)
                Test-Svg $svgPath $tp $info.XrefCount
            }
            continue
        }
        $cells = foreach ($slug in $manuals.Keys) { if ($included.ContainsKey($slug) -and $included[$slug] -contains $tp) { 'included' } elseif ($included.ContainsKey($slug)) { 'excluded' } else { 'no manual' } }
        $matrixRows.Add((Rel $tp) + ',' + ($cells -join ','))
        # the site's own pages (content/site/) belong to the root of the published tree, which build-site writes the map for
        if (-not $used.Contains($tp) -and -not $tp.StartsWith($siteDir, [System.StringComparison]::OrdinalIgnoreCase)) { Fail "orphan: the topic is in no manual's navigation" (Rel $tp) }
    }
    foreach ($png in Get-ChildItem -LiteralPath $srcRoot -Recurse -Filter '*.png') {
        if (-not $usedImages.Contains($png.FullName)) { Fail "orphan: no key uses this picture" (Rel $png.FullName) }
        if ((Rel $png.FullName) -notmatch '/platforms/[a-z0-9-]+/images/[^/]+$') { Fail "a screenshot belongs in platforms/<manual>/images/ (authoring standards, section 3)" (Rel $png.FullName) }
    }
    foreach ($svg in Get-ChildItem -LiteralPath $srcRoot -Recurse -Filter '*.svg') {
        if (-not $usedSvgs.Contains($svg.FullName)) { Fail "orphan: no topic shows this diagram" (Rel $svg.FullName) }
        if ((Rel $svg.FullName) -notmatch '/(images|diagrams)/[^/]+$' -and -not (Test-IsTemplate $svg.FullName)) { Fail "a diagram belongs in an images/ or diagrams/ folder (authoring standards, section 3)" (Rel $svg.FullName) }
    }
    # the terminology list covers every label key (strict sources: the real content)
    if ($strictSource) {
        $termPath = if ([System.IO.Path]::IsPathRooted($Terminology)) { $Terminology } else { Join-Path $root $Terminology }
        if (-not (Test-Path -LiteralPath $termPath)) { Fail "the terminology list $Terminology does not exist" }
        else {
            $listed = @([regex]::Matches((Get-Content -LiteralPath $termPath -Raw), '`(ui-[a-z0-9-]+)`') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique)
            $labelKeys = @()
            foreach ($mp in $maps) { $labelKeys += @((Read-Xml $mp.FullName).SelectNodes('//*[@keys]') | ForEach-Object { $_.GetAttribute('keys') -split '\s+' } | Where-Object { $_ -like 'ui-*' }) }
            foreach ($k in ($labelKeys | Sort-Object -Unique)) { if ($listed -notcontains $k) { Fail "label key '$k' is not in the terminology list ($Terminology)" } }
        }
    }
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
