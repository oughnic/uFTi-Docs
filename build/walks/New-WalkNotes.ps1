#requires -Version 7
<#
.SYNOPSIS
  Writes the notes.md skeleton for one leg of a walk: one line for each row of the sheet that names the leg.

.DESCRIPTION
  The walk plan (authoring/walks/walk-plan.md, DEC-209). Each machine that runs a leg starts from the same
  skeleton, fills in the Result and Seen columns, and drops the file with the leg's other results, so that
  collect-walk.ps1 can merge every leg into one table. The Result is one of Same, Different, Not found or
  Not done. Nothing here names a machine, an account or a device serial number.

  Copyright 2026 Oughtibridge Ltd, Apache-2.0.

.PARAMETER Sheet
  The sheet or sheets, by name: authoring/walks/<name>.md. Default: dates-places-names.

.PARAMETER Leg
  The leg's id, such as android-phone.

.PARAMETER Out
  Where to write the file. Default: notes.md in the current folder. An existing file is never overwritten
  unless -Force is given, because it may hold results.

.PARAMETER SheetsRoot
  The folder that holds the sheets. Default: authoring/walks in this repository.

.EXAMPLE
  pwsh build/walks/New-WalkNotes.ps1 -Leg android-phone -Out D:\drop\alpha-2-walk-1\android-phone\notes.md
#>
[CmdletBinding()]
param(
    [string[]]$Sheet = @('dates-places-names'),
    [Parameter(Mandatory)][ValidatePattern('^[a-z0-9]+(-[a-z0-9]+)*$')][string]$Leg,
    [string]$Out = (Join-Path (Get-Location) 'notes.md'),
    [string]$SheetsRoot,
    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'WalkSheet.psm1') -Force
$root = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..' '..'))
if (-not $SheetsRoot) { $SheetsRoot = Join-Path $root 'authoring' 'walks' }
$Sheet = @($Sheet | ForEach-Object { $_ -split ',' } | Where-Object { $_ })   # pwsh -File passes a comma list as one string

if ((Test-Path -LiteralPath $Out) -and -not $Force) { Write-Error "$Out exists and may hold results. Pass -Force to replace it."; exit 1 }

$sb = [System.Text.StringBuilder]::new()
[void]$sb.AppendLine("# Notes: $Leg")
[void]$sb.AppendLine()
[void]$sb.AppendLine('Fill in the **Result** and **Seen** columns. The Result is one of **Same** (as our page says), **Different** (write what you saw), **Not found** (the screen is not there) or **Not done**. Keep the row numbers as they are. Name no machine, no account and no serial number.')
[void]$sb.AppendLine()
$total = 0
foreach ($name in $Sheet) {
    $sheetObj = Read-WalkSheet -Path (Join-Path $SheetsRoot "$name.md")
    $rows = @(Get-WalkRowsForLeg -Sheet $sheetObj -Leg $Leg)
    [void]$sb.AppendLine("## Results: $name")
    [void]$sb.AppendLine()
    if ($rows.Count -eq 0) { [void]$sb.AppendLine("The sheet has no rows for $Leg."); [void]$sb.AppendLine(); continue }
    [void]$sb.AppendLine('| # | Result | Seen | Do this |')
    [void]$sb.AppendLine('|---|---|---|---|')
    foreach ($r in $rows) {
        [void]$sb.AppendLine(('| {0} | Not done |  | {1} |' -f $r.Id, ($r.Do -replace '\|', '/')))
        $total++
    }
    [void]$sb.AppendLine()
}
[void]$sb.AppendLine('## Anything else seen')
[void]$sb.AppendLine()
[void]$sb.AppendLine('Write here what the rows do not cover.')

$dir = Split-Path -Parent ([System.IO.Path]::GetFullPath($Out))
if ($dir -and -not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
[System.IO.File]::WriteAllText($Out, $sb.ToString().Replace("`r`n", "`n"))
Write-Host "$total row(s) for $Leg written to $Out"
