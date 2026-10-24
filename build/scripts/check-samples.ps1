#requires -Version 7
<#
.SYNOPSIS
  The sample-file gate: keeps real family data out of this public repository (DEC-111).

.DESCRIPTION
  Family tree files are ignored by .gitignore on purpose. One folder may hold them, the Brontë sample
  files in content/sample-data/bronte/stages/. This gate checks what is committed:

    1. Every tracked family tree file (*.ged, *.gdz, *.gedzip) is in that folder, and only *.ged files
       are allowed there: this gate cannot read an archive.
    2. Every file there has a header and a trailer.
    3. None has a submitter record, a contact detail (email, phone, fax, web page, address) or a file
       path in it. A media record may link a Wikimedia Commons image by its address (DEC-120).
    4. Every person in it is on the allow-list of people a screenshot may show (allow-list.md) and has
       a death date no later than the last death year, so nobody in a sample can be living.

  Exits 1 if any of that fails. Copyright 2026 Oughtibridge Ltd, Apache-2.0.

.PARAMETER Root
  The repository root. Default: this repository. The tests point it at a small repository of their own.

.PARAMETER LastDeathYear
  The latest death year a person in a sample may have. Default: 1930.
#>
[CmdletBinding()]
param(
    [string]$Root,
    [int]$LastDeathYear = 1930
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if (-not $Root) {
    Import-Module (Join-Path $PSScriptRoot 'UftiBuild.psm1') -Force
    $Root = Get-UftiRepoRoot
}
$stages = 'content/sample-data/bronte/stages/'
$commons = '^https://upload\.wikimedia\.org/wikipedia/commons/\S+$'   # the one kind of file line a sample may hold (DEC-120)
$allowListPath = Join-Path $Root 'content/sample-data/bronte/allow-list.md'
$problems = [System.Collections.Generic.List[string]]::new()
function Problem { param([string]$Path, [string]$Text) $problems.Add("${Path}: $Text"); Write-Host "  FAIL $Path`: $Text" -ForegroundColor Red }

function Normalize-Name { param([string]$Name) (($Name -replace '/', ' ') -replace '\s+', ' ').Trim().ToLowerInvariant() }

# ---- The allow-list: the names the app may show, from the table in allow-list.md ---------------
$allowed = [System.Collections.Generic.HashSet[string]]::new()
if (Test-Path -LiteralPath $allowListPath) {
    foreach ($line in [System.IO.File]::ReadAllLines($allowListPath)) {
        if ($line -match '^\|\s*P\d+\s*\|(?<name>[^|]*)\|(?<other>[^|]*)\|') {
            foreach ($n in (@($Matches.name) + ($Matches.other -split ','))) { if ($n.Trim()) { [void]$allowed.Add((Normalize-Name $n)) } }
        }
    }
}
else {
    Problem 'content/sample-data/bronte/allow-list.md' 'not found: the people a sample may hold cannot be checked'
}

# ---- Rule 1: where the files are ---------------------------------------------------------------
$tracked = @((& git -C $Root ls-files -z) -split "`0" | Where-Object { $_ -match '(?i)\.(ged|gdz|gedzip)$' })
foreach ($rel in $tracked) {
    $norm = $rel -replace '\\', '/'
    if (-not $norm.StartsWith($stages)) { Problem $norm "a family tree file outside $stages (the ignore rule is a safety net: do not force-add)" }
    elseif ($norm -notmatch '(?i)\.ged$') { Problem $norm 'an archive is not allowed here: this gate cannot read it' }
}

# ---- Rules 2 to 4: what is in each file --------------------------------------------------------
$people = 0
$files = 0
foreach ($rel in ($tracked | Where-Object { ($_ -replace '\\', '/').StartsWith($stages) -and $_ -match '(?i)\.ged$' })) {
    $norm = $rel -replace '\\', '/'
    $files++
    $lines = [System.IO.File]::ReadAllLines((Join-Path $Root $rel))
    $content = @($lines | Where-Object { $_.Trim() })
    if ($content.Count -eq 0 -or $content[0].TrimStart([char]0xFEFF).Trim() -ne '0 HEAD') { Problem $norm 'does not start with a header (0 HEAD)' }
    if ($content.Count -eq 0 -or $content[-1].Trim() -ne '0 TRLR') { Problem $norm 'does not end with a trailer (0 TRLR)' }

    $type = ''; $name = ''; $deathYears = [System.Collections.Generic.List[int]]::new(); $inDeath = $false
    $closePerson = {
        if ($type -eq 'INDI') {
            $script:people++
            $who = if ($name) { $name } else { '(a person with no name)' }
            if (-not $name -or -not $allowed.Contains((Normalize-Name $name))) { Problem $norm "$who is not on the allow-list" }
            if ($deathYears.Count -eq 0) { Problem $norm "$who has no death date, so could be living" }
            elseif (($deathYears | Measure-Object -Maximum).Maximum -gt $LastDeathYear) { Problem $norm "$who died after $LastDeathYear, so could have living relatives" }
        }
    }
    foreach ($line in $content) {
        $l = $line.TrimStart([char]0xFEFF).Trim()
        if ($l -match '^(?<lvl>\d+)\s+(?:(?<xref>@[^@]+@)\s+)?(?<tag>\S+)(?:\s+(?<val>.*))?$') {
            $lvl = [int]$Matches.lvl; $tag = $Matches.tag.ToUpperInvariant(); $val = if ($Matches.ContainsKey('val')) { $Matches.val } else { '' }
            if ($lvl -eq 0) {
                & $closePerson
                $type = $tag; $name = ''; $deathYears = [System.Collections.Generic.List[int]]::new(); $inDeath = $false
                if ($tag -eq 'SUBM') { Problem $norm 'has a submitter record: it names a real person' }
            }
            elseif ($lvl -eq 1) {
                $inDeath = ($tag -eq 'DEAT')
                if ($tag -eq 'NAME' -and $type -eq 'INDI' -and -not $name) { $name = $val }
                if ($tag -eq 'DEAT' -and $type -eq 'INDI' -and $val -match '\d{4}') { foreach ($m in [regex]::Matches($val, '\d{4}')) { $deathYears.Add([int]$m.Value) } }
            }
            elseif ($lvl -eq 2 -and $inDeath -and $tag -eq 'DATE') { foreach ($m in [regex]::Matches($val, '\d{4}')) { $deathYears.Add([int]$m.Value) } }
            # A file line is allowed only as a Wikimedia Commons link on a media record (DEC-120).
            if ($tag -eq 'FILE' -and $type -eq 'OBJE' -and $lvl -eq 1 -and $val -match $commons) { }
            elseif ($tag -eq 'FILE') { Problem $norm 'has a FILE line that is not a Wikimedia Commons link in a media record' }
            elseif ($tag -in @('EMAIL', 'PHON', 'FAX', 'WWW', 'ADDR')) { Problem $norm "has a $tag line: a contact detail" }
        }
        if ($l -match '(?i)[a-z]:\\|/Users/|/home/|AppData|\\\\[a-z0-9._-]+\\|[\w.+-]+@[\w-]+\.[\w.-]+') { Problem $norm "has a file path or an email address: $($l.Substring(0, [Math]::Min(60, $l.Length)))" }
    }
    & $closePerson
}

Write-Host ''
if ($problems.Count) { Write-Host "FAIL: $($problems.Count) problem(s) with family tree files." -ForegroundColor Red; exit 1 }
Write-Host "PASS: $($tracked.Count) family tree file(s) tracked, $files checked, $people people, nobody living." -ForegroundColor Green
exit 0
