#requires -Version 7
<#
.SYNOPSIS
  Builds the whole publishable tree: a root, one folder per platform, and below each platform one
  folder per uFTi app release, each holding the manual and the Quick Start as a website and a PDF.

.DESCRIPTION
  Reads build/publications.ini (the one place a release is declared; the build fails if it is
  missing or not in the agreed form), builds every manual and Quick Start with build.ps1 (the
  toolkit and the GOV.UK plugin only, no build message allowed), writes the root and platform pages
  as DITA 1.3 and builds them the same way, and assembles out/site:

    out/site/
      index.html                       the root: the platforms
      not-found.html                   what a missing address shows
      staticwebapp.config.json         the Azure Static Web Apps configuration
      <platform>/index.html            the platform's versions
      <platform>/<release>/            the manual's website and PDF
      <platform>/<release>/start/      the Quick Start's website and PDF
      <platform>/<release>/version.json

  Releases already published are kept by passing -Keep a folder of the archives that an earlier
  run wrote with -Archive (build and quality, section 7). The tree is then checked by check-site.ps1.

  Copyright 2026 Oughtibridge Ltd, Apache-2.0.

.PARAMETER Output
  The folder the deliverables are built in and the tree is assembled under. Default out/.

.PARAMETER Keep
  A folder of ufti-docs-<platform>-<release>.zip files from earlier runs. Each holds
  <platform>/<release>/ and is put back in the tree, so an old release stays online.

.PARAMETER Reuse
  Use the manuals and Quick Starts already built under -Output instead of building them again.

.PARAMETER Archive
  Also write out/archive/: one zip for each platform's current release, and SHA256SUMS.

.PARAMETER NoCheck
  Do not run check-site.ps1 at the end.

.EXAMPLE
  pwsh build/scripts/build-site.ps1 -Archive
.EXAMPLE
  pwsh build/scripts/build-site.ps1 -Keep ../kept -Archive
#>
[CmdletBinding()]
param(
    [string]$Output = 'out',
    [string]$Keep,
    [switch]$Reuse,
    [switch]$Archive,
    [switch]$NoCheck,
    [string]$ToolsDir
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'UftiBuild.psm1') -Force
Add-Type -AssemblyName System.IO.Compression.FileSystem

$root = Get-UftiRepoRoot
$outDir = [System.IO.Path]::GetFullPath($(if ([System.IO.Path]::IsPathRooted($Output)) { $Output } else { Join-Path $root $Output }))
$siteDir = Join-Path $outDir 'site'
$genDir = Join-Path $root 'out' 'generated' 'site-root'   # fixed: build/projects/site-root.xml reads its sources from here
$archiveDir = Join-Path $outDir 'archive'
$buildScript = Join-Path $PSScriptRoot 'build.ps1'
$utf8 = [System.Text.UTF8Encoding]::new($false)

function Write-Text { param([string]$Path, [string]$Text) New-Item -ItemType Directory -Path (Split-Path -Parent $Path) -Force | Out-Null; [System.IO.File]::WriteAllText($Path, (($Text -replace "`r`n", "`n").TrimEnd() + "`n"), $utf8) }
function Format-Xml { param([string]$Text) [System.Security.SecurityElement]::Escape($Text) }
function Fail { param([string]$Message) Write-UftiProblem $Message; exit 1 }

try { $pub = Read-UftiPublications } catch { Fail "$_" }
$base = $pub.BaseUrl
Write-UftiStep "Publishing tree for $($pub.Platforms.Count) platform(s) at $base"
foreach ($p in $pub.Platforms) { Write-Host ("  {0,-14} {1}" -f $p.Slug, $p.Release) }

# ---- 1. The manuals and Quick Starts ---------------------------------------------------------------

$deliverables = @($pub.Platforms | ForEach-Object { $_.Manual; $_.QuickStart })
if ($Reuse) {
    foreach ($d in $deliverables) { if (-not (Test-Path -LiteralPath (Join-Path $outDir $d))) { Fail "-Reuse: no build of $d under $outDir" } }
}
else {
    foreach ($d in $deliverables) {
        $bargs = @{ Project = $d; Output = $outDir }
        if ($ToolsDir) { $bargs['ToolsDir'] = $ToolsDir }
        & $buildScript @bargs
        if ($LASTEXITCODE -ne 0) { Fail "$d did not build cleanly: the tree is not built" }
    }
}

# ---- 2. A fresh tree, with the earlier releases put back -------------------------------------------

if (Test-Path -LiteralPath $siteDir) { Remove-Item -LiteralPath $siteDir -Recurse -Force }
New-Item -ItemType Directory -Path $siteDir -Force | Out-Null

function Read-VersionFile { param([string]$Dir) $f = Join-Path $Dir 'version.json'; if (Test-Path -LiteralPath $f) { Get-Content -LiteralPath $f -Raw | ConvertFrom-Json } else { $null } }

$kept = [System.Collections.Generic.List[object]]::new()
if ($Keep) {
    $keepDir = [System.IO.Path]::GetFullPath($Keep)
    if (-not (Test-Path -LiteralPath $keepDir)) { Fail "-Keep: $keepDir does not exist" }
    $scratch = Join-Path $outDir 'temp' 'kept'
    if (Test-Path -LiteralPath $scratch) { Remove-Item -LiteralPath $scratch -Recurse -Force }
    foreach ($zip in Get-ChildItem -LiteralPath $keepDir -Filter '*.zip' | Sort-Object Name) {
        $dest = Join-Path $scratch $zip.BaseName
        Expand-Archive -LiteralPath $zip.FullName -DestinationPath $dest -Force
        $found = @(Get-ChildItem -LiteralPath $dest -Directory | ForEach-Object { Get-ChildItem -LiteralPath $_.FullName -Directory })
        if ($found.Count -ne 1) { Fail "$($zip.Name) must hold exactly one <platform>/<release>/ folder" }
        $v = Read-VersionFile $found[0].FullName
        $slug = $found[0].Parent.Name; $rel = $found[0].Name
        if (-not $v -or $v.platform -ne $slug -or $v.release -ne $rel) { Fail "$($zip.Name): $slug/$rel/version.json is missing or names another platform or release" }
        if (-not (Test-UftiReleaseLabel $rel)) { Fail "$($zip.Name): '$rel' is not a release label in the agreed form" }
        $plat = $pub.Platforms | Where-Object Slug -ceq $slug
        if (-not $plat) { Fail "$($zip.Name): '$slug' is not in build/publications.ini. Add the platform again, or delete the archive." }
        $cmp = [string]::CompareOrdinal((Get-UftiReleaseSortKey $rel), (Get-UftiReleaseSortKey $plat.Release))
        if ($cmp -gt 0) { Fail "$($zip.Name): $slug $rel is newer than the release in build/publications.ini ($($plat.Release))" }
        if ($cmp -eq 0) { Write-Host "  $($zip.Name): $slug $rel is the release being built, so the new build replaces it" -ForegroundColor Yellow; continue }
        $target = Join-Path $siteDir $slug $rel
        if (Test-Path -LiteralPath $target) { Fail "$($zip.Name): $slug $rel is in more than one archive" }
        New-Item -ItemType Directory -Path (Split-Path -Parent $target) -Force | Out-Null
        Move-Item -LiteralPath $found[0].FullName -Destination $target
        $kept.Add($v)
        Write-Host "  kept: $slug $rel (from $($zip.Name))"
    }
    if (Test-Path -LiteralPath $scratch) { Remove-Item -LiteralPath $scratch -Recurse -Force }
}

# ---- 3. The root and the platform pages, as DITA, built the same way -------------------------------

# Every release in the tree for a platform, newest first: the current one and the kept ones.
$listing = @{}
foreach ($p in $pub.Platforms) {
    $mpdf = "ufti-user-manual-$($p.Slug)-$($p.Release).pdf"; $spdf = "start/ufti-quick-start-$($p.Slug)-$($p.Release).pdf"
    $rows = [System.Collections.Generic.List[object]]::new()
    $rows.Add([pscustomobject]@{ Release = $p.Release; AppVersion = $p.AppVersion; ManualPdf = $mpdf; QuickStartPdf = $spdf; Current = $true })
    foreach ($v in $kept | Where-Object { $_.platform -ceq $p.Slug }) {
        $rows.Add([pscustomobject]@{ Release = [string]$v.release; AppVersion = [string]$v.appVersion; ManualPdf = [string]$v.manualPdf; QuickStartPdf = [string]$v.quickStartPdf; Current = $false })
    }
    $listing[$p.Slug] = @($rows | Sort-Object { Get-UftiReleaseSortKey $_.Release } -Descending)
}

$head = '<?xml version="1.0" encoding="UTF-8"?>'
function New-PlatformTopic {
    param($Platform, $Rows)
    $t = Format-Xml $Platform.Title; $dev = Format-Xml $Platform.Device
    $sb = [System.Text.StringBuilder]::new()
    [void]$sb.AppendLine($head)
    [void]$sb.AppendLine('<!DOCTYPE concept PUBLIC "-//OASIS//DTD DITA Concept//EN" "concept.dtd">')
    [void]$sb.AppendLine("<concept id=""platform-$($Platform.Slug)"" xml:lang=""en-GB"">")
    [void]$sb.AppendLine("  <title>uFTi on $t</title>")
    [void]$sb.AppendLine("  <shortdesc>The Quick Start and the manual for uFTi on $dev. The latest version is $(Format-Xml $Rows[0].Release).</shortdesc>")
    [void]$sb.AppendLine('  <conbody>')
    [void]$sb.AppendLine('    <p>Choose the version of uFTi that you use. The newest version is first. Each version has its own Quick Start and manual, as a website and as a PDF.</p>')
    $i = 0
    foreach ($r in $Rows) {
        $i++
        $rel = Format-Xml $r.Release
        $title = if ($r.Current) { "Version $rel (the latest)" } else { "Version $rel" }
        [void]$sb.AppendLine("    <section id=""version-$i"">")
        [void]$sb.AppendLine("      <title>$title</title>")
        if ($r.AppVersion) { [void]$sb.AppendLine("      <p>Checked against the app, version $(Format-Xml $r.AppVersion).</p>") }
        [void]$sb.AppendLine('      <ul>')
        [void]$sb.AppendLine("        <li><xref href=""$rel/start/"" scope=""peer"" format=""html"">Read the Quick Start for version $rel on the website</xref></li>")
        [void]$sb.AppendLine("        <li><xref href=""$rel/$(Format-Xml $r.QuickStartPdf)"" scope=""peer"" format=""pdf"">Download the Quick Start for version $rel as a PDF</xref></li>")
        [void]$sb.AppendLine("        <li><xref href=""$rel/"" scope=""peer"" format=""html"">Read the manual for version $rel on the website</xref></li>")
        [void]$sb.AppendLine("        <li><xref href=""$rel/$(Format-Xml $r.ManualPdf)"" scope=""peer"" format=""pdf"">Download the manual for version $rel as a PDF</xref></li>")
        [void]$sb.AppendLine('      </ul>')
        [void]$sb.AppendLine('    </section>')
    }
    [void]$sb.AppendLine('  </conbody>')
    [void]$sb.AppendLine('</concept>')
    $sb.ToString()
}

if (Test-Path -LiteralPath $genDir) { Remove-Item -LiteralPath $genDir -Recurse -Force }
$map = [System.Text.StringBuilder]::new()
[void]$map.AppendLine($head)
[void]$map.AppendLine('<!DOCTYPE map PUBLIC "-//OASIS//DTD DITA Map//EN" "map.dtd">')
[void]$map.AppendLine('<map id="ufti-docs" xml:lang="en-GB">')
[void]$map.AppendLine('  <title>uFTi documentation</title>')
foreach ($p in $pub.Platforms) {
    Write-Text (Join-Path $genDir $p.Slug 'index.dita') (New-PlatformTopic -Platform $p -Rows $listing[$p.Slug])
    [void]$map.AppendLine("  <topicref href=""$($p.Slug)/index.dita""/>")
}
# The site's own pages (content/site/): hand-written topics, copied into the sources of the root so that the root map
# names nothing outside its own folder (the plugin's GOVK016W). Each is written to <name>/index.html at the top of the tree.
foreach ($need in 'accessibility', 'privacy') { if (-not (Test-Path -LiteralPath (Join-Path $root 'content' 'site' "$need.dita"))) { Fail "content/site/$need.dita is missing: the footer of every page links to it" } }
foreach ($sp in Get-ChildItem -LiteralPath (Join-Path $root 'content' 'site') -Filter '*.dita' | Sort-Object Name) {
    $dest = Join-Path $genDir $sp.BaseName 'index.dita'
    New-Item -ItemType Directory -Path (Split-Path -Parent $dest) -Force | Out-Null
    Copy-Item -LiteralPath $sp.FullName -Destination $dest
    [void]$map.AppendLine("  <topicref href=""$($sp.BaseName)/index.dita"" toc=""no""/>")
}
[void]$map.AppendLine('  <topicref href="not-found.dita" toc="no"/>')
[void]$map.AppendLine('</map>')
Write-Text (Join-Path $genDir 'ufti-docs.ditamap') $map.ToString()
Write-Text (Join-Path $genDir 'not-found.dita') @"
$head
<!DOCTYPE concept PUBLIC "-//OASIS//DTD DITA Concept//EN" "concept.dtd">
<concept id="not-found" xml:lang="en-GB">
  <title>Page not found</title>
  <shortdesc>There is no page at this address.</shortdesc>
  <conbody>
    <p>Check the address for mistakes. Or go to the <xref href="$base" scope="peer" format="html">list of devices</xref> and choose again.</p>
  </conbody>
</concept>
"@

$rootArgs = @{ Project = 'site-root'; Output = $outDir }
if ($ToolsDir) { $rootArgs['ToolsDir'] = $ToolsDir }
& $buildScript @rootArgs
if ($LASTEXITCODE -ne 0) { Fail 'the root and platform pages did not build cleanly: the tree is not built' }

# ---- 4. Assemble ---------------------------------------------------------------------------------

Write-UftiStep 'Assemble the tree'
Copy-Item -Path (Join-Path $outDir 'site-root' '*') -Destination $siteDir -Recurse -Force
# The not-found page is served at the address that was asked for, so a relative link in it (the stylesheet, the
# scripts, the platform pages) would be looked for below that address. Its links are made absolute, from base-url.
$nfPath = Join-Path $siteDir 'not-found.html'
$nfHtml = [System.IO.File]::ReadAllText($nfPath)
$nfHtml = $nfHtml -replace '(href|src)="(?!https?://|#|mailto:|/)([^"]*)"', ('$1="' + ([uri]$base).AbsolutePath + '$2"')
[System.IO.File]::WriteAllText($nfPath, $nfHtml, $utf8)
foreach ($p in $pub.Platforms) {
    $verDir = Join-Path $siteDir $p.Slug $p.Release
    if (Test-Path -LiteralPath $verDir) { Remove-Item -LiteralPath $verDir -Recurse -Force }
    New-Item -ItemType Directory -Path $verDir -Force | Out-Null
    Copy-Item -Path (Join-Path $outDir $p.Manual '*') -Destination $verDir -Recurse -Force
    if (Test-Path -LiteralPath (Join-Path $verDir 'start')) { Fail "$($p.Manual) has a start folder of its own, where the Quick Start goes" }
    Copy-Item -LiteralPath (Join-Path $outDir $p.QuickStart) -Destination (Join-Path $verDir 'start') -Recurse -Force
    $v = $listing[$p.Slug] | Where-Object Current
    foreach ($pdf in $v.ManualPdf, $v.QuickStartPdf) { if (-not (Test-Path -LiteralPath (Join-Path $verDir $pdf))) { Fail "$($p.Slug) $($p.Release): the PDF $pdf was not built" } }
    $json = [ordered]@{ platform = $p.Slug; release = $p.Release }
    if ($p.AppVersion) { $json['appVersion'] = $p.AppVersion }
    $json['manualPdf'] = $v.ManualPdf; $json['quickStartPdf'] = $v.QuickStartPdf
    Write-Text (Join-Path $verDir 'version.json') ($json | ConvertTo-Json)
    Write-Host "  $($p.Slug)/$($p.Release)/ and $($p.Slug)/$($p.Release)/start/"
}

# ---- 5. The Static Web Apps configuration ----------------------------------------------------------

$routes = [System.Collections.Generic.List[object]]::new()
foreach ($p in $pub.Platforms) {
    $s = $p.Slug; $c = $p.Release
    foreach ($from in "/$s/latest") { $routes.Add([ordered]@{ route = $from; redirect = "/$s/$c/"; statusCode = 302 }) }
    foreach ($from in "/$s/latest/start") { $routes.Add([ordered]@{ route = $from; redirect = "/$s/$c/start/"; statusCode = 302 }) }
    $routes.Add([ordered]@{ route = "/$s/latest/*"; redirect = "/$s/$c/"; statusCode = 302 })
    # an earlier release does not change, so it may be cached for longer than the one being worked on
    foreach ($r in $listing[$s] | Where-Object { -not $_.Current }) { $routes.Add([ordered]@{ route = "/$s/$($r.Release)/*"; headers = [ordered]@{ 'cache-control' = 'public, max-age=86400' } }) }
}
$config = [ordered]@{
    '$schema'         = 'https://json.schemastore.org/staticwebapp.config.json'
    routes            = @($routes)
    responseOverrides = [ordered]@{ '404' = [ordered]@{ rewrite = '/not-found.html' } }
    globalHeaders     = [ordered]@{
        'cache-control'          = 'public, max-age=300, must-revalidate'
        'x-content-type-options' = 'nosniff'
        'referrer-policy'        = 'strict-origin-when-cross-origin'
    }
    mimeTypes         = [ordered]@{ '.pdf' = 'application/pdf' }
}
Write-Text (Join-Path $siteDir 'staticwebapp.config.json') ($config | ConvertTo-Json -Depth 8)
Write-Host '  staticwebapp.config.json'

# ---- 6. Archives of the current releases, so the next run can keep them -----------------------------

if ($Archive) {
    Write-UftiStep 'Archive each current release'
    if (Test-Path -LiteralPath $archiveDir) { Remove-Item -LiteralPath $archiveDir -Recurse -Force }
    New-Item -ItemType Directory -Path $archiveDir -Force | Out-Null
    $sums = [System.Collections.Generic.List[string]]::new()
    foreach ($p in $pub.Platforms) {
        $zipPath = Join-Path $archiveDir "ufti-docs-$($p.Slug)-$($p.Release).zip"
        $src = Join-Path $siteDir $p.Slug $p.Release
        $zip = [System.IO.Compression.ZipFile]::Open($zipPath, 'Create')
        try {
            foreach ($f in Get-ChildItem -LiteralPath $src -Recurse -File | Sort-Object FullName) {
                $entry = "$($p.Slug)/$($p.Release)/" + ([System.IO.Path]::GetRelativePath($src, $f.FullName) -replace '\\', '/')
                [void][System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $f.FullName, $entry, 'Optimal')
            }
        }
        finally { $zip.Dispose() }
        $sums.Add("$(Get-UftiFileHash256 $zipPath)  $(Split-Path -Leaf $zipPath)")
        Write-Host ("  {0} ({1:N1} MB)" -f (Split-Path -Leaf $zipPath), ((Get-Item -LiteralPath $zipPath).Length / 1MB))
    }
    [System.IO.File]::WriteAllLines((Join-Path $archiveDir 'SHA256SUMS'), $sums)
}

# ---- 7. Check the tree, and show it ----------------------------------------------------------------

$files = @(Get-ChildItem -LiteralPath $siteDir -Recurse -File)
Write-Host ("`n  {0} file(s), {1:N1} MB in {2}" -f $files.Count, (($files | Measure-Object Length -Sum).Sum / 1MB), $siteDir)
if (-not $NoCheck) {
    & (Join-Path $PSScriptRoot 'check-site.ps1') -Output $outDir
    if ($LASTEXITCODE -ne 0) { exit 1 }
}
Write-Host "PASS: the tree is built at $siteDir" -ForegroundColor Green
