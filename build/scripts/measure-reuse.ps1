#requires -Version 7
<#
.SYNOPSIS
  How far the mobile manuals' copies of a topic differ: the figure that says whether two topics
  can be one (platform strategy, section 3).

.DESCRIPTION
  The four mobile manuals (Android phone, Android tablet, iPhone, iPad) each keep a topic of their own
  for the pages that differ by device. This compares each topic that has the same file name in two of
  those folders, under content/platforms/, and counts the lines that differ. It ignores what is not
  text a reader sees: the XML declaration, the document type, the dates, comments and blank lines.

  Two figures for each pair:
    Lines   the lines that are in one file and not the other. A line that changed counts twice.
    Masked  the same, after the device word (phone, tablet, iPhone, iPad, Android phone, Android
            tablet) is replaced by one placeholder. A topic whose Masked figure is 0 differs only by
            a word that the key `product-device` gives (platform strategy, section 3.1), so it can be
            one topic.

  The pairs are the same operating system on the two idioms' sides (Android phone with iPhone, Android
  tablet with iPad) and the same idiom on the two operating systems (Android phone with Android tablet,
  iPhone with iPad). The figures say where to look; they do not decide. A difference may be a screen
  the other device does not have, and that needs a person who has walked both.

.PARAMETER Root
  The repository root. Defaults to the one above build/scripts.
.PARAMETER Topic
  Only the topics whose file name contains this text.
.PARAMETER Max
  Only the pairs whose Masked figure is at most this. Default: all.
.PARAMETER PassThru
  Return the rows as objects, and write no table (the lint uses this).

.EXAMPLE
  pwsh build/scripts/measure-reuse.ps1 -Max 4
#>
[CmdletBinding()]
param(
    [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..' '..')).Path,
    [string]$Topic,
    [int]$Max = [int]::MaxValue,
    [switch]$PassThru
)

$ErrorActionPreference = 'Stop'

$pairs = @(
    @('android-phone', 'iphone'),
    @('android-tablet', 'ipad'),
    @('android-phone', 'android-tablet'),
    @('iphone', 'ipad')
)
$deviceWord = '\b(?:Android phone|Android tablet|iPhone|iPad|phone|tablet)\b'

function Get-Lines {
    param([string]$Path, [switch]$MaskDevice)
    $text = Get-Content -LiteralPath $Path -Raw
    $text = [regex]::Replace($text, '<!--.*?-->', '', 'Singleline')
    $lines = foreach ($l in ($text -split "\r?\n")) {
        $t = $l.Trim()
        if (-not $t -or $t -match '^<\?xml|^<!DOCTYPE|^<(created|revised)\b') { continue }
        if ($MaskDevice) { $t = [regex]::Replace($t, $deviceWord, 'DEVICE', 'IgnoreCase') }
        $t
    }
    , @($lines)
}

function Get-Distance {
    param([string[]]$A, [string[]]$B)
    $d = Compare-Object -ReferenceObject $A -DifferenceObject $B -CaseSensitive
    @($d).Count
}

$platforms = Join-Path $Root 'content' 'platforms'
$rows = foreach ($pair in $pairs) {
    $left = Join-Path $platforms $pair[0] 'topics'
    $right = Join-Path $platforms $pair[1] 'topics'
    if (-not (Test-Path -LiteralPath $left) -or -not (Test-Path -LiteralPath $right)) { continue }
    foreach ($f in Get-ChildItem -LiteralPath $left -Filter '*.dita' | Sort-Object Name) {
        if ($Topic -and $f.Name -notlike "*$Topic*") { continue }
        $other = Join-Path $right $f.Name
        if (-not (Test-Path -LiteralPath $other)) { continue }
        $masked = Get-Distance (Get-Lines $f.FullName -MaskDevice) (Get-Lines $other -MaskDevice)
        if ($masked -gt $Max) { continue }
        [pscustomobject]@{
            Topic  = $f.BaseName
            Pair   = "$($pair[0]) / $($pair[1])"
            Lines  = Get-Distance (Get-Lines $f.FullName) (Get-Lines $other)
            Masked = $masked
        }
    }
}

if ($PassThru) { $rows; return }
if (-not $rows) { Write-Host 'No topic pairs found.'; return }
$rows | Sort-Object Pair, Masked, Topic | Format-Table -AutoSize
Write-Host "$(@($rows).Count) pair(s). Masked 0 means the pair differs only by the device word."
