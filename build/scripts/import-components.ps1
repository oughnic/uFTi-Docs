#requires -Version 7
<#
.SYNOPSIS
  Copies the app's component inventory into content/components/ as data (DEC-248).

.DESCRIPTION
  The app generates, for each platform build, an inventory of what it ships: every package with its
  version, licence and copyright, the fonts, the content and the runtimes. The "Software components
  and licences" page of each manual (help id about.components) is generated from a copy of it, so the
  page cannot drift from the build. Run this after the app team says the lists changed, then run
  new-components-topics.ps1, and commit both.

  The copy keeps only what the page needs. It leaves out the app's repository address and the paths of
  its source files (this repository is public and the application repository is private), and it leaves
  out the test trees that only a Debug build carries: an entry for content with neither a licence nor a
  copyright is not part of a build a reader installs. The copyright sign that the packages' own text
  loses ("c Microsoft Corporation") is put back.

.PARAMETER From
  The folder that holds <platform>.components.json, one for each of windows, android, ios and
  maccatalyst (the app's docs/components folder).

.PARAMETER Output
  Where the copy goes. Default content/components.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$From,
    [string]$Output
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'UftiBuild.psm1') -Force
$root = Get-UftiRepoRoot
if (-not $Output) { $Output = Join-Path $root 'content/components' }
New-Item -ItemType Directory -Force -Path $Output | Out-Null

function Fix-Copyright([string]$text) {
    if ($null -eq $text) { return $null }
    if ($text -match '^c (?=\S)') { return ([string][char]0x00A9) + ' ' + $text.Substring(2) }
    return $text
}

foreach ($platform in 'windows', 'android', 'ios', 'maccatalyst') {
    $src = Join-Path $From "$platform.components.json"
    if (-not (Test-Path -LiteralPath $src)) { throw "No inventory at $src" }
    $j = [System.IO.File]::ReadAllText($src, [System.Text.Encoding]::UTF8) | ConvertFrom-Json -Depth 20

    $packages = @($j.packages | ForEach-Object {
        [ordered]@{ id = $_.id; version = $_.version; licence = $_.licence; copyright = (Fix-Copyright $_.copyright); authors = $_.authors; projectUrl = $_.projectUrl }
    })
    $fonts = @($j.fonts | ForEach-Object {
        [ordered]@{ name = $_.name; licence = $_.licence; copyright = $_.copyright; projectUrl = $_.projectUrl }
    })
    $content = @($j.content | Where-Object { $_.licence -or $_.copyright } | ForEach-Object {
        [ordered]@{
            name = $_.name; licence = $_.licence; copyright = $_.copyright
            media = @($_.media | ForEach-Object { [ordered]@{ title = $_.title; url = $_.url; note = $_.note } })
        }
    })
    $runtimes = @($j.runtimes | ForEach-Object {
        [ordered]@{ name = $_.name; licence = $_.licence; copyright = $_.copyright; projectUrl = $_.projectUrl; noticesUrl = $_.noticesUrl }
    })
    $out = [ordered]@{
        '$comment' = 'A copy of the app''s component inventory for this platform, made by build/scripts/import-components.ps1. Do not edit by hand: import again, then run new-components-topics.ps1.'
        platform   = $j.platform
        app        = [ordered]@{ name = $j.app.name; copyright = $j.app.copyright }
        packages   = $packages
        fonts      = $fonts
        content    = $content
        runtimes   = $runtimes
    }
    $dest = Join-Path $Output "$platform.json"
    [System.IO.File]::WriteAllText($dest, (($out | ConvertTo-Json -Depth 10) + "`n"), [System.Text.UTF8Encoding]::new($false))
    '{0,-12} {1} packages, {2} fonts, {3} content, {4} runtimes' -f $platform, $packages.Count, $fonts.Count, $content.Count, $runtimes.Count
}
