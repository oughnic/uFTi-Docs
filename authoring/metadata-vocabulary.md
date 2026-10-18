# Metadata vocabulary

The values that go into a topic's and a map's metadata, and the help identifier that links a screen in the app to its page.

Part of the [authoring plan](authoring-plan.md). Status: Draft 0.4, 18 October 2026. Written for WP3 ([issue 9](https://github.com/oughnic/uFTi-Docs/issues/9)). Decision: DEC-075 in the [decision log](decision-log.md). It expands [authoring standards, section 9](authoring-standards.md#9-metadata).

Metadata is published: the site reads it for search filters, page tags, link previews and the help map. So it is short, true and never internal.

## 1. A topic's metadata

Metadata goes in the topic's `prolog`. The DTD fixes the order of the elements. Copy it from a [template](../content/templates/README.md).

```xml
<prolog>
  <critdates>
    <created date="2026-10-17"/>
    <revised modified="2026-10-18"/>
  </critdates>
  <metadata>
    <audience type="user" experiencelevel="novice"/>
    <category>How-to</category>
    <keywords>
      <keyword>new person</keyword>
    </keywords>
  </metadata>
  <resourceid appname="ufti" appid="people.edit"/>
</prolog>
```

| Element | Required | Rule | Checked by |
|---|---|---|---|
| `category` | Every topic except a glossary entry | One value from section 2. | lint |
| `audience` | No | `type="user"`, and `experiencelevel` of `novice`, `general` or `expert`. Add it only where it helps a reader choose. It becomes a search filter. | lint |
| `keywords` | No | Real aliases only (section 3). | lint, in part |
| `critdates` | No | `created` and `revised`, only when true (section 4). | lint |
| `resourceid` | On a task that names controls on a screen | The screen's help identifier (section 5). | lint |
| `data` | No | A name with a prefix from a published vocabulary (Dublin Core, DCAT, ADMS, SKOS and the like) is read as metadata. Our own names have no prefix and are not metadata. | the build (`GOVK011W`) |

Never in a topic's metadata: a person's name, `author`, an email address, an issue or pull request number, a review status, a local path. The lint fails on an `author`. Workflow lives in issues and pull requests (standards, section 1).

## 2. Category

A `category` is a kind of page for the reader: it drives search filters and page tags. It is **not** the DITA topic type. One value, exactly as written, from this list.

| Category | A page that | Usually a |
|---|---|---|
| **Get started** | Is on the Quick Start route, or helps a first-time reader succeed in minutes. Under 150 words (lint). | `task` or a short `concept` |
| **How-to** | Helps the reader do one thing. | `task` |
| **Concept** | Explains an idea. | `concept` |
| **Reference** | Is for looking something up, or is a checklist. | `reference` |
| **Troubleshooting** | Helps the reader out of a problem they have met. | `troubleshooting` |
| **Good practice** | Teaches a research habit. Section titles are fixed (lint; [good practice strategy, section 8](good-practice-strategy.md#8-writing-and-review-rules)). | `concept`, `task` or `reference` |
| **Glossary** | Defines a term. Glossary entries carry no metadata, so the value is not written. | `glossentry` |

A new category needs a decision, a change to the list in `lint.ps1`, and a test.

## 3. Keywords

A keyword is an alias a reader might type that the topic's own words do not give. The plugin writes keywords into the page for search and drops a keyword that only repeats a word of the title.

- **Do:** other names ("citation" for a topic titled "Say where you found it"), abbreviations, older names, what a reader would type if they did not know our word ("family tree file" for a topic that mentions GEDCOM).
- **Do not:** repeat a word of the title (the lint fails a one-word keyword that does), list every word of the topic, or add a keyword to be found for something the topic is not about.
- **Plain words.** A keyword is a word a reader uses, not a label or a tag from a file. Never a GEDCOM tag (DEC-030).
- Few. Two to four is plenty.

## 4. Dates

- `created` is the day the topic was first written. `revised` is the day of the last change that matters to a reader.
- **Only when true.** Set them by hand on a substantive change. Never batch-stamp a folder. Do not give a date in both a map's `bookmeta` and its topics.
- Written `YYYY-MM-DD`. The lint fails a date that is not real, a date in the future, and a `revised` earlier than `created`.
- The site shows no dates until a reliable process exists (Q13). The dates are kept so that the process can be built from them.

## 5. The help identifier

The help identifier links a screen in the app to the page that explains it (DEC-028). The app opens the page whose `resourceid` matches the screen. The build gathers the identifiers into a help map for each device and language (WP7b). So every topic that explains a screen carries one.

```xml
<resourceid appname="ufti" appid="citations.edit"/>
```

### 5.1 The rules

- **`appname` is always `ufti`.**
- **`appid` is `area.screen`,** in lower case, with letters, digits and hyphens. The area is the part of the app (`people`, `sources`). The screen is the one thing the reader is doing there (`edit`, `view`, `list`). A screen with no variants may be an area alone (`search`, `settings`). The lint fails an identifier that does not match this shape.
- **Taken from the [help-target list](journeys/help-targets.md).** Those identifiers are proposals until the app team gives each screen its own (Q22). When it does, the topic changes to match and nothing else does.
- **One identifier names one topic in a manual.** The lint fails an identifier claimed by two topics included in the same manual. Where two idioms have a topic each for one screen (DEC-093), both carry the identifier: a manual sees only one of them.
- **Which topics carry one.** A task that tells the reader to choose controls on a screen explains that screen, so it must have one: the lint fails a task that uses `uicontrol` or `wintitle` with none. A concept or a reference may have one when it explains a screen, but need not. A Quick Start page carries the identifier of the screen it is about, and gives it up to the full topic for that screen when that is written (DEC-083).
- **More than one.** A task that spans two screens may carry two `resourceid` elements, as "Add your first person" does (`workspaces.create` and `people.edit`). Prefer one topic for one screen.
- **Never an issue number,** a version, a platform or a device name. The identifier is the same on every device; the manual a reader is in decides which topic opens.
- **Coverage.** Every screen in the screen catalogue (WP4) has a topic with its identifier. `lint.ps1` checks this against a `screens.csv` when a source has one (the throwaway fixture does).

### 5.2 Areas in use

| Area | What it covers | Examples |
|---|---|---|
| `workspaces` | The list of family trees, making one, saving and bringing one in | `workspaces.list`, `workspaces.create`, `workspaces.export` |
| `people` | People | `people.list`, `people.view`, `people.edit` |
| `families` | Families | `families.view`, `families.edit` |
| `tree` | The tree | `tree.view` |
| `search` | Finding a person | `search` |
| `events` | Facts with dates | `events.edit`, `events.date` |
| `places` | Places | `places.edit` |
| `sources` | Sources | `sources.list`, `sources.edit` |
| `citations` | Saying where a fact came from | `citations.edit` |
| `repositories` | Where sources are kept | `repositories.edit` |
| `evidence` | Weighing evidence that disagrees | `evidence.reconcile` |
| `notes`, `research` | Notes and research notes | `notes.edit`, `research.edit` |
| `media` | Pictures and other files | `media.list`, `media.add` |
| `forms` | Forms for records such as a census household | `forms.census` |
| `checks`, `duplicates` | Checking a tree and finding duplicates | `checks.results`, `duplicates.list` |
| `settings` | Language, appearance and text size | `settings` |

A new area needs a row here, in the help-target list, and a word to the app team.

## 6. A map's metadata

Publication-wide facts go in a bookmap's `bookmeta`, or in `topicmeta` for a plain map.

| What | Where | Rule |
|---|---|---|
| Publisher | `bookmeta/publisherinformation/organization` | The organisation. The lint fails a bookmap without it. |
| Copyright | `bookmeta/bookrights` | `copyrfirst/year` and `bookowner/organization`. The lint fails a bookmap without an owner. |
| Language | `xml:lang="en-GB"` on the root | The lint fails a map without it. |
| Dates | `bookmeta/critdates` | Only when true; never also on the topics. |
| Product, version, platform | `topicmeta/prodinfo` on a platform key map | The picture importer writes the version and the reference device. |
| Reference device and dataset | `topicmeta/data` with `name="reference-device"` and `name="dataset"` | As the existing key maps do. |

The licence, the site address and the organisation's URL are **build parameters**, not source. Never a person's name in a map: the lint fails `authorinformation` and `personname`.

## 7. Keys are metadata too

Keys decide how one word or picture is reused, so they follow a vocabulary of their own. The lint checks each of these.

| Key for | Starts with | Example |
|---|---|---|
| A topic | The file name, without `.dita` | `say-where-you-found-it` |
| A glossary entry | `term-` and the file name | `term-workspace` |
| A picture | `img-` | `img-citation-add` |
| A label the app prints | `ui-` | `ui-save` |
| A product fact | `product-` | `product-name` |

Every `ui-` key must be in the [terminology list](terminology.md). A diagram's file is not a key: a topic shows it with `svgref`.

## 8. What the lint says

| If you see | It means |
|---|---|
| `no category in prolog/metadata` | Add one of the values in section 2. |
| `category 'x' is not in the controlled list` | Use a value in section 2 exactly. |
| `keyword 'x' only repeats a word of the title` | Remove it or give a real alias. |
| `audience experiencelevel 'x' is not one of ...` | Use `novice`, `general` or `expert`. |
| `critdates created 'x' is not a date written YYYY-MM-DD` | Write the date as `2026-10-18`. |
| `critdates ... is in the future` / `is before created` | Fix the date. |
| `help identifier 'x' is not area.screen ...` | Use lower case, with letters, digits and hyphens, in the shape of section 5.1. |
| `a task that names controls on a screen has no resourceid help identifier` | Add the identifier from the help-target list. |
| `help identifier 'x' is also claimed by ...` | One identifier, one topic in a manual. |
| `a person or author in metadata` | Remove it: metadata names nobody. |
