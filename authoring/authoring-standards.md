# Authoring standards

How DITA is written in this repository: structure, naming, markup, metadata and accessibility. The words are in the [style guide](style-guide.md), the plain word for each label and term in the [terminology list](terminology.md), the metadata values in the [metadata vocabulary](metadata-vocabulary.md), and the starting points in the [templates](../content/templates/README.md).

Part of the [authoring plan](authoring-plan.md). Status: Draft 0.4, 16 October 2026. Decisions are tracked in the [decision log](decision-log.md).

Much of this follows the plugin's own guide for people who write DITA for it, [SOURCE-SYSTEMS.md](https://github.com/iStandUK/govuk-dita-plugin/blob/main/docs/SOURCE-SYSTEMS.md), because following it means the website, search, print version, PDF and page metadata all come out right without editing the output.

## 1. DITA profile

- **DITA 1.3**, with the standard DTD-based `DOCTYPE`. The toolkit validates every file.
- **Topic types:** `concept`, `task`, `reference`, `troubleshooting` and `glossentry`. **Bookmaps** for publications. Plain maps for key maps and shared chapter structure.
- **No specialisation.** Use standard elements only.
- **No Markdown topics, no Lightweight DITA, no DITA 2.0.** The plugin targets DITA 1.3.
- **Domains.** The standard DTDs include the user interface, software and highlight domains. Use highlight elements (`b`, `i`) only when no semantic element fits.
- **Encoding.** UTF-8, with an XML declaration.
- **Language.** `xml:lang="en-GB"` on every map and topic.
- **One topic per file.** The root element's `id` matches the file name.
- **`outputclass`** only for effects the plugin documents, currently `search-ignore`, `search-demote` and `landscape`. Classes carry styling, not meaning. Never record a topic's type or status in `outputclass`.
- **Forbidden:** `mapref` by key, keys that name maps, and `chunk="to-content"` (both trigger known DITA-OT 4.4 defects).
- **No GEDCOM tags, structures or file contents** anywhere: not in a topic, a glossary entry, a table or an example (DEC-030). They are not human-centred. The field reference is generated from the GEDCOM 7 structure definitions in plain words, keyed by the label on screen. Lint fails on a tag pattern.
- **No statements about price, "free", "forever", accounts or sign-in** (DEC-040). Those facts live on ufti.com and in keys. A topic may say where a tree is saved on the reader's own device (DEC-168), never where any service keeps data.
- **Workflow is not recorded in the source.** No `@status` or `@rev` for review state. Use pull requests and issues.

## 2. Topic-based authoring rules

1. **Standalone.** A reader arriving from search understands the topic with no earlier context.
2. **One purpose, one type.** Never mix concept, task and reference.
3. **No positional references.** Avoid "above", "below", "previous section", "next chapter", "as described earlier".
4. **No numbers in titles.** The build numbers chapters and sections.
5. **State prerequisites** in `prereq`. Do not assume them.
6. **Links by key.** Order and hierarchy come from the map, not the topic.
7. **Size.** Aim for a concept of about 500 words or fewer and a task of nine steps or fewer. Split anything longer.
8. **Every topic has** a title, a short description, `xml:lang` and metadata.
9. **Reuse by reference.** Keys for words and facts. Content references only for fragments that must stay identical.
10. **Minimalism.** Do not explain the obvious. Show the result of an action. Help readers recover from mistakes.

## 3. Files, folders and identifiers

| Item | Rule |
|---|---|
| File names | Lower case, hyphens, no spaces. Extensions `.dita`, `.ditamap`, `.ditaval`. |
| Stability | **Names never change after publication.** They become URLs. Never put a status in a name. If a name must change, record it in the decision log and leave a stub topic at the old name. |
| Type prefixes | None. A folder says the area (`people/`, `sources/`). The topic says its type. |
| Folders | One folder per area, at most two levels deep. |
| Topic `id` | The file name without its extension. Unique across the publication. |
| Task files | Start with a verb: `add-a-person.dita`. |
| Concept and reference files | A noun phrase: `workspaces.dita`, `event-types.dita`. |
| Troubleshooting files | The symptom: `photo-does-not-appear.dita`. |
| Maps | `ufti-manual-<slug>.ditamap`, `good-practice-guide.ditamap`, and shared chapter maps named for the chapter. |
| Keys | Topic keys match the file name without its extension. Image keys start `img-`. UI label keys start `ui-`. Product facts start `product-`. |
| Images | `<name>.png` in `platforms/<slug>/images/`. Shared diagrams are `.svg` in `images/`. |

## 4. Titles and short descriptions

**Titles**

- Sentence case. Unique within a publication. No more than about 70 characters. No trailing full stop.
- **Task:** imperative verb ("Add a person"). **Concept and reference:** noun phrase ("Workspaces", "Event types"). **Troubleshooting:** the symptom as a reader would say it ("A photo does not appear"). **Glossary entry:** the term.
- UI names appear exactly as on screen.
- Add a `searchtitle` only when a fuller title helps in search results.

**Short descriptions (`shortdesc`)** are required on every topic and chapter.

- One sentence, ideally 25 words or fewer.
- Say what the topic is or what it helps the reader do. Do not repeat the title and do not begin "This topic".
- The plugin uses it in the navigation and home page, weights it four times in search, and writes it into link previews and page metadata.

## 5. Topic patterns

| Topic | Pattern |
|---|---|
| **Task** | `prereq` only for real prerequisites. `context`: one or two sentences on when and why. `steps`: one action per `step`, `cmd` in the imperative and no longer than about 25 words, `info` for essential detail, `stepresult` for what the reader will see. At most nine steps. `choices` for alternatives of equal standing. `result`. `postreq` for next steps with links. No tables inside steps. |
| **Concept** | An opening paragraph saying what it is and why it matters. Titled sections. No procedures. Diagrams carry a title and alternative text. Related links come from the relationship table. |
| **Reference** | A table with a header row, or a `properties` list for field descriptions. Ordered in a way a reader can scan. |
| **Troubleshooting** | One problem per topic. `condition` for what the reader sees, then `troubleSolution` with `cause` and `remedy`. |
| **Glossary entry** | `glossterm`, a one- or two-sentence `glossdef`, and `glossAlt` for acronyms and abbreviations. Singular form. Synonyms as keywords. |
| **Chapter introduction** | A short concept saying what the chapter covers. Its short description doubles as the home page summary. |
| **Quick Start page** | A `task` (or a short `concept`) under 150 words with one picture, in the Quick Start bookmap. Steps first. One link at the end. |
| **Key concept set** | For each key concept, four linked pieces: a diagram (see), the concept (read), a task on the Brontë dataset (do) and a checklist (check) (DEC-035). The relationship table links them. |

Good practice concepts add a fixed set of section titles ([good practice strategy, section 8](good-practice-strategy.md#8-writing-and-review-rules)).

## 6. Inline markup

| What | Element | Notes |
|---|---|---|
| Button, tab, field, menu item | `uicontrol` | Exact on-screen label, or by key (`keyref="ui-..."`). |
| Menu path | `menucascade` of `uicontrol` | |
| Window, dialog or page title | `wintitle` | |
| Text the reader types | `userinput` | Also used for keyboard keys, as DITA 1.3 has no dedicated element. |
| Text the app shows | `systemoutput` | |
| File names and paths | `filepath` | |
| Product name | `keyword keyref="product-name"` | Marked `translate="no"` in the key. |
| A defined term | `term keyref="..."` | First use in a topic, for research and app terms. |
| Title of a book or document | `cite` | |
| Warnings | `note type="warning"`, `"caution"` or `"important"` | Only for real risk such as data loss. |
| Advice | `note` or `note type="tip"` | |
| Emphasis | Avoid. Rewrite the sentence. | |

The plugin renders neutral notes (`note`, `tip`, `remember`) as inset text, and the warning family (`warning`, `caution`, `important`, `attention`, `danger`) as warning text. The second group is loud, so use it rarely.

## 7. Images, figures and tables

- **Screenshots** are PNG, optimised, and referenced by key ([platform strategy, section 4](platform-strategy.md#4-screenshots-as-keys)).
- **Diagrams** are SVG, inlined by the plugin through `svg-container` and `svgref` so that links inside them work (DEC-036). Rules: a `title` and a `desc`; real text, not outlines, so it can be read, searched and translated; the theme's colours as literal values from the tokens block; links to topics by relative address (file names are stable), checked by the SVG link check; a text list of the same links follows the diagram, because the PDF keeps the picture but loses the links, and because a screen reader needs the route; no information only in the picture; no more than about twelve nodes, or split it. The [diagram template](../content/templates/template-diagram.svg) shows all of it.
- **Alternative text is mandatory** on every image. For screenshots it is the key's `linktext`. Describe the purpose, not the appearance. Never start "Image of" or "Screenshot of". The PDF generator warns (`DSPDF009W`) when it is missing, and the PDF then fails PDF/UA.
- **No decorative images.** If an image needs no description, it does not belong.
- **No text in images,** no information only in a picture, and no cues that rely on colour alone.
- **Figures.** Every picture sits in a `fig` (DEC-082, DEC-074): the theme caps a figure's picture to the page in the PDF, and a bare `image` is not capped. The lint fails an `image` outside a `fig`. A screenshot's `fig` has no title, because a caption that repeats the alternative text only adds words. A diagram's `fig` has a title, which names it.
- **Screenshot capture** follows the [screenshot strategy](screenshot-strategy.md): scripted, on a pinned emulator, simulator or clean Windows profile, in the Oxford and slate theme, light variant (dark only in the topic about appearance), showing the Brontë dataset only, a normalised status bar, and one size and scaling per manual. No device frames.
- **Tables** have a header row (`thead`) and a `title`, a simple structure, no layout tables, and few columns so they read on a phone. A table or figure that needs a landscape page in the PDF uses `outputclass="landscape"`.
- **Audio and video** are not used for now. If added, captions and transcripts are mandatory.

## 8. Links and relationships

- Link to topics by `keyref`. Keys are defined on topicrefs in the navigation.
- An `xref` with no text takes the target's title. Add text only when it helps.
- **Link text makes sense out of context.** Never "click here", "read more" or a bare URL.
- External links use `scope="external" format="html"`. The link check covers them. Say when a destination is paid or members-only.
- **Relationship tables** (`reltable`) in the shared chapter maps generate related links, including links from tasks to good practice. Topics hold hand-written `related-links` only for external "Further reading".
- **Content references** (`conref`, `conkeyref`) only for fragments that must stay identical, such as a standard caution. Keep them in a resource-only library topic. Prefer keys for words and phrases.
- **No links between separately built publications.** DITA-OT 4.4 cannot resolve them ([platform strategy, section 6](platform-strategy.md#6-build-model)).

## 9. Metadata

### 9.1 In a topic

Metadata goes in the topic's `prolog`. The DTD fixes the order of elements. The values and the help identifier's shape are in the [metadata vocabulary](metadata-vocabulary.md). Pattern:

```xml
<prolog>
  <critdates>
    <created date="YYYY-MM-DD"/>
    <revised modified="YYYY-MM-DD"/>
  </critdates>
  <metadata>
    <audience type="user" experiencelevel="novice"/>
    <category>Concept</category>
    <keywords>
      <keyword>family tree file</keyword>
    </keywords>
  </metadata>
</prolog>
```

| Element | Rule |
|---|---|
| `category` | One value from the controlled list: *Get started*, *How-to*, *Concept*, *Reference*, *Troubleshooting*, *Good practice*, *Glossary*. It separates kinds of page for search filters and page tags. It is not the DITA topic type. |
| `keywords` | Real aliases only: other names, abbreviations, former names. **Never the title's own words.** The plugin drops a keyword that only repeats a title word. |
| `audience` | `experiencelevel` of `novice`, `general` or `expert`, only where it helps a reader choose. It becomes a search filter. |
| `critdates` | `created` and `revised`, **only when true**. Set by the author on a substantive change. Never batch-stamped. Do not give dates in both `bookmeta` and topics. The site shows no dates until a reliable process exists (Q13). |
| `resourceid` | For a topic that documents a screen: `appname="ufti"` and `appid` set to the screen's stable identifier. The help map is generated from it (DEC-028), so every screen topic must have one. Never an issue number. |
| `data` | A name with a prefix from Dublin Core, DCAT, ADMS, SKOS and similar vocabularies is read as metadata, and written to the page where the plugin has a mapping for it. A name that is not a real term of those vocabularies is reported (`GOVK011W`) and dropped. A name with no prefix is ours and is not metadata. |

### 9.2 In a map

Publication-wide facts go in `bookmeta`, or in `topicmeta` for a plain map: the publisher organisation, the book's `critdates`, the edition, the copyright year and owner (`bookrights`), and the language.

Platform key maps carry `prodinfo` with the product name, version and platform, plus `data` entries for the reference device and the dataset, as the existing key maps do.

The licence, site address and organisation URL are **build parameters**, not source.

### 9.3 Never in metadata

Metadata is published. It never holds internal information or the names of people. The plugin names a person as creator only when we choose it.

## 10. Accessibility at source level

The plugin supplies landmarks, a skip link, focus states and contrast. It cannot make inaccessible source accessible. As authors we are responsible for:

- **Headings.** Structure comes from topic and section nesting. Never skip a level or style text to look like a heading.
- **Alternative text** on every image, and a `title` or `desc` on every diagram.
- **Link text** that makes sense out of context.
- **Tables** with header rows and simple structures.
- **Language** on every map and topic.
- **Instructions that refer to a control's name,** not its position or colour: "select **Delete**", not "select the red button on the right".
- **Plain language.** Short sentences. Expand an abbreviation on first use, or link it to its glossary entry.
- **Keyboard instructions** for desktop platforms.
- **Captions and transcripts** for any audio or video.
- **PDF/UA.** The generator tags the structure. We make sure titles, language, alternative text and table headers exist, that `DSPDF009W` never appears, and that reading order is checked by hand before each release.
- **An accessibility statement** is written honestly for the site (WP10), following the GOV.UK template, and linked from the footer.

## 11. Writing style

The full rules are in the [style guide](style-guide.md); the plain word for each label and term is in the [terminology list](terminology.md). The base is the [GOV.UK style guide](https://www.gov.uk/guidance/style-guide) and content design principles, with the project overrides the style guide records (DEC-010, DEC-070). In short:

- **British English** (en-GB), with the examples leaning to the United Kingdom (DEC-078).
- **Reading level** (DEC-029). Written for an average 11-year-old. Per topic: Flesch reading ease 70 or more, Flesch-Kincaid grade 6 or lower, an average sentence of 15 words or fewer and none over 25. Vale measures every topic in CI and an error fails the build. The targets stayed as they were after the Quick Start was measured (DEC-071). English measures do not apply to Spanish, which has its own (WP16).
- **Voice.** Second person ("you"), active, present tense. Steps use the imperative. One idea in a sentence.
- **Neutral verbs.** "Choose", "select", "open", "enter" and "type" work for touch and pointer. Avoid "click", "tap" and "press" except in text for one device.
- **Avoid** "simply", "just", "easy", "obviously", "please", "via", "e.g.", "i.e." and "etc.".
- **Name the control,** never its colour or its position.
- **Dates** are written 1 January 2026. The product is always written **uFTi**.
- **Terminology.** One term for one concept, from the terminology list. A label is printed as the app prints it, from a key (DEC-090). A hard word is explained once and has a glossary entry.
- **Inclusive language.** Assume nothing about a family. Never blame the reader.
- **The worked example.** The people and places of the Brontë dataset, spelt as the dataset spells them: Brontë with the diaeresis in text, and `bronte` in file names and keys. Invent no other people ([dataset strategy](dataset-strategy.md)).

## 12. Localisation readiness

We write only British English for now (Q6), but we write so that translation is possible later.

- Never build a sentence from fragments. Keep whole sentences inside a condition.
- Put names that may differ by language in keys, so a translation can reuse the app's own strings.
- Mark names and code that must not be translated with `translate="no"`.
- Avoid idioms and culture-specific examples.
- No text inside images, and no translatable text trapped in SVG.
- Write dates and numbers unambiguously.
- Reading-level measures differ by language. Each edition sets its own in the style guide.

## 13. Templates and linting

WP3 delivered (DEC-070 to DEC-079):

- **Templates** in [`content/templates/`](../content/templates/README.md) for every topic type, the Quick Start page, an idiom variant, the key concept set, the clickable diagram and the platform key maps. They are in no map, and the lint and Vale check them like topics.
- **The [style guide](style-guide.md), the [terminology list](terminology.md) and the [metadata vocabulary](metadata-vocabulary.md).**
- **Prose lint** with Vale (`.vale.ini`, `build/vale/styles/uFTi/`): reading level, British spelling, and the words the standards rule out or advise against.
- **Structure lint** (`build/scripts/lint.ps1`).
- **A test for every machine-checked rule** (`build/scripts/test-source-rules.ps1`): a small publication or a few sentences that break the rule, which must fail. It also builds every template with the toolkit, which validates it against the DITA 1.3 DTD. CI runs it in the `lint` job.

The checks run locally with `pwsh build/scripts/check-source.ps1` and in CI ([build and quality](build-and-quality.md)).

### 13.1 Which rules are checked, and by what

"Before" means the check existed when WP1 delivered the toolchain. "WP3" means this work package added it, with a failing test. "Review" means a person checks it and no machine can.

| Standard | Rule | Checked by |
|---|---|---|
| 1 | DITA 1.3 DTD; the toolkit validates every file | Build (before); lint also fails a DOCTYPE that is not the standard one for the root (WP3) |
| 1 | Topic types limited to the five; no specialisation | Lint (before); the DOCTYPE check (WP3) |
| 1 | UTF-8 with an XML declaration | Lint (WP3) |
| 1 | `xml:lang="en-GB"` on every topic | Lint (before) |
| 1 | `xml:lang="en-GB"` on every map | Lint rejects a wrong value (before) and a missing one (WP3) |
| 1 | `id` matches the file name | Lint (before) |
| 1 | `outputclass` only `search-ignore`, `search-demote`, `landscape` | Lint (WP3) |
| 1 | No `mapref` by key, no key that names a map, no `chunk="to-content"` | Lint (before) |
| 1 | No GEDCOM tags; no price, accounts or "free" | Vale `GedcomTags`, `BusinessModel` (before) |
| 1 | No workflow in the source | Lint rejects `@rev` (before) and `@status`, `draft-comment`, `required-cleanup` (WP3) |
| 1 | No Markdown topics, no Lightweight DITA | Review |
| 2 | No positional references | Vale `Positional` (before) |
| 2 | No numbers in titles | Lint (WP3) |
| 2 | Links by key | Lint (before) |
| 2 | Size: a task of nine steps or fewer, a concept of 500 words or fewer | Lint (WP3) |
| 2 | Every topic has a title, a short description, `xml:lang` and metadata | Lint (before) |
| 2 | Standalone; one purpose; prerequisites; reuse; minimalism | Review |
| 3 | File and folder names lower case with hyphens | Lint (before) |
| 3 | Topic keys are the file name; glossary keys `term-`; picture keys `img-`; label keys `ui-`; product keys `product-` | Lint (WP3) |
| 3 | Screenshots in `platforms/<manual>/images/`, diagrams in `images/` or `diagrams/` | Lint (WP3) |
| 3 | A manual's root bookmap is named for its slug | Lint (before) |
| 3 | Names never change after publication; verb-first task names; folders at most two levels deep | Review |
| 4 | Title 70 characters or fewer, no full stop | Lint (before) |
| 4 | Titles unique within a publication | Lint (WP3) |
| 4 | Short description present and 30 words or fewer | Lint (before) |
| 4 | Short description is one sentence, does not begin "This topic", does not repeat the title | Lint (WP3) |
| 4 | Sentence case; imperative task titles | Review |
| 5 | A task has steps; each `cmd` is 25 words or fewer; no table in a step | Lint (WP3) |
| 5 | A reference table has a title and a header row | Lint (WP3) |
| 5 | A troubleshooting topic has a condition, a cause and a remedy; a glossary entry has a definition | Lint (WP3) |
| 5 | A Quick Start ("Get started") page is under 150 words | Lint (WP3) |
| 5 | Good practice concepts use the fixed section titles | Lint (WP3) |
| 6 | Labels by key, never typed (DEC-090) | Lint, in real content (WP3) |
| 6 | Product name written uFTi | Vale `ProductName` (WP3) |
| 6 | The other inline markup rules | Review |
| 7 | Alternative text on every image, not starting "Image of" | Lint (before) |
| 7 | Pictures by key, every picture in a `fig` | Lint (WP3) |
| 7 | A diagram has a title, a description and real text, and no script or `aria-labelledby` | Lint (before) |
| 7 | A diagram's links reach topics; its colours are the theme's tokens; every link is listed again as text | Links: lint (before). Colours and list: lint (WP3) |
| 7 | A table has a title and a header row | Lint (WP3) |
| 7 | No video or audio, no object | Lint (WP3) |
| 7 | Screenshot capture rules | Importer (before) and review |
| 8 | External links `scope="external" format="html"` | Lint (before) |
| 8 | Link text means something out of context | Lint (WP3) |
| 8 | Relationship tables; content references; no links between publications | Review |
| 9 | `category` from the list; keywords not the title's own words | Lint (before) |
| 9 | `audience`, `critdates` valid; `resourceid` shape, unique, and present on a task that names controls | Lint (WP3) |
| 9 | `resourceid` appname is `ufti`; a topic's metadata names nobody | Lint (before) |
| 9 | A bookmap names its publisher and copyright owner; a map names nobody | Lint (WP3) |
| 10 | Control named, not its colour | Vale `ColourCues` (WP3) |
| 10 | Control named, not its place | Vale `PositionCues`, a warning (WP3) |
| 10 | Headings, keyboard instructions, accessibility statement | Review |
| 10 | PDF/UA, page accessibility | Output checks (before) |
| 11 | Reading ease, grade, average and longest sentence | Vale (before); `ReadingEase` and `GradeLevel` restate the two Flesch rules with true messages (WP3) |
| 11 | Words to avoid; neutral verbs; British spelling | Vale `Avoid`, `NeutralVerbs`, `Spelling` (before) |
| 11 | Dates the GOV.UK way | Vale `Dates` (WP3) |
| 11 | Plain words; one term for one idea | Vale `PlainWords`, `Terminology`, warnings (WP3); the terminology list's coverage of every label key, by lint (WP3) |
| 11 | Inclusive language; tone | Review |
| 12 | Localisation readiness | Review |

Rules that only a person can check are in the [style guide's checklist](style-guide.md#11-checklist-for-the-plain-language-reviewer) and the [definition of done](authoring-plan.md#73-definition-of-done).
