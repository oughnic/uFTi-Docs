#requires -Version 7
<#
.SYNOPSIS
  The output gates for one built deliverable: build messages, HTML validity, page structure,
  links, page metadata, accessibility, PDF/UA, fonts and figures in the PDF, alternative text,
  the theme on the site and in a browser, page weight, and determinism.

.DESCRIPTION
  Runs every gate in build and quality, section 4, that reads built output. The plugin
  repository's checkers (links, metadata, page weight, axe-core) need Python and Node: this
  machine's own if present, otherwise the pinned containers in tools.lock through Docker. A gate
  whose tool is missing fails, unless -AllowSkips.

  Reports go to out/reports/<deliverable>/. Exits 1 if any gate fails.
  Copyright 2026 Oughtibridge Ltd, Apache-2.0.

.PARAMETER Deliverable
  The deliverable's folder name under the output folder, such as fixture-android-phone.

.PARAMETER CompareWith
  Another output folder holding the same deliverable built again: the determinism gate.

.PARAMETER Skip
  Gates to leave out: log, structure, html, links, metadata, a11y, pdf-ua, pdf-fonts, alt,
  theme, theme-browser, weight, determinism.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Deliverable,
    [string]$Output = 'out',
    [string]$Log,
    [string]$SiteUrl,
    [string]$CompareWith,
    [string[]]$Skip = @(),
    [switch]$AllowSkips,
    [string]$ToolsDir
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'UftiBuild.psm1') -Force
$root = Get-UftiRepoRoot
if (-not $ToolsDir) { $ToolsDir = Get-UftiToolsDir }
$ToolsDir = [System.IO.Path]::GetFullPath($ToolsDir)
$lock = Read-UftiToolsLock
$P = Get-UftiToolPaths -Lock $lock -ToolsDir $ToolsDir
Add-UftiToolsToPath -Paths $P | Out-Null

$outDir = [System.IO.Path]::GetFullPath($(if ([System.IO.Path]::IsPathRooted($Output)) { $Output } else { Join-Path $root $Output }))
$dir = Join-Path $outDir $Deliverable
if (-not (Test-Path -LiteralPath $dir)) { Write-UftiProblem "No output at $dir. Build it first."; exit 1 }
$reports = Join-Path $outDir 'reports' $Deliverable
New-Item -ItemType Directory -Path $reports -Force | Out-Null
if (-not $Log) {
    foreach ($c in (Join-Path $outDir 'logs' "$Deliverable.log"), (Join-Path $outDir 'logs' 'fixture.log')) { if (Test-Path -LiteralPath $c) { $Log = $c; break } }
}
if (-not $SiteUrl) {
    # a published manual or Quick Start has the address its release gives (build/publications.ini)
    $pub = Get-UftiPublishedDeliverable -Publications (Read-UftiPublications) -Project $Deliverable
    if ($pub) { $SiteUrl = $pub.SiteUrl }
}
if (-not $SiteUrl) {
    $pf = Join-Path $root 'build' 'projects' "$Deliverable.xml"
    if ((Test-Path -LiteralPath $pf) -and ((Get-Content -LiteralPath $pf -Raw) -match 'name="govuk\.site\.url"\s+value="(?<u>[^"]+)"')) { $SiteUrl = $Matches['u'] }
}
$htmlFiles = @(Get-ChildItem -LiteralPath $dir -Recurse -Filter '*.html' | Where-Object { $_.FullName -notmatch '[\\/]pagefind[\\/]' })
$pdfFiles = @(Get-ChildItem -LiteralPath $dir -Filter '*.pdf')
Write-Host "Checking $dir`: $($htmlFiles.Count) HTML page(s), $($pdfFiles.Count) PDF(s)$(if ($SiteUrl) { ", site $SiteUrl" })"

# ---- Interpreters: this machine's, or the pinned containers --------------------------------

$python = Find-UftiInterpreter python
$node = Find-UftiInterpreter node
$script:docker = $null; $script:dockerChecked = $false
function Get-Docker { if (-not $script:dockerChecked) { $script:docker = Find-UftiInterpreter docker; $script:dockerChecked = $true }; $script:docker }
function ConvertTo-ContainerPath {
    param([string]$HostPath)
    $full = [System.IO.Path]::GetFullPath($HostPath)
    if ($full.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase)) { $rel = [System.IO.Path]::GetRelativePath($root, $full) -replace '\\', '/'; return $(if ($rel -eq '.') { '/work' } else { "/work/$rel" }) }
    if ($full.StartsWith($ToolsDir, [System.StringComparison]::OrdinalIgnoreCase)) { return '/tools/' + ([System.IO.Path]::GetRelativePath($ToolsDir, $full) -replace '\\', '/') }
    throw "$HostPath is outside the repository and the tools folder, so it cannot be mounted"
}
function Invoke-Container {
    param([string]$Image, [string]$WorkDir, [string[]]$Command)
    $d = Get-Docker; if (-not $d) { return $null }
    $args = @('run', '--rm', '-v', "$root`:/work", '-v', "$ToolsDir`:/tools", '-w', $WorkDir, $Image) + $Command
    Invoke-UftiProcess -FilePath $d -ArgumentList $args -WorkingDirectory $root
}
function Invoke-Python {
    # A script from the plugin tools, with host paths as arguments.
    param([string]$Script, [string[]]$Arguments)
    $scriptPath = Join-Path $P.PluginTools 'tools' $Script
    if (-not (Test-Path -LiteralPath $scriptPath)) { throw "$Script is not installed: run bootstrap.ps1 -Only plugin-tools" }
    if ($python) { return Invoke-UftiProcess -FilePath $python -ArgumentList (@('-I', $scriptPath) + $Arguments) -WorkingDirectory $root }
    $image = $lock['containers']['python']
    Invoke-Container $image '/work' (@('python3', '-I', (ConvertTo-ContainerPath $scriptPath)) + ($Arguments | ForEach-Object { if ($_ -match '^[A-Za-z]:\\|^/' ) { ConvertTo-ContainerPath $_ } else { $_ } }))
}
function Install-A11y {
    # The accessibility runner's dependencies, once: Playwright and axe-core at the pinned versions, and Chromium.
    if (-not (Test-Path -LiteralPath (Join-Path $P.A11y 'package-lock.json'))) { throw "The accessibility runner is not installed: run bootstrap.ps1 -Only plugin-tools" }
    if (-not (Test-Path -LiteralPath (Join-Path $P.A11y 'node_modules'))) {
        Write-Host "  installing the accessibility runner's dependencies"
        $r = Invoke-UftiProcess -FilePath (Get-Command npm).Source -ArgumentList @('ci', '--no-audit', '--no-fund') -WorkingDirectory $P.A11y -Quiet
        if ($r.ExitCode -ne 0) { $r.Output | ForEach-Object { Write-Host "    $_" }; throw 'npm ci failed' }
    }
    $marker = Join-Path $P.A11y '.chromium-installed'
    if (-not (Test-Path -LiteralPath $marker)) {
        Write-Host "  installing Chromium for Playwright"
        $r = Invoke-UftiProcess -FilePath (Get-Command npx).Source -ArgumentList @('playwright', 'install', 'chromium') -WorkingDirectory $P.A11y -Quiet
        if ($r.ExitCode -ne 0) { $r.Output | ForEach-Object { Write-Host "    $_" }; throw 'playwright install failed' }
        New-Item -ItemType File -Path $marker -Force | Out-Null
    }
}
function Invoke-Node {
    # A script in the accessibility runner's folder, with host paths as arguments.
    param([string]$Script, [string[]]$Arguments)
    if ($node) { Install-A11y; return Invoke-UftiProcess -FilePath $node -ArgumentList (@($Script) + $Arguments) -WorkingDirectory $P.A11y }
    $image = $lock['containers']['playwright']
    $wd = ConvertTo-ContainerPath $P.A11y
    $cargs = ($Arguments | ForEach-Object { if ($_ -match '^[A-Za-z]:\\|^/') { ConvertTo-ContainerPath $_ } else { $_ } }) -join ' '
    Invoke-Container $image $wd @('bash', '-lc', "npm ci --no-audit --no-fund > /dev/null && node $Script $cargs")
}

# ---- Gates -----------------------------------------------------------------------------------

$results = [ordered]@{}
function Gate {
    param([string]$Name, [scriptblock]$Body)
    if ($Skip -contains $Name) { $results[$Name] = 'skipped'; return }
    Write-UftiStep "Gate: $Name"
    try {
        $r = & $Body
        if ($null -eq $r) { $results[$Name] = 'skipped'; Write-UftiNotice "$Name skipped: no tool to run it (install Python or Node, or Docker)" }
        else { $results[$Name] = $(if ($r) { 'pass' } else { 'FAIL' }) }
    }
    catch { Write-UftiProblem "$Name`: $_"; $results[$Name] = 'FAIL' }
}
function Save-Report { param([string]$Name, [string[]]$Lines) [System.IO.File]::WriteAllLines((Join-Path $reports $Name), $Lines) }

Gate 'log' {
    if (-not $Log -or -not (Test-Path -LiteralPath $Log)) { throw "no build log found (looked under $(Join-Path $outDir 'logs')); pass -Log" }
    $m = Get-UftiBuildMessages -Lines (Get-Content -LiteralPath $Log)
    Write-Host "  $Log`: $($m.Gated.Count) gated message(s), $($m.Info.Count) info"
    $m.Gated | Select-Object -Unique | ForEach-Object { Write-UftiProblem $_ }
    $m.Gated.Count -eq 0
}

Gate 'structure' {
    $bad = 0
    foreach ($f in $htmlFiles) {
        if ($f.Name -like 'print*.html') { continue }
        $t = Get-Content -LiteralPath $f.FullName -Raw
        $h1 = ([regex]::Matches($t, '<h1[\s>]')).Count; $main = ([regex]::Matches($t, '<main[\s>]')).Count
        if ($h1 -ne 1 -or $main -ne 1) { $bad++; Write-UftiProblem "$($f.Name): $h1 h1 and $main main (one of each expected)" -File ([System.IO.Path]::GetRelativePath($root, $f.FullName)) }
    }
    Write-Host "  $($htmlFiles.Count) page(s) checked"
    $bad -eq 0
}

Gate 'html' {
    if (-not (Test-Path -LiteralPath $P.VnuJar)) { throw "vnu.jar is not installed: run bootstrap.ps1 -Only vnu" }
    $r = Invoke-UftiProcess -FilePath 'java' -ArgumentList @('-jar', $P.VnuJar, '--errors-only', '--skip-non-html', $dir) -WorkingDirectory $root
    Save-Report 'vnu.txt' $r.Output
    $r.ExitCode -eq 0
}

Gate 'links' {
    $r = Invoke-Python 'check_links.py' @($dir)
    if ($null -eq $r) { return $null }
    Save-Report 'links.txt' $r.Output
    $r.ExitCode -eq 0
}

Gate 'metadata' {
    if (-not $SiteUrl) { throw 'no site URL: pass -SiteUrl, or set govuk.site.url in the project file' }
    $r = Invoke-Python 'check_metadata.py' @('--site-url', $SiteUrl, '--dita-dir', $P.DitaHome, $dir)
    if ($null -eq $r) { return $null }
    Save-Report 'metadata.txt' $r.Output
    $r.ExitCode -eq 0
}

Gate 'a11y' {
    # the plugin's runner's libraries, through our wrapper, which knows the documented exceptions
    foreach ($f in 'a11y.mjs', 'a11y-exceptions.json') { Copy-Item -LiteralPath (Join-Path $PSScriptRoot $f) -Destination (Join-Path $P.A11y $f) -Force -ErrorAction SilentlyContinue }
    $r = Invoke-Node 'a11y.mjs' @($dir)
    if ($null -eq $r) { return $null }
    Save-Report 'axe.txt' $r.Output
    $r.ExitCode -eq 0
}

Gate 'pdf-ua' {
    if ($pdfFiles.Count -eq 0) { throw 'no PDF in the output' }
    if (-not (Test-Path -LiteralPath $P.VeraPdf)) { throw "veraPDF is not installed: run bootstrap.ps1 -Only verapdf" }
    $ok = $true
    foreach ($pdf in $pdfFiles) {
        $r = Invoke-UftiProcess -FilePath $P.VeraPdf -ArgumentList @('--flavour', 'ua1', '--format', 'text', $pdf.FullName) -WorkingDirectory $root -Quiet
        Save-Report "verapdf-ua1-$($pdf.BaseName).txt" $r.Output
        $first = @($r.Output | Where-Object { $_ -match '^(PASS|FAIL) ' })
        if ($first.Count -and $first[0] -like 'PASS *') { Write-Host "  $($pdf.Name): PDF/UA-1 PASS" }
        else { $ok = $false; Write-UftiProblem "$($pdf.Name) is not PDF/UA-1"; $r.Output | Select-Object -First 30 | ForEach-Object { Write-Host "    $_" } }
        # PDF/UA-2 is advisory: reported, never gated
        $r2 = Invoke-UftiProcess -FilePath $P.VeraPdf -ArgumentList @('--flavour', 'ua2', '--format', 'text', $pdf.FullName) -WorkingDirectory $root -Quiet
        Save-Report "verapdf-ua2-$($pdf.BaseName).txt" $r2.Output
        $f2 = @($r2.Output | Where-Object { $_ -match '^(PASS|FAIL) ' })
        Write-Host "  $($pdf.Name): PDF/UA-2 (advisory) $(if ($f2.Count) { ($f2[0] -split ' ')[0] } else { 'unknown' })"
    }
    $ok
}

Gate 'pdf-fonts' {
    if ($pdfFiles.Count -eq 0) { throw 'no PDF in the output' }
    $lib = Join-Path $P.DesignSystemPdfHome 'lib'
    if (-not (Test-Path -LiteralPath $lib)) { throw "DesignSystemPDF is not installed (its PDFBox is used to read the PDF): run bootstrap.ps1 -Only designsystempdf" }
    # the class path spelt out: pwsh on Linux expands a wildcard argument into several
    $cp = (Get-ChildItem -LiteralPath $lib -Filter '*.jar' | ForEach-Object { $_.FullName }) -join [System.IO.Path]::PathSeparator
    $ok = $true
    foreach ($pdf in $pdfFiles) {
        # the 110 mm cap is the theme's own print rule for figures (build/theme/README.md, section 3)
        $r = Invoke-UftiProcess -FilePath 'java' -ArgumentList @('-cp', $cp, (Join-Path $PSScriptRoot 'PdfReport.java'), $pdf.FullName, '--require-font', 'SourceSerif4-Semibold', '--require-font', 'AtkinsonHyperlegibleNext-Regular', '--max-image-height-mm', '110') -WorkingDirectory $root
        Save-Report "pdf-report-$($pdf.BaseName).txt" $r.Output
        if ($r.ExitCode -ne 0) { $ok = $false }
    }
    $ok
}

Gate 'alt' {
    $bad = 0
    if ($Log -and (Test-Path -LiteralPath $Log)) { foreach ($l in (Get-Content -LiteralPath $Log | Where-Object { $_ -match 'DSPDF009W' })) { $bad++; Write-UftiProblem $l } }
    foreach ($f in $htmlFiles) {
        $t = Get-Content -LiteralPath $f.FullName -Raw
        foreach ($m in [regex]::Matches($t, '<img\b[^>]*>')) { if ($m.Value -notmatch '\balt=') { $bad++; Write-UftiProblem "$($f.Name): an img without alt: $($m.Value)" } }
        # an inline svg is named by aria-label or aria-labelledby, or by its own title child; a
        # decorative one is hidden
        foreach ($m in [regex]::Matches($t, '(?s)<svg\b(?<open>[^>]*)>(?<body>.*?)</svg>')) {
            $open = $m.Groups['open'].Value
            if ($open -match 'aria-hidden="true"' -or $open -match '\b(aria-label|aria-labelledby)=') { continue }
            if ($m.Groups['body'].Value -match '^\s*(<[^>]*>\s*)*?<title\b') { continue }
            $bad++; Write-UftiProblem "$($f.Name): an inline svg without an accessible name (no aria-label, no title child): <svg$($open.Substring(0, [math]::Min(100, $open.Length)))>"
        }
    }
    $bad -eq 0
}

Gate 'theme' {
    $bad = 0
    $theme = Join-Path $dir 'theme'
    $css = Join-Path $theme 'ufti.css'
    if (-not (Test-Path -LiteralPath $css)) { throw "theme/ufti.css is not in the output: args.css, args.cssroot, args.copycss or args.csspath is wrong" }
    foreach ($f in $htmlFiles) { if ((Get-Content -LiteralPath $f.FullName -Raw) -notmatch 'theme/ufti\.css"') { $bad++; Write-UftiProblem "$($f.Name) does not link theme/ufti.css" } }
    $srcFonts = Join-Path $root 'build' 'theme' 'assets' 'fonts'
    foreach ($font in Get-ChildItem -LiteralPath $srcFonts -Filter '*.ttf') {
        $copy = Join-Path $theme 'fonts' $font.Name
        if (-not (Test-Path -LiteralPath $copy)) { $bad++; Write-UftiProblem "theme/fonts/$($font.Name) was not copied (govuk.css.assets)" }
        elseif ((Get-UftiFileHash256 $copy) -ne (Get-UftiFileHash256 $font.FullName)) { $bad++; Write-UftiProblem "theme/fonts/$($font.Name) differs from the source font" }
    }
    foreach ($lic in 'AtkinsonHyperlegibleNext-OFL.txt', 'SourceSerif4-OFL.md') { if (-not (Test-Path -LiteralPath (Join-Path $theme 'licences' $lic))) { $bad++; Write-UftiProblem "theme/licences/$lic is not published with the fonts" } }
    foreach ($m in [regex]::Matches((Get-Content -LiteralPath $css -Raw), 'url\("(?<u>[^"]+)"\)')) {
        if (-not (Test-Path -LiteralPath (Join-Path $theme $m.Groups['u'].Value))) { $bad++; Write-UftiProblem "ufti.css refers to $($m.Groups['u'].Value), which is not beside it" }
    }
    Write-Host "  $($htmlFiles.Count) page(s) link the stylesheet; fonts and licences checked"
    $bad -eq 0
}

Gate 'theme-browser' {
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'theme-probe.mjs') -Destination (Join-Path $P.A11y 'theme-probe.mjs') -Force -ErrorAction SilentlyContinue
    $r = Invoke-Node 'theme-probe.mjs' @($dir)
    if ($null -eq $r) { return $null }
    Save-Report 'theme-browser.txt' $r.Output
    $r.ExitCode -eq 0
}

Gate 'weight' {
    $r = Invoke-Python 'page_weight.py' @('--report', '--budget-kb', '300', $dir)
    if ($null -eq $r) { return $null }
    Save-Report 'page-weight.txt' $r.Output
    $r.ExitCode -eq 0
}

Gate 'determinism' {
    if (-not $CompareWith) { Write-Host '  no second build to compare (pass -CompareWith)'; return $true }
    $other = Join-Path ([System.IO.Path]::GetFullPath($(if ([System.IO.Path]::IsPathRooted($CompareWith)) { $CompareWith } else { Join-Path $root $CompareWith }))) $Deliverable
    if (-not (Test-Path -LiteralPath $other)) { throw "no second build at $other" }
    # Pagefind's index is left out: its bytes differ between runs on identical pages (the plugin's
    # own determinism check builds without search for the same reason). Everything else, the PDF
    # included, must be byte for byte the same.
    $a = @{}; foreach ($f in Get-ChildItem -LiteralPath $dir -Recurse -File | Where-Object { $_.FullName -notmatch '[\\/]pagefind[\\/]' }) { $a[[System.IO.Path]::GetRelativePath($dir, $f.FullName)] = Get-UftiFileHash256 $f.FullName }
    $b = @{}; foreach ($f in Get-ChildItem -LiteralPath $other -Recurse -File | Where-Object { $_.FullName -notmatch '[\\/]pagefind[\\/]' }) { $b[[System.IO.Path]::GetRelativePath($other, $f.FullName)] = Get-UftiFileHash256 $f.FullName }
    $bad = 0
    foreach ($k in ($a.Keys + $b.Keys | Sort-Object -Unique)) {
        if (-not $a.ContainsKey($k)) { $bad++; Write-UftiProblem "only in the second build: $k" }
        elseif (-not $b.ContainsKey($k)) { $bad++; Write-UftiProblem "only in the first build: $k" }
        elseif ($a[$k] -ne $b[$k]) { $bad++; Write-UftiProblem "differs between builds: $k" }
    }
    Write-Host "  $($a.Count) file(s) compared"
    $bad -eq 0
}

# ---- Summary ---------------------------------------------------------------------------------

Write-Host ''
$failed = 0; $skipped = 0
foreach ($k in $results.Keys) {
    $v = $results[$k]
    if ($v -eq 'FAIL') { $failed++ } elseif ($v -eq 'skipped') { $skipped++ }
    Write-Host ("  {0,-14} {1}" -f $k, $v) -ForegroundColor $(if ($v -eq 'pass') { 'Green' } elseif ($v -eq 'FAIL') { 'Red' } else { 'Yellow' })
}
Write-Host "  reports: $reports"
if ($failed) { Write-Host "FAIL: $failed gate(s) failed for $Deliverable." -ForegroundColor Red; exit 1 }
if ($skipped -and -not $AllowSkips) { Write-Host "FAIL: $skipped gate(s) could not run for $Deliverable (pass -AllowSkips to accept that)." -ForegroundColor Red; exit 1 }
Write-Host "PASS: every output gate passed for $Deliverable$(if ($skipped) { " ($skipped skipped)" })." -ForegroundColor Green
