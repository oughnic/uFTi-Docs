#requires -Version 7
<#
.SYNOPSIS
  Tests the source rules: each rule that lint.ps1 and Vale enforce has a case that must fail, and
  the base cases that must pass.

.DESCRIPTION
  WP3 (authoring standards, section 13). A rule nobody has seen fail is a rule nobody can trust, so
  every check that the structure lint or the prose lint adds comes with a small publication, or a
  few sentences, that break it. The lint cases start from one valid little publication written to a
  temporary folder, change one thing, and expect lint.ps1 to exit 1 with the message for that
  rule. The Vale cases write one topic and expect the named check to raise an alert. The template
  case builds every template with the toolkit, which validates it against the DITA 1.3 DTD.

  Nothing in the repository is changed. Exits 1 if any case does not behave as expected.
  Copyright 2026 Oughtibridge Ltd, Apache-2.0.

.PARAMETER Only
  Run only these parts: lint, vale, templates, samples. Default: all four.

.PARAMETER Filter
  Run only the cases whose name contains this text.
#>
[CmdletBinding()]
param(
    [ValidateSet('lint', 'vale', 'templates', 'samples')][string[]]$Only = @('lint', 'vale', 'templates', 'samples'),
    [string]$Filter = '',
    [string]$ToolsDir
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'UftiBuild.psm1') -Force
$root = Get-UftiRepoRoot
$work = Join-Path ([System.IO.Path]::GetTempPath()) "ufti-source-rules-$([guid]::NewGuid().ToString('N').Substring(0, 8))"
New-Item -ItemType Directory -Path $work | Out-Null
$results = [System.Collections.Generic.List[object]]::new()
function Record { param([string]$Part, [string]$Name, [bool]$Ok, [string]$Detail) $results.Add([pscustomobject]@{ Part = $Part; Name = $Name; Ok = $Ok }); Write-Host ("  {0,-4} {1}: {2}" -f $(if ($Ok) { 'ok' } else { 'FAIL' }), $Part, $Name) -ForegroundColor $(if ($Ok) { 'Green' } else { 'Red' }); if (-not $Ok -and $Detail) { Write-Host "       $Detail" -ForegroundColor Red } }

# ---- A small valid publication ----------------------------------------------------------------

function Write-File { param([string]$Dir, [string]$Rel, [string]$Text) $p = Join-Path $Dir $Rel; New-Item -ItemType Directory -Path (Split-Path -Parent $p) -Force | Out-Null; [System.IO.File]::WriteAllText($p, $Text.Replace("`r`n", "`n")) }

function New-BasePublication {
    param([string]$Dir)
    $xml = '<?xml version="1.0" encoding="UTF-8"?>' + "`n"
    Write-File $Dir 'ufti-test-windows.ditamap' ($xml + @'
<!DOCTYPE bookmap PUBLIC "-//OASIS//DTD DITA BookMap//EN" "bookmap.dtd">
<bookmap id="ufti-test-windows" xml:lang="en-GB">
  <booktitle><mainbooktitle>Test publication</mainbooktitle></booktitle>
  <bookmeta>
    <publisherinformation><organization>Oughtibridge Ltd</organization></publisherinformation>
    <bookrights><copyrfirst><year>2026</year></copyrfirst><bookowner><organization>Oughtibridge Ltd</organization></bookowner></bookrights>
  </bookmeta>
  <chapter href="topics/do-it.dita" keys="do-it">
    <mapref href="keys/ui-labels.ditamap" processing-role="resource-only"/>
    <mapref href="keys/product.ditamap" processing-role="resource-only"/>
    <mapref href="platforms/windows/keys/images.ditamap" processing-role="resource-only"/>
  </chapter>
  <chapter href="topics/know-it.dita" keys="know-it"/>
  <chapter href="topics/see-it.dita" keys="see-it"/>
  <chapter href="topics/fix-it.dita" keys="fix-it"/>
  <chapter href="topics/look-it-up.dita" keys="look-it-up"/>
  <backmatter>
    <booklists>
      <glossarylist>
        <topicref href="glossary/word.dita" keys="term-word"/>
      </glossarylist>
    </booklists>
  </backmatter>
</bookmap>
'@)
    Write-File $Dir 'keys/ui-labels.ditamap' ($xml + @'
<!DOCTYPE map PUBLIC "-//OASIS//DTD DITA Map//EN" "map.dtd">
<map id="test-ui-labels" xml:lang="en-GB">
  <keydef keys="ui-save"><topicmeta><keywords><keyword>Save</keyword></keywords></topicmeta></keydef>
</map>
'@)
    Write-File $Dir 'keys/product.ditamap' ($xml + @'
<!DOCTYPE map PUBLIC "-//OASIS//DTD DITA Map//EN" "map.dtd">
<map id="test-product" xml:lang="en-GB">
  <keydef keys="product-name"><topicmeta><keywords><keyword translate="no">uFTi</keyword></keywords></topicmeta></keydef>
</map>
'@)
    Write-File $Dir 'platforms/windows/keys/images.ditamap' ($xml + @'
<!DOCTYPE map PUBLIC "-//OASIS//DTD DITA Map//EN" "map.dtd">
<map id="test-images" xml:lang="en-GB">
  <keydef keys="img-shot" href="../images/shot.png" format="png" scope="local"><topicmeta><linktext>The form with a name typed in it</linktext></topicmeta></keydef>
</map>
'@)
    New-Item -ItemType Directory -Path (Join-Path $Dir 'platforms/windows/images') -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $root 'build/fixtures/wp1/platforms/windows/images/person-view.png') -Destination (Join-Path $Dir 'platforms/windows/images/shot.png')
    Write-File $Dir 'images/flow.svg' ($xml + @'
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 160" width="640" height="160" role="img">
  <title>Two steps</title>
  <desc>Two boxes. The first says Do it and the second says Know it. Each links to its page.</desc>
  <style>.box { fill: #D5E2F2; stroke: #1E3A5F; } .label { fill: #12263F; }</style>
  <a href="do-it.html"><rect class="box" x="20" y="40" width="240" height="80"/><text class="label" x="140" y="88">Do it</text></a>
  <a href="know-it.html"><rect class="box" x="380" y="40" width="240" height="80"/><text class="label" x="500" y="88">Know it</text></a>
</svg>
'@)
    Write-File $Dir 'topics/do-it.dita' ($xml + @'
<!DOCTYPE task PUBLIC "-//OASIS//DTD DITA Task//EN" "task.dtd">
<task id="do-it" xml:lang="en-GB">
  <title>Do it</title>
  <shortdesc>Save one thing in your workspace.</shortdesc>
  <prolog>
    <critdates>
      <created date="2026-10-01"/>
      <revised modified="2026-10-02"/>
    </critdates>
    <metadata>
      <audience type="user" experiencelevel="novice"/>
      <category>How-to</category>
      <keywords>
        <keyword>store</keyword>
      </keywords>
    </metadata>
    <resourceid appname="ufti" appid="things.edit"/>
  </prolog>
  <taskbody>
    <steps>
      <step>
        <cmd>Choose <uicontrol keyref="ui-save"/>.</cmd>
        <stepresult>
          <p>A short message says Saved.</p>
        </stepresult>
      </step>
    </steps>
    <result>
      <p>The thing is saved.</p>
      <fig>
        <image keyref="img-shot"/>
      </fig>
    </result>
    <postreq>
      <p>Next: <xref keyref="know-it"/>.</p>
    </postreq>
  </taskbody>
</task>
'@)
    Write-File $Dir 'topics/know-it.dita' ($xml + @'
<!DOCTYPE concept PUBLIC "-//OASIS//DTD DITA Concept//EN" "concept.dtd">
<concept id="know-it" xml:lang="en-GB">
  <title>Know it</title>
  <shortdesc>The one idea behind saving.</shortdesc>
  <prolog>
    <metadata>
      <category>Concept</category>
    </metadata>
  </prolog>
  <conbody>
    <p>A thing is kept when you save it.</p>
  </conbody>
</concept>
'@)
    Write-File $Dir 'topics/see-it.dita' ($xml + @'
<!DOCTYPE concept PUBLIC "-//OASIS//DTD DITA Concept//EN" "concept.dtd">
<concept id="see-it" xml:lang="en-GB">
  <title>See it</title>
  <shortdesc>The two steps in a picture.</shortdesc>
  <prolog>
    <metadata>
      <category>Concept</category>
    </metadata>
  </prolog>
  <conbody>
    <fig>
      <title>The two steps</title>
      <svg-container>
        <svgref href="../images/flow.svg"/>
      </svg-container>
    </fig>
    <p>The same steps as a list:</p>
    <ol>
      <li><xref keyref="do-it"/></li>
      <li><xref keyref="know-it"/></li>
    </ol>
  </conbody>
</concept>
'@)
    Write-File $Dir 'topics/fix-it.dita' ($xml + @'
<!DOCTYPE troubleshooting PUBLIC "-//OASIS//DTD DITA Troubleshooting//EN" "troubleshooting.dtd">
<troubleshooting id="fix-it" xml:lang="en-GB">
  <title>A change does not stay</title>
  <shortdesc>What to do when a change is gone.</shortdesc>
  <prolog>
    <metadata>
      <category>Troubleshooting</category>
    </metadata>
  </prolog>
  <troublebody>
    <condition>
      <p>You make a change, and it is gone later.</p>
    </condition>
    <troubleSolution>
      <cause>
        <p>The form was closed before you saved.</p>
      </cause>
      <remedy>
        <steps>
          <step>
            <cmd>Open the form again and make the change.</cmd>
          </step>
        </steps>
      </remedy>
    </troubleSolution>
  </troublebody>
</troubleshooting>
'@)
    Write-File $Dir 'topics/look-it-up.dita' ($xml + @'
<!DOCTYPE reference PUBLIC "-//OASIS//DTD DITA Reference//EN" "reference.dtd">
<reference id="look-it-up" xml:lang="en-GB">
  <title>Look it up</title>
  <shortdesc>The things you can save.</shortdesc>
  <prolog>
    <metadata>
      <category>Reference</category>
    </metadata>
  </prolog>
  <refbody>
    <table>
      <title>Things you can save</title>
      <tgroup cols="2">
        <thead>
          <row><entry>Thing</entry><entry>What it holds</entry></row>
        </thead>
        <tbody>
          <row><entry>Person</entry><entry>A name.</entry></row>
        </tbody>
      </tgroup>
    </table>
  </refbody>
</reference>
'@)
    Write-File $Dir 'glossary/word.dita' ($xml + @'
<!DOCTYPE glossentry PUBLIC "-//OASIS//DTD DITA Glossary Entry//EN" "glossentry.dtd">
<glossentry id="word" xml:lang="en-GB">
  <glossterm>word</glossterm>
  <glossdef>A group of letters that means something.</glossdef>
</glossentry>
'@)
    Write-File $Dir 'terminology.md' "# Terminology`n`n| Key | Words |`n|---|---|`n| ``ui-save`` | Save |`n"
}

function Edit-File {
    # Change one thing, and fail loudly if the text to change is not there, so a case can never pass by
    # changing nothing.
    param([string]$Dir, [string]$Rel, [string]$Old, [string]$New)
    $p = Join-Path $Dir $Rel
    $text = [System.IO.File]::ReadAllText($p)
    if (-not $text.Contains($Old)) { throw "test setup: '$Old' is not in $Rel" }
    [System.IO.File]::WriteAllText($p, $text.Replace($Old, $New))
}

function Invoke-Lint {
    param([string]$Dir)
    $out = & pwsh -NoProfile -File (Join-Path $PSScriptRoot 'lint.ps1') -Source $Dir -Matrix (Join-Path $Dir 'matrix.csv') -Strict -Terminology (Join-Path $Dir 'terminology.md') 2>&1 | ForEach-Object { "$_" }
    [pscustomobject]@{ Exit = $LASTEXITCODE; Text = ($out -join "`n") }
}

# One filler sentence of ten words, repeated to make a page of the length a rule cares about.
function Words { param([int]$Count) (@(1..$Count | ForEach-Object { 'word' }) -join ' ') + '.' }

# ---- Lint cases: each changes one thing and names the message it must raise -------------------

$lintCases = @(
    @{ Name = 'xml-declaration'; Expect = 'does not start with the XML declaration'; Do = { param($d) Edit-File $d 'topics/know-it.dita' '<?xml version="1.0" encoding="UTF-8"?>' '' } }
    @{ Name = 'doctype-not-standard'; Expect = 'is not the standard one'; Do = { param($d) Edit-File $d 'topics/do-it.dita' '-//OASIS//DTD DITA Task//EN' '-//EXAMPLE//DTD Special Task//EN' } }
    @{ Name = 'doctype-names-another-root'; Expect = 'but the root element is'; Do = { param($d) Edit-File $d 'topics/know-it.dita' '<!DOCTYPE concept PUBLIC' '<!DOCTYPE task PUBLIC' } }
    @{ Name = 'map-without-language'; Expect = 'no xml:lang'; Do = { param($d) Edit-File $d 'keys/ui-labels.ditamap' ' xml:lang="en-GB"' '' } }
    @{ Name = 'outputclass-not-documented'; Expect = "outputclass 'fancy'"; Do = { param($d) Edit-File $d 'topics/know-it.dita' '<p>A thing' '<p outputclass="fancy">A thing' } }
    @{ Name = 'status-attribute'; Expect = '@status'; Do = { param($d) Edit-File $d 'topics/know-it.dita' '<conbody>' '<conbody status="reviewed">' } }
    @{ Name = 'title-starts-with-number'; Expect = 'starts with a number'; Do = { param($d) Edit-File $d 'topics/know-it.dita' '<title>Know it</title>' '<title>3. Know it</title>' } }
    @{ Name = 'title-duplicate'; Expect = 'is also the title of'; Do = { param($d) Edit-File $d 'topics/see-it.dita' '<title>See it</title>' '<title>Know it</title>' } }
    @{ Name = 'shortdesc-this-topic'; Expect = "begins 'This topic'"; Do = { param($d) Edit-File $d 'topics/know-it.dita' 'The one idea behind saving.' 'This topic explains the one idea behind saving.' } }
    @{ Name = 'shortdesc-repeats-title'; Expect = 'only repeats the title'; Do = { param($d) Edit-File $d 'topics/know-it.dita' '<shortdesc>The one idea behind saving.</shortdesc>' '<shortdesc>Know it.</shortdesc>' } }
    @{ Name = 'shortdesc-two-sentences'; Expect = 'more than one sentence'; Do = { param($d) Edit-File $d 'topics/know-it.dita' 'The one idea behind saving.' 'The one idea behind saving. It is short.' } }
    @{ Name = 'audience-level'; Expect = "experiencelevel 'beginner'"; Do = { param($d) Edit-File $d 'topics/do-it.dita' 'experiencelevel="novice"' 'experiencelevel="beginner"' } }
    @{ Name = 'date-in-the-future'; Expect = 'is in the future'; Do = { param($d) Edit-File $d 'topics/do-it.dita' '<created date="2026-10-01"/>' '<created date="2099-01-01"/>' } }
    @{ Name = 'date-not-a-date'; Expect = 'not a date written YYYY-MM-DD'; Do = { param($d) Edit-File $d 'topics/do-it.dita' '<created date="2026-10-01"/>' '<created date="1 October 2026"/>' } }
    @{ Name = 'date-revised-before-created'; Expect = 'is before created'; Do = { param($d) Edit-File $d 'topics/do-it.dita' '<revised modified="2026-10-02"/>' '<revised modified="2026-09-01"/>' } }
    @{ Name = 'help-id-format'; Expect = 'is not area.screen'; Do = { param($d) Edit-File $d 'topics/do-it.dita' 'appid="things.edit"' 'appid="Things Edit"' } }
    @{ Name = 'help-id-missing'; Expect = 'has no resourceid help identifier'; Do = { param($d) Edit-File $d 'topics/do-it.dita' '<resourceid appname="ufti" appid="things.edit"/>' '' } }
    @{ Name = 'help-id-claimed-twice'; Expect = 'is also claimed by'; Do = { param($d) Edit-File $d 'topics/know-it.dita' '</prolog>' '<resourceid appname="ufti" appid="things.edit"/></prolog>' } }
    @{ Name = 'forbidden-element'; Expect = '<object> is not used'; Do = { param($d) Edit-File $d 'topics/know-it.dita' '<p>A thing is kept when you save it.</p>' '<p>A thing is kept when you save it.</p><object data="clip.mp4"/>' } }
    @{ Name = 'link-text-click-here'; Expect = "means nothing out of context"; Do = { param($d) Edit-File $d 'topics/do-it.dita' '<xref keyref="know-it"/>' '<xref keyref="know-it">click here</xref>' } }
    @{ Name = 'link-text-bare-address'; Expect = 'link text is a bare address'; Do = { param($d) Edit-File $d 'topics/do-it.dita' '<xref keyref="know-it"/>' '<xref href="https://example.org/" scope="external" format="html">https://example.org/</xref>' } }
    @{ Name = 'image-outside-a-fig'; Expect = 'image outside a fig'; Do = { param($d) Edit-File $d 'topics/do-it.dita' '<fig>
        <image keyref="img-shot"/>
      </fig>' '<image keyref="img-shot"/>' } }
    @{ Name = 'image-by-href'; Expect = 'pictures are referenced by key'; Do = { param($d) Edit-File $d 'topics/do-it.dita' '<image keyref="img-shot"/>' '<image href="../platforms/windows/images/shot.png"><alt>A form</alt></image>' } }
    @{ Name = 'table-without-title'; Expect = 'table without a title'; Do = { param($d) Edit-File $d 'topics/look-it-up.dita' '<title>Things you can save</title>' '' } }
    @{ Name = 'table-without-header-row'; Expect = 'table without a header row'; Do = { param($d) Edit-File $d 'topics/look-it-up.dita' '<thead>
          <row><entry>Thing</entry><entry>What it holds</entry></row>
        </thead>' '' } }
    @{ Name = 'task-without-steps'; Expect = 'a task has steps'; Do = { param($d) Edit-File $d 'topics/do-it.dita' '<steps>
      <step>
        <cmd>Choose <uicontrol keyref="ui-save"/>.</cmd>
        <stepresult>
          <p>A short message says Saved.</p>
        </stepresult>
      </step>
    </steps>' '<context><p>Choose Save.</p></context>' } }
    @{ Name = 'task-with-ten-steps'; Expect = '10 steps'; Do = { param($d) Edit-File $d 'topics/do-it.dita' '</steps>' (((1..9 | ForEach-Object { '<step><cmd>Choose <uicontrol keyref="ui-save"/>.</cmd></step>' }) -join '') + '</steps>') } }
    @{ Name = 'step-command-too-long'; Expect = 'a step command of'; Do = { param($d) Edit-File $d 'topics/do-it.dita' '<cmd>Choose <uicontrol keyref="ui-save"/>.</cmd>' ('<cmd>Choose <uicontrol keyref="ui-save"/> ' + (Words 26) + '</cmd>') } }
    @{ Name = 'table-inside-a-step'; Expect = 'a table inside a step'; Do = { param($d) Edit-File $d 'topics/do-it.dita' '<stepresult>' '<info><simpletable><sthead><stentry>A</stentry></sthead><strow><stentry>B</stentry></strow></simpletable></info><stepresult>' } }
    @{ Name = 'concept-too-long'; Expect = 'a concept of'; Do = { param($d) Edit-File $d 'topics/know-it.dita' '<p>A thing is kept when you save it.</p>' ('<p>' + (Words 520) + '</p>') } }
    @{ Name = 'quick-start-page-too-long'; Expect = 'Quick Start pages stay under 150'; Do = { param($d) Edit-File $d 'topics/know-it.dita' '<category>Concept</category>' '<category>Get started</category>'; Edit-File $d 'topics/know-it.dita' '<p>A thing is kept when you save it.</p>' ('<p>' + (Words 160) + '</p>') } }
    @{ Name = 'good-practice-section-title'; Expect = 'good practice section title'; Do = { param($d) Edit-File $d 'topics/know-it.dita' '<category>Concept</category>' '<category>Good practice</category>'; Edit-File $d 'topics/know-it.dita' '<p>A thing is kept when you save it.</p>' '<section><title>Overview</title><p>A thing is kept when you save it.</p></section>' } }
    @{ Name = 'troubleshooting-without-condition'; Expect = 'needs a condition'; Do = { param($d) Edit-File $d 'topics/fix-it.dita' '<condition>
      <p>You make a change, and it is gone later.</p>
    </condition>' '' } }
    @{ Name = 'troubleshooting-without-remedy'; Expect = 'needs a troubleSolution with a cause and a remedy'; Do = { param($d) Edit-File $d 'topics/fix-it.dita' '<remedy>
        <steps>
          <step>
            <cmd>Open the form again and make the change.</cmd>
          </step>
        </steps>
      </remedy>' '' } }
    @{ Name = 'glossary-without-definition'; Expect = 'needs a glossdef'; Do = { param($d) Edit-File $d 'glossary/word.dita' '<glossdef>A group of letters that means something.</glossdef>' '' } }
    @{ Name = 'label-typed-inline'; Expect = "label typed inline ('Save')"; Do = { param($d) Edit-File $d 'topics/do-it.dita' '<uicontrol keyref="ui-save"/>' '<uicontrol>Save</uicontrol>' } }
    @{ Name = 'key-for-a-topic'; Expect = "a topic's key is its file name"; Do = { param($d) Edit-File $d 'ufti-test-windows.ditamap' 'keys="know-it"' 'keys="idea"' } }
    @{ Name = 'key-for-a-picture'; Expect = 'picture keys start img-'; Do = { param($d) Edit-File $d 'platforms/windows/keys/images.ditamap' 'keys="img-shot"' 'keys="shot"' } }
    @{ Name = 'key-for-a-word'; Expect = 'label keys start ui-'; Do = { param($d) Edit-File $d 'keys/ui-labels.ditamap' 'keys="ui-save"' 'keys="save"' } }
    @{ Name = 'picture-in-the-wrong-folder'; Expect = 'belongs in platforms/<manual>/images/'; Do = { param($d) Copy-Item (Join-Path $d 'platforms/windows/images/shot.png') (Join-Path $d 'images/stray.png') } }
    @{ Name = 'diagram-colour'; Expect = 'is not a token of the theme'; Do = { param($d) Edit-File $d 'images/flow.svg' '#D5E2F2' '#FF0000' } }
    @{ Name = 'diagram-links-not-listed'; Expect = 'a text list of the same links must follow'; Do = { param($d) Edit-File $d 'topics/see-it.dita' '<li><xref keyref="know-it"/></li>' '' } }
    @{ Name = 'bookmap-without-publisher'; Expect = 'names its publisher organisation'; Do = { param($d) Edit-File $d 'ufti-test-windows.ditamap' '<publisherinformation><organization>Oughtibridge Ltd</organization></publisherinformation>' '' } }
    @{ Name = 'bookmap-without-owner'; Expect = 'names the owner of its copyright'; Do = { param($d) Edit-File $d 'ufti-test-windows.ditamap' '<bookowner><organization>Oughtibridge Ltd</organization></bookowner>' '' } }
    @{ Name = 'person-in-map-metadata'; Expect = 'metadata names nobody'; Do = { param($d) Edit-File $d 'ufti-test-windows.ditamap' '</bookmeta>' '<authorinformation><personinfo><personname><firstname>A</firstname></personname></personinfo></authorinformation></bookmeta>' } }
    @{ Name = 'label-missing-from-terminology'; Expect = "label key 'ui-extra' is not in the terminology list"; Do = { param($d) Edit-File $d 'keys/ui-labels.ditamap' '</map>' '<keydef keys="ui-extra"><topicmeta><keywords><keyword>Extra</keyword></keywords></topicmeta></keydef></map>' } }
    @{ Name = 'template-in-a-manual'; Expect = "a template is in a manual's navigation"; Do = { param($d) $dest = Join-Path $d 'templates/know-it-too.dita'; New-Item -ItemType Directory -Path (Split-Path $dest) -Force | Out-Null; (Get-Content (Join-Path $d 'topics/know-it.dita') -Raw).Replace('id="know-it"', 'id="know-it-too"').Replace('<title>Know it</title>', '<title>Know it too</title>') | Set-Content $dest -NoNewline; Edit-File $d 'ufti-test-windows.ditamap' '<chapter href="topics/see-it.dita" keys="see-it"/>' '<chapter href="topics/see-it.dita" keys="see-it"/><chapter href="templates/know-it-too.dita" keys="know-it-too"/>' } }
)

# Cases that must pass: the base itself, and a template that no map uses.
$lintPass = @(
    @{ Name = 'the base publication passes'; Do = { param($d) } }
    @{ Name = 'a template in no map passes'; Do = { param($d) $dest = Join-Path $d 'templates/know-it-too.dita'; New-Item -ItemType Directory -Path (Split-Path $dest) -Force | Out-Null; (Get-Content (Join-Path $d 'topics/know-it.dita') -Raw).Replace('id="know-it"', 'id="know-it-too"').Replace('<title>Know it</title>', '<title>Know it too</title>') | Set-Content $dest -NoNewline } }
)

if ($Only -contains 'lint') {
    Write-UftiStep 'Lint cases'
    foreach ($c in $lintPass) {
        if ($Filter -and $c.Name -notlike "*$Filter*") { continue }
        $d = Join-Path $work ("pass-" + [guid]::NewGuid().ToString('N').Substring(0, 6))
        New-BasePublication $d; & $c.Do $d
        $r = Invoke-Lint $d
        Record 'lint' $c.Name ($r.Exit -eq 0) ($r.Text -split "`n" | Where-Object { $_ -match 'FAIL' } | Select-Object -First 3 | Out-String)
    }
    foreach ($c in $lintCases) {
        if ($Filter -and $c.Name -notlike "*$Filter*") { continue }
        $d = Join-Path $work $c.Name
        New-BasePublication $d; & $c.Do $d
        $r = Invoke-Lint $d
        $ok = ($r.Exit -eq 1) -and $r.Text.Contains($c.Expect)
        Record 'lint' "$($c.Name) fails" $ok "expected exit 1 with '$($c.Expect)'; got exit $($r.Exit):`n$((($r.Text -split "`n") | Where-Object { $_ -match 'FAIL' } | Select-Object -First 4) -join "`n")"
    }
}

# ---- Vale cases --------------------------------------------------------------------------------

$valeCases = @(
    @{ Name = 'product name in lower case'; Check = 'uFTi.ProductName'; Text = 'Open ufti from your list of apps.' }
    @{ Name = 'product name in capitals'; Check = 'uFTi.ProductName'; Text = 'UFTI keeps your work as you go.' }
    @{ Name = 'date with an ordinal'; Check = 'uFTi.Dates'; Text = 'The register is dated 3rd March 1816.' }
    @{ Name = 'date with the month first'; Check = 'uFTi.Dates'; Text = 'He was born on March 21 in the village.' }
    @{ Name = 'date with slashes'; Check = 'uFTi.Dates'; Text = 'The entry says 21/03/1816.' }
    @{ Name = 'date as year, month, day'; Check = 'uFTi.Dates'; Text = 'The entry says 1816-03-21.' }
    @{ Name = 'date with an abbreviated month'; Check = 'uFTi.Dates'; Text = 'He was born on 21 Mar 1816.' }
    @{ Name = 'control named by its colour'; Check = 'uFTi.ColourCues'; Text = 'Choose the red button.' }
    @{ Name = 'control named by its place'; Check = 'uFTi.PositionCues'; Text = 'Choose the button at the top right.' }
    @{ Name = 'a long word for a plain one'; Check = 'uFTi.PlainWords'; Text = 'You can utilise the search box.' }
    @{ Name = 'a word the terminology list replaces'; Check = 'uFTi.Terminology'; Text = 'The app is a database of your family.' }
    @{ Name = 'a business-model word'; Check = 'uFTi.BusinessModel'; Text = 'Your tree is kept in the cloud.' }
    @{ Name = 'a GEDCOM tag'; Check = 'uFTi.GedcomTags'; Text = 'The line starts with INDI.' }
    @{ Name = 'a word to avoid'; Check = 'uFTi.Avoid'; Text = 'Just choose Save.' }
    @{ Name = 'a positional reference'; Check = 'uFTi.Positional'; Text = 'As described above, choose Save.' }
    @{ Name = 'a sentence over 25 words'; Check = 'uFTi.LongSentence'; Text = ((Words 30) -replace '\.$', '') + '.' }
    @{ Name = 'hard words lower the reading ease'; Check = 'uFTi.ReadingEase'; Text = 'Understanding comprehensive documentation requires considerable concentration.' }
    @{ Name = 'hard words raise the grade'; Check = 'uFTi.GradeLevel'; Text = 'Understanding comprehensive documentation requires considerable concentration.' }
    @{ Name = 'a long average sentence'; Check = 'uFTi.AverageSentence'; Text = (Words 24) + ' ' + (Words 24) }
    @{ Name = 'a spelling mistake'; Check = 'uFTi.Spelling'; Text = 'Choose the colour of the dashbord.' }
    @{ Name = 'an American spelling'; Check = 'uFTi.Spelling'; Text = 'Choose the color you like.' }
)
$valeClean = @(
    @{ Name = 'plain sentences raise none of the style checks'; Text = 'Open uFTi from your list of apps. Choose Save. The date is 3 March 1816.' }
)

function New-ValeTopic {
    param([string]$Path, [string]$Sentence)
    $xml = '<?xml version="1.0" encoding="UTF-8"?>' + "`n"
    $text = $xml + @"
<!DOCTYPE concept PUBLIC "-//OASIS//DTD DITA Concept//EN" "concept.dtd">
<concept id="probe" xml:lang="en-GB">
  <title>Probe</title>
  <shortdesc>A probe for a rule.</shortdesc>
  <conbody>
    <p>$Sentence</p>
  </conbody>
</concept>
"@
    [System.IO.File]::WriteAllText($Path, $text.Replace("`r`n", "`n"))
}

if ($Only -contains 'vale') {
    Write-UftiStep 'Vale cases'
    if (-not $ToolsDir) { $ToolsDir = Get-UftiToolsDir }
    $lock = Read-UftiToolsLock
    $P = Get-UftiToolPaths -Lock $lock -ToolsDir $ToolsDir
    Add-UftiToolsToPath -Paths $P | Out-Null
    if (-not (Test-Path -LiteralPath $P.Vale) -or -not (Test-Path -LiteralPath $P.Dita)) { throw 'Vale and the toolkit are needed: run build/scripts/bootstrap.ps1' }
    $valeDir = Join-Path $work 'vale'
    New-Item -ItemType Directory -Path $valeDir | Out-Null
    function Get-ValeChecks {
        param([string]$Sentence, [string]$Config = (Join-Path $root '.vale.ini'), [string]$Name = "probe-$([guid]::NewGuid().ToString('N').Substring(0, 6))")
        $f = Join-Path $valeDir "$Name.dita"
        New-ValeTopic $f $Sentence
        $json = & $P.Vale --config $Config --output=JSON --no-wrap $f 2>$null | Out-String
        $parsed = $json | ConvertFrom-Json
        @($parsed.PSObject.Properties | ForEach-Object { $_.Value } | ForEach-Object { $_.Check } | Sort-Object -Unique)
    }
    foreach ($c in $valeClean) {
        if ($Filter -and $c.Name -notlike "*$Filter*") { continue }
        $found = @(Get-ValeChecks $c.Text | Where-Object { $_ -in @('uFTi.ProductName', 'uFTi.Dates', 'uFTi.ColourCues', 'uFTi.PositionCues', 'uFTi.PlainWords', 'uFTi.Terminology') })
        Record 'vale' $c.Name ($found.Count -eq 0) "unexpected: $($found -join ', ')"
    }
    foreach ($c in $valeCases) {
        if ($Filter -and $c.Name -notlike "*$Filter*") { continue }
        $found = Get-ValeChecks $c.Text
        Record 'vale' "$($c.Name) raises $($c.Check)" ($found -contains $c.Check) "raised: $($found -join ', ')"
    }
    # an exception for one file (DEC-029, .vale.ini): a section for that file switches a rule off, and only for it
    if (-not $Filter -or 'exception' -like "*$Filter*") {
        $iniText = (Get-Content (Join-Path $root '.vale.ini') -Raw) -replace '(?m)^StylesPath = .*$', ('StylesPath = ' + (Join-Path $root 'build/vale/styles').Replace([char]92, [char]47))
        $iniText += "`n[*probe-excepted.dita]`nuFTi.LongSentence = NO`n"
        $excIni = Join-Path $valeDir 'exception.vale.ini'
        [System.IO.File]::WriteAllText($excIni, $iniText)
        $long = ((Words 30) -replace '.$', '') + '.'
        $with = Get-ValeChecks $long $excIni 'probe-excepted'
        $without = Get-ValeChecks $long $excIni 'probe-other'
        Record 'vale' 'an exception section for one file switches a rule off for that file' ($with -notcontains 'uFTi.LongSentence') "still raised: $($with -join ', ')"
        Record 'vale' 'an exception section leaves the rule on for other files' ($without -contains 'uFTi.LongSentence') "raised: $($without -join ', ')"
    }
}

# ---- Templates are valid DITA 1.3 --------------------------------------------------------------

if ($Only -contains 'templates') {
    Write-UftiStep 'Templates: valid DITA 1.3'
    if (-not $ToolsDir) { $ToolsDir = Get-UftiToolsDir }
    $lock = Read-UftiToolsLock
    $P = Get-UftiToolPaths -Lock $lock -ToolsDir $ToolsDir
    Add-UftiToolsToPath -Paths $P | Out-Null
    if (-not (Test-Path -LiteralPath $P.Dita)) { throw 'The toolkit is needed to validate: run build/scripts/bootstrap.ps1' }
    function Test-Validates {
        # The toolkit validates every topic against its DTD while it reads it. A topic the DTD rejects is
        # reported as an error or a fatal error, and the build stops or says so.
        param([string]$Name, [string[]]$Topics, [bool]$MustFail = $false)
        $dir = Join-Path $work "validate-$Name"
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        # relative addresses: the toolkit does not follow an absolute one from a map
        $refs = ($Topics | ForEach-Object { "  <topicref href=""$([System.IO.Path]::GetRelativePath($dir, (Resolve-Path -LiteralPath $_).Path) -replace '\\', '/')"" processing-role=""normal""/>" }) -join "`n"
        [System.IO.File]::WriteAllText((Join-Path $dir 'check.ditamap'), "<?xml version=""1.0"" encoding=""UTF-8""?>`n<!DOCTYPE map PUBLIC ""-//OASIS//DTD DITA Map//EN"" ""map.dtd"">`n<map xml:lang=""en-GB"">`n$refs`n</map>`n")
        $r = Invoke-UftiProcess -FilePath $P.Dita -ArgumentList @('--input', (Join-Path $dir 'check.ditamap'), '--format', 'html5', '--output', (Join-Path $dir 'out'), '--verbose') -WorkingDirectory $dir -Quiet
        $text = ($r.Output -join "`n")
        $bad = @($text -split "`n" | Where-Object { $_ -match '\[Fatal Error\]|\[Error\]|DOTJ\d+[EF]\b|The content of element|Element type ".*" must|is not allowed|Attribute ".*" is not declared' })
        [pscustomobject]@{ Ok = ($r.ExitCode -eq 0 -and $bad.Count -eq 0); Bad = $bad }
    }
    $templateDir = Join-Path $root 'content/templates'
    $tpl = @(Get-ChildItem -LiteralPath $templateDir -Recurse -Filter '*.dita' -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName })
    # a topic the DTD rejects must be reported, or the check proves nothing
    $badTopic = Join-Path $work 'invalid.dita'
    [System.IO.File]::WriteAllText($badTopic, "<?xml version=""1.0"" encoding=""UTF-8""?>`n<!DOCTYPE concept PUBLIC ""-//OASIS//DTD DITA Concept//EN"" ""concept.dtd"">`n<concept id=""invalid"" xml:lang=""en-GB""><title>Invalid</title><conbody><steps><step><cmd>No.</cmd></step></steps></conbody></concept>`n")
    $v = Test-Validates 'invalid' @($badTopic)
    Record 'templates' 'a topic the DTD rejects is reported' (-not $v.Ok) 'the toolkit said nothing about an invalid topic'
    if ($tpl.Count -eq 0) { Record 'templates' 'templates exist' $false 'content/templates has no topics' }
    foreach ($t in $tpl) {
        $name = [System.IO.Path]::GetRelativePath($templateDir, $t) -replace '[\\/]', '-'
        if ($Filter -and $name -notlike "*$Filter*") { continue }
        $v = Test-Validates ($name -replace '\.dita$', '') @($t)
        Record 'templates' "$name is valid DITA 1.3" $v.Ok (($v.Bad | Select-Object -First 3) -join "`n       ")
    }
}

# ---- The sample-file gate (DEC-111) -------------------------------------------------------------

if ($Only -contains 'samples') {
    Write-UftiStep 'Samples: family tree data stays in one folder, and nobody in it could be living'
    $gate = Join-Path $PSScriptRoot 'check-samples.ps1'
    $allowList = Join-Path $root 'content/sample-data/bronte/allow-list.md'
    $stagesRel = 'content/sample-data/bronte/stages'
    $goodTree = @'
0 HEAD
1 CHAR UTF-8
1 GEDC
2 VERS 5.5.1
0 @I1@ INDI
1 NAME Patrick /Brontë/
1 SEX M
1 BIRT
2 DATE 17 MAR 1777
1 DEAT
2 DATE 7 JUN 1861
1 FAMS @F1@
0 @I2@ INDI
1 NAME Maria /Branwell/
1 SEX F
1 DEAT
2 DATE 15 SEP 1821
1 FAMS @F1@
0 @F1@ FAM
1 HUSB @I1@
1 WIFE @I2@
1 MARR
2 DATE 29 DEC 1812
0 TRLR
'@
    $goodTree = $goodTree.Replace("`r`n", "`n")
    function Invoke-Samples {
        # a small repository of its own: the gate reads what is tracked, so the files are added with -f
        param([hashtable]$Files)
        $dir = Join-Path $work ('samples-' + [guid]::NewGuid().ToString('N').Substring(0, 6))
        New-Item -ItemType Directory -Path $dir | Out-Null
        & git -C $dir init -q 2>&1 | Out-Null
        Write-File $dir 'content/sample-data/bronte/allow-list.md' ([System.IO.File]::ReadAllText($allowList))
        foreach ($k in $Files.Keys) { Write-File $dir $k $Files[$k] }
        & git -C $dir add -f -A 2>&1 | Out-Null
        $out = & pwsh -NoProfile -File $gate -Root $dir 2>&1 | ForEach-Object { "$_" }
        [pscustomobject]@{ Exit = $LASTEXITCODE; Text = ($out -join "`n") }
    }
    $sampleCases = @(
        @{ Name = 'two allowed people who died long ago'; Pass = $true; Expect = ''; Files = @{ "$stagesRel/sample.ged" = $goodTree } }
        @{ Name = 'a family tree file outside the allowed folder'; Pass = $false; Expect = 'outside'; Files = @{ "$stagesRel/sample.ged" = $goodTree; 'content/other/tree.ged' = $goodTree } }
        @{ Name = 'an archive in the allowed folder'; Pass = $false; Expect = 'archive is not allowed'; Files = @{ "$stagesRel/sample.ged" = $goodTree; "$stagesRel/sample.gdz" = 'not read' } }
        @{ Name = 'a person with no death date'; Pass = $false; Expect = 'no death date'; Files = @{ "$stagesRel/sample.ged" = $goodTree.Replace("1 DEAT`n2 DATE 15 SEP 1821`n", '') } }
        @{ Name = 'a person who died after 1930'; Pass = $false; Expect = 'died after 1930'; Files = @{ "$stagesRel/sample.ged" = $goodTree.Replace('15 SEP 1821', '15 SEP 1985') } }
        @{ Name = 'a person who is not on the allow-list'; Pass = $false; Expect = 'not on the allow-list'; Files = @{ "$stagesRel/sample.ged" = $goodTree.Replace('Maria /Branwell/', 'Someone /Else/') } }
        @{ Name = 'a submitter record'; Pass = $false; Expect = 'submitter record'; Files = @{ "$stagesRel/sample.ged" = $goodTree.Replace('0 TRLR', "0 @U1@ SUBM`n1 NAME A Person`n0 TRLR") } }
        @{ Name = 'an email address'; Pass = $false; Expect = 'email address'; Files = @{ "$stagesRel/sample.ged" = $goodTree.Replace('1 SEX M', "1 SEX M`n1 NOTE write to a.person@example.com") } }
        @{ Name = 'a file path'; Pass = $false; Expect = 'file path'; Files = @{ "$stagesRel/sample.ged" = $goodTree.Replace('1 SEX M', "1 SEX M`n1 NOTE saved at C:\Users\someone\tree.ged") } }
        @{ Name = 'a Wikimedia Commons link in a media record'; Pass = $true; Expect = ''; Files = @{ "$stagesRel/sample.ged" = $goodTree.Replace('0 TRLR', "0 @M05@ OBJE`n1 FILE https://upload.wikimedia.org/wikipedia/commons/3/38/St_johns_rear_buildings.jpg`n2 FORM jpg`n0 TRLR") } }
        @{ Name = 'a file link that is not a Wikimedia Commons link'; Pass = $false; Expect = 'not a Wikimedia Commons link'; Files = @{ "$stagesRel/sample.ged" = $goodTree.Replace('0 TRLR', "0 @M05@ OBJE`n1 FILE https://example.org/photo.jpg`n0 TRLR") } }
        @{ Name = 'a Wikimedia Commons link outside a media record'; Pass = $false; Expect = 'not a Wikimedia Commons link'; Files = @{ "$stagesRel/sample.ged" = $goodTree.Replace('1 SEX M', "1 SEX M`n1 FILE https://upload.wikimedia.org/wikipedia/commons/3/38/St_johns_rear_buildings.jpg") } }
        @{ Name = 'a file without a trailer'; Pass = $false; Expect = 'trailer'; Files = @{ "$stagesRel/sample.ged" = $goodTree.Replace("`n0 TRLR", '') } }
    )
    foreach ($c in $sampleCases) {
        if ($Filter -and $c.Name -notlike "*$Filter*") { continue }
        $r = Invoke-Samples $c.Files
        if ($c.Pass) { Record 'samples' "$($c.Name) passes" ($r.Exit -eq 0) "expected exit 0; got exit $($r.Exit):`n$($r.Text)" }
        else { Record 'samples' "$($c.Name) fails" ($r.Exit -eq 1 -and $r.Text -match $c.Expect) "expected exit 1 with '$($c.Expect)'; got exit $($r.Exit):`n$((($r.Text -split "`n") | Select-Object -First 4) -join "`n")" }
    }
}

Remove-Item -LiteralPath $work -Recurse -Force -ErrorAction SilentlyContinue
$failed = @($results | Where-Object { -not $_.Ok })
Write-Host ''
Write-Host "$($results.Count - $failed.Count) of $($results.Count) case(s) behaved as expected."
if ($failed.Count) { Write-Host "FAIL: $($failed.Count) case(s) did not." -ForegroundColor Red; exit 1 }
Write-Host 'PASS: every source rule fails where it should and passes where it should.' -ForegroundColor Green
