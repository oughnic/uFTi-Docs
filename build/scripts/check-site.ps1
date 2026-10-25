#requires -Version 7
<#
.SYNOPSIS
  Checks the publishable tree that build-site.ps1 assembles: its shape, its releases, its Static
  Web Apps configuration, and every link inside it.

.DESCRIPTION
  Pure PowerShell, so it needs no Python or Docker. It checks that:
    - the top level holds the root pages, the shared folders and one folder per platform in
      build/publications.ini, and nothing else; a platform folder holds its page and release folders;
    - every release folder in the tree has a version.json that names its own platform and release,
      a release label in the agreed form, a website, a Quick Start website (start/) and two PDFs;
      and each platform's current release is there;
    - staticwebapp.config.json is valid JSON, every redirect lands on a page, "latest" points at the
      current release, and the 404 page and the PDF content type are set;
    - every link in every page resolves to a file in the tree, with the exact letter case a server
      needs, including links from the root to a platform, a platform to its releases, and a manual
      to its Quick Start and back. Addresses that start with the base address of the site are
      followed into the tree; other addresses are counted and left alone;
    - a link to a part of a page (#...) names an id or anchor that page has;
    - each canonical address and each sitemap entry is the address of the page it is on, so a wrong
      release or base address in a build shows up here;
    - the accessibility statement and the privacy policy are at the top of the tree, every page's
      footer links them at addresses that start with the base address, and no page still links the
      accessibility statement on the marketing site.

  Reports go to out/reports/site/. Exits 1 on any failure.
  Copyright 2026 Oughtibridge Ltd, Apache-2.0.

.PARAMETER Output
  The output folder that holds site/. Default out/.
#>
[CmdletBinding()]
param(
    [string]$Output = 'out'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'UftiBuild.psm1') -Force

$root = Get-UftiRepoRoot
$outDir = [System.IO.Path]::GetFullPath($(if ([System.IO.Path]::IsPathRooted($Output)) { $Output } else { Join-Path $root $Output }))
$siteDir = Join-Path $outDir 'site'
$reports = Join-Path $outDir 'reports' 'site'
New-Item -ItemType Directory -Path $reports -Force | Out-Null
if (-not (Test-Path -LiteralPath $siteDir)) { Write-UftiProblem "No tree at $siteDir. Build it first with build-site.ps1."; exit 1 }
try { $pub = Read-UftiPublications } catch { Write-UftiProblem "$_"; exit 1 }
$base = $pub.BaseUrl

$problems = [System.Collections.Generic.List[string]]::new()
function Bad { param([string]$Message) $problems.Add($Message) }

# The tree, as sets of paths relative to its root with forward slashes. Ordinal comparison, because a
# server on Linux is case sensitive and this machine may not be.
$files = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
$lowerFiles = @{}
$dirs = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
foreach ($f in Get-ChildItem -LiteralPath $siteDir -Recurse -File) {
    $rel = [System.IO.Path]::GetRelativePath($siteDir, $f.FullName) -replace '\\', '/'
    [void]$files.Add($rel); $lowerFiles[$rel.ToLowerInvariant()] = $rel
    $d = [System.IO.Path]::GetDirectoryName($rel) -replace '\\', '/'
    while ($d) { [void]$dirs.Add($d); $d = [System.IO.Path]::GetDirectoryName($d) -replace '\\', '/' }
}
Write-UftiStep "Check the tree at $siteDir ($($files.Count) files)"

# ---- Shape -------------------------------------------------------------------------------------------

foreach ($need in 'index.html', 'not-found.html', 'staticwebapp.config.json', 'robots.txt', 'sitemap.xml', 'accessibility/index.html', 'privacy/index.html') { if (-not $files.Contains($need)) { Bad "the root has no $need" } }
$slugs = @($pub.Platforms | ForEach-Object Slug)
$shared = 'govuk', 'theme', 'accessibility', 'privacy'   # the shared folders and the two site pages (DEC-150)
foreach ($top in Get-ChildItem -LiteralPath $siteDir -Directory) {
    if ($slugs -cnotcontains $top.Name -and $shared -cnotcontains $top.Name) { Bad "unexpected folder at the root: $($top.Name)/ (a platform is added in build/publications.ini)" }
}
foreach ($p in $pub.Platforms) {
    $s = $p.Slug
    if (-not $files.Contains("$s/index.html")) { Bad "$s/ has no index.html (the list of its versions)" }
    foreach ($f in Get-ChildItem -LiteralPath (Join-Path $siteDir $s) -File -ErrorAction SilentlyContinue) { if ($f.Name -ne 'index.html') { Bad "$s/$($f.Name) does not belong in a platform folder" } }
    $versions = @(Get-ChildItem -LiteralPath (Join-Path $siteDir $s) -Directory -ErrorAction SilentlyContinue)
    if (-not ($versions | Where-Object { $_.Name -ceq $p.Release })) { Bad "$s/$($p.Release)/ is not in the tree: the current release of $s is missing" }
    foreach ($v in $versions) {
        $r = $v.Name; $dir = "$s/$r"
        if (-not (Test-UftiReleaseLabel $r)) { Bad "$dir/ is not a release label in the agreed form (Alpha-N, Beta-N, RC-N, or a number such as 1.0)"; continue }
        $vf = Join-Path $v.FullName 'version.json'
        if (-not (Test-Path -LiteralPath $vf)) { Bad "$dir/version.json is missing"; continue }
        try { $j = Get-Content -LiteralPath $vf -Raw | ConvertFrom-Json } catch { Bad "$dir/version.json is not valid JSON"; continue }
        if ($j.platform -cne $s -or $j.release -cne $r) { Bad "$dir/version.json says $($j.platform) $($j.release)" }
        foreach ($need in 'index.html', 'start/index.html', 'sitemap.xml', 'start/sitemap.xml', [string]$j.manualPdf, [string]$j.quickStartPdf) {
            if (-not $files.Contains("$dir/$need")) { Bad "$dir/$need is missing" }
        }
        foreach ($pdf in [string]$j.manualPdf, [string]$j.quickStartPdf) {
            $path = Join-Path $v.FullName $pdf
            if (-not (Test-Path -LiteralPath $path)) { continue }
            $fs = [System.IO.File]::OpenRead($path); try { $buf = [byte[]]::new(5); [void]$fs.Read($buf, 0, 5); $len = $fs.Length } finally { $fs.Dispose() }
            if ([System.Text.Encoding]::ASCII.GetString($buf) -ne '%PDF-' -or $len -lt 2000) { Bad "$dir/$pdf is not a PDF ($len bytes)" }
        }
        if ($r -ceq $p.Release -and $p.AppVersion -and $j.PSObject.Properties['appVersion'] -and $j.appVersion -cne $p.AppVersion) { Bad "$dir/version.json app version differs from build/publications.ini" }
    }
}

# ---- Static Web Apps configuration -------------------------------------------------------------------

$swaPath = Join-Path $siteDir 'staticwebapp.config.json'
if (Test-Path -LiteralPath $swaPath) {
    try {
        $swa = Get-Content -LiteralPath $swaPath -Raw | ConvertFrom-Json
        $landing = { param($t) $x = $t.TrimStart('/'); if ($x -eq '' -or $x.EndsWith('/')) { $x += 'index.html' }; $x }
        foreach ($r in @($swa.routes)) {
            if ($r.PSObject.Properties['redirect']) {
                if (-not $files.Contains((& $landing $r.redirect))) { Bad "staticwebapp.config.json: $($r.route) redirects to $($r.redirect), which is not a page in the tree" }
                if ($r.route -eq $r.redirect) { Bad "staticwebapp.config.json: $($r.route) redirects to itself" }
            }
        }
        # Azure treats a route with and without its closing slash as the same route, and refuses a file that has both
        $seen = @{}
        foreach ($r in @($swa.routes)) {
            $k = ([string]$r.route).TrimEnd('/').ToLowerInvariant(); if ($k -eq '') { $k = '/' }
            if ($seen.ContainsKey($k)) { Bad "staticwebapp.config.json: the route $($r.route) duplicates $($seen[$k]) (Azure ignores a closing slash)" } else { $seen[$k] = $r.route }
        }
        foreach ($p in $pub.Platforms) {
            $latest = @($swa.routes | Where-Object { $_.route -ceq "/$($p.Slug)/latest" })
            if ($latest.Count -ne 1 -or $latest[0].redirect -cne "/$($p.Slug)/$($p.Release)/") { Bad "staticwebapp.config.json: /$($p.Slug)/latest must redirect to /$($p.Slug)/$($p.Release)/ (the current release)" }
        }
        $nf = $swa.responseOverrides.'404'
        if (-not $nf -or -not $files.Contains(([string]$nf.rewrite).TrimStart('/'))) { Bad 'staticwebapp.config.json: the 404 response does not rewrite to a page in the tree' }
        if ($swa.mimeTypes.'.pdf' -ne 'application/pdf') { Bad 'staticwebapp.config.json: the content type of .pdf is not set' }
        if (-not $swa.globalHeaders.'cache-control') { Bad 'staticwebapp.config.json: no cache-control header' }
    }
    catch { Bad "staticwebapp.config.json is not valid: $_" }
}

# ---- Links, canonical addresses and sitemaps ---------------------------------------------------------

$ids = @{}
function Get-PageIds {
    param([string]$Rel)
    if (-not $ids.ContainsKey($Rel)) {
        $set = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::Ordinal)
        foreach ($m in $idRegex.Matches([System.IO.File]::ReadAllText((Join-Path $siteDir $Rel)))) { [void]$set.Add([System.Net.WebUtility]::HtmlDecode($m.Groups[1].Value)) }
        $ids[$Rel] = $set
    }
    $ids[$Rel]
}
$linkRegex = [regex]::new('(?i)<[a-z][^>]*?\s(?:href|src)\s*=\s*(?:"([^"]*)"|''([^'']*)'')', 'Compiled')
$idRegex = [regex]::new('(?i)\s(?:id|name)\s*=\s*"([^"]*)"', 'Compiled')
$canonRegex = [regex]::new('(?i)<link\s[^>]*rel="canonical"[^>]*href="([^"]+)"', 'Compiled')

function Resolve-TreePath {
    # A path under the tree from a page's folder and a relative path; $null if it climbs out of the tree.
    param([string]$FromDir, [string]$Path)
    $parts = [System.Collections.Generic.List[string]]::new()
    if ($FromDir) { $parts.AddRange([string[]]($FromDir -split '/')) }
    foreach ($seg in ($Path -split '/')) {
        if ($seg -eq '..') { if ($parts.Count -eq 0) { return $null }; $parts.RemoveAt($parts.Count - 1) }
        elseif ($seg -ne '.' -and $seg -ne '') { $parts.Add($seg) }
    }
    $parts -join '/'
}

$pages = @($files | Where-Object { $_.EndsWith('.html') -and $_ -notmatch '(^|/)pagefind/' } | Sort-Object)
$checked = 0; $external = 0; $skipped = 0; $crossRoots = 0
$externalSet = [System.Collections.Generic.HashSet[string]]::new()
# The not-found page is served at the address that was asked for, so a relative link in it (the stylesheet, the
# scripts, the platform pages) is looked for below that address and fails. Every link in it must be absolute.
$nfFile = Join-Path $siteDir 'not-found.html'
if (Test-Path -LiteralPath $nfFile) {
    $nfLeft = [regex]::Matches([System.IO.File]::ReadAllText($nfFile), '(?:href|src)="(?!https?://|#|mailto:|/)[^"]*"')
    if ($nfLeft.Count -gt 0) { Bad "not-found.html has $($nfLeft.Count) relative link(s), such as $($nfLeft[0].Value): it is served at the address that was asked for, so they fail there (they must start with the base address)" }
}

foreach ($page in $pages) {
    $text = [System.IO.File]::ReadAllText((Join-Path $siteDir $page))
    $fromDir = [System.IO.Path]::GetDirectoryName($page) -replace '\\', '/'
    # The footer of every page that has one links the two site pages, at the addresses base-url gives, and the old
    # address of the accessibility statement (the marketing site) is gone (DEC-150).
    if ($text -match 'class="govuk-footer"') {
        foreach ($want in "${base}accessibility/", "${base}privacy/") {
            if ($text.IndexOf("href=""$want""", [System.StringComparison]::Ordinal) -lt 0) { Bad "${page}: the footer does not link $want" }
        }
    }
    if ($text -match '(?<![\w.])ufti\.com/accessibility') { Bad "${page}: still links the accessibility statement on the marketing site (ufti.com/accessibility), which is now at ${base}accessibility/" }
    foreach ($m in $linkRegex.Matches($text)) {
        $url = [System.Net.WebUtility]::HtmlDecode(($m.Groups[1].Value + $m.Groups[2].Value)).Trim()
        if ($url -eq '') { continue }
        $rest = $null
        if ($url -match '^(?i:mailto|tel|data|javascript|blob):') { $skipped++; continue }
        if ($url.StartsWith($base, [System.StringComparison]::Ordinal)) { $rest = $url.Substring($base.Length); $fromDirUse = '' }
        elseif ($url -match '^(?i:https?:)?//') { $external++; [void]$externalSet.Add($url); continue }
        elseif ($page -ceq 'not-found.html' -and $url.StartsWith(([uri]$base).AbsolutePath, [System.StringComparison]::Ordinal)) { $rest = $url.Substring(([uri]$base).AbsolutePath.Length); $fromDirUse = '' }
        elseif ($url.StartsWith('/')) { Bad "${page}: the link $url starts with a slash, which breaks when the site is served below another path"; continue }
        else { $rest = $url; $fromDirUse = $fromDir }
        $checked++
        $frag = ''; $q = $rest.IndexOf('#'); if ($q -ge 0) { $frag = $rest.Substring($q + 1); $rest = $rest.Substring(0, $q) }
        $q = $rest.IndexOf('?'); if ($q -ge 0) { $rest = $rest.Substring(0, $q) }
        $rest = [Uri]::UnescapeDataString($rest)
        if ($rest -eq '') { $target = $page }
        else {
            $resolved = Resolve-TreePath $fromDirUse $rest
            if ($null -eq $resolved) { Bad "${page}: the link $url climbs out of the tree"; continue }
            $target = if ($rest.EndsWith('/') -or $resolved -eq '') { ($resolved + '/index.html').TrimStart('/') } else { $resolved }
            if (-not $files.Contains($target)) {
                if ($dirs.Contains($resolved)) { Bad "${page}: the link $url names a folder without a closing slash" }
                elseif ($lowerFiles.ContainsKey($target.ToLowerInvariant())) { Bad "${page}: the link $url differs in letter case from $($lowerFiles[$target.ToLowerInvariant()])" }
                else { Bad "${page}: the link $url does not resolve ($target is not in the tree)" }
                continue
            }
        }
        if ($frag -and $frag -notmatch '^:~:' -and $target.EndsWith('.html')) {
            $frag = [Uri]::UnescapeDataString($frag)
            if (-not (Get-PageIds $target).Contains($frag)) { Bad "${page}: the link $url names #$frag, which $target does not have" }
        }
    }
    $c = $canonRegex.Match($text)
    if ($c.Success -and $page -notmatch '^(print|search)\.html$|/(print|search)\.html$') {
        $want = $base + $page
        if ($c.Groups[1].Value -cne $want) { Bad "${page}: the canonical address is $($c.Groups[1].Value), not $want" }
    }
}
foreach ($sm in $files | Where-Object { $_ -ceq 'sitemap.xml' -or $_.EndsWith('/sitemap.xml') } | Sort-Object) {
    $dir = [System.IO.Path]::GetDirectoryName($sm) -replace '\\', '/'
    $prefix = if ($dir) { "$base$dir/" } else { $base }
    foreach ($m in [regex]::Matches([System.IO.File]::ReadAllText((Join-Path $siteDir $sm)), '<loc>([^<]+)</loc>')) {
        $loc = $m.Groups[1].Value.Trim()
        if (-not $loc.StartsWith($prefix, [System.StringComparison]::Ordinal)) { Bad "${sm}: $loc is not below $prefix"; continue }
        $checked++
        if (-not $files.Contains($loc.Substring($base.Length))) { Bad "${sm}: $loc is not a page in the tree" }
    }
}

[System.IO.File]::WriteAllLines((Join-Path $reports 'links.txt'), @("pages: $($pages.Count)", "links followed: $checked", "external links left alone: $external ($($externalSet.Count) distinct)", "skipped (mailto, data...): $skipped", "problems: $($problems.Count)") + $problems)
Write-Host "  $($pages.Count) page(s), $checked link(s) and sitemap entries followed, $external external link(s) left alone ($($externalSet.Count) distinct)"
Write-Host "  report: $(Join-Path $reports 'links.txt')"
if ($problems.Count) {
    $problems | Select-Object -First 60 | ForEach-Object { Write-UftiProblem $_ }
    if ($problems.Count -gt 60) { Write-Host "  ... and $($problems.Count - 60) more, in the report" }
    Write-Host "FAIL: the tree has $($problems.Count) problem(s)." -ForegroundColor Red
    exit 1
}
Write-Host 'PASS: the tree is well formed and every link in it resolves.' -ForegroundColor Green
