#requires -Version 7
<#
.SYNOPSIS
  Assembles the Brontë sample files for publication, so the application can pull them (DEC-121).

.DESCRIPTION
  Runs the sample-file gate (DEC-111), then copies every *.ged file in
  content/sample-data/bronte/stages/ into the output folder byte for byte and writes beside them:

    bronte-sample-SHA256SUMS         "<sha256>  <name>" for each file, for sha256sum -c
    bronte-sample-manifest.json      the name to show on screen, the commit, and each file's name,
                                     size, SHA-256 and GEDCOM version

  The file names are the contract with the application. They stay stable (DEC-121). Nothing here
  depends on the clock, so the same commit gives the same output.

  The CI workflow .github/workflows/samples.yml publishes the folder as the rolling release
  bronte-sample-latest, and release.yml attaches it to each version release. Locally, run it to see
  what would be published.

.PARAMETER Output
  The folder to write into. It is created if it does not exist. Other files in it are left alone.

.PARAMETER Root
  The repository root. Default: this repository.

  Copyright 2026 Oughtibridge Ltd, Apache-2.0.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Output,
    [string]$Root
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if (-not $Root) {
    Import-Module (Join-Path $PSScriptRoot 'UftiBuild.psm1') -Force
    $Root = Get-UftiRepoRoot
}

$displayName = 'Brontë family of Haworth'
$stages = Join-Path $Root 'content/sample-data/bronte/stages'
$utf8 = [System.Text.UTF8Encoding]::new($false)

# Nothing is published that the gate would refuse: no real family data, nobody who could be living.
& (Join-Path $PSScriptRoot 'check-samples.ps1') -Root $Root
if ($LASTEXITCODE -ne 0) { throw 'The sample-file gate failed, so nothing is assembled.' }

$files = @(Get-ChildItem -LiteralPath $stages -Filter '*.ged' -File | Sort-Object Name)
if ($files.Count -eq 0) { throw "No *.ged files in $stages." }

New-Item -ItemType Directory -Path $Output -Force | Out-Null

$commit = if ($env:GITHUB_SHA) { $env:GITHUB_SHA } else { (& git -C $Root rev-parse HEAD).Trim() }
$entries = [System.Collections.Generic.List[object]]::new()
$sums = [System.Collections.Generic.List[string]]::new()
foreach ($f in $files) {
    $target = Join-Path $Output $f.Name
    Copy-Item -LiteralPath $f.FullName -Destination $target -Force
    $hash = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash.ToLowerInvariant()
    $header = (Get-Content -LiteralPath $target -TotalCount 30 -Encoding utf8) -join "`n"
    $version = if ($header -match '(?m)^\s*1 GEDC\s*\n\s*2 VERS (\S+)') { $Matches[1] } else { 'unknown' }
    $entries.Add([ordered]@{ name = $f.Name; bytes = (Get-Item -LiteralPath $target).Length; sha256 = $hash; gedcom = $version })
    $sums.Add("$hash  $($f.Name)")
    Write-Host ("  {0}  {1,7} bytes  GEDCOM {2}  {3}" -f $hash.Substring(0, 12), (Get-Item -LiteralPath $target).Length, $version, $f.Name)
}

[System.IO.File]::WriteAllText((Join-Path $Output 'bronte-sample-SHA256SUMS'), (($sums -join "`n") + "`n"), $utf8)
$manifest = [ordered]@{ name = $displayName; commit = $commit; files = $entries }
[System.IO.File]::WriteAllText((Join-Path $Output 'bronte-sample-manifest.json'), (($manifest | ConvertTo-Json -Depth 5) + "`n"), $utf8)

Write-Host "PASS: $($files.Count) sample file(s) assembled in $Output from $($commit.Substring(0, 7))." -ForegroundColor Green
exit 0
