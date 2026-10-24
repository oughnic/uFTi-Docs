# Terminology list

The plain word for each label the app prints and each term the documentation uses. One word for one idea, everywhere.

Part of the [authoring plan](authoring-plan.md). Status: Draft 0.4, 18 October 2026. Written for WP3 ([issue 9](https://github.com/oughnic/uFTi-Docs/issues/9)). Decisions: DEC-072 and the [style guide](style-guide.md). Nothing here is final until the decision is marked *Accepted*.

## 1. How to use this list

- **A label is printed exactly as the app prints it,** even where it is jargon (DEC-090). It always comes from a key (`<uicontrol keyref="ui-..."/>`), never typed in a topic. If the app changes a label, the key changes and nothing else does.
- **Around a label, use the plain word.** The label *Family* opens the tree, so a topic says "the family tree" in its own words and explains the label once.
- **A hard word is explained once,** in plain words, in the topic that uses it, and has a glossary entry (DEC-029). Link the first use with `<term keyref="term-..."/>`.
- **Never a file tag, structure or line of a file** (DEC-030). The plain word for a GEDCOM file is *family tree file*.
- **The lint keeps this list whole.** `lint.ps1` fails if a `ui-` key in the key maps is missing from section 2. Add the row in the same change that adds the key. Keys are written in `code` so the lint can find them.
- **Vale nudges the plain word** (rules `uFTi.Terminology` and `uFTi.PlainWords`, as warnings). The words they replace are in section 4.

The *Change* column marks what has been asked of the app team:

| Mark | Meaning |
|---|---|
| **Asked** | The decision log records that the app team has been asked to change it. |
| **Proposed** | We suggest a plainer label. It has not been asked yet; it waits for the maintainer (Q33). |
| none | No change is wanted. |

The decision log records that "a label change has been asked of the app team" (DEC-090) without naming each label. Only what it names is marked **Asked** here. Q32 asks the maintainer to confirm the rest.

## 2. Words on screen

Read from the Windows app (version 0.1.0.1) and the Android phone app (version 0.1.0) on 17 October 2026. A label is shared when both show it ([`content/keys/ui-labels.ditamap`](../content/keys/ui-labels.ditamap)). A label only one device shows is marked with the device.

### 2.1 Screens, tabs and menu items

| Key | Label as printed | What we say around it | Change |
|---|---|---|---|
| `ui-workspaces` | Workspaces | The screen that lists your family trees, one card for each. | none |
| `ui-person` | Person | The page of the person you are looking at. | none |
| `ui-family` | Family | The family tree of the person you are looking at. The screen it opens is titled *Pedigree*. The Windows Alpha-1 build prints *Family tree* instead (`ui-family-tree`). | **Proposed**: *Family tree* (Q33) |
| `ui-facts` | Facts | The list of facts about that person. See *fact*. The Windows Alpha-1 build prints *Events* instead (`ui-events`). | none |
| `ui-notes` | Notes | The notes you have written. | none |
| `ui-pedigree` | Pedigree | The title of the screen that draws the tree. Explain it once, by its glossary entry *pedigree*. | **Proposed**: *Family tree* (Q33) |
| `ui-more` | More | The fifth tab on the Android phone. It lists *Notes* and other places. | none |
| `ui-sources` | Sources | The screen that lists the sources of one fact. | none |

### 2.2 Buttons and bars

| Key | Label as printed | What we say around it | Change |
|---|---|---|---|
| `ui-add` | + | The plus button. Say where it is only if the name alone would not find it. | none |
| `ui-search` | Search | The search box and its button. Type a few letters of a name, then choose *Search*. | none |
| `ui-add-button` | Add | The button that opens the form chosen on the sheet. | none |
| `ui-create-workspace` | Create workspace | The button that starts a new family tree. | none |
| `ui-add-from-file` | Add from file… | The button that brings in a family tree file. | none |
| `ui-create` | Create | The button that finishes making a new workspace. | none |
| `ui-save-as` | Save as… | The button on a workspace's card that keeps a copy of the family tree. | none |
| `ui-save` | Save | The button that keeps what you typed. | none |
| `ui-add-source` | Add source | The button that starts adding a source to a fact. | none |
| `ui-save-source` | Save source | The button that keeps a new source. | none |
| `ui-done` | Done | The button that closes a screen. | none |

### 2.3 Sheets, boxes and forms

| Key | Label as printed | What we say around it | Change |
|---|---|---|---|
| `ui-add-a-record` | Add a record | The title of the sheet that **+** opens. Say "something new", not "a record", in our own words. | **Proposed**: *Add something new* (Q33) |
| `ui-add-a-new-person` | Add a new person | The heading on that sheet for adding a person. | none |
| `ui-basic-details` | Basic details | The choice that opens a short form for a person. | none |
| `ui-new-workspace` | New workspace | The title of the small box where you name a new family tree. | none |
| `ui-new-person` | New person | The title of the form for a person on Windows only. | none |
| `ui-save-workspace-as` | Save workspace as | The title of the box that asks which kind of file to make. | none |
| `ui-add-a-new-source` | Add a new source | The choice for a source you have not used before. | none |

### 2.4 Boxes you type in, and facts

| Key | Label as printed | What we say around it | Change |
|---|---|---|---|
| `ui-given-names` | Given name(s) | The first name, and any middle names. | none |
| `ui-surname` | Surname | The last name, or family name. | none |
| `ui-sex` | Sex | Print the label. Do not explain it or guess what it holds. | none |
| `ui-birth` | Birth | The fact for when and where a person was born. | none |
| `ui-title` | Title | The box for the name of a source, such as the name of a certificate or a book. | none |

### 2.5 The two kinds of file

These two labels are jargon, and they appear only once, on the page about keeping a copy, only as labels (DEC-090). The page itself says "family tree file".

| Key | Label as printed | What we say around it | Change |
|---|---|---|---|
| `ui-gedcom-file` | GEDCOM file (.ged) | A family tree file. It holds the people, families and facts. | **Proposed**: *Family tree file (.ged)* (Q33) |
| `ui-gedzip-archive` | GEDZIP archive (.gdz) — includes media | A family tree file with the pictures and other files in the same package. | **Proposed**: *Family tree file with pictures (.gdz)* (Q33) |

### 2.6 Words on screen that are not a key

These are not labels in a key map. The pages do not repeat them.

| What is on screen | What the documentation does | Change |
|---|---|---|
| A workspace's name printed with hyphens | Fixed in the next Alpha build: the summary after a file opens is titled as its card is (DEC-125). The page no longer mentions it. | **Fixed** |
| *Entered via* and a version number on a person's page | Pictures show the app as it is (DEC-091). | **Asked** |
| The *Citation reference* box on the source form | Pages tell the reader to fill in *Title* only, because the box does not keep what is typed (DEC-090). | **Asked** (a fix, not a new word) |
| File paths printed on cards | Pictures are cropped so no path shows (DEC-091, DEC-096). | **Asked** (DEC-097) |
| The button that fills a form from a document | Not used. It is an AI feature, which is out of scope (DEC-020, DEC-096). | **Asked** (DEC-097): a plain label |
| The line the app shows after a file opens on a phone or tablet, and the summary it shows of what came in | Not quoted, because the wording has not been walked. The pages say only that the app says so in one line (DEC-102). | none |

### 2.7 Windows Alpha-1 additions

Read from the Windows app (version 0.1.0.1, Alpha-1 build) on 24 October 2026 ([`content/platforms/windows/keys/ui-labels.ditamap`](../content/platforms/windows/keys/ui-labels.ditamap)). In this build the menu names *Family tree* and *Events* where the first build printed *Family* and *Facts*; the keys `ui-family` and `ui-facts` stay for the Android phone. A label only the Windows app shows.

| Key | Label as printed | What we say around it | Change |
|---|---|---|---|
| `ui-family-tree` | Family tree | The menu item and screen that draw one person's family. | none |
| `ui-events` | Events | The menu item and screen that list what happened in one person's life. | none |
| `ui-where-records-are-kept` | Where records are kept | The menu item and page for archives, libraries and websites. | none |
| `ui-who-made-this-tree` | Who made this tree | The menu item and page for the people credited with the tree. | none |
| `ui-research-questions-and-notes` | Research questions and notes | The menu item and page for your list of questions and ideas. | none |
| `ui-preferences` | Preferences | The menu item and page for the colours and the light or dark look. | none |
| `ui-about-ufti` | About uFTi | The menu item for the page about the app. | none |
| `ui-more-forms` | More forms | The button at the end of the Add a record list that shows the forms that do not fit the person. The app adds a count in brackets, such as *More forms (10)*. | none |
| `ui-showing` | Showing | The start of the chip at the top that names the person the pages show. The chip clears when the tree that person came from is removed. | none |
| `ui-show-details` | Show details | The link on a workspace card that shows its file. | none |
| `ui-remove` | Remove | The button on a card, or in a box, that takes a tree off the list, or a source off a fact. | none |
| `ui-cancel` | Cancel | The button that leaves a box or a form without a change. | none |
| `ui-ok` | OK | The button that closes a summary. | none |
| `ui-active` | Active | The mark on the card of the open tree. | none |
| `ui-remove-workspace` | Remove workspace | The title of the box that asks you to check before a tree leaves the list. | none |
| `ui-which-version-of-gedcom` | Which version of GEDCOM? | The title of the box that asks which version of the file to make. | none |
| `ui-gedcom-7` | GEDCOM 7 (recommended) | The newer version of the file. | none |
| `ui-gedcom-551` | GEDCOM 5.5.1 (for older programs) | The older version of the file. | none |
| `ui-refine-by` | Refine by | The title of the list of filters under the search box. | none |
| `ui-dates` | Dates | A filter for search results. | none |
| `ui-place` | Place | A filter for search results. | none |
| `ui-event-type` | Event type | A filter for search results. | none |
| `ui-sound-alike` | Approximate (sound-alike) matches | A filter that also finds names that sound alike. | none |
| `ui-clear-filters` | Clear filters | The link that removes the filters. | none |
| `ui-edit` | Edit | The button that turns a page into a form. | none |
| `ui-delete-person` | Delete person | The button that removes a person. | none |
| `ui-photos` | Photos | The part of a page that holds the picture buttons. | none |
| `ui-add-a-new-family` | Add a new family | The button on a person who is not yet in a family. | none |
| `ui-add-event` | Add event | The button under a list of events. | none |
| `ui-all-events` | All events | The link that goes back from one event to the list. | none |
| `ui-delete-event` | Delete event | The button that removes an event. | none |
| `ui-note` | Note | The choice for adding a note, and the box for it. | none |
| `ui-first-partner` | Husband / partner 1 | The first partner on the family form. | none |
| `ui-second-partner` | Wife / partner 2 | The second partner on the family form. | none |
| `ui-marriage-date` | Marriage date | The box for when the partners married. | none |
| `ui-place-of-marriage` | Place of marriage | The box for where the partners married. | none |
| `ui-children` | Children | The part of the family form that lists the children. | none |
| `ui-add-row` | Add row | The button that adds a line for one child. | none |
| `ui-set` | Set… | The button in a child's row that opens a small window. | none |
| `ui-view-family-tree` | View family tree | The button on a family's page that draws the tree. | none |
| `ui-delete-family` | Delete family | The button that removes a family. | none |
| `ui-return-to-focus` | Return to focus | The button that goes back to the first person in the tree. | none |
| `ui-fit-to-screen` | Fit to screen | The button that shrinks the tree to fit the window. | none |
| `ui-compare-records` | Compare records that disagree | The button for two records that give different answers. | none |
| `ui-theme` | Theme | The group of three colour sets. | none |
| `ui-oxford-and-slate` | Oxford and slate | The colour set used in this manual's pictures. | none |
| `ui-appearance` | Appearance | The group that sets a light look, a dark look or the Windows setting. | none |
| `ui-follow-the-system` | Follow the system | The choice that copies the Windows setting. | none |
| `ui-light` | Light | The choice for a light look. | none |
| `ui-dark` | Dark | The choice for a dark look. | none |

## 3. Domain terms

The words the documentation uses for the ideas behind the app. A term in bold needs a glossary entry before a topic uses it. The seven entries that exist are in [`content/glossary/`](../content/glossary/).

| Say | It means | Glossary entry | Do not say |
|---|---|---|---|
| **workspace** | One family tree, with all of its people, facts and sources. You can have more than one. | `workspace` | database, project, file |
| family tree | The tree of people and families that a workspace holds. Draw it with *Family*. | none (everyday words) | genealogy, ancestry chart |
| person | Someone in your tree. | none | individual, record |
| family | A group of people joined together in the tree, such as a couple. | none | household, unit |
| **fact** | Something you record about a person, such as a birth with its date. The menu says *Facts*. | `fact` | event, attribute, field |
| **source** | Where you found a fact: a certificate, a census page, or what someone told you. | `source` | citation, reference, evidence |
| **pedigree** | The name the screen gives to the tree it draws. | `pedigree` | pedigree chart |
| **family tree file** | A file that holds a whole family tree. Use it for a GEDCOM file. | `family-tree-file` | GEDCOM file, tree file, export file |
| **saved copy** | A family tree file you make with *Save as…*. It stays as it was when you made it. | `saved-copy` | export, archive (unless the label says so). Not *backup*: that is the file the app makes for itself |
| **backup** | An older copy of a family tree file that the app makes for itself, the first time it saves after you start it. The word is in the file's name, so the page uses it (DEC-103). | `backup` | saved copy (that is the one you make), export |
| **citation** | The exact place in a source where a fact is found, such as a page. Use it only when the app or a good practice topic needs it. | needed (WP9) | reference |
| **repository** | Where a source is kept: an archive, a library or a website. | needed (WP9) | archive (as a label) |
| **submitter** | The person who made the tree. | needed (WP9) | creator, author |
| **event** | The name some screens give a fact. To be confirmed against the screens (WP4). | needed (WP4) | |
| **original source**, **derivative source** | A record in its first form, such as a certificate, and a copy of it, such as a transcript or an index. | needed (WP9) | primary source, secondary source (those are about information) |
| **primary information**, **secondary information** | What someone who was there told at the time, and what was told by someone who was not, or later. | needed (WP9) | first-hand, second-hand |
| living person | Someone who may still be alive. Treated with care (privacy). | needed (WP9) | |
| dataset | Our word for the worked example, the Brontë family. Readers see "the Brontë family". | none | sample data |

## 4. Plain words for plain words

The Vale rule `uFTi.PlainWords` warns on the words in the left column, and `uFTi.Terminology` on the app terms. They are advice. A plain word is not always the right one.

| Say | Not |
|---|---|
| app | application, program, software |
| choose, select, enter, open | click, tap, press (unless the text is for one device only) |
| use | utilise, utilize |
| start | commence |
| end | terminate |
| before | prior to |
| to | in order to |
| make sure | ensure |
| about | approximately, regarding |
| some | a number of |
| if | in the event that |
| then | subsequently |
| help | assist |
| find | locate |
| many | numerous |
| buy | purchase |
| try | attempt |
| enough | sufficient |
| get | obtain |
| show | indicate |
| change | modify |
| so | therefore |
| family history | genealogy, genealogical |

## 5. Names of things on screen

| Say | For |
|---|---|
| screen | Everything the app shows at once. |
| page | A person's page, as the app calls it, and a page of this guide. |
| button | Something you choose to do an action. |
| box | A small window, or a place to type. Say "the box named Title" so the reader knows which. |
| card | One workspace, person or result in a list. |
| tab | One of the places along the bottom of the Android phone. |
| menu item | One of the places in the side menu on Windows. |
| sheet | The panel that rises over a screen, such as the one **+** opens. |
| chip | The small counter beside a heading. Call it "the small chip" until the app names it. |

Say "the **Save** button", not "the Save field". Say "Type a name in **Title**", not "Fill in the Title field".
