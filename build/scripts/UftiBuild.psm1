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
            if (-not $section) { throw "tools.lock: a value before any [section]: $line" }
            $lock[$section][$Matches['k'].Trim()] = $Matches['v'].Trim()
        }
        else { throw "tools.lock: cannot read line: $line" }
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

Export-ModuleMember -Function Get-UftiRepoRoot, Get-UftiToolsDir, Get-UftiPlatformId, Get-UftiPlatformCandidates, Read-UftiToolsLock, Get-UftiLockValue, Get-UftiToolPaths, Add-UftiToolsToPath, Get-UftiFileHash256, Test-UftiCommand, Find-UftiInterpreter, Invoke-UftiProcess, Write-UftiStep, Write-UftiProblem, Write-UftiNotice, Get-UftiBuildMessages
