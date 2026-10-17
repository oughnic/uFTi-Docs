#requires -Version 7
<#
.SYNOPSIS
  Downloads the pinned tools into .tools/ and verifies their checksums.

.DESCRIPTION
  Reads build/tools.lock, fetches each tool from its pinned address, refuses any file whose size
  or SHA-256 differs, and installs it under the tools folder: the DITA Open Toolkit with the
  GOV.UK plugin, DesignSystemPDF, Pagefind, veraPDF, the Nu HTML Checker, Vale, gitleaks and the
  plugin repository's checkers. Nothing goes into C:\Program Files or the system PATH (DEC-015).
  Java 17 or later must already be installed. Safe to run again: a tool already installed at the
  pinned version is left alone.

  Copyright 2026 Oughtibridge Ltd, Apache-2.0.

.PARAMETER ToolsDir
  Where to install. Defaults to .tools/ at the repository root, or $env:UFTI_TOOLS. Keep it short
  on Windows: the toolkit's launcher repeats the path once per library.

.PARAMETER BuildOnly
  Only what a build needs: the toolkit, the plugin, DesignSystemPDF and Pagefind.

.PARAMETER Only
  A list of tools to install, by their names in tools.lock.

.PARAMETER Force
  Reinstall even when the pinned version is already there.

.PARAMETER RecordPending
  For a maintainer upgrading a tool: a checksum written as PENDING in tools.lock is computed and
  printed instead of failing, so it can be pasted into the lock. Never used by CI.

.EXAMPLE
  pwsh build/scripts/bootstrap.ps1
.EXAMPLE
  pwsh build/scripts/bootstrap.ps1 -BuildOnly
#>
[CmdletBinding()]
param(
    [string]$ToolsDir,
    [switch]$BuildOnly,
    [string[]]$Only,
    [switch]$Force,
    [switch]$RecordPending
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
Import-Module (Join-Path $PSScriptRoot 'UftiBuild.psm1') -Force

$root = Get-UftiRepoRoot
if (-not $ToolsDir) { $ToolsDir = Get-UftiToolsDir }
$ToolsDir = [System.IO.Path]::GetFullPath($ToolsDir)
$lock = Read-UftiToolsLock
$P = Get-UftiToolPaths -Lock $lock -ToolsDir $ToolsDir
$platform = Get-UftiPlatformId
foreach ($d in $ToolsDir, $P.Downloads, $P.Markers) { if (-not (Test-Path -LiteralPath $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null } }

$buildSet = @('dita-ot', 'govuk-plugin', 'designsystempdf', 'pagefind')
$checkSet = @('verapdf', 'vnu', 'vale', 'gitleaks', 'plugin-tools')
$wanted = if ($Only) { $Only } elseif ($BuildOnly) { $buildSet } else { $buildSet + $checkSet }
foreach ($w in $wanted) { if (-not $lock.Contains($w)) { throw "Unknown tool '$w'. Tools: $(($buildSet + $checkSet) -join ', ')" } }

Write-Host "Tools folder: $ToolsDir ($platform)"
if ($IsWindows -and $P.DitaHome.Length -gt 80) {
    Write-UftiNotice "The toolkit path is $($P.DitaHome.Length) characters long. If dita.bat fails with 'The input line is too long', set UFTI_TOOLS to a shorter folder and run bootstrap again (111 characters is known to fail; the default on Windows is %LOCALAPPDATA%\ufti-tools)."
}

# ---- Helpers ---------------------------------------------------------------------------------

function Test-Java {
    param([int]$Minimum)
    $java = Get-Command java -ErrorAction SilentlyContinue
    if (-not $java) { throw "Java $Minimum or later is needed and 'java' is not on the PATH." }
    $out = & $java.Source -version 2>&1 | Out-String
    if ($out -match 'version "(?<maj>\d+)(\.(?<min>\d+))?') {
        $major = [int]$Matches['maj']
        if ($major -eq 1 -and $Matches['min']) { $major = [int]$Matches['min'] }
        if ($major -lt $Minimum) { throw "Java $Minimum or later is needed; found $major ($($out.Trim()))." }
        Write-Host "Java $major found."
    }
    else { throw "Cannot read the Java version from: $out" }
}

function Get-Pinned {
    # Download a pinned file into downloads/ (or reuse it) and verify its size and checksum.
    param([Parameter(Mandatory)][string]$Tool, [string]$Key = 'url', [string]$SizeKey = 'size', [string]$ShaKey = 'sha256', [string]$Name)
    $url = Get-UftiLockValue -Lock $lock -Tool $Tool -Key $Key -Platform $platform
    if (-not $url) { throw "[$Tool] has no '$Key' for $platform in tools.lock" }
    $size = Get-UftiLockValue -Lock $lock -Tool $Tool -Key $SizeKey -Platform $platform
    $sha = Get-UftiLockValue -Lock $lock -Tool $Tool -Key $ShaKey -Platform $platform
    if (-not $Name) { $Name = [System.IO.Path]::GetFileName(([uri]$url).AbsolutePath) }
    $dest = Join-Path $P.Downloads $Name
    if ((Test-Path -LiteralPath $dest) -and $sha -and $sha -ne 'PENDING' -and (Get-UftiFileHash256 $dest) -eq $sha) {
        Write-Host "  ${Name}: already downloaded and verified"
        return $dest
    }
    Write-Host "  downloading $url"
    $tmp = "$dest.part"
    Invoke-WebRequest -Uri $url -OutFile $tmp -UseBasicParsing
    $actualSize = (Get-Item -LiteralPath $tmp).Length
    if ($size -and [int64]$size -ne $actualSize) { Remove-Item -LiteralPath $tmp; throw "$Name is $actualSize bytes; tools.lock says $size." }
    $actual = Get-UftiFileHash256 $tmp
    if (-not $sha -or $sha -eq 'PENDING') {
        if ($RecordPending) { Write-UftiNotice "${Name}: SHA-256 $actual (PENDING in tools.lock; record it)" }
        else { Remove-Item -LiteralPath $tmp; throw "$Name has no checksum in tools.lock (PENDING). A maintainer records it with -RecordPending." }
    }
    elseif ($actual -ne $sha) { Remove-Item -LiteralPath $tmp; throw "${Name}: SHA-256 is $actual, tools.lock says $sha. Not installed." }
    else { Write-Host "  ${Name}: $actualSize bytes, SHA-256 verified" }
    Move-Item -LiteralPath $tmp -Destination $dest -Force
    $dest
}

function Get-Marker { param([string]$Tool) $f = Join-Path $P.Markers $Tool; if (Test-Path -LiteralPath $f) { (Get-Content -LiteralPath $f -Raw).Trim() } else { $null } }
function Set-Marker { param([string]$Tool, [string]$Value) [System.IO.File]::WriteAllText((Join-Path $P.Markers $Tool), $Value) }
function Test-Installed {
    # True when the marker says this tool is installed at this pin and the folder is there.
    param([string]$Tool, [string]$Stamp, [string]$Path)
    (-not $Force) -and ((Get-Marker $Tool) -eq $Stamp) -and (Test-Path -LiteralPath $Path)
}
function Remove-Tree { param([string]$Path) if (Test-Path -LiteralPath $Path) { Remove-Item -LiteralPath $Path -Recurse -Force } }
function Expand-Tar { param([string]$Archive, [string]$Into) if (-not (Test-Path -LiteralPath $Into)) { New-Item -ItemType Directory -Path $Into -Force | Out-Null }; & tar -xzf $Archive -C $Into; if ($LASTEXITCODE -ne 0) { throw "tar failed on $Archive" } }
function Set-Executable { param([string[]]$Paths) if (-not $IsWindows) { foreach ($p in $Paths) { if (Test-Path -LiteralPath $p) { & chmod +x $p } } } }
function Assert-Runs {
    param([string]$Exe, [string[]]$Arguments, [string]$Expect, [string]$What)
    $out = (& $Exe @Arguments 2>&1 | Out-String)
    if ($LASTEXITCODE -ne 0 -or ($Expect -and $out -notmatch [regex]::Escape($Expect))) { throw "$What did not run as expected (exit $LASTEXITCODE): $($out.Trim())" }
    Write-Host "  $What ok: $(($out.Trim() -split "`n")[0])"
}

# ---- Tools -----------------------------------------------------------------------------------

function Install-DitaOt {
    $t = $lock['dita-ot']; $stamp = "$($t['version']) $($t['sha256'])"
    Write-UftiStep "DITA Open Toolkit $($t['version'])"
    if (Test-Installed 'dita-ot' $stamp $P.Dita) { Write-Host "  installed at $($P.DitaHome)"; return }
    Test-Java ([int]$lock['java']['minimum'])
    $zip = Get-Pinned 'dita-ot'
    Remove-Tree $P.DitaHome
    Expand-Archive -LiteralPath $zip -DestinationPath $ToolsDir -Force
    if (-not (Test-Path -LiteralPath $P.Dita)) { throw "The toolkit did not unpack to $($P.DitaHome)" }
    Set-Executable @((Join-Path $P.DitaBin 'dita'), (Join-Path $P.DitaBin 'ant'))
    Assert-Runs $P.Dita @('--version') $t['version'] 'dita --version'
    Set-Marker 'dita-ot' $stamp
}

function Get-InstalledPluginVersion {
    $px = Join-Path $P.PluginDir 'plugin.xml'
    if (Test-Path -LiteralPath $px) { if ((Get-Content -LiteralPath $px -Raw) -match 'version="(?<v>[^"]+)"') { return $Matches['v'] } }
    $null
}

function Install-Plugin {
    $t = $lock['govuk-plugin']; $stamp = "$($t['version']) $($t['sha256'])"
    Write-UftiStep "GOV.UK plugin $($t['id']) $($t['version'])"
    if (-not (Test-Path -LiteralPath $P.Dita)) { throw 'Install the toolkit first (dita-ot).' }
    $have = Get-InstalledPluginVersion
    if ((-not $Force) -and $have -eq $t['version'] -and (Get-Marker 'govuk-plugin') -eq $stamp) { Write-Host "  installed in the toolkit"; return }
    $zip = Get-Pinned 'govuk-plugin'
    if ($have) {
        Write-Host "  removing $($t['id']) $have"
        & $P.Dita uninstall $t['id'] 2>&1 | ForEach-Object { Write-Host "    $_" }
        if ($LASTEXITCODE -ne 0) { throw 'dita uninstall failed' }
    }
    # Run from the downloads folder: the toolkit treats a matching folder name in the working
    # folder as the thing to install (the plugin manual says so).
    Push-Location -LiteralPath $P.Downloads
    try { & $P.Dita install $zip 2>&1 | ForEach-Object { Write-Host "    $_" }; $code = $LASTEXITCODE } finally { Pop-Location }
    if ($code -ne 0) { throw 'dita install failed' }
    $out = (& $P.Dita transtypes 2>&1 | Out-String)
    if ($out -notmatch '(?m)^\s*govuk\s*$') { throw "The govuk transtype is not listed after installing: $out" }
    Write-Host "  govuk transtype available"
    Set-Marker 'govuk-plugin' $stamp
}

function Install-DesignSystemPdf {
    $t = $lock['designsystempdf']; $stamp = "$($t['version']) $($t['sha256'])"
    Write-UftiStep "DesignSystemPDF $($t['version'])"
    if (Test-Installed 'designsystempdf' $stamp $P.DesignSystemPdf) { Write-Host "  installed at $($P.DesignSystemPdfHome)"; return }
    Test-Java ([int]$lock['java']['minimum'])
    $zip = Get-Pinned 'designsystempdf'
    Remove-Tree $P.DesignSystemPdfHome
    Expand-Archive -LiteralPath $zip -DestinationPath $ToolsDir -Force
    if (-not (Test-Path -LiteralPath $P.DesignSystemPdf)) { throw "DesignSystemPDF did not unpack to $($P.DesignSystemPdfHome)" }
    Set-Executable @((Join-Path $P.DesignSystemPdfBin 'designsystempdf'))
    Assert-Runs $P.DesignSystemPdf @('--version') "DesignSystemPDF $($t['version'])" 'designsystempdf --version'
    Set-Marker 'designsystempdf' $stamp
}

function Install-Pagefind {
    $t = $lock['pagefind']; $sha = Get-UftiLockValue -Lock $lock -Tool 'pagefind' -Key 'sha256' -Platform $platform; $stamp = "$($t['version']) $sha"
    Write-UftiStep "Pagefind $($t['version'])"
    if (Test-Installed 'pagefind' $stamp $P.Pagefind) { Write-Host "  installed at $($P.Pagefind)"; return }
    $tgz = Get-Pinned 'pagefind'
    Remove-Tree $P.PagefindDir
    Expand-Tar $tgz $P.PagefindDir
    Set-Executable @($P.Pagefind)
    Assert-Runs $P.Pagefind @('--version') $t['version'] 'pagefind --version'
    Set-Marker 'pagefind' $stamp
}

function Install-VeraPdf {
    $t = $lock['verapdf']; $stamp = "$($t['version']) $($t['sha256'])"
    Write-UftiStep "veraPDF $($t['version'])"
    if (Test-Installed 'verapdf' $stamp $P.VeraPdf) { Write-Host "  installed at $($P.VeraPdfDir)"; return }
    Test-Java ([int]$lock['java']['minimum'])
    $zip = Get-Pinned 'verapdf'
    $unpack = Join-Path $P.Downloads 'verapdf-installer'
    Remove-Tree $unpack; Remove-Tree $P.VeraPdfDir
    Expand-Archive -LiteralPath $zip -DestinationPath $unpack -Force
    $jar = Join-Path $unpack $t['installer-jar']
    if (-not (Test-Path -LiteralPath $jar)) { throw "Installer jar not found: $jar" }
    & java "-DINSTALL_PATH=$($P.VeraPdfDir)" -jar $jar (Join-Path $PSScriptRoot 'verapdf-auto-install.xml') 2>&1 | ForEach-Object { Write-Host "    $_" }
    if ($LASTEXITCODE -ne 0) { throw 'The veraPDF installer failed' }
    Remove-Tree $unpack
    Set-Executable @((Join-Path $P.VeraPdfDir 'verapdf'))
    Assert-Runs $P.VeraPdf @('--version') "veraPDF $($t['version'])" 'verapdf --version'
    Set-Marker 'verapdf' $stamp
}

function Install-Vnu {
    $t = $lock['vnu']; $stamp = "$($t['version']) $($t['sha256'])"
    Write-UftiStep "Nu HTML Checker $($t['version'])"
    if (Test-Installed 'vnu' $stamp $P.VnuJar) { Write-Host "  installed at $($P.VnuJar)"; return }
    Test-Java ([int]$lock['java']['minimum'])
    $tgz = Get-Pinned 'vnu'
    $unpack = Join-Path $P.Downloads 'vnu-unpack'
    Remove-Tree $unpack
    Expand-Tar $tgz $unpack
    $jar = Join-Path $unpack $t['jar-in-archive']
    if (-not (Test-Path -LiteralPath $jar)) { throw "vnu.jar not found in the archive at $($t['jar-in-archive'])" }
    New-Item -ItemType Directory -Path (Split-Path -Parent $P.VnuJar) -Force | Out-Null
    Copy-Item -LiteralPath $jar -Destination $P.VnuJar -Force
    Remove-Tree $unpack
    Assert-Runs 'java' @('-jar', $P.VnuJar, '--version') $t['version'] 'vnu.jar --version'
    Set-Marker 'vnu' $stamp
}

function Install-Binary {
    # A single executable shipped as a zip (Windows) or tar.gz (elsewhere): Vale, gitleaks.
    param([string]$Tool, [string]$Dir, [string]$Exe, [string[]]$VersionArgs, [string]$Expect)
    $t = $lock[$Tool]; $sha = Get-UftiLockValue -Lock $lock -Tool $Tool -Key 'sha256' -Platform $platform; $stamp = "$($t['version']) $sha"
    Write-UftiStep "$Tool $($t['version'])"
    if (Test-Installed $Tool $stamp $Exe) { Write-Host "  installed at $Exe"; return }
    $file = Get-Pinned $Tool
    Remove-Tree $Dir
    if ($file -like '*.zip') { Expand-Archive -LiteralPath $file -DestinationPath $Dir -Force } else { Expand-Tar $file $Dir }
    Set-Executable @($Exe)
    Assert-Runs $Exe $VersionArgs $Expect "$Tool version"
    Set-Marker $Tool $stamp
}

function Install-PluginTools {
    $t = $lock['plugin-tools']
    $files = @($t.Keys | Where-Object { $_ -like 'file.*' })
    $joined = ($files | ForEach-Object { $t[$_] }) -join ","
    $digest = [System.BitConverter]::ToString([System.Security.Cryptography.SHA256]::HashData([System.Text.Encoding]::UTF8.GetBytes($joined))).Replace("-", "").Substring(0, 16).ToLowerInvariant()
    $stamp = "$($t["tag"]) $digest"
    Write-UftiStep "Plugin repository checkers at $($t['tag'])"
    if (Test-Installed 'plugin-tools' $stamp $P.PluginTools) { Write-Host "  installed at $($P.PluginTools)"; return }
    foreach ($k in $files) {
        $rel = $k.Substring(5); $sha = $t[$k]
        $dest = Join-Path $P.PluginTools $rel
        New-Item -ItemType Directory -Path (Split-Path -Parent $dest) -Force | Out-Null
        $url = $t['base'] + $rel
        Write-Host "  $rel"
        Invoke-WebRequest -Uri $url -OutFile "$dest.part" -UseBasicParsing
        $actual = Get-UftiFileHash256 "$dest.part"
        if ($actual -ne $sha) { Remove-Item -LiteralPath "$dest.part"; throw "${rel}: SHA-256 is $actual, tools.lock says $sha." }
        Move-Item -LiteralPath "$dest.part" -Destination $dest -Force
    }
    Set-Marker 'plugin-tools' $stamp
}

# ---- Run -------------------------------------------------------------------------------------

foreach ($tool in $wanted) {
    switch ($tool) {
        'dita-ot' { Install-DitaOt }
        'govuk-plugin' { Install-Plugin }
        'designsystempdf' { Install-DesignSystemPdf }
        'pagefind' { Install-Pagefind }
        'verapdf' { Install-VeraPdf }
        'vnu' { Install-Vnu }
        'vale' { Install-Binary 'vale' $P.ValeDir $P.Vale @('--version') $lock['vale']['version'] }
        'gitleaks' { Install-Binary 'gitleaks' $P.GitleaksDir $P.Gitleaks @('version') $lock['gitleaks']['version'] }
        'plugin-tools' { Install-PluginTools }
    }
}

Write-Host "`nDone. Tools in $ToolsDir. Build with: pwsh build/scripts/build.ps1 -Project fixture" -ForegroundColor Green
