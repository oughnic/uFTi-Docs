#requires -Version 7
<#
.SYNOPSIS
    Brings the app team's brand artwork into this repository.
.DESCRIPTION
    Reads the SVG files of the app's design/brand folder from -From, converts their text to outlines, and
    writes the artwork to build/brand/art/ and the files the build ships (favicon, share image, marks) to
    build/theme/assets/brand/. It runs in the pinned Playwright container (the host needs only Docker),
    with the theme's own fonts. Record the source commit in build/brand/README.md after each import.
.PARAMETER From
    A folder holding the app's design/brand/*.svg files.
#>
[CmdletBinding()]
param([Parameter(Mandatory)][string]$From)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot '../scripts/UftiBuild.psm1') -Force
$root = Get-UftiRepoRoot
$lock = Read-UftiToolsLock
$image = $lock['containers']['playwright']
$docker = (Get-Command docker -ErrorAction Stop).Source
$from = (Resolve-Path -LiteralPath $From).Path

Write-Host "== Import the brand artwork from $from"
$inner = 'cd /tmp && npm init -y >/dev/null && npm i playwright@1.64.1 opentype.js@1.3.4 >/dev/null 2>&1 && cp /work/build/brand/import-brand.mjs /tmp/ && node import-brand.mjs /src /work/build/theme/assets/fonts /work/build/brand/art /work/build/theme/assets/brand'
$env:MSYS_NO_PATHCONV = '1'
& $docker run --rm -v "${root}:/work" -v "${from}:/src:ro" $image bash -lc $inner
if ($LASTEXITCODE -ne 0) { throw "The import failed (exit $LASTEXITCODE)." }
