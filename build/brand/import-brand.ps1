#requires -Version 7
<#
.SYNOPSIS
    Brings the app team's brand artwork into this repository, unchanged.
.DESCRIPTION
    The terms of use (art/README.md, their README) allow the files to be copied unchanged apart from
    scaling, so nothing here edits a file: it copies the ones the documentation uses.
      art/                      the files kept from the artwork, with the app team's own README and terms
      ../theme/assets/brand/    the four files the build ships beside the stylesheet
    Take the files from a tag of the app's repository (brand-v<version>), with the GitHub CLI, or from a
    folder that holds design/brand. Then change the version, tag and commit in README.md.
.PARAMETER Tag
    The tag to import, for example brand-v1.1.0.
.PARAMETER From
    A folder holding design/brand's files, in place of -Tag.
.PARAMETER Repository
    The app's repository (it is private: gh must be signed in with access to it).
#>
[CmdletBinding()]
param(
    [string]$Tag = 'brand-v1.3.0',
    [string]$From,
    [string]$Repository = 'oughtibridge/uFTi-2'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$art = Join-Path $PSScriptRoot 'art'
$ship = Join-Path $root 'build/theme/assets/brand'

# What is kept, and what the build ships. Files with live text (the .svg of each text artwork) load the app's
# fonts from a path in the app's repository and draw wrongly anywhere else, so only the outlined ones are kept.
$keep = @(
    'README.md', 'ufti-sampler.svg', 'ufti-mark.svg', 'ufti-mark-on-dark.svg', 'ufti-touch-icon.svg',
    'ufti-sampler-16.svg', 'ufti-sampler-32.svg', 'ufti-sampler-48.svg', 'ufti-sampler-16.png', 'ufti-sampler-32.png', 'ufti-sampler-48.png',
    'ufti.ico', 'ufti-icon-180.png', 'ufti-icon-300.png', 'ufti-icon-512.png', 'ufti-icon-1024.png',
    'ufti-box-front-outlined.svg', 'ufti-hero-outlined.svg', 'ufti-play-feature-outlined.svg', 'ufti-share-card-outlined.svg', 'ufti-share-card.png',
    'ufti-store-poster-outlined.svg', 'ufti-store-box-art-outlined.svg', 'ufti-app-icon.svg', 'ufti-app-icon-256.png', 'ufti-app-icon-1024.png', 'ufti-app.ico'
)
$shipped = @('ufti.ico', 'ufti-share-card.png', 'ufti-mark.svg', 'ufti-mark-on-dark.svg')

$work = Join-Path ([System.IO.Path]::GetTempPath()) "ufti-brand-$([guid]::NewGuid().ToString('N'))"
New-Item -ItemType Directory -Path $work | Out-Null
try {
    if ($From) {
        $src = (Resolve-Path -LiteralPath $From).Path
    } else {
        Write-Host "== Fetch $Tag from $Repository"
        $gh = (Get-Command gh -ErrorAction Stop).Source
        # Start-Process writes the raw bytes, so a PNG or an icon is not changed on the way.
        foreach ($f in $keep) {
            $ghArgs = @('api', '-H', '"Accept: application/vnd.github.raw"', "repos/$Repository/contents/design/brand/${f}?ref=$Tag")
            $p = Start-Process -FilePath $gh -ArgumentList $ghArgs -RedirectStandardOutput (Join-Path $work $f) -NoNewWindow -Wait -PassThru
            if ($p.ExitCode -ne 0) { throw "Could not fetch $f at $Tag." }
        }
        $src = $work
        $sha = & $gh api "repos/$Repository/commits/$Tag" --jq .sha
        Write-Host "  commit $sha"
    }
    New-Item -ItemType Directory -Path $art, $ship -Force | Out-Null
    Get-ChildItem -LiteralPath $art -File | Remove-Item -Force
    Get-ChildItem -LiteralPath $ship -File | Remove-Item -Force
    foreach ($f in $keep) {
        $p = Join-Path $src $f
        if (-not (Test-Path -LiteralPath $p)) { throw "$f is not in the artwork." }
        Copy-Item -LiteralPath $p -Destination (Join-Path $art $f)
    }
    foreach ($f in $shipped) { Copy-Item -LiteralPath (Join-Path $art $f) -Destination (Join-Path $ship $f) }
    Write-Host "  kept $($keep.Count) file(s) in build/brand/art/, shipped $($shipped.Count) in build/theme/assets/brand/"
} finally {
    if (Test-Path -LiteralPath $work) { Remove-Item -LiteralPath $work -Recurse -Force }
}
