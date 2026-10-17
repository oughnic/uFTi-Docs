# Platform strategy

How we document one application on several platforms and device idioms without copying content.

Part of the [authoring plan](authoring-plan.md). Status: Draft 0.4, 16 October 2026. Decisions are tracked in the [decision log](decision-log.md).

## 1. Principles

1. **One product, one body of knowledge.** Platforms differ in *how* you do something, rarely in *what* or *why*.
2. **Single source.** A fact, a step or a concept is written once.
3. **One reader, one device.** Each manual mentions only the platform and device idiom the reader is using.
4. **Use the cheapest mechanism that keeps the text readable.** The ladder in [section 3](#3-reuse-levels) says which.
5. **Nothing is silently missing.** A missing screenshot, label or topic for a manual fails the build or shows up in a report.
6. **Idiom first, platform at the edges.** Topics are written for phone, tablet or desktop. The operating system matters only for getting, updating and keeping the app, and for what it provides around it ([section 2.3](#23-idiom-first-platform-at-the-edges)).

## 2. Platform catalogue

uFTi is one .NET MAUI application. Three platforms are supported (DEC-019): **Android**, **iOS** and **Windows** (the WinUI head). Android and iOS each cater for two **device idioms**, phone and tablet. Windows is a desktop idiom. That gives five manuals.

| `@platform` value | Folder slug | Manual title (provisional) | Platform and idiom | Evidence today | Wave |
|---|---|---|---|---|---|
| `AndroidPhone` | `android-phone` | uFTi user manual: Android phone | Android, phone | Key map and screenshot set (named `AndroidMobile` today) | 1 |
| `WindowsWinUI` | `windows` | uFTi user manual: Windows | Windows (WinUI), desktop | Key map and screenshot set | 1 |
| `AndroidTablet` | `android-tablet` | uFTi user manual: Android tablet | Android, tablet | None | 2 |
| `iPhone` | `iphone` | uFTi user manual: iPhone | iOS, phone | None | 2 |
| `iPad` | `ipad` | uFTi user manual: iPad | iOS, tablet | None | 2 |

**Reference devices.** The device or machine each manual's pictures are captured on. The key map records it (section 4).

| Manual | Reference device | Notes |
|---|---|---|
| Android phone | Samsung Galaxy A41, model SM-A415F, Android 12, 1080 by 2400 pixels at 420 dpi, portrait. A physical phone (DEC-088). | Captured in the app, so the picture has no status bar, notification or other app. The serial number is never recorded here. |
| Windows | A clean Windows profile or virtual machine at a fixed window size, landscape (DEC-023). | A generic user name, so no personal path or name appears. |
| Android tablet, iPhone, iPad | An emulator or simulator, pinned when the manual joins (DEC-023). | Not chosen yet. |

Notes:

- **The supported platforms are decided** (DEC-019). Other MAUI heads are not supported and are not documented. The existing WPF key map is not imported.
- **Waves** (DEC-021). Wave 1 is the reference pair, which already have screenshot sets. Wave 2 adds Android tablet, then iPhone and iPad. Capturing iOS screenshots needs a Mac and a device or simulator. Building the documentation does not.
- **Values are single, case-sensitive tokens.** They appear in DITAVAL files and source. Once published they are never renamed. The existing Android key map says `AndroidMobile`. WP5 renames it `AndroidPhone`, because `Mobile` becomes a group token for phones and tablets together.
- **The Windows token keeps the head's name, `WindowsWinUI`.** The reader-facing title and the URL say simply "Windows".
- **No tablet idiom on Windows.** The Windows manual covers the desktop idiom.

### 2.1 Attribute vocabulary

| Attribute | Use | Values |
|---|---|---|
| `@product` | Which product a map or topic belongs to | `uFTi`. New values only if other surfaces are documented later. |
| `@platform` | Which platforms, idioms or groups a map, topic or element applies to. A space-separated list. | The platform tokens above, and the group tokens below. |
| `@props`, `@otherprops`, `@audience`, `@rev` | **Not used** for conditional text. | Keeps filtering to one dimension. |
| `audience` element in the `prolog` | The reader's experience level, for search filters. It does not filter content. | DITA's own `novice`, `general`, `expert`. |

**Group tokens.** The same attribute carries names for groups of platforms. The starting set is `Android`, `iOS`, `Phone`, `Tablet`, `Mobile` (phone and tablet), `Touch`, `Desktop` and `Pointer`. Group membership is defined by each manual's DITAVAL filter, not in the source:

| Manual | Tokens its filter includes |
|---|---|
| Android phone | `AndroidPhone`, `Android`, `Phone`, `Mobile`, `Touch` |
| Android tablet | `AndroidTablet`, `Android`, `Tablet`, `Mobile`, `Touch` |
| iPhone | `iPhone`, `iOS`, `Phone`, `Mobile`, `Touch` |
| iPad | `iPad`, `iOS`, `Tablet`, `Mobile`, `Touch` |
| Windows | `WindowsWinUI`, `Desktop`, `Pointer` |

**Use the widest token that is true.** Android permissions: `Android`. Behaviour of the tablet idiom on both operating systems: `Tablet`. Swipe gestures: `Touch`. A feature of the iPad alone: `iPad`. Keeping to group tokens means a new manual never needs edits throughout the source. Add a token beyond the starting set only when it would be used in at least two places.

**DITAVAL pattern.** Each manual's filter excludes every `@platform` value by default and includes the tokens that manual owns. An element with no `@platform` is always included. An element with several values is kept if any of them is included. WP2 verifies this against DITA-OT 4.4.1.

### 2.2 Phone and tablet idioms

The app adapts to the device idiom, so layout, navigation and available space can differ between a phone and a tablet running the same operating system.

- **A manual per idiom.** A reader's device is one idiom, and screenshots and navigation instructions are resolved per build through keys ([section 4](#4-screenshots-as-keys)). Giving each idiom its own manual keeps one topic and one `img-*` key serving every manual, with no idiom labels in the text (DEC-006, Q16).
- **Most text is shared.** For the same operating system, phone and tablet manuals share most topics. The extra cost of a second idiom is mainly its screenshot set, plus idiom-specific variants and topics.
- **Idiom-specific text is written for a reader who already knows their device.** It carries no "on a tablet" labels. If Q16 flips to one manual per operating system, those variants would need labels added.
- **Measure before assuming.** WP4 measures how far the tablet idiom differs: navigation chrome, layouts, gestures and multi-window behaviour. WP2 prototypes both idioms of one operating system.
- **The alternative (Q16).** One manual per operating system covering both idioms means fewer outputs. But every figure and variant must then be labelled by idiom in the source, and readers see content for a device they are not using.

### 2.3 Idiom first, platform at the edges

What a reader does on a phone differs from what they do on a tablet or a desktop: the layout, the navigation chrome, the gestures, how much fits on the screen. What differs between Android and iOS, or between either and Windows, sits at the edges: getting the app, updating it, permissions, where files live, the operating system's accessibility features, backup and sharing. So (DEC-032):

- **Write for an idiom.** A topic is written for phone, tablet or desktop, with the group tokens `Phone`, `Tablet`, `Desktop`, `Touch` and `Pointer`. A reader never sees another idiom's instructions.
- **Platform only at the edges.** The platform and device tokens (`Android`, `iOS`, `WindowsWinUI` and the five device tokens) are used for the edge list in [section 8](#8-what-usually-differs-between-platforms) and nowhere else. Lint flags a platform token in a topic outside that list.
- **Outputs stay one per device,** because a reader's device is one platform and one idiom, and installation is platform-specific.
- **The chooser asks "What are you using uFTi on?"** and lists devices, not operating systems.
- **The Quick Start is the sharpest case.** Its first and sixth pages (get it, keep it safe) are platform-specific; the rest are idiom-specific.

Q16, whether phone and tablet get separate manuals, is unchanged: this decides how topics are written, not how many manuals there are.

## 3. Reuse levels

Use the first level that works. Idiom differences use the same ladder as platform differences.

| Level | Use when | Mechanism | Limit |
|---|---|---|---|
| **0. Neutral wording** | The instruction is the same everywhere once worded neutrally. | Plain text: "select", "open", "enter", not "tap" or "click". | Preferred. Most text lives here. |
| **1. Keys** | Only a name, label or picture differs. | `keyref` for screenshots, UI labels and product facts. | No limit. |
| **2. Inline variant** | One or two steps, sentences or list items differ. | `@platform` on `step`, `li`, `p`, `ph`, `note` or table `row`. | At most three per topic. Never inside a sentence. Never nested. |
| **3. Platform-specific topic** | More than about a third of a topic differs, or the task exists on one platform or idiom only. | A topic under `content/platforms/`, referenced from the shared map position with `@platform` on its `topicref`. | Put what is common in a shared concept and link to it. |
| **4. Platform-specific chapter** | A whole area exists on some platforms only, such as camera capture on phones and tablets. | A chapter map with `@platform`. | Rare. |

Rules:

- **Never use a condition to hide a different idea.** If the concept differs, write separate topics.
- **Keep whole sentences inside a condition,** so translated text is never stitched together.
- **Prefer a group token to a list of platform tokens.**
- **Prefer a platform-specific topic to a fourth variant.**
- **Do not use conditions for version differences.** Tagged releases hold earlier versions (DEC-013).

## 4. Screenshots as keys

This generalises the convention already used in the existing key maps. How screenshots are chosen, captured, imported and kept current is in the [screenshot strategy](screenshot-strategy.md).

- **Every screenshot is a key** defined in its manual's key map. A topic refers to it with `<image keyref="img-person-view"/>`. The key definition's `linktext` is the alternative text.

  ```xml
  <keydef keys="img-person-view" href="images/person-view.png" format="png" scope="local">
    <topicmeta><linktext>Person page with identity, birth, death, photos and the Edit button</linktext></topicmeta>
  </keydef>
  ```

- **Every idiom has its own key map and screenshot set.** Key names are the same in every manual, so one topic serves all of them.
- **Key names** are `img-<area>-<what>`: lower case, hyphenated, and identical for the same screen on every device.
- **File names are stable** when a screenshot is re-captured, so keys never change.
- **Alternative text** says what the picture shows and why it matters. It does not start "Screenshot of". One sentence.
- **Each key map records** the reference device or machine, its operating system version, the app version and the dataset, in `data` elements. Use an emulator or simulator of the idiom: a tablet for Android, an iPhone and an iPad for iOS (DEC-023). The Android phone is the exception: its reference device is a physical phone (DEC-088).
- **Key maps carry `@platform`,** so a build for another manual excludes them.
- **The Brontë dataset only.** See the [dataset strategy](dataset-strategy.md) and the [disclosure boundary](authoring-plan.md#74-disclosure-boundary-and-privacy).
- **One theme.** Every screenshot is captured in the app's Oxford and slate theme, light variant, so the pictures match the site and PDF (DEC-024).
- **No silent fallback.** A topic that shows a screen that does not exist on a device is filtered out for that manual. An unresolved image key is a build failure.
- **Figures.** Use `fig` with a `title` when the text refers to the picture. Alternative text and caption must not repeat each other. No information may exist only in a picture. Prefer cropping and clear text to annotated callouts.

WP2 verifies that alternative text taken from `linktext` reaches both the HTML and the PDF.

## 5. UI labels and product facts as keys

- **Product facts** live in `content/keys/product.ditamap`: the product name (marked `translate="no"`), the app version, platform display names and standard links. Topics use `<keyword keyref="product-name"/>`.
- **UI labels** live in `content/keys/ui-labels.ditamap`: names of screens, tabs, buttons and fields that are used in more than two topics or are known to differ by platform or language. Topics use `<uicontrol keyref="ui-people"/>`. Labels used once are typed inline, exactly as on screen.
- **Platform overrides.** A label that differs on one device is defined in that manual's key map. DITA gives priority to the first definition, so each manual's key map is included before the shared keys. WP2 verifies this.
- **Stretch goal.** Generate the label keys from the application's resource files so the manual always uses the exact UI wording, and so a Spanish set could follow. The generated file would hold only user-facing strings. WP3 and WP4 evaluate it.

## 6. Build model

Two ways to turn shared sources into per-manual publications:

- **A. One build per manual.** Each manual's DITAVAL filter excludes other manuals' content. Each build is a complete publication with its own website and PDF, five in all. A platform chooser page links them.
- **B. One build for all manuals.** DITA branch filtering (`ditavalref`) and key scopes produce one copy of the content per manual inside a single website.

**A constraint from DITA-OT 4.4.** Publications built as separate deliverables share nothing. Links between them do not resolve, and cross-deliverable keys are unsupported. Under A, every manual's build must therefore contain everything it links to. That is why the good practice part is included in each manual (DEC-007). Links between manuals are plain external links, reached through the chooser.

| Criterion | A: build per manual | B: one build with branches |
|---|---|---|
| Reader sees only their device | Yes, by construction | Yes, if navigation is arranged per branch |
| Links to shared guidance | External between sites. The guide is duplicated in each build. | Internal. One copy of the guidance. |
| Search | One index per manual | One index, so a platform filter is needed |
| PDF per manual | One per build | One per bookmap. The whole-library PDF is skipped or enormous. |
| Build risk | Low: ordinary DITA-OT features | Higher: branch filtering, key scopes and the plugin's navigation together |
| Authoring complexity | Low | Medium (key scopes) |
| Adding a manual | New DITAVAL, project entry, folder | New branch in the root map |
| Duplicate content across sites | Yes. The guide appears in six places: five manuals and the standalone guide. | No for shared guidance |
| CI time | Five builds, in parallel as a matrix | One longer build |

**A variant of A to test.** The guide is built six times under A. WP2 also tests embedding only the contextual cues in each manual and linking out to the standalone guide through an external key map, which uses the same key names as the guide's internal keys. It trades self-contained PDFs for less duplication.

**Recommendation: A** (DEC-006), because it uses only mainstream DITA-OT features and gives each reader a self-contained manual and PDF. WP2 prototypes both and decides on evidence.

**WP2 exit criteria**

1. A shared topic builds for three manuals (Android phone, Android tablet and Windows) with different screenshots, different labels and one inline variant.
2. The Android phone and tablet manuals share their operating-system topics and differ only in idiom-specific content.
3. A platform-specific topic appears only in its own manuals.
4. Alternative text from key link text appears in the HTML and the PDF. veraPDF passes PDF/UA-1. There is no `DSPDF009W`.
5. An unresolved key or image is reported in a way the CI can gate on.
6. The platform chooser works as DITA, or a fallback is chosen.
7. The good practice callout pattern renders with an accessible label in HTML and PDF. Candidates: a note with `type="other"`, a titled section, or a tip with a bold lead-in.
8. Build time and output size are recorded for a prototype of about 50 topics.
9. B and the link-out variant are prototyped to the same level, or abandoned with reasons recorded.
10. The separate-manual and combined-manual options for phone and tablet are compared, and Q16 is answered.
11. The PDF uses the theme's fonts, not the generator's bundled fallback: headings in Source Serif 4 Semibold and text in Atkinson Hyperlegible Next, every font embedded, and figures fitting the page ([theme README](../build/theme/README.md#8-verification)).

## 7. Map patterns

Proposed. WP2 finalises them.

```text
content/
  ufti-manual-<slug>.ditamap     one bookmap per manual, five in all, at the root (see below)
  good-practice-guide.ditamap    the standalone guide
content/maps/structure/          shared chapter maps, one per chapter
content/platforms/
  <slug>/keys/, images/          each manual's own key map and screenshots
  <token>/topics/                platform-specific topics, in a folder named for the
                                 token that governs them: an OS (android, ios), an idiom
                                 across OSs (phone, tablet) or a single manual (ipad, ...)
```

- **One root map per publication, at the root of the publication's folder.** DITA-OT takes the root map's folder as the input directory: a topic or image above it is built with `DOTJ036W`, the plugin does not inline a diagram from there (`GOVK005W`), and the plugin's relative links then miss. `args.input.dir` does not change this (WP1 tested it on the command line and in a project file). So the bookmaps sit at `content/`, and every topic, key map, image and diagram sits beneath them (DEC-045).
- Include submaps with `<mapref href="...">`. **Never** `mapref keyref`, and never define keys that name maps. DITA-OT 4.4.1 does not resolve keys inside a submap included by key, and the toolkit gives no warning (the plugin does).
- **A manual's bookmap** has front matter, chapters and back matter. Each chapter's `href` is a chapter-introduction topic, and its children come from a shared chapter map. A bookmap does not allow `mapref` or `keydef` at its top level: put them inside chapters and front or back matter.
- **The manual's key map** is included first, as a resource-only map, so its keys take priority.
- **Platform-specific topics** are referenced from the shared chapter maps with `@platform` on the `topicref`.
- **Keys sit on topicrefs** in the navigation (`keys="..."`), and links use `keyref`. Resource-only maps hold keys for images and topics that are not in the navigation.
- **The navigation is the publication.** Nest entries under the page that lists them. Use `toc="no"` for topics reachable only by links.
- **No `chunk="to-content"`.** It triggers known DITA-OT 4.4 defects.
- **Relationship tables** (`reltable`) in the shared chapter maps generate related links, including links from tasks to good practice.
- **Several books from one map.** A map that references several bookmaps gives one website plus a print version and PDF per bookmap. This is the basis for option B.

## 8. What usually differs between platforms

Use this as a checklist when writing a manual's variants and platform-specific topics.

- Installation, updates and uninstalling.
- First run and permissions: camera, files, notifications.
- Navigation chrome: tabs, side rail, split view, menu bar.
- Gestures versus pointer and keyboard.
- Keyboard shortcuts and menus (Windows, and tablets with a hardware keyboard).
- Opening, saving and sharing files, and where files live.
- Windows, split screen and multi-window behaviour.
- Orientation changes and the number of columns shown.
- Photo capture and the media picker.
- Operating system accessibility features: screen reader, text size and display scaling, contrast, voice control.
- Backup and cloud storage locations.
- Known limitations of the platform.

## 9. Adding a platform

The same steps add a new device idiom of a supported platform.

1. Confirm it is a supported platform (DEC-019). A new platform is a product decision.
2. Add it to the [catalogue](#2-platform-catalogue) and record it in the decision log.
3. Choose a reference device or machine of that idiom. Record its operating system and the app version.
4. Replay the Brontë journey on the device, capture screenshots to the stable names ([dataset strategy](dataset-strategy.md)), and write the key map, with `linktext` for every image.
5. Add a DITAVAL file, a project entry and a CI matrix entry.
6. Run the coverage report ([section 10](#10-consistency-checks)). List missing keys and topics.
7. Write platform-specific topics using the checklist in [section 8](#8-what-usually-differs-between-platforms).
8. Perform every task on the device (technical review).
9. Do an accessibility pass with the platform's screen reader.
10. Add the manual to the platform chooser and to the "platform differences" reference topic.
11. Publish.

## 10. Consistency checks

CI generates these. Failures block a release unless noted.

| Check | What it reports |
|---|---|
| Key coverage | Every `keyref` resolves in every build that includes the topic. |
| Image coverage | Every `img-*` key a topic uses is defined, with an existing file, in every manual that includes the topic. |
| Applicability matrix | Topic by manual (included or excluded) as a CSV artefact. Reviewed at release. Does not block. |
| Idiom parity | Topics in one idiom's manual but not in the other's for the same operating system. Expected only for idiom-specific topics. |
| Variant budget | Topics with more than three `@platform` variants are flagged. |
| Orphans | Topics in no map, platform-specific topics nobody references, and screenshots no key uses. |
| Vocabulary | Every `@platform` value is in the catalogue or the group token set. |
