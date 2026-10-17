#requires -Version 7
<#
.SYNOPSIS
  Builds one project file with the pinned toolkit, and fails on any build warning.

.DESCRIPTION
  A thin wrapper over "dita --project": puts the bootstrapped tools on the PATH (so the plugin
  finds Pagefind and DesignSystemPDF), runs the toolkit's Windows launcher dita.bat (or bin/dita
  elsewhere), keeps the log under out/logs/, and then reads the log: any GOVK, DOTX, DOTJ, DOTA
  or DSPDF warning, error or fatal message fails the build (build and quality, section 4), as
  does DOTJ047I, an unresolved key. With -Smoke the messages are reported and not gated
  (DEC-042: the stock html5 build only proves the sources build without the plugin).

  Copyright 2026 Oughtibridge Ltd, Apache-2.0.

.PARAMETER Project
  A name under build/projects/ (fixture, fixture-android-phone, fixture-smoke, ...) or a path.

.PARAMETER Output
  The output folder; each deliverable lands in its own subfolder. Default out/.

.EXAMPLE
  pwsh build/scripts/build.ps1 -Project fixture-android-phone
.EXAMPLE
  pwsh build/scripts/build.ps1 -Project fixture-smoke -Smoke
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Project,
    [string]$Output = 'out',
    [switch]$Smoke,
    [switch]$ShowInfo,
    [string]$ToolsDir
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'UftiBuild.psm1') -Force

$root = Get-UftiRepoRoot
if (-not $ToolsDir) { $ToolsDir = Get-UftiToolsDir }
$lock = Read-UftiToolsLock
$P = Get-UftiToolPaths -Lock $lock -ToolsDir $ToolsDir
if (-not (Test-Path -LiteralPath $P.Dita)) { Write-UftiProblem "The toolkit is not at $($P.DitaHome). Run build/scripts/bootstrap.ps1 first."; exit 1 }

$projectFile = if (Test-Path -LiteralPath $Project) { (Resolve-Path -LiteralPath $Project).Path } else { Join-Path $root 'build' 'projects' "$Project.xml" }
if (-not (Test-Path -LiteralPath $projectFile)) { Write-UftiProblem "No project file: $projectFile"; exit 1 }
$name = [System.IO.Path]::GetFileNameWithoutExtension($projectFile)
$outDir = if ([System.IO.Path]::IsPathRooted($Output)) { $Output } else { Join-Path $root $Output }
$outDir = [System.IO.Path]::GetFullPath($outDir)
$log = Join-Path $outDir 'logs' "$name.log"
$temp = Join-Path $outDir 'temp' $name

$onPath = Add-UftiToolsToPath -Paths $P
Write-UftiStep "Build $name"

# The toolkit writes into the output folder without clearing it, and Pagefind leaves old index
# fragments behind, so each deliverable's folder is removed first: a build is from nothing.
function Get-DeliverableOutputs {
    param([string]$File, [System.Collections.Generic.HashSet[string]]$Seen)
    if (-not $Seen.Add($File)) { return }
    [xml]$x = Get-Content -LiteralPath $File -Raw
    $ns = [System.Xml.XmlNamespaceManager]::new($x.NameTable); $ns.AddNamespace('p', 'https://www.dita-ot.org/project')
    foreach ($o in $x.SelectNodes('//p:deliverable/p:output/@href', $ns)) { $o.Value }
    foreach ($i in $x.SelectNodes('//p:include/@href', $ns)) { Get-DeliverableOutputs (Join-Path (Split-Path -Parent $File) $i.Value) $Seen }
}
foreach ($href in (Get-DeliverableOutputs $projectFile ([System.Collections.Generic.HashSet[string]]::new()))) {
    $target = [System.IO.Path]::GetFullPath((Join-Path $outDir $href))
    if ($target.StartsWith($outDir) -and $target -ne $outDir -and (Test-Path -LiteralPath $target)) { Remove-Item -LiteralPath $target -Recurse -Force; Write-Host "  cleared: $target" }
}
Write-Host "  project: $projectFile"
Write-Host "  output:  $outDir"
Write-Host "  tools:   $($onPath -join '; ')"

$started = Get-Date
$r = Invoke-UftiProcess -FilePath $P.Dita -ArgumentList @("--project=$projectFile", "--output=$outDir", "--temp=$temp") -WorkingDirectory $root -LogPath $log
$took = [int]((Get-Date) - $started).TotalSeconds
if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Recurse -Force -ErrorAction SilentlyContinue }
Write-Host "`n  log: $log ($took s)"

$m = Get-UftiBuildMessages -Lines $r.Output
$codes = @($m.Gated | ForEach-Object { if ($_ -match '\[((GOVK|DOTX|DOTJ|DOTA|DSPDF)\d{3}[WEFI])\]') { $Matches[1] } else { 'other' } } | Group-Object | ForEach-Object { "$($_.Name) x$($_.Count)" })
if ($ShowInfo -and $m.Info.Count) { Write-Host "  info messages: $($m.Info.Count)"; $m.Info | ForEach-Object { Write-Host "    $_" } }

if ($r.ExitCode -ne 0) { Write-UftiProblem "dita exited with $($r.ExitCode) building $name"; exit $r.ExitCode }
if ($m.Gated.Count -eq 0) { Write-Host "PASS: $name built with no warnings." -ForegroundColor Green; exit 0 }
if ($Smoke) {
    Write-UftiNotice "Smoke build ${name}: $($m.Gated.Count) message(s) reported, not gated: $($codes -join ', ')"
    $m.Gated | Select-Object -Unique | ForEach-Object { Write-Host "    $_" }
    exit 0
}
Write-UftiProblem "${name}: $($m.Gated.Count) build message(s) fail the build: $($codes -join ', ')"
$m.Gated | Select-Object -Unique | ForEach-Object { Write-Host "    $_" }
exit 1
