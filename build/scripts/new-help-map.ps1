#requires -Version 7
<#
.SYNOPSIS
  Writes the in-app help map for each device, release and language (DEC-028, work package 7b).

.DESCRIPTION
  The app opens the page for the screen the reader is on. It looks up (screen id, device, release,
  language) in a map. This script writes those maps from the source, so the mapping lives with the
  content and is checked by the build.

  For each platform in build/publications.ini it takes the topics its manual includes (the same walk
  as lint.ps1), reads the resourceid of each topic and of each nested topic, keeps only the ids that are
  in the app's inventory (build/help/screens.csv: task ids such as people.add stay in the topics for
  search and never reach a map), and writes
      <Output>/<platform>.<release>.<language>.help-map.json
  with: status, baseUrl, device, release, language, home, complete, gaps, and targets (id to page,
  relative to baseUrl; a nested topic's page ends in #its-id). Several ids may share a page. "gaps"
  names every screen of the inventory that has no target in this map, so the app can list the same
  ones; "complete" is true when it is empty.

  A map says "status": "proposed" unless -Published is given. -Published also needs proof that the
  pages are there: -Site <folder> checks them in the tree the build assembled, and -Live checks them on
  the host (an HTTP request for each page, and the anchor in it). The script refuses to write a published
  map when any page or anchor is missing, so a release build of the app can never link to a page that
  does not exist. A screen with no page is left out; the app falls back to the manual's home page.

  The report prints, for each device and language, how many of the app's screens have a page and which
  do not. A gap in a language other than the source language never fails the script.

  Exits 1 on: an id claimed by two topics in one manual; an id that is not in the inventory shape;
  -Published without -Site or -Live; a page or anchor that -Site or -Live cannot find.
  Copyright 2026 Oughtibridge Ltd, Apache-2.0.

.PARAMETER Inventory
  The app's screens, one per row (screen_id, screen_name). Default build/help/screens.csv.

.PARAMETER Output
  The folder for the maps. Default out/help-maps.

.PARAMETER Platform
  Only these platforms (the section names of publications.ini). Default: all.

.PARAMETER Language
  The language of the topics to map. Topics in another language are left out. Default en-GB.

.PARAMETER Published
  Write "status": "published". Needs -Site or -Live.

.PARAMETER Site
  The assembled tree (out/site): every page and anchor a map names must be in it.

.PARAMETER Live
  Check every page and anchor on the host the maps name (docs.ufti.com), over HTTP.

.PARAMETER ContentRoot
  The folder that holds ufti-manual-<platform>.ditamap. Default content/. The tests point it at a small
  publication.

.PARAMETER PublicationsFile
  The publications file to read. Default build/publications.ini. The tests point it at their own.
#>
[CmdletBinding()]
param(
    [string]$Inventory = 'build/help/screens.csv',
    [string]$Output = 'out/help-maps',
    [string[]]$Platform,
    [string]$Language = 'en-GB',
    [switch]$Published,
    [string]$Site,
    [switch]$Live,
    [string]$ContentRoot,
    [string]$PublicationsFile
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'UftiBuild.psm1') -Force
$root = Get-UftiRepoRoot
$content = if ($ContentRoot) { $ContentRoot } else { Join-Path $root 'content' }
$problems = [System.Collections.Generic.List[string]]::new()
function Problem { param([string]$Message) $problems.Add($Message); Write-UftiProblem $Message }

if ($Published -and -not $Site -and -not $Live) { throw '-Published needs proof the pages are there: give -Site <folder> or -Live.' }

# ---- The app's screens ---------------------------------------------------------------------------
$invPath = if ([System.IO.Path]::IsPathRooted($Inventory)) { $Inventory } else { Join-Path $root $Inventory }
if (-not (Test-Path -LiteralPath $invPath)) { throw "the inventory $Inventory does not exist" }
$idPattern = '^[a-z][a-z0-9-]*(\.[a-z][a-z0-9-]*)?$'          # the app's shape: area or area.screen
$screens = [ordered]@{}
foreach ($row in (Import-Csv -LiteralPath $invPath)) {
    if ($row.screen_id -cnotmatch $idPattern) { Problem "inventory: '$($row.screen_id)' is not an app screen id (area or area.screen, lower case)"; continue }
    if ($screens.Contains($row.screen_id)) { Problem "inventory: '$($row.screen_id)' is listed twice"; continue }
    $screens[$row.screen_id] = $row.screen_name
}

# ---- Which topic answers which id, for each manual -----------------------------------------------
function Read-Topic {
    param([string]$Path)
    $settings = [System.Xml.XmlReaderSettings]::new(); $settings.DtdProcessing = [System.Xml.DtdProcessing]::Ignore; $settings.XmlResolver = $null
    $reader = [System.Xml.XmlReader]::Create($Path, $settings)
    try { $doc = [System.Xml.XmlDocument]::new(); $doc.Load($reader); $doc } finally { $reader.Dispose() }
}

$topicCache = @{}
function Get-TopicClaims {
    # (appid, fragment) for each resourceid of a topic: '' for the topic's own page, its id for a nested topic
    param([string]$Path)
    if ($topicCache.ContainsKey($Path)) { return $topicCache[$Path] }
    $doc = Read-Topic $Path
    $el = $doc.DocumentElement
    $claims = [System.Collections.Generic.List[object]]::new()
    foreach ($r in $el.SelectNodes('prolog/resourceid[@appname="ufti"]')) { $claims.Add([pscustomobject]@{ Id = $r.GetAttribute('appid'); Fragment = '' }) }
    foreach ($nt in $el.SelectNodes('descendant::*[self::concept or self::reference]')) {
        foreach ($r in $nt.SelectNodes('prolog/resourceid[@appname="ufti"]')) { $claims.Add([pscustomobject]@{ Id = $r.GetAttribute('appid'); Fragment = $nt.GetAttribute('id') }) }
    }
    $result = [pscustomobject]@{ Language = $el.GetAttribute('xml:lang'); Claims = $claims.ToArray() }
    $topicCache[$Path] = $result
    $result
}

# ---- Checking a page and its anchor, in the tree or on the host ----------------------------------
$liveCache = @{}
function Test-Page {
    param([string]$Slug, [string]$Release, [string]$Base, [string]$Page)
    $file, $frag = $Page -split '#', 2
    if ($Live) {
        $url = "$Base$file"
        if (-not $liveCache.ContainsKey($url)) {
            try { $liveCache[$url] = (Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 30).Content } catch { $liveCache[$url] = $null }
        }
        $html = $liveCache[$url]
        if ($null -eq $html) { return "page not live: $url" }
    } else {
        $path = Join-Path $Site (Join-Path $Slug (Join-Path $Release $file))
        if (-not (Test-Path -LiteralPath $path)) { return "page not in the tree: $Slug/$Release/$file" }
        $html = if ($frag) { Get-Content -LiteralPath $path -Raw } else { '' }
    }
    if ($frag -and $html -notmatch ('id="' + [regex]::Escape($frag) + '"')) { return "anchor #$frag not in $Slug/$Release/$file" }
    $null
}

# ---- Each platform -------------------------------------------------------------------------------
$pubs = if ($PublicationsFile) { Read-UftiPublications -Path $PublicationsFile } else { Read-UftiPublications }
$outDir = if ([System.IO.Path]::IsPathRooted($Output)) { $Output } else { Join-Path $root $Output }
New-Item -ItemType Directory -Path $outDir -Force | Out-Null
$utf8 = [System.Text.UTF8Encoding]::new($false)
$report = [System.Collections.Generic.List[object]]::new()

foreach ($p in $pubs.Platforms) {
    if ($Platform -and $Platform -notcontains $p.Slug) { continue }
    $dv = Join-Path $root 'build' 'ditaval' "$($p.Slug).ditaval"
    [xml]$val = Get-Content -LiteralPath $dv -Raw
    $tokens = @($val.val.prop | Where-Object { $_.action -eq 'include' -and $_.val } | ForEach-Object { $_.val })
    $rootMap = Join-Path $content "ufti-manual-$($p.Slug).ditamap"
    if (-not (Test-Path -LiteralPath $rootMap)) { Problem "no root map content/ufti-manual-$($p.Slug).ditamap for $($p.Slug)"; continue }

    $claimedBy = @{}      # id -> list of (page, topic)
    $outside = [System.Collections.Generic.HashSet[string]]::new()
    foreach ($t in (Get-UftiManualTopics -MapPath $rootMap -Tokens $tokens)) {
        $info = Get-TopicClaims $t
        if ($info.Language -ne $Language) { continue }
        $rel = ([System.IO.Path]::GetRelativePath($content, $t) -replace '\\', '/') -replace '\.dita$', '.html'
        foreach ($c in $info.Claims) {
            if (-not $screens.Contains($c.Id)) { [void]$outside.Add($c.Id); continue }
            $page = if ($c.Fragment) { "$rel#$($c.Fragment)" } else { $rel }
            if (-not $claimedBy.ContainsKey($c.Id)) { $claimedBy[$c.Id] = [System.Collections.Generic.List[string]]::new() }
            $claimedBy[$c.Id].Add($page)
        }
    }

    $base = "$($pubs.BaseUrl)$($p.Slug)/$($p.Release)/"
    $targets = [ordered]@{}
    foreach ($id in ($screens.Keys | Sort-Object { $_ } -CaseSensitive)) {
        if (-not $claimedBy.ContainsKey($id)) { continue }
        $pages = @($claimedBy[$id] | Select-Object -Unique)
        if ($pages.Count -gt 1) { Problem "$($p.Slug): '$id' is claimed by $($pages.Count) topics ($($pages -join ', ')): one identifier, one landing page"; continue }
        $targets[$id] = $pages[0]
    }

    if ($Site -or $Live) {
        $homeWhy = Test-Page $p.Slug $p.Release $base 'index.html'
        if ($homeWhy) { Problem "$($p.Slug): $homeWhy" }
        foreach ($id in @($targets.Keys)) {
            $why = Test-Page $p.Slug $p.Release $base $targets[$id]
            if ($why) { Problem "$($p.Slug): '$id' -> $why"; if ($Published) { $targets.Remove($id) } }
        }
    }

    $missing = @($screens.Keys | Where-Object { -not $targets.Contains($_) })
    $map = [ordered]@{
        status   = if ($Published) { 'published' } else { 'proposed' }
        baseUrl  = $base
        device   = $p.Slug
        release  = $p.Release
        language = $Language
        home     = 'index.html'
        complete = ($missing.Count -eq 0)
        gaps     = @($missing | Sort-Object { $_ } -CaseSensitive)
        targets  = $targets
    }
    $file = Join-Path $outDir "$($p.Slug).$($p.Release).$Language.help-map.json"
    [System.IO.File]::WriteAllText($file, (($map | ConvertTo-Json -Depth 4) -replace "`r`n", "`n") + "`n", $utf8)
    $distinct = @($targets.Values | ForEach-Object { ($_ -split '#')[0] } | Select-Object -Unique).Count
    $report.Add([pscustomobject]@{ Device = $p.Slug; Release = $p.Release; Language = $Language; Status = $map.status; Screens = $screens.Count; Pages = $targets.Count; DistinctPages = $distinct; Missing = ($missing -join ' '); OtherIds = $outside.Count })
}

Write-UftiStep "Help maps in $([System.IO.Path]::GetRelativePath($root, $outDir))"
$report | Format-Table Device, Release, Language, Status, Screens, Pages, DistinctPages, OtherIds -AutoSize | Out-String | Write-Host
foreach ($r in $report) { if ($r.Missing) { Write-Host ("  {0}: no page yet for {1}" -f $r.Device, $r.Missing) } }
Write-Host "  (OtherIds: task identifiers in topics that the app has no screen for; they stay out of the map)"

if ($problems.Count) {
    # a published map is never left behind by a run that found a problem
    if ($Published) { foreach ($f in (Get-ChildItem -LiteralPath $outDir -Filter '*.help-map.json')) { Remove-Item -LiteralPath $f.FullName } }
    Write-Host "FAIL: $($problems.Count) problem(s)." -ForegroundColor Red
    exit 1
}
Write-Host "PASS: $($report.Count) help map(s) written." -ForegroundColor Green
