#requires -Version 7
<#
.SYNOPSIS
  Imports a folder of captured screenshots into one manual: checks them, strips and optimises the
  PNG files, writes them to the manual's image folder and keeps its key map in step.

.DESCRIPTION
  The first slice of WP5 (screenshot strategy, section 5). A capture run (made by the scripts in the
  application repository, never here) leaves a folder with a screens/ folder of PNG files and a
  manifest.json. This script:

    1. validates the manifest: the manual, the Oxford and slate theme (light), en-GB, the Brontë
       dataset, and for every picture its key, its file, its size and its checksum;
    2. checks that every key is one the manual expects (an img-* key in its key map), that every
       expected key is present, and that every key has alternative text in the key map;
    3. checks privacy: the focus of every picture is a person on the allow-list in
       content/sample-data/bronte/allow-list.md, or the sample workspace itself;
    4. strips every PNG chunk that is not needed to draw the picture (text, time, profile, physical
       size and the like), caps the width, and compresses the picture again without losing a pixel;
    5. writes each file to content/platforms/<manual>/images/ only if its bytes differ from the one
       already there;
    6. updates the key map's product version and reference device, and writes a manifest of what was
       imported, with the app version each picture was last checked against;
    7. prints a report: new, changed, unchanged, missing and orphaned pictures, and for each new or
       changed picture the topics that use its key.

  Nothing is written unless every check passes. -WhatIf runs the checks and shows the report.
  Exits 1 on any failure. Copyright 2026 Oughtibridge Ltd, Apache-2.0.

  What remains for WP5 (decision log): a screen catalogue to validate against in place of the key map,
  the comparison with a small tolerance so that anti-aliasing noise is not a change, width caps
  confirmed on a tablet and a phone, resizing without System.Drawing so that it runs off Windows,
  and the Android phone and Windows key maps brought in under their older names.

.PARAMETER Capture
  The capture folder: it holds manifest.json and screens/. Default: the Windows hand-off folder.

.PARAMETER Manual
  The manual's folder slug (windows, android-phone, ...). Default: the manifest's "manual".

.PARAMETER MaxWidth
  The widest a picture may be, in pixels. Default: 1080 for the phone manuals, 1600 for the others.

.PARAMETER AddNewKeys
  Accept a key the key map does not have yet: its key definition is added with alternative text that
  fails the lint until a person writes it. Without this switch an unknown key is an error.

.PARAMETER ReportPath
  Also write the report here, as Markdown.

.EXAMPLE
  pwsh build/scripts/Import-Screenshots.ps1 -WhatIf
.EXAMPLE
  pwsh build/scripts/Import-Screenshots.ps1 -Capture D:\captures\windows -Manual windows
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$Capture = (Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) 'ufti-docs-work' 'handoff' 'windows'),
    [string]$Manual,
    [int]$MaxWidth,
    [switch]$AddNewKeys,
    [string]$ReportPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'UftiBuild.psm1') -Force
$root = Get-UftiRepoRoot
$failures = [System.Collections.Generic.List[string]]::new()
function Fail { param([string]$Message) $failures.Add($Message); Write-UftiProblem $Message }
function Rel { param([string]$Path) [System.IO.Path]::GetRelativePath($root, $Path) -replace '\\', '/' }

# ---- The PNG work, in C#: chunks, checksums and the lossless recompression --------------------------

if (-not ('UftiPng' -as [type])) {
    Add-Type -TypeDefinition @'
using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;

public static class UftiPng
{
    static readonly uint[] Table = MakeTable();
    static uint[] MakeTable() {
        var t = new uint[256];
        for (uint n = 0; n < 256; n++) { uint c = n; for (int k = 0; k < 8; k++) c = (c & 1) != 0 ? 0xEDB88320u ^ (c >> 1) : c >> 1; t[n] = c; }
        return t;
    }
    static uint Crc(byte[] b, int off, int len) {
        uint c = 0xFFFFFFFFu;
        for (int i = off; i < off + len; i++) c = Table[(c ^ b[i]) & 0xFF] ^ (c >> 8);
        return c ^ 0xFFFFFFFFu;
    }
    static uint ReadU32(byte[] b, int o) { return ((uint)b[o] << 24) | ((uint)b[o + 1] << 16) | ((uint)b[o + 2] << 8) | b[o + 3]; }
    static void WriteU32(Stream s, uint v) { s.WriteByte((byte)(v >> 24)); s.WriteByte((byte)(v >> 16)); s.WriteByte((byte)(v >> 8)); s.WriteByte((byte)v); }
    static void WriteChunk(Stream s, string type, byte[] data, int off, int len) {
        WriteU32(s, (uint)len);
        var body = new byte[4 + len];
        for (int i = 0; i < 4; i++) body[i] = (byte)type[i];
        Buffer.BlockCopy(data, off, body, 4, len);
        s.Write(body, 0, body.Length);
        WriteU32(s, Crc(body, 0, body.Length));
    }

    public sealed class Result
    {
        public byte[] Bytes;
        public int Width, Height, BitDepth, ColorType, Interlace;
        public List<string> Dropped = new List<string>();
        public long BytesBefore, BytesAfter;
    }

    // Reads the file's size and checks its chunks; throws on a bad signature or checksum.
    public static Result Inspect(byte[] src) {
        var r = new Result { BytesBefore = src.Length };
        Walk(src, r, null);
        return r;
    }

    // Keeps IHDR, sRGB, PLTE, tRNS, IDAT and IEND, drops every other chunk, and writes the picture
    // data again as one stream compressed as small as the framework can: the pixels do not change.
    public static Result Clean(byte[] src) {
        var r = new Result { BytesBefore = src.Length };
        var kept = new List<KeyValuePair<string, byte[]>>();
        Walk(src, r, kept);
        using (var raw = new MemoryStream()) {
            foreach (var k in kept) if (k.Key == "IDAT") raw.Write(k.Value, 0, k.Value.Length);
            byte[] original = raw.ToArray();
            byte[] best = original;
            try {
                byte[] pixels;
                using (var inflate = new ZLibStream(new MemoryStream(original), CompressionMode.Decompress))
                using (var plain = new MemoryStream()) { inflate.CopyTo(plain); pixels = plain.ToArray(); }
                using (var packed = new MemoryStream()) {
                    using (var deflate = new ZLibStream(packed, CompressionLevel.SmallestSize, true)) deflate.Write(pixels, 0, pixels.Length);
                    if (packed.Length < original.Length) best = packed.ToArray();
                }
            } catch (InvalidDataException) { /* keep the original stream */ }
            using (var o = new MemoryStream()) {
                o.Write(new byte[] { 0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A }, 0, 8);
                bool wroteIdat = false;
                foreach (var k in kept) {
                    if (k.Key == "IDAT") { if (!wroteIdat) { WriteChunk(o, "IDAT", best, 0, best.Length); wroteIdat = true; } }
                    else WriteChunk(o, k.Key, k.Value, 0, k.Value.Length);
                }
                r.Bytes = o.ToArray();
            }
        }
        r.BytesAfter = r.Bytes.Length;
        return r;
    }

    static void Walk(byte[] b, Result r, List<KeyValuePair<string, byte[]>> kept) {
        byte[] sig = { 0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A };
        if (b.Length < 8 + 25) throw new InvalidDataException("not a PNG file (too short)");
        for (int i = 0; i < 8; i++) if (b[i] != sig[i]) throw new InvalidDataException("not a PNG file (bad signature)");
        int pos = 8; bool sawIhdr = false, sawIdat = false, sawIend = false;
        while (pos + 12 <= b.Length) {
            uint len = ReadU32(b, pos);
            if (len > int.MaxValue || pos + 12 + (long)len > b.Length) throw new InvalidDataException("a chunk runs past the end of the file");
            string type = "" + (char)b[pos + 4] + (char)b[pos + 5] + (char)b[pos + 6] + (char)b[pos + 7];
            if (Crc(b, pos + 4, 4 + (int)len) != ReadU32(b, pos + 8 + (int)len)) throw new InvalidDataException("the " + type + " chunk fails its checksum");
            int data = pos + 8;
            if (type == "IHDR") {
                sawIhdr = true;
                r.Width = (int)ReadU32(b, data); r.Height = (int)ReadU32(b, data + 4);
                r.BitDepth = b[data + 8]; r.ColorType = b[data + 9]; r.Interlace = b[data + 12];
            }
            if (type == "IDAT") sawIdat = true;
            if (type == "IEND") sawIend = true;
            bool keep = type == "IHDR" || type == "PLTE" || type == "tRNS" || type == "IDAT" || type == "IEND" || type == "sRGB";
            if (kept != null) {
                if (keep) { var d = new byte[len]; Buffer.BlockCopy(b, data, d, 0, (int)len); kept.Add(new KeyValuePair<string, byte[]>(type, d)); }
                else r.Dropped.Add(type);
            }
            pos += 12 + (int)len;
            if (sawIend) break;
        }
        if (!sawIhdr || !sawIdat || !sawIend) throw new InvalidDataException("the file is missing IHDR, IDAT or IEND");
    }
}
'@
}

function Get-PngBytesResized {
    # Scales a PNG down to the given width with System.Drawing (Windows). The caller cleans the result.
    param([byte[]]$Bytes, [int]$Width)
    if (-not $IsWindows) { throw "resizing needs System.Drawing, which runs on Windows only; capture at or under $Width pixels wide" }
    Add-Type -AssemblyName System.Drawing
    $in = [System.IO.MemoryStream]::new($Bytes)
    $src = [System.Drawing.Bitmap]::new($in)
    try {
        $h = [int][math]::Round($src.Height * $Width / $src.Width)
        $dst = [System.Drawing.Bitmap]::new($Width, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
        try {
            $g = [System.Drawing.Graphics]::FromImage($dst)
            try {
                $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
                $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
                $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
                $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
                $g.DrawImage($src, 0, 0, $Width, $h)
            } finally { $g.Dispose() }
            $out = [System.IO.MemoryStream]::new()
            $dst.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
            , $out.ToArray()
        } finally { $dst.Dispose() }
    } finally { $src.Dispose(); $in.Dispose() }
}

# ---- Read the capture ------------------------------------------------------------------------------

$Capture = [System.IO.Path]::GetFullPath($Capture)
$manifestPath = Join-Path $Capture 'manifest.json'
$screensDir = Join-Path $Capture 'screens'
Write-UftiStep "Import screenshots from $Capture"
if (-not (Test-Path -LiteralPath $manifestPath)) { Write-UftiProblem "No manifest.json in $Capture"; exit 1 }
if (-not (Test-Path -LiteralPath $screensDir)) { Write-UftiProblem "No screens folder in $Capture"; exit 1 }
$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json -Depth 20

function Get-Prop { param($Object, [string]$Name) if ($null -ne $Object -and $Object.PSObject.Properties[$Name]) { $Object.$Name } else { $null } }

if (-not $Manual) { $Manual = Get-Prop $manifest 'manual' }
if (-not $Manual) { Write-UftiProblem 'Say which manual: -Manual, or "manual" in the manifest.'; exit 1 }
if ($Manual -notmatch '^[a-z0-9-]+$') { Write-UftiProblem "'$Manual' is not a manual slug"; exit 1 }
if ((Get-Prop $manifest 'manual') -and (Get-Prop $manifest 'manual') -ne $Manual) { Fail "the manifest is for '$(Get-Prop $manifest 'manual')', not '$Manual'" }
if (-not $MaxWidth) { $MaxWidth = if ($Manual -in 'android-phone', 'iphone') { 1080 } else { 1600 } }

$platformDir = Join-Path $root 'content' 'platforms' $Manual
$keyMapPath = Join-Path $platformDir 'keys' 'images.ditamap'
$imagesDir = Join-Path $platformDir 'images'
if (-not (Test-Path -LiteralPath $keyMapPath)) { Write-UftiProblem "No key map at $(Rel $keyMapPath)"; exit 1 }

# ---- The key map: the keys the manual expects, and their alternative text ---------------------------

$keyMapText = Get-Content -LiteralPath $keyMapPath -Raw
$settings = [System.Xml.XmlReaderSettings]::new(); $settings.DtdProcessing = [System.Xml.DtdProcessing]::Ignore; $settings.XmlResolver = $null
$reader = [System.Xml.XmlReader]::Create($keyMapPath, $settings)
$keyDoc = [System.Xml.XmlDocument]::new(); try { $keyDoc.Load($reader) } finally { $reader.Dispose() }
$expected = [ordered]@{}   # key -> @{ File; Alt }
foreach ($kd in $keyDoc.SelectNodes('//keydef[@keys]')) {
    foreach ($k in ($kd.GetAttribute('keys') -split '\s+' | Where-Object { $_ -like 'img-*' })) {
        $lt = $kd.SelectSingleNode('topicmeta/linktext')
        $expected[$k] = @{ File = [System.IO.Path]::GetFileName($kd.GetAttribute('href')); Alt = $(if ($lt) { $lt.InnerText.Trim() } else { '' }) }
    }
}

# ---- The allow-list ---------------------------------------------------------------------------------

function Get-AllowList {
    $path = Join-Path $root 'content' 'sample-data' 'bronte' 'allow-list.md'
    if (-not (Test-Path -LiteralPath $path)) { throw "No allow-list at $(Rel $path)" }
    $names = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $ids = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $inAllowed = $false
    foreach ($line in Get-Content -LiteralPath $path) {
        if ($line -match '^##\s+Allowed\s*$') { $inAllowed = $true; continue }
        if ($line -match '^##\s+') { $inAllowed = $false; continue }
        if ($inAllowed -and $line -match '^\|\s*(P\d{2})\s*\|\s*([^|]+?)\s*\|\s*([^|]*?)\s*\|') {
            [void]$ids.Add($Matches[1]); [void]$names.Add($Matches[2].Normalize())
            foreach ($o in ($Matches[3] -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ })) { [void]$names.Add($o.Normalize()) }
        }
    }
    if ($ids.Count -eq 0) { throw "Found no people in the Allowed table of $(Rel $path)" }
    # the sample workspace itself may also appear (allow-list, below the table)
    [void]$names.Add('Brontë family of Haworth'.Normalize())
    @{ Names = $names; Ids = $ids }
}
$allow = Get-AllowList

# ---- Check the manifest -----------------------------------------------------------------------------

$theme = Get-Prop $manifest 'theme'
if ((Get-Prop $theme 'name') -ne 'oxford-slate') { Fail "theme is '$(Get-Prop $theme 'name')': pictures are captured in the oxford-slate theme (DEC-024)" }
if ((Get-Prop $theme 'variant') -ne 'light') { Fail "theme variant is '$(Get-Prop $theme 'variant')': pictures are captured in the light variant (DEC-024)" }
if ((Get-Prop $manifest 'locale') -ne 'en-GB') { Fail "locale is '$(Get-Prop $manifest 'locale')': pictures are captured in en-GB" }
if ((Get-Prop (Get-Prop $manifest 'dataset') 'name') -ne 'bronte') { Fail "dataset is '$(Get-Prop (Get-Prop $manifest 'dataset') 'name')': pictures show the Brontë dataset only (DEC-025)" }
$deviceInfo = Get-Prop $manifest 'device'
if ($deviceInfo) {
    # a physical phone must not leave its serial number (or any other identifier) in this repository
    foreach ($pr in $deviceInfo.PSObject.Properties) { if ($pr.Name -match '(?i)serial|imei|udid|android.?id|adb') { Fail "the manifest's device holds '$($pr.Name)': take identifiers out of the manifest before importing" } }
    if ((Get-Prop $deviceInfo 'kind') -notin 'emulator', 'simulator', 'physical', 'virtual machine', 'clean profile') { Fail "device.kind is '$(Get-Prop $deviceInfo 'kind')': one of emulator, simulator, physical, virtual machine, clean profile" }
}
$appVersion = Get-Prop (Get-Prop $manifest 'app') 'version'
if (-not $appVersion) { Fail 'the manifest has no app.version' }
$images = @(Get-Prop $manifest 'images')
if ($images.Count -eq 0) { Fail 'the manifest lists no pictures' }

$plan = [System.Collections.Generic.List[object]]::new()
$seen = [System.Collections.Generic.HashSet[string]]::new()
foreach ($im in $images) {
    $key = [string](Get-Prop $im 'key')
    if ($key -notmatch '^img-[a-z0-9]+(-[a-z0-9]+)*$') { Fail "'$key' is not a picture key (img-<area>-<what>)"; continue }
    if (-not $seen.Add($key)) { Fail "$key is listed twice"; continue }
    $file = $key.Substring(4) + '.png'
    if ((Get-Prop $im 'file') -and (Get-Prop $im 'file') -ne $file) { Fail "$key`: the file is '$(Get-Prop $im 'file')' but the file name for this key is '$file'" ; continue }
    $isNew = -not $expected.Contains($key)
    if ($isNew -and -not $AddNewKeys) { Fail "$key is not a key this manual expects (not in $(Rel $keyMapPath)); add its key definition with alternative text, or use -AddNewKeys"; continue }
    if (-not $isNew) {
        if ($expected[$key].File -ne $file) { Fail "$key`: the key map points at '$($expected[$key].File)', not '$file'" ; continue }
        $alt = $expected[$key].Alt
        if (-not $alt) { Fail "$key has no alternative text (linktext) in the key map" }
        elseif ($alt -match '\bTODO\b') { Fail "$key still has placeholder alternative text" }
        elseif ($alt -match '^\s*(Image|Screenshot|Picture) of') { Fail "$key`: the alternative text starts 'Image of' or 'Screenshot of'" }
        elseif (($alt -split '(?<=[.!?])\s+').Count -gt 1) { Fail "$key`: the alternative text is more than one sentence" }
    }
    # the focus (privacy): a person on the allow-list, or the sample workspace
    $focus = [string](Get-Prop $im 'focus')
    $focusId = [string](Get-Prop $im 'focusId')
    if (-not $focus -and -not $focusId) { Fail "$key has no focus in the manifest: name the person or the workspace the picture shows" }
    else {
        if ($focus -and -not $allow.Names.Contains($focus.Normalize())) { Fail "$key`: the focus '$focus' is not on the allow-list (content/sample-data/bronte/allow-list.md)" }
        if ($focusId -and -not $allow.Ids.Contains($focusId)) { Fail "$key`: the focus id '$focusId' is not on the allow-list" }
    }
    $ws = [string](Get-Prop $im 'workspace')
    if ($ws -and $ws.Normalize() -ne 'Brontë family of Haworth'.Normalize()) { Fail "$key`: the workspace is '$ws'; pictures show the Brontë dataset only" }
    # the file
    $src = Join-Path $screensDir $file
    if (-not (Test-Path -LiteralPath $src)) { Fail "$key`: $file is not in the screens folder"; continue }
    $bytes = [System.IO.File]::ReadAllBytes($src)
    $sha = (Get-FileHash -LiteralPath $src -Algorithm SHA256).Hash.ToLowerInvariant()
    if ((Get-Prop $im 'sha256') -and ([string](Get-Prop $im 'sha256')).ToLowerInvariant() -ne $sha) { Fail "$key`: the checksum does not match the manifest (the file changed after capture)"; continue }
    try { $info = [UftiPng]::Inspect($bytes) } catch { Fail "$key`: $($_.Exception.Message)"; continue }
    if ((Get-Prop $im 'width') -and [int](Get-Prop $im 'width') -ne $info.Width) { Fail "$key`: the manifest says $(Get-Prop $im 'width') pixels wide, the file is $($info.Width)"; continue }
    if ((Get-Prop $im 'height') -and [int](Get-Prop $im 'height') -ne $info.Height) { Fail "$key`: the manifest says $(Get-Prop $im 'height') pixels high, the file is $($info.Height)"; continue }
    $plan.Add([pscustomobject]@{ Key = $key; File = $file; Source = $src; Bytes = $bytes; Info = $info; Entry = $im; IsNew = $isNew })
}
$missing = @($expected.Keys | Where-Object { -not $seen.Contains($_) })
foreach ($k in $missing) { Fail "$k is expected by the manual but not in the capture" }
$strayFiles = @(Get-ChildItem -LiteralPath $screensDir -Filter '*.png' -File | Where-Object { @($plan.File) -notcontains $_.Name -and ($images | ForEach-Object { ($_.key -replace '^img-', '') + '.png' }) -notcontains $_.Name })
foreach ($f in $strayFiles) { Fail "$($f.Name) is in the screens folder but not in the manifest" }

if ($failures.Count) {
    Write-Host "`nFAIL: $($failures.Count) problem(s). Nothing was written." -ForegroundColor Red
    exit 1
}

# ---- Strip, cap, compress, compare ------------------------------------------------------------------

$results = [System.Collections.Generic.List[object]]::new()
foreach ($p in $plan) {
    $bytes = $p.Bytes
    $resized = $false
    if ($p.Info.Width -gt $MaxWidth) { $bytes = Get-PngBytesResized $bytes $MaxWidth; $resized = $true }
    $clean = [UftiPng]::Clean($bytes)
    $target = Join-Path $imagesDir $p.File
    $status = 'new'
    if (Test-Path -LiteralPath $target) {
        $status = if ([System.Linq.Enumerable]::SequenceEqual([byte[]][System.IO.File]::ReadAllBytes($target), [byte[]]$clean.Bytes)) { 'unchanged' } else { 'changed' }
    }
    $results.Add([pscustomobject]@{
        Key = $p.Key; File = $p.File; Status = $status; Resized = $resized; Dropped = @($clean.Dropped | Sort-Object -Unique)
        Width = $clean.Width; Height = $clean.Height; Before = $p.Info.BytesBefore; After = $clean.BytesAfter
        Bytes = $clean.Bytes; Target = $target; Entry = $p.Entry; Sha = ([System.BitConverter]::ToString([System.Security.Cryptography.SHA256]::HashData([byte[]]$clean.Bytes)) -replace '-', '').ToLowerInvariant()
    })
}
$orphans = @()
if (Test-Path -LiteralPath $imagesDir) { $orphans = @(Get-ChildItem -LiteralPath $imagesDir -Filter '*.png' -File | Where-Object { @($results.File) -notcontains $_.Name } | ForEach-Object { $_.Name }) }

# ---- Write ------------------------------------------------------------------------------------------

if ($PSCmdlet.ShouldProcess((Rel $imagesDir), "write $(@($results | Where-Object Status -ne 'unchanged').Count) picture(s), update the key map and write the manifest")) {
    New-Item -ItemType Directory -Path $imagesDir -Force | Out-Null
    foreach ($r in $results | Where-Object Status -ne 'unchanged') { [System.IO.File]::WriteAllBytes($r.Target, [byte[]]$r.Bytes) }

    # the key map: new keys with a placeholder, the product version, the reference device
    $text = $keyMapText
    foreach ($r in $results | Where-Object { -not $expected.Contains($_.Key) }) {
        $def = "  <keydef keys=""$($r.Key)"" href=""../images/$($r.File)"" format=""png"" scope=""local"" platform=""WindowsWinUI"">`n    <topicmeta><linktext>TODO: write the alternative text</linktext></topicmeta>`n  </keydef>`n"
        if ($Manual -ne 'windows') { $def = $def -replace 'platform="WindowsWinUI"', "platform=""$((Get-Content (Join-Path $root 'build' 'ditaval' ($Manual + '.ditaval')) -Raw | Select-String 'val="([A-Za-z]+)" action="include"' | ForEach-Object { $_.Matches[0].Groups[1].Value } | Select-Object -First 1))""" }
        $text = $text -replace '</map>\s*$', ($def + '</map>')
    }
    $text = [regex]::Replace($text, '<vrm version="[^"]*"/>', "<vrm version=""$appVersion""/>")
    $device = Get-Prop $manifest 'device'
    if ($device) {
        $desc = (@((Get-Prop $device 'kind'), (Get-Prop $device 'profile'), (Get-Prop $device 'os'), $(if ((Get-Prop $device 'width') -and (Get-Prop $device 'height')) { "$(Get-Prop $device 'width') x $(Get-Prop $device 'height')" }), (Get-Prop $device 'orientation')) | Where-Object { $_ }) -join ', '
        $desc = [System.Security.SecurityElement]::Escape($desc)
        $text = [regex]::Replace($text, '(<data name="reference-device" value=")[^"]*(")', { param($m) $m.Groups[1].Value + $desc + $m.Groups[2].Value })
    }
    if ($text -ne $keyMapText) { [System.IO.File]::WriteAllText($keyMapPath, $text, [System.Text.UTF8Encoding]::new($false)) }

    # the manifest of what was imported: a short, public-safe copy
    $out = [ordered]@{
        manual = $Manual
        app = [ordered]@{ version = $appVersion }
        theme = [ordered]@{ name = (Get-Prop $theme 'name'); variant = (Get-Prop $theme 'variant') }
        locale = (Get-Prop $manifest 'locale')
        dataset = [ordered]@{ name = 'bronte' }
        device = $(if ($device) { [ordered]@{ kind = (Get-Prop $device 'kind'); os = (Get-Prop $device 'os'); width = (Get-Prop $device 'width'); height = (Get-Prop $device 'height'); orientation = (Get-Prop $device 'orientation') } })
        captured = (Get-Prop $manifest 'captured')
        images = @($results | Sort-Object Key | ForEach-Object {
            [ordered]@{ key = $_.Key; file = $_.File; sha256 = $_.Sha; width = $_.Width; height = $_.Height; stage = (Get-Prop $_.Entry 'stage'); workspace = (Get-Prop $_.Entry 'workspace'); focus = (Get-Prop $_.Entry 'focus'); capture = (Get-Prop $_.Entry 'capture'); verifiedAppVersion = $appVersion }
        })
    }
    [System.IO.File]::WriteAllText((Join-Path $imagesDir 'manifest.json'), (($out | ConvertTo-Json -Depth 8) + "`n"), [System.Text.UTF8Encoding]::new($false))
}

# ---- Report -----------------------------------------------------------------------------------------

function Get-TopicsUsing { param([string]$Key) @(Get-ChildItem -LiteralPath (Join-Path $root 'content') -Recurse -Filter '*.dita' | Where-Object { (Get-Content -LiteralPath $_.FullName -Raw) -match ('keyref="' + [regex]::Escape($Key) + '"') } | ForEach-Object { [System.IO.Path]::GetFileNameWithoutExtension($_.Name) }) }
$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add("# Screenshot import: $Manual")
$lines.Add('')
$lines.Add("App version $appVersion. Width cap $MaxWidth pixels. $($results.Count) picture(s): " + ((($results | Group-Object Status | ForEach-Object { "$($_.Count) $($_.Name)" }) -join ', ')) + '.')
$lines.Add('')
$lines.Add('| Key | Result | Size | Bytes before | Bytes after | Dropped chunks | Topics that use it |')
$lines.Add('|---|---|---|---|---|---|---|')
foreach ($r in $results | Sort-Object Key) {
    $topics = if ($r.Status -eq 'unchanged') { '' } else { (Get-TopicsUsing $r.Key) -join ', ' }
    $lines.Add("| $($r.Key) | $($r.Status)$(if ($r.Resized) { ', resized' }) | $($r.Width) x $($r.Height) | $($r.Before) | $($r.After) | $($r.Dropped -join ' ') | $topics |")
}
$lines.Add('')
$lines.Add("Missing from the capture: $(if ($missing) { $missing -join ', ' } else { 'none' }).")
$lines.Add("Orphaned in the image folder (no key in the capture): $(if ($orphans) { $orphans -join ', ' } else { 'none' }).")
$lines | ForEach-Object { Write-Host $_ }
if ($ReportPath) { [System.IO.File]::WriteAllLines($ReportPath, $lines) }
if ($orphans) { Write-UftiNotice "Orphaned pictures in $(Rel $imagesDir): $($orphans -join ', '). Delete them, or the lint reports them." }
Write-Host "`nPASS: $($results.Count) picture(s) checked$(if ($WhatIfPreference) { ' (nothing written: -WhatIf)' } else { ' and imported' })." -ForegroundColor Green
exit 0
