#requires -Version 7
<#
.SYNOPSIS
  What the build scripts share: where things are, the tool lock, the tools on the PATH, and
  running programs with their output kept.

.DESCRIPTION
  Imported by bootstrap.ps1, build.ps1, lint.ps1, check-source.ps1 and check-output.ps1.
  Copyright 2026 Oughtibridge Ltd, Apache-2.0.
#>
Set-StrictMode -Version Latest

function Get-UftiRepoRoot {
    # build/scripts/UftiBuild.psm1 -> the repository root
    (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..' '..')).Path
}

function Get-UftiToolsDir {
    # UFTI_TOOLS if set. Otherwise, on Windows, a short folder of the user's own: the toolkit's
    # dita.bat repeats its path once per library, and a long path overruns the command line limit
    # ("The input line is too long"), which a checkout under a deep folder reaches. Elsewhere,
    # .tools/ at the repository root.
    if ($env:UFTI_TOOLS) { return $env:UFTI_TOOLS }
    if ($IsWindows -and $env:LOCALAPPDATA) { return Join-Path $env:LOCALAPPDATA 'ufti-tools' }
    Join-Path (Get-UftiRepoRoot) '.tools'
}

function Get-UftiPlatformId {
    $arch = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture.ToString().ToLowerInvariant()
    $arch = if ($arch -eq 'arm64') { 'arm64' } else { 'x64' }
    if ($IsWindows) { return "windows-$arch" }
    if ($IsMacOS) { return "macos-$arch" }
    "linux-$arch"
}

function Read-UftiToolsLock {
    param([string]$Path = (Join-Path (Get-UftiRepoRoot) 'build' 'tools.lock'))
    $lock = [ordered]@{}
    $section = $null
    foreach ($raw in [System.IO.File]::ReadAllLines($Path)) {
        $line = $raw.Trim()
        if (-not $line -or $line.StartsWith('#')) { continue }
        if ($line -match '^\[(?<s>[A-Za-z0-9_.-]+)\]$') { $section = $Matches['s']; $lock[$section] = [ordered]@{}; continue }
        if ($line -match '^(?<k>[^=]+?)\s*=\s*(?<v>.*)$') {
            if (-not $section) { throw "$([System.IO.Path]::GetFileName($Path)): a value before any [section]: $line" }
            $lock[$section][$Matches['k'].Trim()] = $Matches['v'].Trim()
        }
        else { throw "$([System.IO.Path]::GetFileName($Path)): cannot read line: $line" }
    }
    $lock
}

function Get-UftiPlatformCandidates {
    # This platform, then the platform whose programs it can run (Windows on ARM runs x64 programs
    # under emulation; macOS on Apple silicon runs x64 under Rosetta), then no platform.
    param([string]$Platform = (Get-UftiPlatformId))
    $c = @($Platform)
    if ($Platform -eq 'windows-arm64') { $c += 'windows-x64' }
    if ($Platform -eq 'macos-arm64') { $c += 'macos-x64' }
    $c
}

function Get-UftiLockValue {
    # A key for this platform ("url.windows-x64"), a fallback platform's, or the plain key ("url").
    param([Parameter(Mandatory)]$Lock, [Parameter(Mandatory)][string]$Tool, [Parameter(Mandatory)][string]$Key, [string]$Platform = (Get-UftiPlatformId))
    if (-not $Lock.Contains($Tool)) { throw "tools.lock has no [$Tool] section" }
    $t = $Lock[$Tool]
    foreach ($p in (Get-UftiPlatformCandidates -Platform $Platform)) { if ($t.Contains("$Key.$p")) { return $t["$Key.$p"] } }
    if ($t.Contains($Key)) { return $t[$Key] }
    $null
}

function Get-UftiToolPaths {
    # Where bootstrap puts each tool. Nothing here checks that it exists.
    param($Lock = (Read-UftiToolsLock), [string]$ToolsDir = (Get-UftiToolsDir))
    $exe = if ($IsWindows) { '.exe' } else { '' }
    $bat = if ($IsWindows) { '.bat' } else { '' }
    $ditaHome = Join-Path $ToolsDir $Lock['dita-ot']['folder']
    $dspdfHome = Join-Path $ToolsDir $Lock['designsystempdf']['folder']
    [pscustomobject]@{
        ToolsDir        = $ToolsDir
        Downloads       = Join-Path $ToolsDir 'downloads'
        Markers         = Join-Path $ToolsDir '.installed'
        DitaHome        = $ditaHome
        DitaBin         = Join-Path $ditaHome 'bin'
        Dita            = Join-Path $ditaHome 'bin' "dita$bat"
        PluginDir       = Join-Path $ditaHome 'plugins' $Lock['govuk-plugin']['id']
        DesignSystemPdfHome = $dspdfHome
        DesignSystemPdfBin  = Join-Path $dspdfHome 'bin'
        DesignSystemPdf = Join-Path $dspdfHome 'bin' "designsystempdf$bat"
        PagefindDir     = Join-Path $ToolsDir 'pagefind'
        Pagefind        = Join-Path $ToolsDir 'pagefind' "pagefind$exe"
        VeraPdfDir      = Join-Path $ToolsDir 'verapdf'
        VeraPdf         = Join-Path $ToolsDir 'verapdf' "verapdf$bat"
        VnuJar          = Join-Path $ToolsDir 'vnu' 'vnu.jar'
        ValeDir         = Join-Path $ToolsDir 'vale'
        Vale            = Join-Path $ToolsDir 'vale' "vale$exe"
        GitleaksDir     = Join-Path $ToolsDir 'gitleaks'
        Gitleaks        = Join-Path $ToolsDir 'gitleaks' "gitleaks$exe"
        PluginTools     = Join-Path $ToolsDir 'plugin-tools'
        A11y            = Join-Path $ToolsDir 'plugin-tools' 'tools' 'a11y'
    }
}

function Add-UftiToolsToPath {
    # Prepend the tool folders that exist, so dita, designsystempdf, pagefind, verapdf, vale and
    # gitleaks are found by name, as the plugin finds Pagefind and DesignSystemPDF.
    param($Paths = (Get-UftiToolPaths))
    $sep = [System.IO.Path]::PathSeparator
    $dirs = @($Paths.DitaBin, $Paths.DesignSystemPdfBin, $Paths.PagefindDir, $Paths.VeraPdfDir, $Paths.ValeDir, $Paths.GitleaksDir) | Where-Object { Test-Path -LiteralPath $_ }
    $current = $env:PATH -split [regex]::Escape($sep)
    $new = @($dirs | Where-Object { $current -notcontains $_ })
    if ($new.Count) { $env:PATH = ($new + $current) -join $sep }
    $dirs
}

function Get-UftiFileHash256 {
    param([Parameter(Mandatory)][string]$Path)
    (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.ToLowerInvariant()
}

function Test-UftiCommand {
    param([Parameter(Mandatory)][string]$Name)
    $null -ne (Get-Command $Name -ErrorAction SilentlyContinue)
}

function Find-UftiInterpreter {
    # python3 or python (3.x only), node, docker: whichever this machine has.
    param([Parameter(Mandatory)][ValidateSet('python', 'node', 'docker')][string]$Kind)
    switch ($Kind) {
        'python' {
            foreach ($c in 'python3', 'python') {
                $cmd = Get-Command $c -ErrorAction SilentlyContinue
                if ($cmd) {
                    $v = & $cmd.Source --version 2>&1 | Out-String
                    if ($v -match 'Python 3\.') { return $cmd.Source }
                }
            }
            return $null
        }
        'node' { $cmd = Get-Command node -ErrorAction SilentlyContinue; if ($cmd) { return $cmd.Source }; return $null }
        'docker' {
            $cmd = Get-Command docker -ErrorAction SilentlyContinue
            if (-not $cmd) { return $null }
            & $cmd.Source info *> $null
            if ($LASTEXITCODE -eq 0) { return $cmd.Source }
            return $null
        }
    }
}

function Invoke-UftiProcess {
    <#
    .SYNOPSIS Run a program, show its output as it comes, keep a copy, and return the exit code.
    #>
    param(
        [Parameter(Mandatory)][string]$FilePath,
        [string[]]$ArgumentList = @(),
        [string]$WorkingDirectory = (Get-Location).Path,
        [string]$LogPath,
        [switch]$Quiet
    )
    $lines = [System.Collections.Generic.List[string]]::new()
    Push-Location -LiteralPath $WorkingDirectory
    try {
        # 2>&1 merges the error stream; the native command's exit code is in $LASTEXITCODE.
        & $FilePath @ArgumentList 2>&1 | ForEach-Object {
            $s = if ($_ -is [System.Management.Automation.ErrorRecord]) { $_.ToString() } else { [string]$_ }
            $lines.Add($s)
            if (-not $Quiet) { Write-Host $s }
        }
        $code = $LASTEXITCODE
    }
    finally { Pop-Location }
    if ($LogPath) {
        $dir = Split-Path -Parent $LogPath
        if ($dir -and -not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
        [System.IO.File]::WriteAllLines($LogPath, $lines)
    }
    [pscustomobject]@{ ExitCode = $code; Output = $lines }
}

function Write-UftiStep { param([string]$Message) Write-Host "`n== $Message" -ForegroundColor Cyan }

function Write-UftiProblem {
    # A failure line, and a GitHub Actions error annotation when run there.
    param([string]$Message, [string]$File, [int]$Line)
    if ($env:GITHUB_ACTIONS) {
        $where = if ($File) { "file=$File" + $(if ($Line) { ",line=$Line" } else { '' }) } else { '' }
        $safe = $Message -replace '%', '%25' -replace "`r", '%0D' -replace "`n", '%0A'
        Write-Host "::error ${where}::${safe}"
    }
    Write-Host "FAIL: $Message" -ForegroundColor Red
}

function Write-UftiNotice {
    param([string]$Message)
    if ($env:GITHUB_ACTIONS) { $safe = $Message -replace '%', '%25' -replace "`r", '%0D' -replace "`n", '%0A'; Write-Host "::notice::$safe" }
    Write-Host "NOTE: $Message" -ForegroundColor Yellow
}

function Get-UftiBuildMessages {
    <#
    .SYNOPSIS The toolkit, plugin and PDF generator messages in a build log, by severity.
    .DESCRIPTION
      Codes look like [GOVK001W], [DOTX008W], [DOTJ047I], [DSPDF009W]. Warnings, errors and fatal
      messages fail a build (build and quality, section 4). One info message is treated as a
      failure too: DOTJ047I, an unresolved key, because the plan requires zero unresolved keys and
      the toolkit reports it at the information level only, which the build scripts enable with
      --verbose (the default level prints nothing for it). The source lint checks keys as well.
    #>
    param([AllowNull()][AllowEmptyCollection()][string[]]$Lines)
    $gated = [System.Collections.Generic.List[string]]::new()
    $info = [System.Collections.Generic.List[string]]::new()
    if ($null -eq $Lines) { $Lines = @() }
    foreach ($l in $Lines) {
        if ($l -match '\[(?<code>(GOVK|DOTX|DOTJ|DOTA|DSPDF)\d{3}(?<sev>[WEFI]))\]') {
            $code = $Matches['code']
            if ($Matches['sev'] -ne 'I' -or $code -eq 'DOTJ047I') { $gated.Add($l.Trim()) } else { $info.Add($l.Trim()) }
        }
        elseif ($l -match '^\s*(BUILD FAILED|Error:|\[ERROR\]|Exception in thread)') { $gated.Add($l.Trim()) }
    }
    [pscustomobject]@{ Gated = $gated; Info = $info }
}

# ---- Publications: which release each platform is published as (build and quality, section 7) ----

function Test-UftiReleaseLabel {
    # Alpha-1, Beta-2, RC-1, 1.0, 1.2.3: the uFTi app's release, never this repository's version.
    param([AllowNull()][string]$Label)
    $Label -cmatch '^((Alpha|Beta|RC)-[1-9][0-9]*|[0-9]+\.[0-9]+(\.[0-9]+)?)$'
}

function Get-UftiReleaseSortKey {
    # A key that sorts as releases do: Alpha-1 < Alpha-2 < Beta-1 < RC-1 < 1.0 < 1.0.1 < 1.1. Compare
    # keys as strings, ordinally.
    param([Parameter(Mandatory)][string]$Label)
    if ($Label -cmatch '^(?<s>Alpha|Beta|RC)-(?<n>\d+)$') {
        $rank = @{ Alpha = 1; Beta = 2; RC = 3 }[$Matches['s']]
        return '{0}.{1:D6}.{2:D6}.{3:D6}' -f $rank, [int]$Matches['n'], 0, 0
    }
    if ($Label -cmatch '^(?<a>\d+)\.(?<b>\d+)(\.(?<c>\d+))?$') {
        $c = if ($Matches['c']) { [int]$Matches['c'] } else { 0 }
        return '{0}.{1:D6}.{2:D6}.{3:D6}' -f 4, [int]$Matches['a'], [int]$Matches['b'], $c
    }
    throw "'$Label' is not a release label"
}

function Read-UftiPublications {
    <#
    .SYNOPSIS The platforms and releases in build/publications.ini, checked.
    .DESCRIPTION
      Throws one error listing every problem: a missing or malformed release, a missing project
      file, a platform name that cannot be a folder, an app version that disagrees with the version
      the platform's pictures were checked against, and so on.
    #>
    param([string]$Path = (Join-Path (Get-UftiRepoRoot) 'build' 'publications.ini'))
    $root = Get-UftiRepoRoot
    $rel = [System.IO.Path]::GetRelativePath($root, $Path) -replace '\\', '/'
    $problems = [System.Collections.Generic.List[string]]::new()
    if (-not (Test-Path -LiteralPath $Path)) { throw "$rel does not exist" }
    $ini = Read-UftiToolsLock -Path $Path
    $headers = @(Get-Content -LiteralPath $Path | Where-Object { $_ -match '^\s*\[' } | ForEach-Object { $_.Trim() })
    foreach ($d in ($headers | Group-Object | Where-Object Count -gt 1)) { $problems.Add("section $($d.Name) appears more than once") }

    $base = $null
    if (-not $ini.Contains('site') -or -not $ini['site'].Contains('base-url')) { $problems.Add('[site] base-url is missing') }
    else {
        $base = $ini['site']['base-url']
        if ($base -notmatch '^https://[a-z0-9.-]+(:\d+)?/([A-Za-z0-9._~-]+/)*$') { $problems.Add("[site] base-url '$base' must be an https address that ends with a slash") }
    }

    $reserved = 'govuk', 'theme', 'pagefind', 'latest', 'start', 'logs', 'temp', 'reports', 'accessibility', 'privacy'
    $platforms = [System.Collections.Generic.List[object]]::new()
    foreach ($slug in $ini.Keys) {
        if ($slug -eq 'site') { continue }
        $s = $ini[$slug]
        $where = "[$slug]"
        if ($slug -cnotmatch '^[a-z0-9]+(-[a-z0-9]+)*$') { $problems.Add("$where the section name is the platform's folder: lower case letters, digits and single hyphens only") }
        if ($reserved -contains $slug) { $problems.Add("$where '$slug' is a name the site uses for something else") }
        foreach ($k in 'title', 'device', 'release', 'manual', 'quick-start') { if (-not $s.Contains($k) -or -not $s[$k]) { $problems.Add("$where $k is missing") } }
        foreach ($k in $s.Keys) { if ('title', 'device', 'release', 'app-version', 'manual', 'quick-start' -notcontains $k) { $problems.Add("$where unknown key '$k'") } }
        $release = if ($s.Contains('release')) { $s['release'] } else { '' }
        if ($release -and -not (Test-UftiReleaseLabel $release)) { $problems.Add("$where release '$release' is not in the agreed form (Alpha-N, Beta-N, RC-N, or a number such as 1.0 or 1.2.3)") }
        foreach ($k in 'manual', 'quick-start') {
            if ($s.Contains($k) -and $s[$k] -and -not (Test-Path -LiteralPath (Join-Path $root 'build' 'projects' "$($s[$k]).xml"))) { $problems.Add("$where $k '$($s[$k])' has no file build/projects/$($s[$k]).xml") }
        }
        # The version the app prints, wherever the platform's pictures recorded one.
        $appVersion = if ($s.Contains('app-version')) { $s['app-version'] } else { '' }
        $recorded = [System.Collections.Generic.List[string]]::new()
        $keyMap = Join-Path $root 'content' 'platforms' $slug 'keys' 'images.ditamap'
        if (Test-Path -LiteralPath $keyMap) { foreach ($m in [regex]::Matches((Get-Content -LiteralPath $keyMap -Raw), '<vrm version="([^"]*)"')) { $recorded.Add($m.Groups[1].Value) } }
        $manifest = Join-Path $root 'content' 'platforms' $slug 'images' 'manifest.json'
        if (Test-Path -LiteralPath $manifest) { $v = (Get-Content -LiteralPath $manifest -Raw | ConvertFrom-Json).app.version; if ($v) { $recorded.Add([string]$v) } }
        if ($recorded.Count -and -not $appVersion) { $problems.Add("$where the pictures record app version '$($recorded[0])', so app-version must say so") }
        foreach ($v in $recorded) { if ($appVersion -and $v -ne $appVersion) { $problems.Add("$where app-version '$appVersion' differs from '$v' recorded with the pictures: they change together") } }
        $platforms.Add([pscustomobject]@{
            Slug = $slug; Title = $s['title']; Device = $s['device']; Release = $release; AppVersion = $appVersion
            Manual = $s['manual']; QuickStart = $s['quick-start']
        })
    }
    if ($platforms.Count -eq 0) { $problems.Add('no platform is declared') }
    if ($problems.Count) { throw ("${rel}:`n  - " + ($problems -join "`n  - ")) }
    [pscustomobject]@{ BaseUrl = $base; Platforms = $platforms.ToArray() }
}

function Get-UftiFooterLinks {
    # The footer's link pairs, with the platform's own first. The shared pairs (accessibility
    # statement, privacy policy, source, licence) are read from common.xml; its "Choose your device"
    # pair is replaced, and the addresses of the two site pages are made from base-url (they are
    # pages of the root of the tree, DEC-150).
    param([Parameter(Mandatory)]$Publications, [Parameter(Mandatory)][ValidateSet('root', 'manual', 'quick-start')][string]$Kind, $Platform)
    $common = Get-Content -LiteralPath (Join-Path (Get-UftiRepoRoot) 'build' 'projects' 'common.xml') -Raw
    $b = $Publications.BaseUrl
    $sitePages = @{ 'Accessibility statement' = "${b}accessibility/"; 'Privacy policy' = "${b}privacy/" }
    $shared = if ($common -match 'name="govuk\.footer\.links"\s+value="(?<v>[^"]+)"') {
        @($Matches['v'] -split ';' | Where-Object { $_ -and $_ -notlike 'Choose your device|*' } | ForEach-Object {
            $label = ($_ -split '\|', 2)[0]
            if ($sitePages.ContainsKey($label)) { "$label|$($sitePages[$label])" } else { $_ }
        })
    } else { @() }
    $own = @("Choose your device|$b")
    if ($Kind -ne 'root') {
        $own += "Version $($Platform.Release): other versions|$b$($Platform.Slug)/"
        $own += if ($Kind -eq 'manual') { "Quick Start|$b$($Platform.Slug)/$($Platform.Release)/start/" } else { "Full manual|$b$($Platform.Slug)/$($Platform.Release)/" }
    }
    ($own + $shared) -join ';'
}

function Get-UftiPublishedDeliverable {
    <#
    .SYNOPSIS What a project's build needs from the publications: its address, PDF name and footer links.
    .DESCRIPTION
      Returns $null for a project that is not published (a fixture). The address is
      <base-url><platform>/<release>/ for a manual and <...>/start/ for its Quick Start, so the
      release in the file decides where the output goes and what every canonical link says.
    #>
    param([Parameter(Mandatory)]$Publications, [Parameter(Mandatory)][string]$Project)
    $b = $Publications.BaseUrl
    if ($Project -eq 'site-root') {
        return [pscustomobject]@{ Kind = 'root'; Platform = $null; Release = $null; SiteUrl = $b; PdfName = $null; FooterLinks = (Get-UftiFooterLinks -Publications $Publications -Kind root) }
    }
    foreach ($p in $Publications.Platforms) {
        if ($Project -ceq $p.Manual) {
            return [pscustomobject]@{ Kind = 'manual'; Platform = $p; Release = $p.Release; SiteUrl = "$b$($p.Slug)/$($p.Release)/"; PdfName = "ufti-user-manual-$($p.Slug)-$($p.Release)"; FooterLinks = (Get-UftiFooterLinks -Publications $Publications -Kind manual -Platform $p) }
        }
        if ($Project -ceq $p.QuickStart) {
            return [pscustomobject]@{ Kind = 'quick-start'; Platform = $p; Release = $p.Release; SiteUrl = "$b$($p.Slug)/$($p.Release)/start/"; PdfName = "ufti-quick-start-$($p.Slug)-$($p.Release)"; FooterLinks = (Get-UftiFooterLinks -Publications $Publications -Kind quick-start -Platform $p) }
        }
    }
    $null
}

function Get-UftiDeliverableParameters {
    # The toolkit arguments that a published project's build adds to its project file, so that the
    # release in build/publications.ini decides the address, the PDF name and the footer links.
    param([Parameter(Mandatory)]$Published)
    $a = @("--govuk.site.url=$($Published.SiteUrl)", "--govuk.footer.links=$($Published.FooterLinks)")
    if ($Published.PdfName) { $a += "--govuk.pdf.name=$($Published.PdfName)" }
    $a
}

Export-ModuleMember -Function Get-UftiRepoRoot, Get-UftiToolsDir, Get-UftiPlatformId, Get-UftiPlatformCandidates, Read-UftiToolsLock, Get-UftiLockValue, Get-UftiToolPaths, Add-UftiToolsToPath, Get-UftiFileHash256, Test-UftiCommand, Find-UftiInterpreter, Invoke-UftiProcess, Write-UftiStep, Write-UftiProblem, Write-UftiNotice, Get-UftiBuildMessages, Test-UftiReleaseLabel, Get-UftiReleaseSortKey, Read-UftiPublications, Get-UftiFooterLinks, Get-UftiPublishedDeliverable, Get-UftiDeliverableParameters
