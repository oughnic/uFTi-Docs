# Authoring standards

How DITA is written in this repository. This is the short version. WP3 expands it into a full style guide, terminology list and templates.

Part of the [authoring plan](authoring-plan.md). Status: Draft 0.3, 16 October 2026. Decisions are tracked in the [decision log](decision-log.md).

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
- **Diagrams** are SVG with a `title` and a `desc`, and no text that cannot be translated.
- **Alternative text is mandatory** on every image. For screenshots it is the key's `linktext`. Describe the purpose, not the appearance. Never start "Image of" or "Screenshot of". The PDF generator warns (`DSPDF009W`) when it is missing, and the PDF then fails PDF/UA.
- **No decorative images.** If an image needs no description, it does not belong.
- **No text in images,** no information only in a picture, and no cues that rely on colour alone.
- **Figures** use `fig` with a `title`. The caption must not repeat the alternative text.
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

Metadata goes in the topic's `prolog`. The DTD fixes the order of elements. Pattern:

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
| `resourceid` | Optional stable feature identifier, such as `people.edit`, for traceability. Never an issue number. |
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

The base is the [GOV.UK style guide](https://www.gov.uk/guidance/style-guide) and content design principles, with project overrides recorded in the WP3 style guide (DEC-010).

- **British English** (en-GB).
- **Voice.** Second person ("you"), active, present tense. Steps use the imperative.
- **Sentences.** Short, one idea each.
- **Neutral verbs.** "Select", "open", "enter" and "choose" work for touch and pointer. Avoid "click", "tap" and "press" except in platform-specific text.
- **Avoid** "simply", "just", "easy", "obviously", "please", "via", "e.g.", "i.e." and "etc.".
- **Dates and numbers** follow the GOV.UK style guide, for example 1 January 2026.
- **Capitalisation.** Sentence case in headings. UI labels exactly as on screen. The product name is always written **uFTi**, including at the start of a sentence.
- **Terminology.** One term for one concept. The WP3 terminology list fixes terms such as "workspace". Research terms are defined in the glossary.
- **Inclusive language.** Do not assume how many parents a person has, or their gender, partner or family shape. Never blame the reader.
- **The worked example.** Use the people and places of the Brontë dataset consistently, spelt as the dataset spells them: Brontë with the diaeresis in text, and `bronte` in file names and keys. Invent no other people ([dataset strategy](dataset-strategy.md)).

## 12. Localisation readiness

We write only British English for now (Q6), but we write so that translation is possible later.

- Never build a sentence from fragments. Keep whole sentences inside a condition.
- Put names that may differ by language in keys, so a translation can reuse the app's own strings.
- Mark names and code that must not be translated with `translate="no"`.
- Avoid idioms and culture-specific examples.
- No text inside images, and no translatable text trapped in SVG.
- Write dates and numbers unambiguously.

## 13. Templates and linting

WP3 delivers:

- **Templates** for concept, task, reference, troubleshooting, glossary entry, chapter introduction, good practice concept and platform key map.
- **Prose lint** with Vale, using a project style based on the rules above, and British English spelling.
- **Structure lint** that checks: file name pattern, `id` matches file name, title and short description present, short description length, `category` from the list, alternative text present, `@platform` values in the catalogue, the variant budget, key resolution, no `mapref` by key, no `chunk="to-content"`, no positional words, good practice section titles, and the "not allowed" disclosure patterns.

The checks run locally and in CI ([build and quality](build-and-quality.md)).
