#requires -Version 7
<#
.SYNOPSIS
  Assembles the help maps for publication, so the application can pull them (DEC-196).

.DESCRIPTION
  Takes the maps that new-help-map.ps1 wrote (<device>.<release>.<language>.help-map.json), checks each
  one, copies them byte for byte into the output folder, and writes beside them:

    help-maps-SHA256SUMS         "<sha256>  <name>" for each file, for sha256sum -c
    help-maps-manifest.json      the status, the commit, and each file's name, device, release, language,
                                 size, SHA-256, number of targets and gaps

  The file names are the contract with the application. They stay stable (DEC-196). Nothing here depends
  on the clock, so the same commit gives the same output.

  A folder holds maps of one status, and -Status says which. The CI workflow .github/workflows/site.yml
  publishes "proposed" maps as the rolling release help-maps-proposed (for development builds of the
  app) and "published" maps, proved against the live host, as help-maps-published (for release builds).

  Exits 1 on: no maps; a map of another status than -Status; a file whose name does not follow its
  device, release and language; a map without the fields the app reads; a base address that does not
  end in /<device>/<release>/; a target that is not a relative address; an id in both targets and gaps;
  "complete" that disagrees with "gaps".

.PARAMETER Maps
  The folder that holds the maps. Default out/help-maps.

.PARAMETER Output
  The folder to write into. It is created if it does not exist. Other files in it are left alone.

.PARAMETER Status
  proposed or published. Every map in the folder must say it.

.PARAMETER Root
  The repository root. Default: this repository.

  Copyright 2026 Oughtibridge Ltd, Apache-2.0.
#>
[CmdletBinding()]
param(
    [string]$Maps = 'out/help-maps',
    [Parameter(Mandatory)][string]$Output,
    [Parameter(Mandatory)][ValidateSet('proposed', 'published')][string]$Status,
    [string]$Root
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if (-not $Root) {
    Import-Module (Join-Path $PSScriptRoot 'UftiBuild.psm1') -Force
    $Root = Get-UftiRepoRoot
}

$mapsDir = if ([System.IO.Path]::IsPathRooted($Maps)) { $Maps } else { Join-Path $Root $Maps }
$utf8 = [System.Text.UTF8Encoding]::new($false)
$idPattern = '^[a-z][a-z0-9-]*(\.[a-z][a-z0-9-]*)?$'
$required = 'status', 'baseUrl', 'device', 'release', 'language', 'home', 'complete', 'gaps', 'targets'
$problems = [System.Collections.Generic.List[string]]::new()
function Problem { param([string]$Message) $problems.Add($Message); Write-Host "  FAIL: $Message" -ForegroundColor Red }

if (-not (Test-Path -LiteralPath $mapsDir)) { throw "the folder $Maps does not exist" }
$files = @(Get-ChildItem -LiteralPath $mapsDir -Filter '*.help-map.json' -File | Sort-Object Name)
if ($files.Count -eq 0) { throw "no *.help-map.json files in $Maps" }

$entries = [System.Collections.Generic.List[object]]::new()
foreach ($f in $files) {
    try { $m = Get-Content -LiteralPath $f.FullName -Raw -Encoding utf8 | ConvertFrom-Json } catch { Problem "$($f.Name): not valid JSON"; continue }
    $names = @($m.PSObject.Properties.Name)
    $missing = @($required | Where-Object { $names -notcontains $_ })
    if ($missing) { Problem "$($f.Name): missing $($missing -join ', ')"; continue }

    if ($m.status -cne $Status) { Problem "$($f.Name): status is '$($m.status)', but this publication is '$Status'" }
    if ($f.Name -cne "$($m.device).$($m.release).$($m.language).help-map.json") { Problem "$($f.Name): the name does not follow device.release.language ($($m.device).$($m.release).$($m.language))" }
    if (-not "$($m.baseUrl)".EndsWith("/$($m.device)/$($m.release)/")) { Problem "$($f.Name): baseUrl '$($m.baseUrl)' does not end in /$($m.device)/$($m.release)/" }
    if ($m.home -isnot [string] -or -not $m.home) { Problem "$($f.Name): home is empty" }

    $targetIds = @($m.targets.PSObject.Properties.Name)
    $gapIds = @($m.gaps)
    foreach ($id in $targetIds + $gapIds) { if ($id -cnotmatch $idPattern) { Problem "$($f.Name): '$id' is not an app screen id (area or area.screen, lower case)" } }
    foreach ($id in $targetIds) {
        $page = $m.targets.$id
        if ($page -isnot [string] -or -not $page) { Problem "$($f.Name): '$id' has no page"; continue }
        if ($page -match '^[a-z][a-z0-9+.-]*:|^/|\\') { Problem "$($f.Name): '$id' -> '$page' is not a relative address" }
    }
    foreach ($id in $gapIds) { if ($targetIds -contains $id) { Problem "$($f.Name): '$id' is both a target and a gap" } }
    if (($m.complete -eq $true) -ne ($gapIds.Count -eq 0)) { Problem "$($f.Name): complete is $($m.complete), but there are $($gapIds.Count) gap(s)" }

    $entries.Add([pscustomobject]@{ File = $f; Map = $m; Targets = $targetIds.Count; Gaps = $gapIds.Count })
}

if ($problems.Count) { Write-Host "FAIL: $($problems.Count) problem(s); nothing is assembled." -ForegroundColor Red; exit 1 }

New-Item -ItemType Directory -Path $Output -Force | Out-Null
$commit = if ($env:GITHUB_SHA) { $env:GITHUB_SHA } else { (& git -C $Root rev-parse HEAD).Trim() }
$list = [System.Collections.Generic.List[object]]::new()
$sums = [System.Collections.Generic.List[string]]::new()
foreach ($e in $entries) {
    $target = Join-Path $Output $e.File.Name
    Copy-Item -LiteralPath $e.File.FullName -Destination $target -Force
    $hash = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash.ToLowerInvariant()
    $bytes = (Get-Item -LiteralPath $target).Length
    $list.Add([ordered]@{ name = $e.File.Name; device = $e.Map.device; release = $e.Map.release; language = $e.Map.language; bytes = $bytes; sha256 = $hash; targets = $e.Targets; gaps = $e.Gaps })
    $sums.Add("$hash  $($e.File.Name)")
    Write-Host ("  {0}  {1,6} bytes  {2} targets, {3} gap(s)  {4}" -f $hash.Substring(0, 12), $bytes, $e.Targets, $e.Gaps, $e.File.Name)
}

[System.IO.File]::WriteAllText((Join-Path $Output 'help-maps-SHA256SUMS'), (($sums -join "`n") + "`n"), $utf8)
$manifest = [ordered]@{ status = $Status; commit = $commit; files = $list }
[System.IO.File]::WriteAllText((Join-Path $Output 'help-maps-manifest.json'), ((($manifest | ConvertTo-Json -Depth 5) -replace "`r`n", "`n") + "`n"), $utf8)

Write-Host "PASS: $($entries.Count) $Status help map(s) assembled in $Output from $($commit.Substring(0, 7))." -ForegroundColor Green
exit 0
