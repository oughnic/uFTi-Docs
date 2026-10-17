# uFTi publisher theme

A stylesheet and fonts that give the website and the PDF the look of the uFTi app's **Oxford and slate** theme: its colours and its two typefaces, on top of the plugin's neutral branding.

**Status: built into real plugin output and a real PDF by WP1, and verified there** (see [verification](#8-verification)). The checks below pass, and the theme is wired into every build through `build/projects/common.xml`. WP6 looks at every component on a real build and adds the logo, favicon and share image.

## 1. What is here

| Path | What it is |
|---|---|
| `ufti.css` | The publisher stylesheet. One file, because the build takes one. |
| `assets/fonts/` | Six TrueType fonts: Atkinson Hyperlegible Next (regular, bold, italic) and Source Serif 4 (regular, italic, semibold). |
| `assets/licences/` | The licences of those fonts. They travel with the fonts. |
| `check-theme.ps1` | Checks contrast and the stylesheet's own rules. PowerShell 7, on any operating system. |

## 2. Where the look comes from

The colours are the **light variant** of the app's theme, version 1.0.0, copied into a delimited tokens block at the top of `ufti.css`. Everything else in the file refers to those tokens, and a check fails the build if a colour appears anywhere else.

| Theme role | Token | Used for |
|---|---|---|
| surface | `--ufti-surface` | Page edge and footer background |
| surface raised | `--ufti-surface-raised` | The page itself, and the background behind figures |
| surface container | `--ufti-surface-container` | Code blocks, the sidebar toggle, grey tags, secondary buttons |
| on surface | `--ufti-on-surface` | Body text, headings, the active page in the sidebar |
| on surface muted | `--ufti-on-surface-muted` | Hints, captions, attributions, the sidebar carets |
| outline | `--ufti-outline` | Rules, table lines, the inset bar, screenshot edges |
| outline strong | `--ufti-outline-strong` | Input and search borders |
| primary | `--ufti-primary` | The masthead, the brand rule above the footer, buttons |
| link | `--ufti-link` | Links, in every state |
| on primary container | `--ufti-on-primary-container` | Link hover, button hover |
| primary container | `--ufti-primary-container` | The default tag, including the phase banner's |
| selection | `--ufti-selection` | Selected text |
| success, warning, error and their containers | `--ufti-success`, and so on | Error and success text, the warning button, coloured tags |

The Design System reads most of its colours from custom properties, so section 4 of the stylesheet sets those once. The plugin's own page furniture (masthead, sidebar, contents lists) sets colours directly, so section 5 overrides it rule by rule. Section 6 covers Design System components that use literal colours (buttons, tags, pagination). Section 7 repeats the same values as literals for the print document and the PDF.

## 3. Typography

| Face | Where | Weights |
|---|---|---|
| **Source Serif 4** | The page title, the first three heading levels and the masthead's name | Semibold (600) |
| **Atkinson Hyperlegible Next** | Everything else: body text, smaller headings, links, tables, search | Regular (400), bold (700), italic |

This is the app's own split of a display face and a text face. Code keeps the plugin's monospace stack. Type **sizes stay the Design System's**: the app's scale is tuned for its screens, and the manual should keep the readable scale the Design System gives it.

**Figure height.** A phone screenshot is tall and narrow, so figures are limited to 40 rem on screen and 110 mm in the PDF. Without that, a portrait screenshot at full column width would be taller than a screen, or than a page.

## 4. Wiring it into the pipeline

The build takes one stylesheet and copies the files it refers to. In a DITA-OT project file (one deliverable per manual), with paths relative to the project file:

```xml
<project xmlns="https://www.dita-ot.org/project">
  <deliverable id="android-phone">
    <context><input href="../../content/maps/ufti-manual-android-phone.ditamap"/></context>
    <output href="android-phone"/>
    <publication transtype="govuk">
      <param name="args.css" value="ufti.css"/>
      <param name="args.cssroot" href="../theme"/>
      <param name="args.copycss" value="yes"/>
      <param name="govuk.css.assets" href="../theme/assets"/>
      <param name="govuk.pdf.fonts" href="../theme/assets/fonts"/>
      <param name="govuk.print" value="yes"/>
      <param name="govuk.pdf" value="yes"/>
      <param name="govuk.csp" value="meta"/>
    </publication>
  </deliverable>
</project>
```

This is what `build/projects/common.xml` does, with two details found in WP1: a folder is given with `path` rather than `href` (`path="../theme"`, resolved relative to the project file, which the toolkit then passes as a full path), and `args.csspath` is set to `theme`, so the stylesheet, the fonts and the licences land together under `theme/` in the output. On the command line `args.cssroot` must be a full path, because a relative one is not read from the folder you run the command in.

The same on a command line, on Windows:

```powershell
dita.bat --input=content\maps\ufti-manual-android-phone.ditamap --format=govuk --output=out\android-phone `
  -Dargs.css=ufti.css -Dargs.cssroot=C:\src\uFTi-Docs\build\theme -Dargs.copycss=yes `
  -Dgovuk.css.assets=C:\src\uFTi-Docs\build\theme\assets `
  -Dgovuk.pdf.fonts=C:\src\uFTi-Docs\build\theme\assets\fonts `
  -Dgovuk.print=yes -Dgovuk.pdf=yes -Dgovuk.csp=meta
```

What each parameter does:

- `args.css`, `args.cssroot`, `args.copycss` link the stylesheet after the Design System's and the plugin's, on every page and in the print document.
- `govuk.css.assets` copies `assets/` beside the stylesheet, so `url("fonts/…")` resolves, and the licences are published with the fonts.
- `govuk.pdf.fonts` gives DesignSystemPDF the same TrueType files, so the PDF embeds the same faces. It must hold only fonts, which is why the licences live beside `fonts/`, not in it.
- `govuk.csp=meta` is compatible: the fonts are hosted with the site, which is all that policy allows.

## 5. Deliberately unchanged

- **Focus states.** The Design System's yellow focus stays. The app's navy focus ring would vanish on the navy masthead, and the plugin's accessibility checks assume the yellow. The checker confirms the yellow is visible on the masthead (8.5:1) and that focused text is readable (14.6:1).
- **Type sizes, spacing and square corners.** The app rounds its corners and sets its own scale. The manual keeps the Design System's.
- **Visited links.** One link colour in every state, so the sidebar, the contents lists and topic text agree. Links stay underlined, so colour is never the only cue.
- **Tag colours with no role in the theme** (purple, teal, pink, magenta, turquoise).
- **Dark mode.** Not included. See [section 8](#8-verification).

## 6. Checks

```powershell
pwsh build/theme/check-theme.ps1
```

It exits 1 on any failure, and WP1 puts it in CI. It checks:

- **Contrast.** Every pairing the stylesheet uses meets WCAG 2.2 AA: 4.5:1 for text, 3:1 for boundaries. All 31 pass.
- **No colour outside the tokens block.** The one exception is the print section (7), which is written with literal values and **no `var()`**. The PDF generator never resolves CSS custom properties, and its layout engine may not, so a rule that relied on one would silently fall back to the Design System's own font and colours. Each literal names its token on its own line (`ufti: literal outline`), and the checker fails if a literal and its token differ. Thirty are checked.
- **Every `var(--ufti-…)` names a defined token.**
- **Every font file the stylesheet names exists**, and the licences are present.

Results, generated by the script (`-Markdown`):

| Pairing | Colours | Ratio | Needs | Used for |
|---|---|---|---|---|
| on-surface on surface-raised | #1B2430 on #FFFFFF | 15.65:1 | 4.5:1 | Body text on the page |
| on-surface on surface | #1B2430 on #F5F7FA | 14.58:1 | 4.5:1 | Body text on the page edge and in the footer |
| on-surface on surface-container | #1B2430 on #E9EDF2 | 13.31:1 | 4.5:1 | Code blocks, sidebar toggle, grey tags |
| on-surface-muted on surface-raised | #4B5563 on #FFFFFF | 7.56:1 | 4.5:1 | Secondary text, hints, captions, attributions |
| on-surface-muted on surface | #4B5563 on #F5F7FA | 7.04:1 | 4.5:1 | Secondary text in the footer |
| on-surface-muted on surface-container | #4B5563 on #E9EDF2 | 6.43:1 | 4.5:1 | Secondary text on tinted fills |
| link on surface-raised | #1E3A5F on #FFFFFF | 11.5:1 | 4.5:1 | Links in topic text, the sidebar and contents lists |
| link on surface | #1E3A5F on #F5F7FA | 10.72:1 | 4.5:1 | Footer links |
| link on surface-container | #1E3A5F on #E9EDF2 | 9.78:1 | 4.5:1 | Links inside tinted fills |
| on-primary-container on surface-raised | #12263F on #FFFFFF | 15.28:1 | 4.5:1 | Link hover on the page |
| on-primary-container on surface | #12263F on #F5F7FA | 14.23:1 | 4.5:1 | Link hover in the footer |
| on-surface on surface-raised | #1B2430 on #FFFFFF | 15.65:1 | 4.5:1 | Link active state |
| on-primary on primary | #FFFFFF on #1E3A5F | 11.5:1 | 4.5:1 | Masthead title, primary buttons, current page |
| on-primary on on-primary-container | #FFFFFF on #12263F | 15.28:1 | 4.5:1 | Primary button on hover |
| on-primary-container on primary-container | #12263F on #D5E2F2 | 11.63:1 | 4.5:1 | Default tag and the phase banner tag |
| on-success-container on success-container | #1E4D2C on #D9EEDD | 8:1 | 4.5:1 | Green tag |
| on-error-container on error-container | #7A1F18 on #F7DEDB | 8.07:1 | 4.5:1 | Red tag |
| on-warning-container on warning-container | #5E3D00 on #F6E7C6 | 8.01:1 | 4.5:1 | Orange and yellow tags |
| primary on surface-container | #1E3A5F on #E9EDF2 | 9.78:1 | 4.5:1 | Secondary button text |
| primary on primary-container | #1E3A5F on #D5E2F2 | 8.76:1 | 4.5:1 | Secondary button on hover |
| on-surface on selection | #1B2430 on #DBE6F3 | 12.39:1 | 4.5:1 | Selected text |
| on-primary on error | #FFFFFF on #A42E25 | 7.01:1 | 4.5:1 | Warning button |
| error on surface-raised | #A42E25 on #FFFFFF | 7.01:1 | 4.5:1 | Error text |
| success on surface-raised | #2E6B3F on #FFFFFF | 6.38:1 | 4.5:1 | Success text |
| outline on surface-raised | #7C8694 on #FFFFFF | 3.69:1 | 3:1 | Borders and rules on the page, the inset bar, screenshot edges |
| outline on surface | #7C8694 on #F5F7FA | 3.44:1 | 3:1 | Borders and rules on the page edge |
| outline-strong on surface-raised | #5B6572 on #FFFFFF | 5.92:1 | 3:1 | Input borders, search box, secondary button edge |
| outline-strong on surface-container | #5B6572 on #E9EDF2 | 5.03:1 | 3:1 | Secondary button edge on its fill |
| primary on surface-raised | #1E3A5F on #FFFFFF | 11.5:1 | 3:1 | The brand rule above the footer |
| focus yellow on primary | #FFDD00 on #1E3A5F | 8.54:1 | 3:1 | Focus ring on the masthead (Design System colour) |
| focus text on focus yellow | #0B0C0C on #FFDD00 | 14.55:1 | 4.5:1 | Text of a focused link (Design System colours) |

## 7. Fonts

Both families are licensed under the **SIL Open Font License 1.1**, which allows them to be bundled and redistributed unchanged with their licences. They are the same files the app bundles, copied unmodified. The licences are in [`assets/licences/`](assets/licences/), and the build publishes them with the fonts.

| File | CSS family, weight | Version | Size | SHA-256 |
|---|---|---|---|---|
| `AtkinsonHyperlegibleNext-Regular.ttf` | Atkinson Hyperlegible Next, 400 | 2.001 | 65,068 | `88ed5c31a71584c7772963b02d04bef1eb7e3d2e9c8b9cb204339b1f82cf432c` |
| `AtkinsonHyperlegibleNext-Bold.ttf` | Atkinson Hyperlegible Next, 700 | 2.001 | 66,792 | `994414047df66bb4998d01c1cb1eeb4a2ddc4622d1aa56bbb8adbeca7645b041` |
| `AtkinsonHyperlegibleNext-Italic.ttf` | Atkinson Hyperlegible Next, 400 italic | 2.001 | 69,812 | `b7f8f03ceb28ebadb2de2332b2e869a00e8dbfb5c8e00fdbb06385770c8227e7` |
| `SourceSerif4-Regular.ttf` | Source Serif 4, 400 | 4.005 | 261,868 | `e5a4ee6a3d87bb9024796be390c6771e2a0eb1883dae25effaf57ca01668e24b` |
| `SourceSerif4-It.ttf` | Source Serif 4, 400 italic | 4.005 | 187,808 | `9d2950a8f1da66e21502c35d646a1d2148e79f9ea43fd2158cf02f5232e7f430` |
| `SourceSerif4-Semibold.ttf` | Source Serif 4, 600 (and the alias "Source Serif 4 Semibold") | 4.005 | 272,088 | `36db62940cb5728b12b1802476dc7fcf4c6c519a7bdd476ba23a4e555fc4655f` |

All six have TrueType outlines and are static (not variable), which is what the PDF generator can embed. Do not rename or edit them: the Source Serif licence reserves the name "Source" for the unmodified fonts.

A page loads only the faces it uses. A typical page fetches about 400 KB of fonts. Converting to WOFF2 would roughly halve that: a follow-up for WP6, which needs a conversion tool in the build.

## 8. Verification

**On mock markup (15 October 2026).** The stylesheet was loaded in a browser together with the plugin's real stylesheets (Design System 6.5.1, the plugin's own, and its neutral overlay), on mock markup built from the plugin's documented class names. All six fonts and the Semibold alias loaded. The masthead, sidebar, headings, links, notes, tables, tags, buttons, code, figures and footer took the theme's colours and faces, and the Design System's yellow focus colour was untouched. Across the 47 pieces of rendered text the lowest contrast was 7.01:1, with no failures. The test found one gap, the search button falling back to Arial, and it is fixed.

**On a real build (WP1, 17 October 2026).** The WP1 fixture, three manuals built with plugin 1.3.0 and DesignSystemPDF 0.1.2 through `build/projects/common.xml`, served over HTTP and opened in a Chromium browser, and the PDFs read with PDFBox and veraPDF (`build/scripts/check-output.ps1`, gates `theme`, `theme-browser`, `pdf-fonts` and `pdf-ua`):

| What | Result |
|---|---|
| The stylesheet | Linked on every page after the Design System's, the plugin's and the neutral overlay, at `theme/ufti.css`, with 76 rules loaded. The six fonts and both licences are copied beside it by `govuk.css.assets`. |
| Fonts on the website | Every face a page uses loads from the site's own files: on a task page Atkinson Hyperlegible Next 400 and 700 and Source Serif 4 600. `document.fonts.check('600 16px "Source Serif 4"')` is true. |
| Headings | `h1` and the masthead title compute to Source Serif 4 at weight 600; body text to Atkinson Hyperlegible Next at 400; text inside the inlined diagram to Atkinson. |
| Figures on the website | A 1080 by 2400 placeholder picture renders at 288 by 640 pixels: held to 40 rem at its true proportions. |
| Fonts in the PDF | Every font embedded: `AtkinsonHyperlegibleNext-Regular`, `AtkinsonHyperlegibleNext-Bold`, `SourceSerif4-Semibold` and, for code, the generator's `NotoSansMono-Regular`. Headings use the Semibold face. No Noto Sans for text. |
| Figures in the PDF | The 110 mm cap holds: the phone picture is drawn at 49 by 110 mm, the tablet picture at 69 by 110 mm, the Windows picture at 174 by 98 mm, each on an A4 page. |
| PDF/UA | PDF/UA-1 passes in veraPDF 1.30.3 for all three PDFs, with no `DSPDF009W`. PDF/UA-2 fails, as advisory. |
| axe-core (WCAG 2.2 AA) | Two findings on the plugin's output, neither in the theme's colours or faces: related links set too close to touch (`target-size`), which the stylesheet now fixes with a 24 px box per link; and a clickable diagram's links nested in an element the plugin marks `role="img"` (`nested-interactive`), accepted as a documented exception until the plugin changes (DEC-054). |

**Not yet verified**

- **Every component.** The fixture has a task, concepts, a glossary, a figure, a diagram, a note-free page and the print document. WP6 looks at notes, tables, tags, search results, the index and the footer on a real build with more content.
- **Dark mode.** The app's theme has a dark variant. The site does not follow the reader's dark preference yet: it needs every plugin and Design System component checked on dark (Q17).
- **WOFF2.** The fonts are served as TrueType; converting them is WP6's.

## 9. Keeping in step with the app

- The tokens block records the theme name and version. When the app's theme or fonts change, replace the block as a whole and update the version, then run the checker.
- The app repository can generate the block from its theme definition, so the values are never retyped. This follows the same rule as screenshots: scripts that need app internals live in the app repository, and this repository receives the output (DEC-024).
- Screenshots are captured in the same theme and variant, so the manual and the app look alike. The capture manifest records which.
