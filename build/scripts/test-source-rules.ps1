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
  Run only these parts: lint, vale, templates, samples, publications, helpmap, reuse, walks. Default: all eight.

.PARAMETER Filter
  Run only the cases whose name contains this text.
#>
[CmdletBinding()]
param(
    [ValidateSet('lint', 'vale', 'templates', 'samples', 'publications', 'helpmap', 'reuse', 'walks')][string[]]$Only = @('lint', 'vale', 'templates', 'samples', 'publications', 'helpmap', 'reuse', 'walks'),
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

# A valid nested topic: it carries its own help identifier, and its id is the page anchor.
$nestedConcept = '<concept id="part-one" xml:lang="en-GB"><title>Part one</title><prolog><resourceid appname="ufti" appid="things.part"/></prolog><conbody><p>Part one.</p></conbody></concept>'

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
    @{ Name = 'nested-topic-in-a-task'; Expect = 'only a concept or a reference nests topics'; Do = { param($d) Edit-File $d 'topics/do-it.dita' '</taskbody>' ('</taskbody>' + $nestedConcept) } }
    @{ Name = 'nested-topic-id-used-twice'; Expect = "nested topic id 'part-one' is used twice"; Do = { param($d) Edit-File $d 'topics/know-it.dita' '</conbody>' ('</conbody>' + $nestedConcept + $nestedConcept) } }
    @{ Name = 'nested-topic-id-not-an-anchor'; Expect = "nested topic id 'Part_One' is the page anchor"; Do = { param($d) Edit-File $d 'topics/know-it.dita' '</conbody>' ('</conbody>' + $nestedConcept.Replace('part-one', 'Part_One')) } }
    @{ Name = 'nested-topic-without-language'; Expect = "xml:lang is not en-GB on nested topic 'part-one'"; Do = { param($d) Edit-File $d 'topics/know-it.dita' '</conbody>' ('</conbody>' + $nestedConcept.Replace(' xml:lang="en-GB"', '')) } }
    @{ Name = 'nested-topic-without-title'; Expect = "nested topic 'part-one' has no title"; Do = { param($d) Edit-File $d 'topics/know-it.dita' '</conbody>' ('</conbody>' + $nestedConcept.Replace('<title>Part one</title>', '')) } }
    @{ Name = 'nested-topic-title-with-a-full-stop'; Expect = "title of nested topic 'part-one' ends with a full stop"; Do = { param($d) Edit-File $d 'topics/know-it.dita' '</conbody>' ('</conbody>' + $nestedConcept.Replace('Part one</title>', 'Part one.</title>')) } }
    @{ Name = 'nested-topic-inside-a-nested-topic'; Expect = 'one level only'; Do = { param($d) Edit-File $d 'topics/know-it.dita' '</conbody>' ('</conbody>' + $nestedConcept.Replace('</concept>', '<concept id="part-deeper" xml:lang="en-GB"><title>Deeper</title><conbody><p>Deeper.</p></conbody></concept></concept>')) } }
    @{ Name = 'nested-topic-help-id-claimed-by-another-topic'; Expect = "help identifier 'things.edit' is also claimed by"; Do = { param($d) Edit-File $d 'topics/know-it.dita' '</conbody>' ('</conbody>' + $nestedConcept.Replace('things.part', 'things.edit')) } }
    @{ Name = 'nested-topic-help-id-format'; Expect = "is not area.screen in lower case with hyphens (nested topic 'part-one')"; Do = { param($d) Edit-File $d 'topics/know-it.dita' '</conbody>' ('</conbody>' + $nestedConcept.Replace('things.part', 'Things Part')) } }
    @{ Name = 'a concept with a nested topic over 500 words'; Expect = 'a concept of'; Do = { param($d) Edit-File $d 'topics/know-it.dita' '</conbody>' ('</conbody>' + $nestedConcept.Replace('<p>Part one.</p>', "<p>$(Words 520)</p>")) } }
    @{ Name = 'screen-with-no-topic'; Expect = "screen 'things.gone' (A thing nobody wrote) has no topic with resourceid"; Do = { param($d) Write-File $d 'screens.csv' "screen_id,screen_name,status`nthings.edit,Edit a thing,`nthings.gone,A thing nobody wrote,`n" } }
    @{ Name = 'screen-marked-gap-that-now-has-a-topic'; Expect = "screen 'things.edit' is marked 'gap' but a topic now carries its identifier"; Do = { param($d) Write-File $d 'screens.csv' "screen_id,screen_name,status`nthings.edit,Edit a thing,gap`n" } }
    @{ Name = 'screen-status-that-is-not-gap'; Expect = "screen 'things.edit': status 'later' is not blank or 'gap'"; Do = { param($d) Write-File $d 'screens.csv' "screen_id,screen_name,status`nthings.edit,Edit a thing,later`n" } }
    @{ Name = 'forbidden-element'; Expect = '<object> is not used'; Do = { param($d) Edit-File $d 'topics/know-it.dita' '<p>A thing is kept when you save it.</p>' '<p>A thing is kept when you save it.</p><object data="clip.mp4"/>' } }
    @{ Name = 'link-text-click-here'; Expect = "means nothing out of context"; Do = { param($d) Edit-File $d 'topics/do-it.dita' '<xref keyref="know-it"/>' '<xref keyref="know-it">click here</xref>' } }
    @{ Name = 'link-text-bare-address'; Expect = 'link text is a bare address'; Do = { param($d) Edit-File $d 'topics/do-it.dita' '<xref keyref="know-it"/>' '<xref href="https://example.org/" scope="external" format="html">https://example.org/</xref>' } }
    @{ Name = 'image-outside-a-fig'; Expect = 'image outside a fig'; Do = { param($d) Edit-File $d 'topics/do-it.dita' '<fig>
        <image keyref="img-shot"/>
      </fig>' '<image keyref="img-shot"/>' } }
    @{ Name = 'key-in-a-picture-for-every-device'; Expect = "key 'img-elsewhere' is not defined in the windows manual"; Do = { param($d) Edit-File $d 'topics/do-it.dita' '<fig>
        <image keyref="img-shot"/>
      </fig>' '<fig>
        <image keyref="img-shot"/>
      </fig><fig><image keyref="img-elsewhere"/></fig>' } }
    @{ Name = 'device-token-on-text-in-a-shared-topic'; Expect = 'used outside platforms/'; Do = { param($d) Edit-File $d 'topics/do-it.dita' '<fig>
        <image keyref="img-shot"/>
      </fig>' '<p platform="AndroidPhone">Only on an Android phone.</p><fig>
        <image keyref="img-shot"/>
      </fig>' } }
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
    @{ Name = 'a concept with a nested topic that has its own help identifier passes'; Do = { param($d) Edit-File $d 'topics/know-it.dita' '</conbody>' ('</conbody>' + $nestedConcept) } }
    @{ Name = 'a screen marked gap with no topic passes (DEC-194)'; Do = { param($d) Write-File $d 'screens.csv' "screen_id,screen_name,status`nthings.edit,Edit a thing,`nthings.gone,A thing nobody wrote,gap`n" } }
    @{ Name = 'a picture for another device in a shared topic passes, though its key is not defined here (DEC-129)'; Do = { param($d) Edit-File $d 'topics/do-it.dita' '<fig>
        <image keyref="img-shot"/>
      </fig>' '<fig>
        <image keyref="img-shot"/>
      </fig><fig platform="AndroidPhone"><image keyref="img-elsewhere"/></fig>' } }
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

# ---- The release rule: build/publications.ini (DEC-141) -----------------------------------------

if ($Only -contains 'publications') {
    Write-UftiStep 'Publications: a release is declared once, in the agreed form, and agrees with the pictures'
    $iniText = [System.IO.File]::ReadAllText((Join-Path $root 'build' 'publications.ini'))
    function Test-Publications {
        # the repository's file with one change, read as the build reads it; a throw is the build failing
        param([string]$Text)
        $p = Join-Path $work ('publications-' + [guid]::NewGuid().ToString('N').Substring(0, 6) + '.ini')
        [System.IO.File]::WriteAllText($p, $Text.Replace("`r`n", "`n"))
        try { $null = Read-UftiPublications -Path $p; [pscustomobject]@{ Ok = $true; Text = '' } } catch { [pscustomobject]@{ Ok = $false; Text = "$_" } }
    }
    function Set-WindowsLine { param([string]$Old, [string]$New) $s = $iniText.IndexOf('[windows]'); $e = $iniText.IndexOf('[android-phone]'); $iniText.Substring(0, $s) + $iniText.Substring($s, $e - $s).Replace($Old, $New) + $iniText.Substring($e) }
    $pubCases = @(
        @{ Name = 'the repository''s file'; Pass = $true; Expect = ''; Text = $iniText }
        @{ Name = 'a release Beta-2'; Pass = $true; Expect = ''; Text = (Set-WindowsLine 'release = Alpha-1' 'release = Beta-2') }
        @{ Name = 'a release RC-1'; Pass = $true; Expect = ''; Text = (Set-WindowsLine 'release = Alpha-1' 'release = RC-1') }
        @{ Name = 'a release 1.0'; Pass = $true; Expect = ''; Text = (Set-WindowsLine 'release = Alpha-1' 'release = 1.0') }
        @{ Name = 'a release 1.2.3'; Pass = $true; Expect = ''; Text = (Set-WindowsLine 'release = Alpha-1' 'release = 1.2.3') }
        @{ Name = 'a platform with no release'; Pass = $false; Expect = 'release is missing'; Text = (Set-WindowsLine "release = Alpha-1`n" '') }
        @{ Name = 'a release in lower case'; Pass = $false; Expect = 'not in the agreed form'; Text = (Set-WindowsLine 'release = Alpha-1' 'release = alpha-1') }
        @{ Name = 'a release numbered from zero'; Pass = $false; Expect = 'not in the agreed form'; Text = (Set-WindowsLine 'release = Alpha-1' 'release = Alpha-0') }
        @{ Name = 'a release with no number'; Pass = $false; Expect = 'not in the agreed form'; Text = (Set-WindowsLine 'release = Alpha-1' 'release = Alpha') }
        @{ Name = 'a release that is a repository tag'; Pass = $false; Expect = 'not in the agreed form'; Text = (Set-WindowsLine 'release = Alpha-1' 'release = v1.0.0') }
        @{ Name = 'a release that is a bare number'; Pass = $false; Expect = 'not in the agreed form'; Text = (Set-WindowsLine 'release = Alpha-1' 'release = 1') }
        @{ Name = 'an app version the pictures do not record'; Pass = $false; Expect = 'differs from'; Text = (Set-WindowsLine 'app-version = 0.1.0.1 (1)' 'app-version = 0.1.0.2 (1)') }
        @{ Name = 'no app version where the pictures record one'; Pass = $false; Expect = 'app-version must say so'; Text = (Set-WindowsLine "app-version = 0.1.0.1 (1)`n" '') }
        @{ Name = 'a base address without its closing slash'; Pass = $false; Expect = 'closing slash|ends with a slash'; Text = $iniText.Replace('base-url = https://docs.ufti.com/', 'base-url = https://docs.ufti.com') }
        @{ Name = 'a base address that is not https'; Pass = $false; Expect = 'ends with a slash'; Text = $iniText.Replace('base-url = https://docs.ufti.com/', 'base-url = http://docs.ufti.com/') }
        @{ Name = 'a platform name that cannot be a folder'; Pass = $false; Expect = 'lower case letters'; Text = $iniText.Replace('[macos]', '[MacOS]') }
        @{ Name = 'a platform named for something else on the site'; Pass = $false; Expect = 'name the site uses'; Text = $iniText.Replace('[macos]', '[latest]') }
        @{ Name = 'a project file that does not exist'; Pass = $false; Expect = 'has no file'; Text = (Set-WindowsLine 'manual = manual-windows' 'manual = manual-nothing') }
        @{ Name = 'a key nobody reads'; Pass = $false; Expect = 'unknown key'; Text = (Set-WindowsLine 'release = Alpha-1' "release = Alpha-1`nversion = 2") }
        @{ Name = 'a platform listed twice'; Pass = $false; Expect = 'more than once'; Text = $iniText + "`n[windows]`ntitle = x`n" }
    )
    foreach ($c in $pubCases) {
        if ($Filter -and $c.Name -notlike "*$Filter*") { continue }
        $r = Test-Publications $c.Text
        if ($c.Pass) { Record 'publications' "$($c.Name) is accepted" $r.Ok "expected it to be read; it failed:`n$($r.Text)" }
        else { Record 'publications' "$($c.Name) fails the build" (-not $r.Ok -and $r.Text -match $c.Expect) "expected a failure matching '$($c.Expect)'; got: $(if ($r.Ok) { 'no failure' } else { $r.Text })" }
    }
    $order = 'Alpha-1', 'Alpha-2', 'Alpha-10', 'Beta-1', 'RC-1', '1.0', '1.0.1', '1.1', '2.0'
    $keys = @($order | ForEach-Object { Get-UftiReleaseSortKey $_ })
    $inOrder = $true; for ($i = 1; $i -lt $keys.Count; $i++) { if ([string]::CompareOrdinal($keys[$i - 1], $keys[$i]) -ge 0) { $inOrder = $false } }
    Record 'publications' 'releases sort as releases do (Alpha-2 before Alpha-10, Beta before RC, RC before 1.0)' $inOrder "keys: $($keys -join ' ')"
}

# ---- The help map (DEC-028): which page a screen's help opens ---------------------------------

if ($Only -contains 'helpmap') {
    Write-Host '== Help map cases'
    $ini = "[site]`nbase-url = https://docs.example.org/`n`n[windows]`ntitle = Windows`ndevice = a Windows computer`nrelease = Alpha-1`napp-version = 0.1.0.1 (1)`nmanual = manual-windows`nquick-start = quick-start-windows`n"
    $inventoryText = "screen_id,screen_name`nthings.edit,Edit a thing`nthings.part,A part of a thing`nthings.list,The list of things`n"
    function New-HelpMapPublication {
        # The small publication, its root map named as the generator wants, a nested topic with its own id,
        # an inventory, and a publications file. Returns the folders.
        param([string]$Name)
        $d = Join-Path $work $Name
        New-BasePublication $d
        Move-Item -LiteralPath (Join-Path $d 'ufti-test-windows.ditamap') -Destination (Join-Path $d 'ufti-manual-windows.ditamap')
        Edit-File $d 'topics/know-it.dita' '</conbody>' ('</conbody>' + $nestedConcept)
        [System.IO.File]::WriteAllText((Join-Path $work "$Name.csv"), $inventoryText)
        [System.IO.File]::WriteAllText((Join-Path $work "$Name.ini"), $ini)
        $d
    }
    function Invoke-HelpMap {
        param([string]$Name, [string[]]$Extra = @())
        $d = Join-Path $work $Name
        $out = Join-Path $work "$Name-maps"
        $text = & pwsh -NoProfile -File (Join-Path $PSScriptRoot 'new-help-map.ps1') -Inventory (Join-Path $work "$Name.csv") -PublicationsFile (Join-Path $work "$Name.ini") -ContentRoot $d -Output $out @Extra 2>&1 | ForEach-Object { "$_" }
        $file = Join-Path $out 'windows.Alpha-1.en-GB.help-map.json'
        [pscustomobject]@{ Exit = $LASTEXITCODE; Text = ($text -join "`n"); Map = $(if (Test-Path -LiteralPath $file) { Get-Content -LiteralPath $file -Raw | ConvertFrom-Json } else { $null }) }
    }
    function New-SiteFor {
        # A tree with every page the small publication builds, and the anchor of the nested topic.
        param([string]$Name, [switch]$WithoutAnchor)
        $s = Join-Path $work "$Name-site/windows/Alpha-1"
        New-Item -ItemType Directory -Path (Join-Path $s 'topics') -Force | Out-Null
        Set-Content -LiteralPath (Join-Path $s 'index.html') '<html></html>'
        Set-Content -LiteralPath (Join-Path $s 'topics/do-it.html') '<html></html>'
        Set-Content -LiteralPath (Join-Path $s 'topics/know-it.html') $(if ($WithoutAnchor) { '<html><div id="other"></div></html>' } else { '<html><div id="part-one"></div></html>' })
        Join-Path $work "$Name-site"
    }
    $helpCases = @(
        @{ Name = 'a screen with a topic and a screen with a nested topic are mapped'; Do = { param($n) }; Check = { param($r) $r.Exit -eq 0 -and $r.Map.targets.'things.edit' -eq 'topics/do-it.html' -and $r.Map.targets.'things.part' -eq 'topics/know-it.html#part-one' }; Why = 'expected both ids in the map' }
        @{ Name = 'a map is proposed unless it is proved'; Do = { param($n) }; Check = { param($r) $r.Map.status -eq 'proposed' -and $r.Map.baseUrl -eq 'https://docs.example.org/windows/Alpha-1/' -and $r.Map.device -eq 'windows' -and $r.Map.release -eq 'Alpha-1' -and $r.Map.language -eq 'en-GB' -and $r.Map.home -eq 'index.html' }; Why = 'expected status proposed and the base address of the release' }
        @{ Name = 'a screen with no page is left out and the map says it is not complete'; Do = { param($n) }; Check = { param($r) $r.Exit -eq 0 -and -not ($r.Map.targets.PSObject.Properties.Name -contains 'things.list') -and $r.Map.complete -eq $false -and @($r.Map.gaps) -contains 'things.list' -and @($r.Map.gaps).Count -eq 1 }; Why = 'expected things.list to be left out, named in gaps, and complete to be false' }
        @{ Name = 'a task identifier that is not a screen stays out of the map'; Do = { param($n) Edit-File (Join-Path $work $n) 'topics/do-it.dita' '<resourceid appname="ufti" appid="things.edit"/>' '<resourceid appname="ufti" appid="things.edit"/><resourceid appname="ufti" appid="things.remove"/>' }; Check = { param($r) $r.Exit -eq 0 -and -not ($r.Map.targets.PSObject.Properties.Name -contains 'things.remove') }; Why = 'expected things.remove to be left out' }
        @{ Name = 'several screens may share one page'; Do = { param($n) Edit-File (Join-Path $work $n) 'topics/do-it.dita' '<resourceid appname="ufti" appid="things.edit"/>' '<resourceid appname="ufti" appid="things.edit"/><resourceid appname="ufti" appid="things.list"/>' }; Check = { param($r) $r.Exit -eq 0 -and $r.Map.targets.'things.list' -eq 'topics/do-it.html' -and $r.Map.complete -eq $true -and @($r.Map.gaps).Count -eq 0 }; Why = 'expected two ids on one page and a complete map' }
        @{ Name = 'a topic in another language is left out and does not fail'; Do = { param($n) Edit-File (Join-Path $work $n) 'topics/know-it.dita' '<concept id="know-it" xml:lang="en-GB">' '<concept id="know-it" xml:lang="es">' }; Check = { param($r) $r.Exit -eq 0 -and -not ($r.Map.targets.PSObject.Properties.Name -contains 'things.part') }; Why = 'expected the Spanish topic to be left out without a failure' }
        @{ Name = 'two topics claiming one screen fail'; Do = { param($n) Edit-File (Join-Path $work $n) 'topics/know-it.dita' '<conbody>' '<conbody><p>x</p></conbody><concept id="part-two" xml:lang="en-GB"><title>Part two</title><prolog><resourceid appname="ufti" appid="things.edit"/></prolog><conbody><p>Part two.</p></conbody></concept><conbody>' }; Fail = 'one identifier, one landing page'; Why = 'expected a failure for the shared identifier' }
        @{ Name = 'an inventory id that is not an app screen id fails'; Do = { param($n) [System.IO.File]::WriteAllText((Join-Path $work "$n.csv"), "screen_id,screen_name`nThings Edit,Bad`n") }; Fail = 'is not an app screen id'; Why = 'expected the bad id to be refused' }
        @{ Name = 'an inventory id listed twice fails'; Do = { param($n) [System.IO.File]::WriteAllText((Join-Path $work "$n.csv"), "screen_id,screen_name`nthings.edit,A`nthings.edit,B`n") }; Fail = 'is listed twice'; Why = 'expected the duplicate to be refused' }
        @{ Name = 'published without proof is refused'; Do = { param($n) }; Extra = @('-Published'); Fail = 'needs proof'; NoMap = $true; Why = 'expected -Published alone to be refused' }
        @{ Name = 'published with every page and anchor in the tree is written'; Do = { param($n) New-SiteFor $n | Out-Null }; Extra = { param($n) @('-Published', '-Site', (Join-Path $work "$n-site")) }; Check = { param($r) $r.Exit -eq 0 -and $r.Map.status -eq 'published' }; Why = 'expected a published map' }
        @{ Name = 'published with an anchor missing from the tree fails and leaves no map'; Do = { param($n) New-SiteFor $n -WithoutAnchor | Out-Null }; Extra = { param($n) @('-Published', '-Site', (Join-Path $work "$n-site")) }; Fail = 'anchor #part-one'; NoMap = $true; Why = 'expected the missing anchor to fail and no published file to remain' }
        @{ Name = 'published with a page missing from the tree fails and leaves no map'; Do = { param($n) $s = New-SiteFor $n; Remove-Item -LiteralPath (Join-Path $s 'windows/Alpha-1/topics/do-it.html') }; Extra = { param($n) @('-Published', '-Site', (Join-Path $work "$n-site")) }; Fail = 'page not in the tree'; NoMap = $true; Why = 'expected the missing page to fail and no published file to remain' }
    )
    foreach ($c in $helpCases) {
        if ($Filter -and $c.Name -notlike "*$Filter*") { continue }
        $n = 'helpmap-' + [guid]::NewGuid().ToString('N').Substring(0, 6)
        New-HelpMapPublication $n | Out-Null
        & $c.Do $n
        $extra = if ($c['Extra'] -is [scriptblock]) { & $c['Extra'] $n } elseif ($c['Extra']) { $c['Extra'] } else { @() }
        $r = Invoke-HelpMap $n $extra
        if ($c['Check']) { Record 'helpmap' $c.Name ([bool](& $c['Check'] $r)) "$($c.Why); got exit $($r.Exit):`n$($r.Text)" }
        else {
            $ok = ($r.Exit -ne 0) -and $r.Text.Contains($c['Fail']) -and (-not $c['NoMap'] -or -not $r.Map)
            Record 'helpmap' "$($c.Name)" $ok "$($c.Why); got exit $($r.Exit), map $(if ($r.Map) { 'written' } else { 'absent' }):`n$($r.Text)"
        }
    }

    # ---- Assembling the maps for the app to pull (DEC-196) ----
    function Invoke-PublishMaps {
        param([string]$Name, [string]$Status = 'proposed')
        $out = Join-Path $work "$Name-out"
        $text = & pwsh -NoProfile -File (Join-Path $PSScriptRoot 'publish-help-maps.ps1') -Maps (Join-Path $work "$Name-maps") -Output $out -Status $Status -Root $root 2>&1 | ForEach-Object { "$_" }
        [pscustomobject]@{ Exit = $LASTEXITCODE; Text = ($text -join "`n"); Out = $out }
    }
    $mapName = 'windows.Alpha-1.en-GB.help-map.json'
    $publishCases = @(
        @{ Name = 'proposed maps are assembled with checksums that verify'; Check = { param($r) $manifest = Get-Content -LiteralPath (Join-Path $r.Out 'help-maps-manifest.json') -Raw | ConvertFrom-Json; $sum = (Get-Content -LiteralPath (Join-Path $r.Out 'help-maps-SHA256SUMS') -Raw).Trim(); $hash = (Get-FileHash -LiteralPath (Join-Path $r.Out $mapName) -Algorithm SHA256).Hash.ToLowerInvariant(); $r.Exit -eq 0 -and $manifest.status -eq 'proposed' -and @($manifest.files).Count -eq 1 -and $manifest.files[0].name -eq $mapName -and $manifest.files[0].targets -eq 2 -and $manifest.files[0].gaps -eq 1 -and $manifest.files[0].sha256 -eq $hash -and $sum -eq "$hash  $mapName" }; Why = 'expected the map, its checksum and a manifest' }
        @{ Name = 'a map of another status than the publication fails'; Status = 'published'; Fail = "status is 'proposed', but this publication is 'published'"; Why = 'expected the proposed map to be refused as published' }
        @{ Name = 'a file whose name does not follow its device fails'; Do = { param($n) Rename-Item -LiteralPath (Join-Path $work "$n-maps/$mapName") -NewName 'ipad.Alpha-1.en-GB.help-map.json' }; Fail = 'does not follow device.release.language'; Why = 'expected the misnamed map to be refused' }
        @{ Name = 'a map without the gaps field fails'; Do = { param($n) $p = Join-Path $work "$n-maps/$mapName"; [System.IO.File]::WriteAllText($p, (Get-Content -LiteralPath $p -Raw | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty gaps | ConvertTo-Json -Depth 5)) }; Fail = 'missing gaps'; Why = 'expected the missing field to be named' }
        @{ Name = 'an id that is both a target and a gap fails'; Do = { param($n) Edit-File $work "$n-maps/$mapName" '"things.list"' '"things.edit"' }; Fail = "'things.edit' is both a target and a gap"; Why = 'expected the clash to be refused' }
        @{ Name = 'complete that disagrees with the gaps fails'; Do = { param($n) Edit-File $work "$n-maps/$mapName" '"complete": false' '"complete": true' }; Fail = 'complete is True, but there are 1 gap(s)'; Why = 'expected the disagreement to be refused' }
        @{ Name = 'a target that is not a relative address fails'; Do = { param($n) Edit-File $work "$n-maps/$mapName" '"topics/do-it.html"' '"https://example.org/do-it.html"' }; Fail = 'is not a relative address'; Why = 'expected the absolute address to be refused' }
        @{ Name = 'a failed run assembles nothing'; Do = { param($n) Edit-File $work "$n-maps/$mapName" '"complete": false' '"complete": true' }; Fail = 'nothing is assembled'; NoOut = $true; Why = 'expected no manifest after a failure' }
    )
    foreach ($c in $publishCases) {
        if ($Filter -and $c.Name -notlike "*$Filter*") { continue }
        $n = 'helpmap-' + [guid]::NewGuid().ToString('N').Substring(0, 6)
        New-HelpMapPublication $n | Out-Null
        Invoke-HelpMap $n | Out-Null
        if ($c['Do']) { & $c['Do'] $n }
        $r = Invoke-PublishMaps $n $(if ($c['Status']) { $c['Status'] } else { 'proposed' })
        if ($c['Check']) { Record 'helpmap' $c.Name ([bool](& $c['Check'] $r)) "$($c.Why); got exit $($r.Exit):`n$($r.Text)" }
        else {
            $ok = ($r.Exit -ne 0) -and $r.Text.Contains($c['Fail']) -and (-not $c['NoOut'] -or -not (Test-Path -LiteralPath (Join-Path $r.Out 'help-maps-manifest.json')))
            Record 'helpmap' $c.Name $ok "$($c.Why); got exit $($r.Exit):`n$($r.Text)"
        }
    }
}

# ---- The reuse measurement (platform strategy, section 3.1) ----------------------------------

if ($Only -contains 'reuse') {
    Write-UftiStep 'Source rules: the reuse measurement'
    $reuse = Join-Path $work 'reuse'
    function New-ReuseTopic {
        param([string]$Slug, [string]$Name, [string]$Device, [string]$Extra = '', [string]$Date = '2026-10-01', [string]$Comment = '')
        Write-File $reuse "content/platforms/$Slug/topics/$Name.dita" @"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE task PUBLIC "-//OASIS//DTD DITA Task//EN" "task.dtd">
$Comment
<task id="$Name" xml:lang="en-GB">
  <title>Do it</title>
  <prolog>
    <critdates>
      <created date="$Date"/>
    </critdates>
  </prolog>

  <taskbody>
    <steps>
      <step><cmd>Open your $Device.</cmd></step>$Extra
    </steps>
  </taskbody>
</task>
"@
    }
    New-ReuseTopic 'android-phone' 'same-text' 'phone' -Date '2026-10-01' -Comment '<!-- written on the phone -->'
    New-ReuseTopic 'iphone' 'same-text' 'phone' -Date '2026-10-20' -Comment '<!-- a different note -->'
    New-ReuseTopic 'android-phone' 'device-word' 'phone'
    New-ReuseTopic 'iphone' 'device-word' 'iPhone'
    New-ReuseTopic 'android-phone' 'a-step-more' 'phone'
    New-ReuseTopic 'iphone' 'a-step-more' 'iPhone' -Extra "`n      <step><cmd>Choose a thing.</cmd></step>"
    New-ReuseTopic 'android-phone' 'one-folder-only' 'phone'
    $all = @(& (Join-Path $PSScriptRoot 'measure-reuse.ps1') -Root $reuse -PassThru)
    $row = { param($t) $all | Where-Object { $_.Topic -eq $t } | Select-Object -First 1 }
    $cases = @(
        @{ Name = 'dates, comments and blank lines are not differences'; Ok = { $r = & $row 'same-text'; $r -and $r.Lines -eq 0 -and $r.Masked -eq 0 } }
        @{ Name = 'a device word is a difference that the key removes'; Ok = { $r = & $row 'device-word'; $r -and $r.Lines -eq 2 -and $r.Masked -eq 0 } }
        @{ Name = 'a step the other device has is a difference that stays'; Ok = { $r = & $row 'a-step-more'; $r -and $r.Lines -eq 3 -and $r.Masked -eq 1 } }
        @{ Name = 'a topic in one folder is not compared'; Ok = { -not (& $row 'one-folder-only') } }
        @{ Name = '-Max leaves out a pair that is further apart'; Ok = { $few = @(& (Join-Path $PSScriptRoot 'measure-reuse.ps1') -Root $reuse -Max 0 -PassThru); ($few | Where-Object { $_.Topic -eq 'a-step-more' }) -eq $null -and @($few).Count -eq 2 } }
    )
    foreach ($c in $cases) {
        if ($Filter -and $c.Name -notlike "*$Filter*") { continue }
        Record 'reuse' $c.Name ([bool](& $c.Ok)) 'the measurement is not what the strategy says it is'
    }
}
# ---- The walk tooling: a run is collected only when every leg is there, on one build, with no identifiers (DEC-209) ----

if ($Only -contains 'walks') {
    Write-UftiStep 'Walks: the sheet, the notes skeleton and the collector'
    $walkTools = Join-Path $root 'build' 'walks'
    Import-Module (Join-Path $walkTools 'WalkSheet.psm1') -Force
    $sheetDir = Join-Path $work 'walk-sheets'
    Write-File $sheetDir 'mini.md' @'
# A small sheet

### Legs and groups

| Token | Legs |
|---|---|
| `both` | `leg-a`, `leg-b` |
| `help` | none yet |

## 1. One

| # | Do this | Our pages say | On |
|---|---|---|---|
| 1.1 | Look at it. | A thing. | `both` |
| 1.2 | Look again. | A thing. | `leg-a` |
| 1.3 | Find the help button. | A thing. | `help` |
'@
    $walkRoot = Join-Path $work 'walk-runs'
    function Write-Sums {
        param([string]$Leg)
        $lines = Get-ChildItem -LiteralPath $Leg -Recurse -File | Where-Object { $_.Name -ne 'SHA256SUMS' } | Sort-Object FullName | ForEach-Object { "$((Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash.ToLowerInvariant())  $([System.IO.Path]::GetRelativePath($Leg, $_.FullName) -replace '\\', '/')" }
        [System.IO.File]::WriteAllText((Join-Path $Leg 'SHA256SUMS'), (($lines -join "`n") + "`n"))
    }
    function Write-WalkLeg {
        param([string]$Run, [string]$Id, [string[]]$Rows, [string]$Seen = 'as the page says', [string]$Result = 'Same', [string]$Status = 'complete', [string]$Version = '0.1.0', [string]$Kind = 'closed')
        $dir = Join-Path $Run $Id
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        $kindJson = if ($Kind) { " `"buildKind`": `"$Kind`"," } else { '' }
        Write-File $dir 'leg-result.json' "{ `"leg`": `"$Id`", `"status`": `"$Status`", `"build`": { `"version`": `"$Version`", `"build`": `"1`" },$kindJson `"environment`": { `"os`": `"Windows 11`", `"screen`": `"1280x800`" } }"
        $t = "# Notes: $Id`n`n## Results: mini`n`n| # | Result | Seen | Do this |`n|---|---|---|---|`n"
        foreach ($r in $Rows) { $t += "| $r | $Result | $Seen | text |`n" }
        Write-File $dir 'notes.md' $t
        Write-Sums $dir
    }
    function New-WalkRun {
        param([string]$Name)
        $run = Join-Path $walkRoot $Name
        Write-File $run 'run.json' '{ "id": "test-run", "build": { "label": "Alpha-1", "version": "0.1.0", "build": "1" }, "sheets": [ "mini" ], "legs": [ { "id": "leg-a", "kind": "behaviour" }, { "id": "leg-b", "kind": "behaviour" } ] }'
        Write-WalkLeg $run 'leg-a' @('1.1', '1.2')
        Write-WalkLeg $run 'leg-b' @('1.1')
        $run
    }
    function Invoke-Collect {
        param([string]$Run, [string[]]$More = @())
        $o = & pwsh -NoProfile -File (Join-Path $walkTools 'collect-walk.ps1') -Run $Run -SheetsRoot $sheetDir -NoImport @More 2>&1 | Out-String
        [pscustomobject]@{ Exit = $LASTEXITCODE; Text = $o; Report = $(if (Test-Path -LiteralPath (Join-Path $Run 'report' 'walk-report.md')) { [System.IO.File]::ReadAllText((Join-Path $Run 'report' 'walk-report.md')) } else { '' }) }
    }
    $walkCases = @(
        @{ Name = 'a complete run on one build'; Pass = $true; More = @(); Do = { param($r) }; Expect = 'is collected' }
        @{ Name = 'a leg that is missing'; Pass = $false; More = @(); Do = { param($r) Remove-Item -LiteralPath (Join-Path $r 'leg-b') -Recurse -Force }; Expect = 'has not been dropped' }
        @{ Name = 'a leg that is missing, when partial runs are accepted'; Pass = $true; More = @('-AllowPartial'); Do = { param($r) Remove-Item -LiteralPath (Join-Path $r 'leg-b') -Recurse -Force }; Expect = 'is collected' }
        @{ Name = 'a leg that ran another build'; Pass = $false; More = @(); Do = { param($r) Write-WalkLeg $r 'leg-b' @('1.1') -Version '0.2.0' }; Expect = 'not the run''s' }
        @{ Name = 'a leg that is only partial'; Pass = $false; More = @(); Do = { param($r) Write-WalkLeg $r 'leg-b' @('1.1') -Status 'partial' }; Expect = 'is partial|not complete' }
        @{ Name = 'a leg that is only partial, when partial runs are accepted'; Pass = $true; More = @('-AllowPartial'); Do = { param($r) Write-WalkLeg $r 'leg-b' @('1.1') -Status 'partial' }; Expect = 'is collected' }
        @{ Name = 'a file changed after its checksum'; Pass = $false; More = @(); Do = { param($r) Add-Content -LiteralPath (Join-Path $r 'leg-a' 'notes.md') "`nmore" }; Expect = 'does not match its checksum' }
        @{ Name = 'a file that is not in SHA256SUMS'; Pass = $false; More = @(); Do = { param($r) Write-File (Join-Path $r 'leg-a') 'extra.txt' 'x' }; Expect = 'is not listed in SHA256SUMS' }
        @{ Name = 'a leg with no checksums'; Pass = $false; More = @(); Do = { param($r) Remove-Item -LiteralPath (Join-Path $r 'leg-a' 'SHA256SUMS') }; Expect = 'has no SHA256SUMS' }
        @{ Name = 'a device serial number in the leg result'; Pass = $false; More = @(); Do = { param($r) $d = Join-Path $r 'leg-a'; Write-File $d 'leg-result.json' '{ "leg": "leg-a", "status": "complete", "build": { "version": "0.1.0", "build": "1" }, "buildKind": "closed", "environment": { "os": "Android 12", "serial": "R58M123ABC" } }'; Write-Sums $d }; Expect = 'keep serial numbers' }
        @{ Name = 'a host name as a key in the leg result'; Pass = $false; More = @(); Do = { param($r) $d = Join-Path $r 'leg-a'; Write-File $d 'leg-result.json' '{ "leg": "leg-a", "status": "complete", "build": { "version": "0.1.0", "build": "1" }, "buildKind": "closed", "environment": { "os": "Windows 11", "hostname": "x" } }'; Write-Sums $d }; Expect = 'keep serial numbers' }
        @{ Name = 'a leg result with no environment card'; Pass = $false; More = @(); Do = { param($r) $d = Join-Path $r 'leg-a'; Write-File $d 'leg-result.json' '{ "leg": "leg-a", "status": "complete", "build": { "version": "0.1.0", "build": "1" }, "buildKind": "closed" }'; Write-Sums $d }; Expect = 'no environment card' }
        @{ Name = 'a leg result that does not say which kind of build it ran'; Pass = $false; More = @(); Do = { param($r) Write-WalkLeg $r 'leg-b' @('1.1') -Kind '' }; Expect = 'has no buildKind' }
        @{ Name = 'a leg result with a kind of build that is not known'; Pass = $false; More = @(); Do = { param($r) Write-WalkLeg $r 'leg-b' @('1.1') -Kind 'debug' }; Expect = 'is not closed or devflow' }
        @{ Name = 'a leg that ran a build with the DevFlow agent'; Pass = $true; More = @(); Do = { param($r) Write-WalkLeg $r 'leg-b' @('1.1') -Kind 'devflow' }; Expect = 'is collected' }
        @{ Name = 'a name on the private deny-list'; Pass = $false; More = @('-DenyList'); Deny = 'Examplehost'; Do = { param($r) Write-WalkLeg $r 'leg-a' @('1.1', '1.2') -Seen 'run on examplehost today' }; Expect = 'deny-list' }
        @{ Name = 'a row that the sheet does not have'; Pass = $false; More = @(); Do = { param($r) Write-WalkLeg $r 'leg-a' @('1.1', '1.2', '9.9') }; Expect = 'is not a row of the sheet' }
        @{ Name = 'a row that waits for a later build'; Pass = $false; More = @(); Do = { param($r) Write-WalkLeg $r 'leg-a' @('1.1', '1.2', '1.3') }; Expect = 'is not a row of the sheet' }
        @{ Name = 'a row with no line'; Pass = $false; More = @(); Do = { param($r) Write-WalkLeg $r 'leg-a' @('1.1') }; Expect = 'has no line for row' }
        @{ Name = 'a row listed twice'; Pass = $false; More = @(); Do = { param($r) Write-WalkLeg $r 'leg-a' @('1.1', '1.2', '1.2') }; Expect = 'appears twice' }
        @{ Name = 'a result that is not one of the four words'; Pass = $false; More = @(); Do = { param($r) Write-WalkLeg $r 'leg-a' @('1.1', '1.2') -Result 'Fine' }; Expect = 'use Same, Different' }
        @{ Name = 'a leg that is not listed in the run'; Pass = $true; More = @(); Do = { param($r) Write-WalkLeg $r 'leg-z' @('1.1') }; Expect = 'is not a leg of this run' }
        @{ Name = 'a run with no run.json'; Pass = $false; More = @(); Do = { param($r) Remove-Item -LiteralPath (Join-Path $r 'run.json') }; Expect = 'No run.json' }
        @{ Name = 'a leg listed twice in the run'; Pass = $false; More = @(); Do = { param($r) Write-File $r 'run.json' '{ "id": "test-run", "build": { "version": "0.1.0", "build": "1" }, "sheets": [ "mini" ], "legs": [ { "id": "leg-a", "kind": "behaviour" }, { "id": "leg-a", "kind": "behaviour" } ] }' }; Expect = 'listed twice' }
        @{ Name = 'a pictures leg with no manual'; Pass = $false; More = @(); Do = { param($r) Write-File $r 'run.json' '{ "id": "test-run", "build": { "version": "0.1.0", "build": "1" }, "sheets": [ "mini" ], "legs": [ { "id": "leg-a", "kind": "pictures" }, { "id": "leg-b", "kind": "behaviour" } ] }' }; Expect = 'names no manual' }
    )
    $n = 0
    foreach ($c in $walkCases) {
        if ($Filter -and $c.Name -notlike "*$Filter*") { continue }
        $n++
        $run = New-WalkRun "case-$n"
        & $c.Do $run
        $more = @($c.More)
        if ($c.ContainsKey('Deny')) { Write-File $run 'deny-list.txt' "# private`n$($c.Deny)`n"; $more = @() }
        $r = Invoke-Collect $run $more
        $ok = if ($c.Pass) { $r.Exit -eq 0 -and $r.Text -match $c.Expect } else { $r.Exit -eq 1 -and $r.Text -match $c.Expect }
        if ($c.ContainsKey('Deny') -and $r.Text -match [regex]::Escape($c.Deny)) { $ok = $false }   # the name itself is never printed
        Record 'walks' "$($c.Name) $(if ($c.Pass) { 'is accepted' } else { 'fails the collection' })" $ok "expected exit $(if ($c.Pass) { 0 } else { 1 }) and '$($c.Expect)'; got exit $($r.Exit): $($r.Text)"
    }
    if (-not $Filter -or 'report' -like "*$Filter*") {
        $run = New-WalkRun 'report'
        Write-WalkLeg $run 'leg-a' @('1.1', '1.2') -Result 'Different' -Seen 'it showed X'
        $r = Invoke-Collect $run
        Record 'walks' 'a Different row is a finding in the report, and not a failure' ($r.Exit -eq 0 -and $r.Report -match '\*\*Different\*\*' -and $r.Report -match '1\.2.*leg-a.*Different: it showed X') "exit $($r.Exit); report: $($r.Report)"
        Record 'walks' 'a row that a leg does not walk is n/a in the report' ($r.Report -match '\| 1\.2 \|[^|]*\|[^|]*\| n/a \|') "report: $($r.Report)"
    }
    if (-not $Filter -or 'kinds' -like "*$Filter*") {
        $run = New-WalkRun 'kinds'
        Write-WalkLeg $run 'leg-b' @('1.1') -Kind 'devflow'
        $r = Invoke-Collect $run
        Record 'walks' 'the report lists the kind of build of each leg, and says when they differ' ($r.Exit -eq 0 -and $r.Report -match '\| `leg-a` \| behaviour \| closed \|' -and $r.Report -match '\| `leg-b` \| behaviour \| devflow \|' -and $r.Report -match 'more than one kind of build') "exit $($r.Exit); report: $($r.Report)"
        $run = New-WalkRun 'kinds-same'
        $r = Invoke-Collect $run
        Record 'walks' 'the report does not warn when every leg ran the same kind of build' ($r.Exit -eq 0 -and $r.Report -notmatch 'more than one kind of build') "report: $($r.Report)"
    }
    $sheet = Read-WalkSheet -Path (Join-Path $sheetDir 'mini.md')
    Record 'walks' 'a group stands for its legs, and a row for later help is walked by no leg' ((@(Get-WalkRowsForLeg $sheet 'leg-b').Id -join ',') -eq '1.1' -and (@(Get-WalkRowsForLeg $sheet 'leg-a').Id -join ',') -eq '1.1,1.2') 'the rows for a leg are not those the sheet names'
    Write-File $sheetDir 'no-on.md' "# x`n`n## 1. One`n`n| # | Do this | Our pages say | On |`n|---|---|---|---|`n| 1.1 | Look. | A thing. | none |`n"
    $threw = $false; try { $null = Read-WalkSheet -Path (Join-Path $sheetDir 'no-on.md') } catch { $threw = "$_" -match 'names no leg' }
    Record 'walks' 'a sheet row that names no leg is refused' $threw 'the sheet was read'
    $notes = Join-Path $work 'walk-notes' 'notes.md'
    & pwsh -NoProfile -File (Join-Path $walkTools 'New-WalkNotes.ps1') -Sheet mini -Leg leg-b -Out $notes -SheetsRoot $sheetDir *> $null
    $nt = if (Test-Path -LiteralPath $notes) { [System.IO.File]::ReadAllText($notes) } else { '' }
    Record 'walks' 'the notes skeleton has a line for each row of the leg and no other' ($nt -match '\| 1\.1 \| Not done' -and $nt -notmatch '\| 1\.2 \|' -and $nt -notmatch '\| 1\.3 \|') $nt
    & pwsh -NoProfile -File (Join-Path $walkTools 'New-WalkNotes.ps1') -Sheet mini -Leg leg-b -Out $notes -SheetsRoot $sheetDir *> $null
    Record 'walks' 'the notes skeleton does not replace a file that may hold results' ($LASTEXITCODE -eq 1) 'a second run replaced the file'
}

Remove-Item -LiteralPath $work -Recurse -Force -ErrorAction SilentlyContinue
$failed =@($results | Where-Object { -not $_.Ok })
Write-Host ''
Write-Host "$($results.Count - $failed.Count) of $($results.Count) case(s) behaved as expected."
if ($failed.Count) { Write-Host "FAIL: $($failed.Count) case(s) did not." -ForegroundColor Red; exit 1 }
Write-Host 'PASS: every source rule fails where it should and passes where it should.' -ForegroundColor Green
