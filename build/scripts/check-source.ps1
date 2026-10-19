#requires -Version 7
<#
.SYNOPSIS
  The source gates: the theme checker, the structure lint, Vale (prose, spelling and the
  reading level), the secret scanner and the sample-file gate.

.DESCRIPTION
  Runs everything that needs no build output (build and quality, section 4). Vale converts each
  topic with the toolkit, so the toolkit must be bootstrapped (bootstrap.ps1 -Only dita-ot,vale,gitleaks
  is enough). Exits 1 if any gate fails. Copyright 2026 Oughtibridge Ltd, Apache-2.0.

.PARAMETER Source
  Folders holding DITA sources. Default: build/fixtures/wp1 and content.

.PARAMETER Skip
  Gates to leave out: theme, lint, vale, secrets, samples.
#>
[CmdletBinding()]
param(
    [string[]]$Source = @('build/fixtures/wp1', 'content'),
    [string[]]$Skip = @(),
    [string]$ToolsDir
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'UftiBuild.psm1') -Force
$root = Get-UftiRepoRoot
if (-not $ToolsDir) { $ToolsDir = Get-UftiToolsDir }
$lock = Read-UftiToolsLock
$P = Get-UftiToolPaths -Lock $lock -ToolsDir $ToolsDir
Add-UftiToolsToPath -Paths $P | Out-Null
$results = [ordered]@{}

function Gate { param([string]$Name, [scriptblock]$Body) if ($Skip -contains $Name) { $results[$Name] = 'skipped'; return }; Write-UftiStep "Gate: $Name"; try { $ok = & $Body; $results[$Name] = $(if ($ok) { 'pass' } else { 'FAIL' }) } catch { Write-UftiProblem "$Name`: $_"; $results[$Name] = 'FAIL' } }

Gate 'theme' {
    # run in this process: a script's exit sets $LASTEXITCODE and returns here
    $out = & (Join-Path $root 'build' 'theme' 'check-theme.ps1') 2>&1 | ForEach-Object { "$_" }
    $out | Select-Object -Last 3 | ForEach-Object { Write-Host "  $_" }
    $LASTEXITCODE -eq 0
}

Gate 'lint' {
    & (Join-Path $PSScriptRoot 'lint.ps1') -Source $Source -Matrix 'out/applicability-matrix.csv'
    $LASTEXITCODE -eq 0
}

Gate 'vale' {
    if (-not (Test-Path -LiteralPath $P.Vale)) { throw "Vale is not installed at $($P.Vale): run bootstrap.ps1" }
    if (-not (Test-Path -LiteralPath $P.Dita)) { throw "Vale needs the toolkit to read DITA: run bootstrap.ps1" }
    $dirs = @($Source | ForEach-Object { if ([System.IO.Path]::IsPathRooted($_)) { $_ } else { Join-Path $root $_ } } | Where-Object { Test-Path -LiteralPath $_ })
    $r = Invoke-UftiProcess -FilePath $P.Vale -ArgumentList (@('--config', (Join-Path $root '.vale.ini'), '--no-wrap') + $dirs) -WorkingDirectory $root
    # Vale exits 1 on errors only; warnings and suggestions are advice.
    $r.ExitCode -eq 0
}

Gate 'secrets' {
    if (-not (Test-Path -LiteralPath $P.Gitleaks)) { throw "gitleaks is not installed at $($P.Gitleaks): run bootstrap.ps1" }
    # the whole history: a secret that was committed and removed is still a leak in a public repository
    $r = Invoke-UftiProcess -FilePath $P.Gitleaks -ArgumentList @('git', '--no-banner', '--redact', '--exit-code', '1', $root) -WorkingDirectory $root
    $r.ExitCode -eq 0
}

Gate 'samples' {
    # family tree files only in the one allowed folder, and nobody in them who could be living (DEC-111)
    & (Join-Path $PSScriptRoot 'check-samples.ps1')
    $LASTEXITCODE -eq 0
}

Write-Host ''
$failed = 0
foreach ($k in $results.Keys) { $v = $results[$k]; if ($v -eq 'FAIL') { $failed++ }; Write-Host ("  {0,-10} {1}" -f $k, $v) -ForegroundColor $(if ($v -eq 'pass') { 'Green' } elseif ($v -eq 'FAIL') { 'Red' } else { 'Yellow' }) }
if ($failed) { Write-Host "FAIL: $failed source gate(s) failed." -ForegroundColor Red; exit 1 }
Write-Host 'PASS: every source gate passed.' -ForegroundColor Green
