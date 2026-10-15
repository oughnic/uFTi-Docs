#requires -Version 7
<#
.SYNOPSIS
  Checks the uFTi publisher stylesheet.

.DESCRIPTION
  1. Contrast: every foreground and background pairing the stylesheet uses meets WCAG 2.2 AA
     (4.5:1 for text, 3:1 for boundaries and other non-text parts).
  2. Hygiene: no hex colour outside the tokens block, except a print-section literal that names
     its token ("ufti: literal <token>") and equals it; no var() in the print section; every
     var(--ufti-...) names a defined token; and every font file the stylesheet names exists.

  Exits 0 when everything passes and 1 otherwise. Copyright 2026 Oughtibridge Ltd, Apache-2.0.

.PARAMETER Css
  The stylesheet to check. Defaults to ufti.css beside this script.

.PARAMETER Markdown
  Also print the contrast results as a Markdown table, for pasting into README.md.
#>
[CmdletBinding()]
param(
    [string]$Css = (Join-Path $PSScriptRoot 'ufti.css'),
    [switch]$Markdown
)

$ErrorActionPreference = 'Stop'
$Css = (Resolve-Path -LiteralPath $Css).Path
$themeRoot = Split-Path -Parent $Css
$text = [System.IO.File]::ReadAllText($Css)
$failures = [System.Collections.Generic.List[string]]::new()

# ---- Tokens ----------------------------------------------------------------------------------

$block = [regex]::Match($text, '/\* BEGIN TOKENS: theme (?<id>\S+) (?<version>[0-9][0-9.]*),(?<body>.*?)/\* END TOKENS \*/', 'Singleline')
if (-not $block.Success) { Write-Error 'No tokens block found: expected "BEGIN TOKENS: theme <id> <version>," and "END TOKENS".' }

$tokens = @{}
foreach ($t in [regex]::Matches($block.Groups['body'].Value, '--ufti-(?<name>[a-z0-9-]+):\s*(?<value>[^;]+);')) {
    $tokens[$t.Groups['name'].Value] = $t.Groups['value'].Value.Trim()
}
Write-Output ("Theme {0} {1}: {2} tokens" -f $block.Groups['id'].Value, $block.Groups['version'].Value, $tokens.Count)

# ---- Contrast --------------------------------------------------------------------------------

function ConvertTo-Rgb([string]$hex) {
    if ($hex -notmatch '^#(?<r>[0-9A-Fa-f]{2})(?<g>[0-9A-Fa-f]{2})(?<b>[0-9A-Fa-f]{2})([0-9A-Fa-f]{2})?$') { throw "Not a hex colour: $hex" }
    return @([Convert]::ToInt32($Matches['r'], 16), [Convert]::ToInt32($Matches['g'], 16), [Convert]::ToInt32($Matches['b'], 16))
}

# Relative luminance and contrast ratio as WCAG 2.2 defines them.
function Get-Luminance([string]$hex) {
    $lin = foreach ($c in ConvertTo-Rgb $hex) {
        $s = $c / 255.0
        if ($s -le 0.04045) { $s / 12.92 } else { [math]::Pow(($s + 0.055) / 1.055, 2.4) }
    }
    return 0.2126 * $lin[0] + 0.7152 * $lin[1] + 0.0722 * $lin[2]
}

function Get-Ratio([string]$a, [string]$b) {
    $la = Get-Luminance $a; $lb = Get-Luminance $b
    $hi = [math]::Max($la, $lb); $lo = [math]::Min($la, $lb)
    return ($hi + 0.05) / ($lo + 0.05)
}

# Foreground token, background token, minimum ratio, where it is used.
$text45 = 4.5; $non3 = 3.0
$pairs = @(
    @('on-surface',            'surface-raised',     $text45, 'Body text on the page'),
    @('on-surface',            'surface',            $text45, 'Body text on the page edge and in the footer'),
    @('on-surface',            'surface-container',  $text45, 'Code blocks, sidebar toggle, grey tags'),
    @('on-surface-muted',      'surface-raised',     $text45, 'Secondary text, hints, captions, attributions'),
    @('on-surface-muted',      'surface',            $text45, 'Secondary text in the footer'),
    @('on-surface-muted',      'surface-container',  $text45, 'Secondary text on tinted fills'),
    @('link',                  'surface-raised',     $text45, 'Links in topic text, the sidebar and contents lists'),
    @('link',                  'surface',            $text45, 'Footer links'),
    @('link',                  'surface-container',  $text45, 'Links inside tinted fills'),
    @('on-primary-container',  'surface-raised',     $text45, 'Link hover on the page'),
    @('on-primary-container',  'surface',            $text45, 'Link hover in the footer'),
    @('on-surface',            'surface-raised',     $text45, 'Link active state'),
    @('on-primary',            'primary',            $text45, 'Masthead title, primary buttons, current page'),
    @('on-primary',            'on-primary-container', $text45, 'Primary button on hover'),
    @('on-primary-container',  'primary-container',  $text45, 'Default tag and the phase banner tag'),
    @('on-success-container',  'success-container',  $text45, 'Green tag'),
    @('on-error-container',    'error-container',    $text45, 'Red tag'),
    @('on-warning-container',  'warning-container',  $text45, 'Orange and yellow tags'),
    @('primary',               'surface-container',  $text45, 'Secondary button text'),
    @('primary',               'primary-container',  $text45, 'Secondary button on hover'),
    @('on-surface',            'selection',          $text45, 'Selected text'),
    @('on-primary',            'error',              $text45, 'Warning button'),
    @('error',                 'surface-raised',     $text45, 'Error text'),
    @('success',               'surface-raised',     $text45, 'Success text'),
    @('outline',               'surface-raised',     $non3,   'Borders and rules on the page, the inset bar, screenshot edges'),
    @('outline',               'surface',            $non3,   'Borders and rules on the page edge'),
    @('outline-strong',        'surface-raised',     $non3,   'Input borders, search box, secondary button edge'),
    @('outline-strong',        'surface-container',  $non3,   'Secondary button edge on its fill'),
    @('primary',               'surface-raised',     $non3,   'The brand rule above the footer')
)

$results = foreach ($p in $pairs) {
    foreach ($n in $p[0], $p[1]) { if (-not $tokens.ContainsKey($n)) { throw "Token --ufti-$n is not defined" } }
    $ratio = Get-Ratio $tokens[$p[0]] $tokens[$p[1]]
    [pscustomobject]@{
        Pair   = "$($p[0]) on $($p[1])"
        Colours = "$($tokens[$p[0]]) on $($tokens[$p[1]])"
        Ratio  = [math]::Round($ratio, 2)
        Needs  = $p[2]
        Pass   = ($ratio -ge $p[2])
        Use    = $p[3]
    }
}

# The Design System's focus state is kept as it is. These are not our tokens, but the focus state
# still has to be visible on our masthead and readable as text.
$focusYellow = '#FFDD00'; $focusText = '#0B0C0C'
$design = @(
    [pscustomobject]@{ Pair = 'focus yellow on primary'; Colours = "$focusYellow on $($tokens['primary'])"; Ratio = [math]::Round((Get-Ratio $focusYellow $tokens['primary']), 2); Needs = $non3; Pass = ((Get-Ratio $focusYellow $tokens['primary']) -ge $non3); Use = 'Focus ring on the masthead (Design System colour)' },
    [pscustomobject]@{ Pair = 'focus text on focus yellow'; Colours = "$focusText on $focusYellow"; Ratio = [math]::Round((Get-Ratio $focusText $focusYellow), 2); Needs = $text45; Pass = ((Get-Ratio $focusText $focusYellow) -ge $text45); Use = 'Text of a focused link (Design System colours)' }
)
$results = @($results) + $design

$results | Format-Table Pair, Colours, Ratio, Needs, Pass, Use -AutoSize -Wrap | Out-String -Width 200 | Write-Output
foreach ($r in $results | Where-Object { -not $_.Pass }) { $failures.Add("Contrast: $($r.Pair) is $($r.Ratio):1, needs $($r.Needs):1 ($($r.Use))") }

if ($Markdown) {
    Write-Output '| Pairing | Colours | Ratio | Needs | Used for |'
    Write-Output '|---|---|---|---|---|'
    foreach ($r in $results) { Write-Output ("| {0} | {1} | {2}:1 | {3}:1 | {4} |" -f $r.Pair, $r.Colours, $r.Ratio, $r.Needs, $r.Use) }
}

# ---- Hygiene ---------------------------------------------------------------------------------

# 1. No hex colour outside the tokens block, except a literal that names its token on the same line
#    ("ufti: literal <token>") and equals it. A font-family literal must end with its token's stack.
$outside = $text.Remove($block.Index, $block.Length)
$marked = [regex]::Replace($outside, '/\*(?<c>.*?)\*/', {
        param($m)
        if ($m.Groups['c'].Value -match 'ufti: literal\s+(?<t>[a-z0-9-]+)') { return "/*LIT:$($Matches['t'])*/" }
        return ' '
    }, 'Singleline')
$squash = { param($s) ($s -replace '\s+', ' ').Trim() }
$literals = 0
foreach ($line in ($marked -split "`r?`n")) {
    $tok = $null
    if ($line -match '/\*LIT:(?<t>[a-z0-9-]+)\*/') { $tok = $Matches['t'] }
    $code = [regex]::Replace($line, '/\*LIT:[a-z0-9-]+\*/', '')
    foreach ($m in [regex]::Matches($code, '(?<![\w#-])#(?:[0-9A-Fa-f]{8}|[0-9A-Fa-f]{6}|[0-9A-Fa-f]{3})\b')) {
        if (-not $tok) { $failures.Add("Hygiene: hex colour $($m.Value) outside the tokens block. Use a token, or add 'ufti: literal <token>' on the line."); continue }
        if (-not $tokens.ContainsKey($tok)) { $failures.Add("Hygiene: 'ufti: literal $tok' names a token that is not defined."); continue }
        $literals++
        if ($m.Value -ine $tokens[$tok]) { $failures.Add("Hygiene: literal $($m.Value) is marked as '$tok', which is $($tokens[$tok]).") }
    }
    if ($tok -and $tokens.ContainsKey($tok) -and $code -match 'font-family:\s*(?<v>[^;]+);') {
        $literals++
        if (-not (& $squash $Matches['v']).EndsWith((& $squash $tokens[$tok]))) { $failures.Add("Hygiene: the font-family literal does not end with the stack of '$tok'.") }
    }
}
Write-Output ("Literals checked against their tokens: {0}" -f $literals)

# 1b. Section 7 serves a PDF engine that may not resolve custom properties: no var() there.
$s7 = $text.IndexOf('/* ===== 7.')
if ($s7 -lt 0) { $failures.Add('Hygiene: section 7 (print document and PDF) not found.') }
elseif ([regex]::Replace($text.Substring($s7), '/\*.*?\*/', '', 'Singleline') -match 'var\(') { $failures.Add('Hygiene: var() used in section 7, which must be literal.') }

# 2. Every var(--ufti-...) names a defined token.
foreach ($m in [regex]::Matches($text, 'var\(--ufti-(?<n>[a-z0-9-]+)')) {
    if (-not $tokens.ContainsKey($m.Groups['n'].Value)) { $failures.Add("Hygiene: var(--ufti-$($m.Groups['n'].Value)) is not a defined token.") }
}

# 3. Every font file the stylesheet names exists in assets/ (which the build copies beside the stylesheet).
$urls = [regex]::Matches($text, 'url\("(?<u>[^"]+)"\)') | ForEach-Object { $_.Groups['u'].Value } | Sort-Object -Unique
foreach ($u in $urls) {
    $path = Join-Path (Join-Path $themeRoot 'assets') $u
    if (-not (Test-Path -LiteralPath $path)) { $failures.Add("Hygiene: $u is named in the stylesheet but $path does not exist.") }
}
Write-Output ("Font and asset files named: {0}" -f $urls.Count)

# 4. Licences travel with the fonts.
foreach ($f in 'AtkinsonHyperlegibleNext-OFL.txt', 'SourceSerif4-OFL.md') {
    if (-not (Test-Path -LiteralPath (Join-Path $themeRoot "assets/licences/$f"))) { $failures.Add("Hygiene: assets/licences/$f is missing.") }
}

# ---- Verdict ---------------------------------------------------------------------------------

if ($failures.Count -eq 0) {
    Write-Output ("PASS: {0} contrast pairings and the hygiene rules." -f $results.Count)
    exit 0
}
$failures | ForEach-Object { Write-Output "FAIL: $_" }
exit 1
