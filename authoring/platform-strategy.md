# Platform strategy

How we document one application on several platforms without copying content.

Part of the [authoring plan](authoring-plan.md). Status: Draft 0.1, 15 October 2026. Decisions are tracked in the [decision log](decision-log.md).

## 1. Principles

1. **One product, one body of knowledge.** Platforms differ in *how* you do something, rarely in *what* or *why*.
2. **Single source.** A fact, a step or a concept is written once.
3. **One reader, one platform.** Each manual mentions only the platform the reader is using.
4. **Use the cheapest mechanism that keeps the text readable.** The ladder in [section 3](#3-reuse-levels) says which.
5. **Nothing is silently missing.** A missing screenshot, label or topic for a platform fails the build or shows up in a report.
6. **Platforms are cheap to add and remove.** Doing so touches platform folders and build configuration, not shared topics.

## 2. Platform catalogue

uFTi is one .NET MAUI application with several *heads*, one per platform. The first three platforms below already have a screenshot key map in the application repository. The rest are proposals.

| `@platform` value | Folder slug | Manual title (provisional) | MAUI head | Evidence today | Wave |
|---|---|---|---|---|---|
| `AndroidMobile` | `android-mobile` | uFTi user manual: Android phone | Workload head, Android | Key map and screenshot set | 1 |
| `WindowsWinUI` | `windows-winui` | uFTi user manual: Windows (WinUI) | Workload head, Windows | Key map and screenshot set | 1 |
| `WindowsWPF` | `windows-wpf` | uFTi user manual: Windows (WPF) | maui-labs WPF head | Key map and screenshot set | 2 |
| `iOS` | `ios` | uFTi user manual: iPhone and iPad | Workload head, iOS (needs a Mac build host) | None | 2 |
| `MacCatalyst` | `mac-catalyst` | uFTi user manual: macOS (Mac Catalyst) | Workload head, Mac Catalyst (needs a Mac) | None | 2 |
| `MacOSAppKit` | `macos-appkit` | uFTi user manual: macOS (AppKit) | maui-labs AppKit head | None | 3 |
| `LinuxGtk4` | `linux-gtk4` | uFTi user manual: Linux (GTK4) | maui-labs GTK4 head | None | 3 |

Notes:

- **Release status is a product decision (Q1).** We document only platforms the product team confirms. The others stay in the catalogue, undocumented.
- **Two Windows heads.** If only one ships to users, retire the other from the catalogue (Q11).
- **Phone and tablet.** Treated as one manual per operating system unless the UI differs enough to justify two (Q2).
- **Values are single, case-sensitive tokens.** They appear in DITAVAL files and source. Once published they are never renamed.

### 2.1 Attribute vocabulary

| Attribute | Use | Values |
|---|---|---|
| `@product` | Which product a map or topic belongs to | `uFTi`. New values only if other surfaces are documented later. |
| `@platform` | Which platforms a map, topic or element applies to. A space-separated list. | The platform tokens above, and optional group tokens (below). |
| `@props`, `@otherprops`, `@audience`, `@rev` | **Not used** for conditional text. | Keeps filtering to one dimension. |
| `audience` element in the `prolog` | The reader's experience level, for search filters. It does not filter content. | DITA's own `novice`, `general`, `expert`. |

**Group tokens.** The same attribute may carry names for groups, such as `Android`, `Apple`, `Windows`, `Desktop`, `Mobile`, `Touch` and `Pointer`. Group membership is defined by each platform's DITAVAL file, not in the source. For example, the Android build includes `AndroidMobile`, `Android`, `Mobile` and `Touch`. Add a group token only when it is used in at least two places, so a new platform never needs edits throughout the source.

**DITAVAL pattern.** Each platform's filter excludes every `@platform` value by default and includes the tokens that platform owns. An element with no `@platform` is always included. An element with several values is kept if any of them is included. WP2 verifies this against DITA-OT 4.4.1.

## 3. Reuse levels

Use the first level that works.

| Level | Use when | Mechanism | Limit |
|---|---|---|---|
| **0. Neutral wording** | The instruction is the same everywhere once worded neutrally. | Plain text: "select", "open", "enter", not "tap" or "click". | Preferred. Most text lives here. |
| **1. Keys** | Only a name, label or picture differs. | `keyref` for screenshots, UI labels and product facts. | No limit. |
| **2. Inline variant** | One or two steps, sentences or list items differ. | `@platform` on `step`, `li`, `p`, `ph`, `note` or table `row`. | At most three per topic. Never inside a sentence. Never nested. |
| **3. Platform-specific topic** | More than about a third of a topic differs, or the task exists on one platform only. | A topic in `content/platforms/<slug>/topics/`, referenced from the shared map position with `@platform` on its `topicref`. | Put what is common in a shared concept and link to it. |
| **4. Platform-specific chapter** | A whole area exists on some platforms only, such as camera capture on mobile. | A chapter map with `@platform`. | Rare. |

Rules:

- **Never use a condition to hide a different idea.** If the concept differs, write separate topics.
- **Keep whole sentences inside a condition,** so translated text is never stitched together.
- **Prefer a platform-specific topic to a fourth variant.**
- **Do not use conditions for version differences.** Tagged releases hold earlier versions (DEC-013).

## 4. Screenshots as keys

This generalises the convention already used in the existing key maps.

- **Every screenshot is a key** defined in its platform's key map. A topic refers to it with `<image keyref="img-person-view"/>`. The key definition's `linktext` is the alternative text.

  ```xml
  <keydef keys="img-person-view" href="images/person-view.png" format="png" scope="local">
    <topicmeta><linktext>Person page with identity, birth, death, photos and the Edit button</linktext></topicmeta>
  </keydef>
  ```

- **Key names** are `img-<area>-<what>`: lower case, hyphenated, and identical for the same screen on every platform.
- **File names are stable** when a screenshot is re-captured, so keys never change.
- **Alternative text** says what the picture shows and why it matters. It does not start "Screenshot of". One sentence.
- **Each platform key map records** the reference device or machine, the operating system version, the app version and the sample workspaces, in `data` elements.
- **Platform key maps carry `@platform`,** so a build for another platform excludes them.
- **Sample workspaces only.** See the [disclosure boundary](authoring-plan.md#74-disclosure-boundary-and-privacy).
- **No silent fallback.** A topic that shows a screen that does not exist on a platform is filtered out for that platform. An unresolved image key is a build failure.
- **Figures.** Use `fig` with a `title` when the text refers to the picture. Alternative text and caption must not repeat each other. No information may exist only in a picture. Prefer cropping and clear text to annotated callouts.

WP2 verifies that alternative text taken from `linktext` reaches both the HTML and the PDF.

## 5. UI labels and product facts as keys

- **Product facts** live in `content/keys/product.ditamap`: the product name (marked `translate="no"`), the app version, platform display names and standard links. Topics use `<keyword keyref="product-name"/>`.
- **UI labels** live in `content/keys/ui-labels.ditamap`: names of screens, tabs, buttons and fields that are used in more than two topics or are known to differ by platform or language. Topics use `<uicontrol keyref="ui-people"/>`. Labels used once are typed inline, exactly as on screen.
- **Platform overrides.** A label that differs on one platform is defined in that platform's key map. DITA gives priority to the first definition, so each platform key map is included before the shared keys. WP2 verifies this.
- **Stretch goal.** Generate the label keys from the application's resource files so the manual always uses the exact UI wording, and so a Spanish set could follow. The generated file would hold only user-facing strings. WP3 and WP4 evaluate it.

## 6. Build model

Two ways to turn shared sources into per-platform publications:

- **A. One build per platform.** Each platform's DITAVAL excludes other platforms' content. Each build is a complete publication with its own website and PDF. A platform chooser page links them.
- **B. One build for all platforms.** DITA branch filtering (`ditavalref`) and key scopes produce one copy of the manual per platform inside a single website.

**A constraint from DITA-OT 4.4.** Publications built as separate deliverables share nothing. Links between them do not resolve, and cross-deliverable keys are unsupported. Under A, every platform build must therefore contain everything it links to. That is why the good practice part is included in each manual (DEC-007). Links between platform sites are plain external links, reached through the chooser.

| Criterion | A: build per platform | B: one build with branches |
|---|---|---|
| Reader sees only their platform | Yes, by construction | Yes, if navigation is arranged per branch |
| Links to shared guidance | External between sites. The guide is duplicated in each build. | Internal. One copy of the guidance. |
| Search | One index per platform | One index, so a platform filter is needed |
| PDF per platform | One per build | One per bookmap. The whole-library PDF is skipped or enormous. |
| Build risk | Low: ordinary DITA-OT features | Higher: branch filtering, key scopes and the plugin's navigation together |
| Authoring complexity | Low | Medium (key scopes) |
| Adding a platform | New DITAVAL, project entry, folder | New branch in the root map |
| Duplicate content across sites | Yes. Pages differ only in platform details. | No for shared guidance |
| CI time | N builds, in parallel as a matrix | One longer build |

**Recommendation: A** (DEC-006), because it uses only mainstream DITA-OT features and gives each reader a self-contained manual and PDF. WP2 prototypes both and decides on evidence.

**WP2 exit criteria**

1. A shared topic builds for three platforms with different screenshots, different labels and one inline variant.
2. A platform-specific topic appears only in its own platform's build.
3. Alternative text from key link text appears in the HTML and the PDF. veraPDF passes PDF/UA-1. There is no `DSPDF009W`.
4. An unresolved key or image is reported in a way the CI can gate on.
5. The platform chooser works as DITA, or a fallback is chosen.
6. The good practice callout pattern renders with an accessible label in HTML and PDF. Candidates: a note with `type="other"`, a titled section, or a tip with a bold lead-in.
7. Build time and output size are recorded for a prototype of about 50 topics.
8. B is prototyped to the same level, or abandoned with reasons recorded.

## 7. Map patterns

Proposed. WP2 finalises them.

```text
content/maps/
  ufti-manual-<slug>.ditamap     one bookmap per platform
  good-practice-guide.ditamap    the standalone guide
  structure/                     shared chapter maps, one per chapter
```

- **One root map per publication.** Include submaps with `<mapref href="...">`. **Never** `mapref keyref`, and never define keys that name maps. DITA-OT 4.4.1 does not resolve keys inside a submap included by key, and the toolkit gives no warning (the plugin does).
- **A platform bookmap** has front matter, chapters and back matter. Each chapter's `href` is a chapter-introduction topic, and its children come from a shared chapter map. A bookmap does not allow `mapref` or `keydef` at its top level: put them inside chapters and front or back matter.
- **The platform key map** is included first, as a resource-only map, so its keys take priority.
- **Platform-specific topics** are referenced from the shared chapter maps with `@platform` on the `topicref`.
- **Keys sit on topicrefs** in the navigation (`keys="..."`), and links use `keyref`. Resource-only maps hold keys for images and topics that are not in the navigation.
- **The navigation is the publication.** Nest entries under the page that lists them. Use `toc="no"` for topics reachable only by links.
- **No `chunk="to-content"`.** It triggers known DITA-OT 4.4 defects.
- **Relationship tables** (`reltable`) in the shared chapter maps generate related links, including links from tasks to good practice.
- **Several books from one map.** A map that references several bookmaps gives one website plus a print version and PDF per bookmap. This is the basis for option B.

## 8. What usually differs between platforms

Use this as a checklist when writing a platform's variants and platform-specific topics.

- Installation, updates and uninstalling.
- First run and permissions: camera, files, notifications.
- Navigation chrome: tabs, side navigation, menu bar.
- Gestures versus pointer and keyboard.
- Keyboard shortcuts and menus (desktop).
- Opening, saving and sharing files, and where files live.
- Windows and multi-window behaviour.
- Photo capture and the media picker.
- Operating system accessibility features: screen reader, text size, contrast, voice control.
- Backup and cloud storage locations.
- Known limitations of the platform.

## 9. Adding a platform

1. Confirm its release status with the product owner (Q1).
2. Add it to the [catalogue](#2-platform-catalogue) and record it in the decision log.
3. Choose a reference device or machine. Record the operating system and app version.
4. Prepare the sample workspaces. Capture screenshots to the stable names. Write the key map, with `linktext` for every image.
5. Add a DITAVAL file, a project entry and a CI matrix entry.
6. Run the coverage report ([section 10](#10-consistency-checks)). List missing keys and topics.
7. Write platform-specific topics using the checklist in [section 8](#8-what-usually-differs-between-platforms).
8. Perform every task on the platform (technical review).
9. Do an accessibility pass with the platform's screen reader.
10. Add the platform to the platform chooser and to the "platform differences" reference topic.
11. Publish.

## 10. Consistency checks

CI generates these. Failures block a release unless noted.

| Check | What it reports |
|---|---|
| Key coverage | Every `keyref` resolves in every build that includes the topic. |
| Image coverage | Every `img-*` key a topic uses is defined, with an existing file, in every platform that includes the topic. |
| Applicability matrix | Topic by platform (included or excluded) as a CSV artefact. Reviewed at release. Does not block. |
| Variant budget | Topics with more than three `@platform` variants are flagged. |
| Orphans | Topics in no map, platform-specific topics nobody references, and screenshots no key uses. |
| Vocabulary | Every `@platform` value is in the catalogue. |
