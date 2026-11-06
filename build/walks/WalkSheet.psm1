#requires -Version 7
# Reads a walk sheet (authoring/walks/<name>.md) for New-WalkNotes.ps1 and collect-walk.ps1 (DEC-209).
#
# A sheet is Markdown. Under "Legs and groups" a table maps a token to the legs it stands for. Every
# other table whose first cell is a row number such as 1.1 holds the rows to walk: the first cell is the
# number, the second is what to do, and the last is "On", the legs (or tokens) the row applies to. A row
# whose only token is one that stands for no leg yet (help) is walked by no leg.
#
# Copyright 2026 Oughtibridge Ltd, Apache-2.0.

Set-StrictMode -Version Latest

function Split-WalkCells {
    param([string]$Line)
    $t = $Line.Trim()
    if ($t.StartsWith('|')) { $t = $t.Substring(1) }
    if ($t.EndsWith('|')) { $t = $t.Substring(0, $t.Length - 1) }
    , @($t -split '\|' | ForEach-Object { $_.Trim() })
}

function Read-WalkSheet {
    <#
    .SYNOPSIS
      The tokens and the rows of one sheet. Each row has Id, Section, Do and Legs (the leg ids it names,
      with every token resolved).
    #>
    param([Parameter(Mandatory)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { throw "No sheet at $Path" }
    $tokens = [ordered]@{}
    $raw = [System.Collections.Generic.List[object]]::new()
    $section = ''
    $inLegs = $false
    foreach ($line in [System.IO.File]::ReadAllLines($Path)) {
        if ($line -match '^#{1,3}\s') {
            $inLegs = $line -match '^###\s+Legs and groups'
            if ($line -match '^##\s+(?<s>.+)$') { $section = $Matches['s'] }
            continue
        }
        if (-not $line.StartsWith('|')) { continue }
        $cells = Split-WalkCells $line
        if ($inLegs) {
            if ($cells.Count -ge 2 -and $cells[0] -match '^`(?<t>[a-z0-9-]+)`$') {
                $tokens[$Matches['t']] = @([regex]::Matches($cells[1], '`(?<l>[a-z0-9-]+)`') | ForEach-Object { $_.Groups['l'].Value })
            }
            continue
        }
        if ($cells.Count -ge 3 -and $cells[0] -match '^\d+\.\d+$') {
            $on = @([regex]::Matches($cells[$cells.Count - 1], '`(?<l>[a-z0-9-]+)`') | ForEach-Object { $_.Groups['l'].Value })
            if ($on.Count -eq 0) { throw "$([System.IO.Path]::GetFileName($Path)): row $($cells[0]) names no leg or group in its last column" }
            $raw.Add([pscustomobject]@{ Id = $cells[0]; Section = $section; Do = $cells[1]; On = $on })
        }
    }
    $rows = [System.Collections.Generic.List[object]]::new()
    $seen = [System.Collections.Generic.HashSet[string]]::new()
    foreach ($r in $raw) {
        if (-not $seen.Add($r.Id)) { throw "$([System.IO.Path]::GetFileName($Path)): row $($r.Id) appears twice" }
        $legs = [System.Collections.Generic.List[string]]::new()
        foreach ($t in $r.On) {
            if ($tokens.Contains($t)) { foreach ($l in $tokens[$t]) { if (-not $legs.Contains($l)) { $legs.Add($l) } } }
            elseif (-not $legs.Contains($t)) { $legs.Add($t) }
        }
        $rows.Add([pscustomobject]@{ Id = $r.Id; Section = $r.Section; Do = $r.Do; On = $r.On; Legs = $legs.ToArray() })
    }
    [pscustomobject]@{ Name = [System.IO.Path]::GetFileNameWithoutExtension($Path); Tokens = $tokens; Rows = $rows.ToArray() }
}

function Get-WalkRowsForLeg {
    param([Parameter(Mandatory)]$Sheet, [Parameter(Mandatory)][string]$Leg)
    @($Sheet.Rows | Where-Object { $_.Legs -contains $Leg })
}

function Read-WalkResults {
    <#
    .SYNOPSIS
      The results a leg wrote in its notes.md: every table row whose first cell is a row number, as Id,
      Result and Seen. Anything else in the file is left alone.
    #>
    param([Parameter(Mandatory)][string]$Path)
    $out = [System.Collections.Generic.List[object]]::new()
    foreach ($line in [System.IO.File]::ReadAllLines($Path)) {
        if (-not $line.StartsWith('|')) { continue }
        $cells = Split-WalkCells $line
        if ($cells.Count -ge 2 -and $cells[0] -match '^\d+\.\d+$') {
            $out.Add([pscustomobject]@{ Id = $cells[0]; Result = $cells[1]; Seen = $(if ($cells.Count -ge 3) { $cells[2] } else { '' }) })
        }
    }
    $out.ToArray()
}

Export-ModuleMember -Function Split-WalkCells, Read-WalkSheet, Get-WalkRowsForLeg, Read-WalkResults
