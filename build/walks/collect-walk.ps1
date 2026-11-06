#requires -Version 7
<#
.SYNOPSIS
  Collects one run of a walk from the shared drop folder: checks every leg, merges the results into one
  report, and runs the screenshot importer for the legs that give pictures.

.DESCRIPTION
  The walk plan (authoring/walks/walk-plan.md, DEC-209). A run folder holds run.json and one folder for
  each leg:

    <run>/run.json                  { "id", "build": { "label", "version", "build" }, "sheets": [...],
                                      "legs": [ { "id", "kind": "pictures" | "behaviour", "manual" } ] }
    <run>/<leg>/leg-result.json     { "leg", "status": "complete" | "partial" | "failed",
                                      "build": { "version", "build" }, "environment": { "os", ... } }
    <run>/<leg>/notes.md            the Results table that New-WalkNotes.ps1 wrote, filled in
    <run>/<leg>/manifest.json       pictures legs only: the screenshot manifest
    <run>/<leg>/screens/<name>.png  pictures legs only
    <run>/<leg>/SHA256SUMS          every file of the leg but itself

  It fails (exit 1) when a leg is missing or not complete, a leg ran another build than the run, a checksum
  does not match or a file is not listed, a result file holds a key that names a device serial number, a
  host or an account, a row is missing or unknown or its Result is not one of Same, Different, Not found
  or Not done, a name on the private deny-list appears in any text file (or in the report), or the
  importer fails. A Different or Not found row is a finding, not a failure: the report lists them.

  The report is written to <Out>/walk-report.md. Nothing is committed and nothing is sent anywhere.
  The importer runs with -WhatIf unless -Import is given, because a real import changes the manual's
  pictures in this repository.

  Copyright 2026 Oughtibridge Ltd, Apache-2.0.

.PARAMETER Run
  The run folder in the shared drop.

.PARAMETER Out
  Where the report and the importer reports go. Default: <Run>/report.

.PARAMETER DenyList
  A private file of names that must never appear in a text file of the run or in the report, one per line
  (host names, account names). It is never committed. Default: <Run>/deny-list.txt when it exists.
  A hit is reported by file and line, never by the name itself.

.PARAMETER Import
  Run the importer for real. Without it the importer runs with -WhatIf.

.PARAMETER NoImport
  Do not run the importer.

.PARAMETER AllowPartial
  Accept a leg whose status is partial, or that is missing, and say so in the report.

.PARAMETER SheetsRoot
  The folder that holds the sheets. Default: authoring/walks in this repository.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Run,
    [string]$Out,
    [string]$DenyList,
    [switch]$Import,
    [switch]$NoImport,
    [switch]$AllowPartial,
    [string]$SheetsRoot
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'WalkSheet.psm1') -Force
Import-Module (Join-Path $PSScriptRoot '..' 'scripts' 'UftiBuild.psm1') -Force
$root = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..' '..'))
if (-not $SheetsRoot) { $SheetsRoot = Join-Path $root 'authoring' 'walks' }
$Run = [System.IO.Path]::GetFullPath($Run)
if (-not $Out) { $Out = Join-Path $Run 'report' }
$Out = [System.IO.Path]::GetFullPath($Out)

$failures = [System.Collections.Generic.List[string]]::new()
$notices = [System.Collections.Generic.List[string]]::new()
function Fail { param([string]$Message) $failures.Add($Message); Write-UftiProblem $Message }
function Notice { param([string]$Message) $notices.Add($Message); Write-UftiNotice $Message }

$words = 'Same', 'Different', 'Not found', 'Not done'
$forbiddenKey = '(?i)serial|imei|udid|android.?id|\badb\b|host|computer|machine|user|account|e-?mail|mac.?address'

function Get-JsonKeys {
    # every property name in a parsed JSON value, at any depth
    param($Value)
    if ($null -eq $Value) { return }
    if ($Value -is [System.Management.Automation.PSCustomObject]) {
        foreach ($p in $Value.PSObject.Properties) { $p.Name; Get-JsonKeys $p.Value }
    }
    elseif ($Value -is [System.Collections.IEnumerable] -and $Value -isnot [string]) { foreach ($v in $Value) { Get-JsonKeys $v } }
}
function Read-Json {
    param([string]$Path, [string]$What)
    try { Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json -Depth 20 }
    catch { Fail "$What is not valid JSON: $([System.IO.Path]::GetRelativePath($Run, $Path) -replace '\\', '/')"; $null }
}
function Get-Prop { param($Object, [string]$Name) if ($null -ne $Object -and $Object.PSObject.Properties[$Name]) { $Object.$Name } else { $null } }
function Rel { param([string]$Path) [System.IO.Path]::GetRelativePath($Run, $Path) -replace '\\', '/' }

# ---- The run ---------------------------------------------------------------------------------

Write-UftiStep "Collect the walk in $Run"
$runFile = Join-Path $Run 'run.json'
if (-not (Test-Path -LiteralPath $runFile)) { Write-UftiProblem "No run.json in $Run"; exit 1 }
$runDef = Read-Json $runFile 'run.json'
if (-not $runDef) { exit 1 }
$runId = [string](Get-Prop $runDef 'id')
if ($runId -notmatch '^[a-z0-9]+(-[a-z0-9]+)*$') { Fail "run.json: the id '$runId' is not in lower case letters, digits and hyphens" }
$build = Get-Prop $runDef 'build'
$buildVersion = [string](Get-Prop $build 'version'); $buildNumber = [string](Get-Prop $build 'build')
if (-not $buildVersion -or -not $buildNumber) { Fail 'run.json: build needs a version and a build number' }
$runLegs = @(Get-Prop $runDef 'legs')
if ($runLegs.Count -eq 0) { Fail 'run.json: no legs' }
$legIds = [System.Collections.Generic.HashSet[string]]::new()
foreach ($l in $runLegs) {
    $id = [string](Get-Prop $l 'id'); $kind = [string](Get-Prop $l 'kind')
    if ($id -notmatch '^[a-z0-9]+(-[a-z0-9]+)*$') { Fail "run.json: a leg id '$id' is not in lower case letters, digits and hyphens"; continue }
    if (-not $legIds.Add($id)) { Fail "run.json: the leg $id is listed twice" }
    if ($kind -notin 'pictures', 'behaviour') { Fail "run.json: the leg $id has kind '$kind' (pictures or behaviour)" }
    if ($kind -eq 'pictures' -and -not [string](Get-Prop $l 'manual')) { Fail "run.json: the pictures leg $id names no manual" }
}
$sheetNames = @(Get-Prop $runDef 'sheets')
$sheets = @()
foreach ($n in $sheetNames) {
    try { $sheets += , (Read-WalkSheet -Path (Join-Path $SheetsRoot "$n.md")) } catch { Fail "sheet '$n': $_" }
}
if ($sheetNames.Count -eq 0) { Notice 'run.json names no sheet, so no results are expected' }

# the private deny-list
$deny = @()
if (-not $DenyList -and (Test-Path -LiteralPath (Join-Path $Run 'deny-list.txt'))) { $DenyList = Join-Path $Run 'deny-list.txt' }
if ($DenyList) {
    if (-not (Test-Path -LiteralPath $DenyList)) { Fail 'the deny-list file does not exist' }
    else { $deny = @(Get-Content -LiteralPath $DenyList | ForEach-Object { $_.Trim() } | Where-Object { $_ -and -not $_.StartsWith('#') }) }
}
function Test-Deny {
    # reports a file and a line, never the name
    param([string]$Path, [string]$Text, [string]$Label)
    $n = 0
    foreach ($line in ($Text -split "`n")) {
        $n++
        foreach ($d in $deny) { if ($line.IndexOf($d, [StringComparison]::OrdinalIgnoreCase) -ge 0) { Fail "$Label line ${n}: a name on the deny-list appears"; break } }
    }
}
$denyFile = if ($DenyList) { [System.IO.Path]::GetFullPath($DenyList) } else { '' }

# ---- The legs -----------------------------------------------------------------------------------

$grid = [ordered]@{}        # row id -> @{ leg -> result }
$seenText = @{}             # "row|leg" -> what was seen
$legStatus = [System.Collections.Generic.List[object]]::new()
$findings = [System.Collections.Generic.List[object]]::new()
$present = [System.Collections.Generic.List[string]]::new()

foreach ($l in $runLegs) {
    $id = [string](Get-Prop $l 'id'); $kind = [string](Get-Prop $l 'kind'); $manual = [string](Get-Prop $l 'manual')
    $dir = Join-Path $Run $id
    $status = 'missing'
    if (-not (Test-Path -LiteralPath $dir -PathType Container)) {
        if ($AllowPartial) { Notice "$id has not been dropped; the report says so" } else { Fail "$id has not been dropped: no folder $id in the run" }
        $legStatus.Add([pscustomobject]@{ Leg = $id; Kind = $kind; Status = $status }); continue
    }
    $present.Add($id)

    # leg-result.json
    $resFile = Join-Path $dir 'leg-result.json'
    if (-not (Test-Path -LiteralPath $resFile)) { Fail "$id has no leg-result.json" }
    else {
        $res = Read-Json $resFile "$id/leg-result.json"
        if ($res) {
            if ([string](Get-Prop $res 'leg') -ne $id) { Fail "$id/leg-result.json is for the leg '$(Get-Prop $res 'leg')'" }
            $status = [string](Get-Prop $res 'status')
            if ($status -notin 'complete', 'partial', 'failed') { Fail "$id/leg-result.json: status '$status' is not complete, partial or failed" }
            elseif ($status -ne 'complete') { if ($AllowPartial -and $status -eq 'partial') { Notice "$id is partial" } else { Fail "$id is $status, not complete" } }
            $b = Get-Prop $res 'build'
            if ([string](Get-Prop $b 'version') -ne $buildVersion -or [string](Get-Prop $b 'build') -ne $buildNumber) {
                Fail "$id ran build $(Get-Prop $b 'version') ($(Get-Prop $b 'build')), not the run's $buildVersion ($buildNumber)"
            }
            if (-not (Get-Prop (Get-Prop $res 'environment') 'os')) { Fail "$id/leg-result.json has no environment card (environment.os)" }
            foreach ($k in @(Get-JsonKeys $res) | Where-Object { $_ -match $forbiddenKey }) { Fail "$id/leg-result.json has a key '$k': keep serial numbers, hosts and accounts out of the run" }
        }
    }

    # the checksums
    $sumFile = Join-Path $dir 'SHA256SUMS'
    $files = @(Get-ChildItem -LiteralPath $dir -Recurse -File | Where-Object { $_.Name -ne 'SHA256SUMS' })
    if (-not (Test-Path -LiteralPath $sumFile)) { Fail "$id has no SHA256SUMS" }
    else {
        $listed = @{}
        foreach ($line in [System.IO.File]::ReadAllLines($sumFile)) {
            if ($line -match '^(?<h>[0-9a-fA-F]{64})\s[ *](?<p>.+)$') { $listed[($Matches['p'] -replace '\\', '/')] = $Matches['h'].ToLowerInvariant() }
            elseif ($line.Trim()) { Fail "$id/SHA256SUMS: a line that is not 'hash  path'" }
        }
        foreach ($f in $files) {
            $rel = [System.IO.Path]::GetRelativePath($dir, $f.FullName) -replace '\\', '/'
            if (-not $listed.ContainsKey($rel)) { Fail "$id/$rel is not listed in SHA256SUMS"; continue }
            if ((Get-FileHash -LiteralPath $f.FullName -Algorithm SHA256).Hash.ToLowerInvariant() -ne $listed[$rel]) { Fail "$id/$rel does not match its checksum" }
        }
        foreach ($p in $listed.Keys) { if (-not (Test-Path -LiteralPath (Join-Path $dir $p))) { Fail "$id/$p is in SHA256SUMS but not in the folder" } }
    }

    # pictures
    if ($kind -eq 'pictures') {
        $mf = Join-Path $dir 'manifest.json'
        if (-not (Test-Path -LiteralPath $mf)) { Fail "$id has no manifest.json" }
        else {
            $m = Read-Json $mf "$id/manifest.json"
            if ($m) {
                if ([string](Get-Prop (Get-Prop $m 'app') 'version') -ne $buildVersion) { Fail "$id/manifest.json is for app version $(Get-Prop (Get-Prop $m 'app') 'version'), not $buildVersion" }
                if ([string](Get-Prop $m 'manual') -ne $manual) { Fail "$id/manifest.json is for the manual '$(Get-Prop $m 'manual')', not '$manual'" }
                foreach ($k in @(Get-JsonKeys $m) | Where-Object { $_ -match $forbiddenKey }) { Fail "$id/manifest.json has a key '$k': keep serial numbers, hosts and accounts out of the run" }
            }
        }
        if (-not (Test-Path -LiteralPath (Join-Path $dir 'screens'))) { Fail "$id has no screens folder" }
    }

    # the text files, against the deny-list
    foreach ($f in $files | Where-Object { $_.Extension -in '.json', '.md', '.txt' -and $_.FullName -ne $denyFile }) { Test-Deny $f.FullName ([System.IO.File]::ReadAllText($f.FullName)) (Rel $f.FullName) }

    # the results
    $notes = Join-Path $dir 'notes.md'
    $expected = @()
    foreach ($s in $sheets) { $expected += @(Get-WalkRowsForLeg -Sheet $s -Leg $id) }
    if (-not (Test-Path -LiteralPath $notes)) { if ($expected.Count) { Fail "$id has no notes.md" } }
    else {
        $got = @(Read-WalkResults -Path $notes)
        $byId = @{}
        foreach ($r in $got) {
            if ($byId.ContainsKey($r.Id)) { Fail "$id/notes.md: row $($r.Id) appears twice"; continue }
            $byId[$r.Id] = $r
            $word = $words | Where-Object { $_ -ieq $r.Result } | Select-Object -First 1
            if (-not $word) { Fail "$id/notes.md: row $($r.Id) has the result '$($r.Result)': use Same, Different, Not found or Not done"; continue }
            if (-not ($expected | Where-Object { $_.Id -eq $r.Id })) { Fail "$id/notes.md: row $($r.Id) is not a row of the sheet for this leg"; continue }
            if (-not $grid.Contains($r.Id)) { $grid[$r.Id] = @{} }
            $grid[$r.Id][$id] = $word
            $seenText["$($r.Id)|$id"] = $r.Seen
            if ($word -in 'Different', 'Not found') { $findings.Add([pscustomobject]@{ Id = $r.Id; Leg = $id; Result = $word; Seen = $r.Seen }) }
        }
        $missing = @($expected | Where-Object { -not $byId.ContainsKey($_.Id) })
        if ($missing.Count) { Fail "$id/notes.md has no line for row(s) $(($missing | ForEach-Object { $_.Id }) -join ', ')" }
    }
    $legStatus.Add([pscustomobject]@{ Leg = $id; Kind = $kind; Status = $status })
}
# a folder that the run does not list
foreach ($d in Get-ChildItem -LiteralPath $Run -Directory | Where-Object { $_.Name -ne 'report' }) { if (-not $legIds.Contains($d.Name)) { Notice "the folder $($d.Name) is not a leg of this run" } }

# ---- The report -----------------------------------------------------------------------------------

$sb = [System.Text.StringBuilder]::new()
function Line { param([string]$Text = '') [void]$sb.AppendLine($Text) }
Line "# Walk report: $runId"
Line
Line "Build $buildVersion ($buildNumber)$(if ((Get-Prop $build 'label')) { ", $(Get-Prop $build 'label')" }). Collected by `build/walks/collect-walk.ps1`. Nothing here has been reviewed yet."
Line
Line '## Legs'
Line
Line '| Leg | Kind | Status |'
Line '|---|---|---|'
foreach ($s in $legStatus) { Line "| ``$($s.Leg)`` | $($s.Kind) | $($s.Status) |" }
Line
$legsInReport = @($runLegs | ForEach-Object { [string](Get-Prop $_ 'id') } | Where-Object { $_ -in $present })
foreach ($s in $sheets) {
    Line "## Results: $($s.Name)"
    Line
    $use = @($legsInReport | Where-Object { $leg = $_; @($s.Rows | Where-Object { $_.Legs -contains $leg }).Count -gt 0 })
    if ($use.Count -eq 0) { Line 'No leg walks a row of this sheet.'; Line; continue }
    $header = ($use | ForEach-Object { '`' + $_ + '`' }) -join ' | '
    $rule = (@($use | ForEach-Object { '---' })) -join '|'
    Line "| # | Do this | $header |"
    Line "|---|---|$rule|"
    foreach ($row in $s.Rows) {
        if (@($row.Legs | Where-Object { $_ -in $use }).Count -eq 0) { continue }
        $short = if ($row.Do.Length -gt 70) { $row.Do.Substring(0, 67) + '...' } else { $row.Do }
        $cells = foreach ($u in $use) {
            if ($row.Legs -notcontains $u) { 'n/a' }
            elseif ($grid.Contains($row.Id) -and $grid[$row.Id].ContainsKey($u)) { $v = $grid[$row.Id][$u]; if ($v -in 'Different', 'Not found') { "**$v**" } else { $v } }
            else { 'Not done' }
        }
        Line "| $($row.Id) | $($short -replace '\|', '/') | $($cells -join ' | ') |"
    }
    Line
}
Line '## Findings'
Line
if ($findings.Count -eq 0) { Line 'No row is Different or Not found.' }
else {
    Line 'Each is a row that did not match our page, or a screen that was not there. Decide for each whether the page, the app or the release should move.'
    Line
    foreach ($f in $findings | Sort-Object { [int]$_.Id.Split('.')[0] * 1000 + [int]$_.Id.Split('.')[1] }, Leg) { Line "- **$($f.Id)**, ``$($f.Leg)``, $($f.Result): $(if ($f.Seen) { $f.Seen } else { 'nothing written' })" }
}
Line
$reportText = $sb.ToString().Replace("`r`n", "`n")
Test-Deny '' $reportText 'the report'

if (-not $failures.Count) {
    New-Item -ItemType Directory -Path $Out -Force | Out-Null
    $reportPath = Join-Path $Out 'walk-report.md'
    [System.IO.File]::WriteAllText($reportPath, $reportText)
    Write-Host "report: $reportPath"
}

# ---- The importer -----------------------------------------------------------------------------------

if (-not $NoImport -and -not $failures.Count) {
    foreach ($l in $runLegs) {
        if ([string](Get-Prop $l 'kind') -ne 'pictures') { continue }
        $id = [string](Get-Prop $l 'id')
        if ($id -notin $present) { continue }
        $importArgs = @('-NoProfile', '-File', (Join-Path $root 'build' 'scripts' 'Import-Screenshots.ps1'), '-Capture', (Join-Path $Run $id), '-Manual', [string](Get-Prop $l 'manual'), '-ReportPath', (Join-Path $Out "import-$id.md"))
        if (-not $Import) { $importArgs += '-WhatIf' }
        Write-UftiStep "Import the pictures of $id$(if (-not $Import) { ' (-WhatIf: nothing is written)' })"
        & pwsh @importArgs
        if ($LASTEXITCODE -ne 0) { Fail "the importer failed for $id" }
    }
}

Write-Host ''
Write-Host "$($present.Count) of $($runLegs.Count) leg(s) present; $($findings.Count) finding(s); $($notices.Count) notice(s)."
if ($failures.Count) { Write-Host "FAIL: $($failures.Count) problem(s) in the run $runId." -ForegroundColor Red; exit 1 }
Write-Host "PASS: the run $runId is collected." -ForegroundColor Green
