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
| A workspace's name printed with hyphens | Fixed in the next Alpha build: the summary after a file opens is titled as its card is (DEC-131). The page no longer mentions it. | **Fixed** |
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
| `ui-link-existing-media` | Link existing media | The list of the tree's pictures that the chain button under Photos opens (iPhone). | none |
| `ui-close` | Close | The button that closes a sheet, such as the list of the tree's pictures (iPhone). | none |
| `ui-allow` | Allow | The iPhone's own answer when it asks if an app may use the camera. | none |
| `ui-theme` | Theme | The group of three colour sets. | none |
| `ui-oxford-and-slate` | Oxford and slate | The colour set used in this manual's pictures. | none |
| `ui-appearance` | Appearance | The group that sets a light look, a dark look or the Windows setting. | none |
| `ui-follow-the-system` | Follow the system | The choice that copies the Windows setting. | none |
| `ui-light` | Light | The choice for a light look. | none |
| `ui-dark` | Dark | The choice for a dark look. | none |

### 2.8 The date editor

Read from the app's date editor on 3 November 2026, from the words the app prints (shared keys in [`content/keys/ui-labels.ditamap`](../content/keys/ui-labels.ditamap)). **Check each against the Alpha-1 build before the Windows manual is published with them:** the walk of Alpha-1 did not open the date editor. The box where a date can be typed as text also shows an example written in the file format's own short codes. DEC-030 stops us quoting it, and it is a plain-words label to ask of the app team (Q32).

| Key | Label as printed | What we say around it | Change |
|---|---|---|---|
| `ui-how-much-do-you-know` | How much do you know? | The question that sets whether the date is a year, a month and year, or a whole date. | none |
| `ui-the-year` | The year | The choice for a date known only as a year. | none |
| `ui-the-month-and-year` | The month and year | The choice for a date known as a month and a year. | none |
| `ui-the-whole-date` | The whole date | The choice for a date with a day, a month and a year. | none |
| `ui-not-sure-of-the-date` | Not sure of the date? | The choice that shows ways to say how sure you are. | none |
| `ui-kind-of-date` | Kind of date | The list of ways to say how sure you are. | none |
| `ui-date-on` | On | The kind of date for a date you know. | none |
| `ui-date-about` | About | The kind of date for a date that is close, not exact. | none |
| `ui-date-estimated` | Estimated | The kind of date for a date you worked out yourself. | none |
| `ui-date-before` | Before | The kind of date for a limit: it happened on or before. | none |
| `ui-date-after` | After | The kind of date for a limit: it happened on or after. | none |
| `ui-date-between` | Between two dates | The kind of date for an earliest and a latest date. | none |
| `ui-date-period` | From a date to a date | The kind of date for something that lasted a while. | none |
| `ui-edit-as-text` | Edit as text | The choice that lets you type the whole date in one box. | none |
| `ui-calendar` | Calendar | The list of calendars. | none |
| `ui-date-of-birth` | Date of birth | The box for when a person was born, in the Basic details form. | none |
| `ui-date-of-death` | Date of death | The box for when a person died, in the Basic details form. | none |
| `ui-place-of-birth` | Place of birth | The box for where a person was born, in the Basic details form. | none |
| `ui-place-of-death` | Place of death | The box for where a person died, in the Basic details form. | none |
| `ui-place-of-birth-new-child` | Place of birth (new child) | The box for where a new child was born, when you add a family. | none |
| `ui-start-typing-a-place` | Start typing a place… | The hint that an empty place box shows. | none |
| `ui-use` | Use | The button that links the form to a person who is already in the tree. | none |
| `ui-add-a-new-person-called` | Add a new person called | The start of the button that makes a second person with the same name. | none |


Read from the Android phone app on 10 November 2026, in the walk for the Android phone manual ([`content/platforms/android-phone/keys/ui-labels.ditamap`](../content/platforms/android-phone/keys/ui-labels.ditamap)). The keys are the labels the screens print.

| Key | Label as printed | What we say around it | Change |
|---|---|---|---|
| `ui-home` | Home | The first place in the bar. It shows the open tree, a search box and the people you opened last. | none |
| `ui-all-people` | All people | The button on Home that lists everyone in the tree. | none |
| `ui-open-another-workspace` | Open another workspace | The button on Home that shows your trees. | none |
| `ui-add-the-first-person` | Add the first person | The button on Home in a tree that has nobody in it yet. | none |
| `ui-continue-with` | Continue with | The heading over the person you opened last. | none |
| `ui-recent-people` | Recent people | The heading over the people you opened lately. | none |
| `ui-help` | Help | The line in the More list that opens the guide to the screen you are on, in the web browser. | none |
| `ui-help-about-this-screen` | Help about this screen | The question mark at the top of every screen, and the name a screen reader gives it. | none |
| `ui-add-note` | Add note | The button on the Notes screen that writes a new note. | none |
| `ui-use-an-existing-note` | Use an existing note | The button on the Notes screen that links a note you already wrote. | none |
| `ui-other-names` | Other names | The part of a person's form for a married name, a pen name and other names. | none |
| `ui-kind-of-name` | Kind of name | The list of kinds of name, such as Married name or Pen name. | none |
| `ui-married-name` | Married name | The kind of name for a name taken at marriage. | none |
| `ui-pen-name` | Pen name | The kind of name for a name used when writing. | none |
| `ui-delete` | Delete | The button in a box that removes what the box names. | none |
| `ui-discard` | Discard | The button in a box that leaves a form without keeping changes. | none |
| `ui-death` | Death | The fact for when and where a person died. | none |
| `ui-other-event` | Other event | The choice on the Add a record sheet for an event that has no form of its own. | none |
| `ui-type` | Type | The list of kinds of event. | none |
| `ui-baptism` | Baptism | A kind of event. | none |
| `ui-residence` | Residence | A kind of event for where a person lived. | none |
| `ui-occupation` | Occupation | A kind of event for a person's work. | none |
| `ui-event` | Event | The kind of event for one that is not on the list. | none |
| `ui-kind-of-event-in-words` | Kind of event, in words | The box where you type your own word for a kind of event. | none |
| `ui-baptism-record` | Baptism record | The form that matches a baptism or christening record. | none |
| `ui-birth-record` | Birth record | The form that matches a birth certificate. | none |
| `ui-burial-record` | Burial record | The form that matches a burial record. | none |
| `ui-death-record` | Death record | The form that matches a death certificate. | none |
| `ui-marriage-register-entry` | Marriage register entry | The form that matches an entry in a marriage register. | none |
| `ui-family-note` | Family note | The form that adds a note to a family. | none |
| `ui-existing-person` | Existing person | The part of a child's row where you choose someone who is already in the tree. | none |
| `ui-citation` | Citation | The button on the Sources sheet that edits the page and the reliability. | none |
| `ui-copy` | Copy | The button that copies a source or a picture. | none |
| `ui-page-or-reference-number` | Page or reference number | The box for the page, folio or entry in a source. | none |
| `ui-how-reliable-it-is` | How reliable it is | The list that rates how good the evidence is. | none |
| `ui-date-of-the-entry` | Date of the entry | The date written in the entry of a source. | none |
| `ui-more-details` | More details | The button on the new source form that adds the author and the publisher. | none |
| `ui-name` | Name | The box for the name of a repository or of the people who made the tree. | none |
| `ui-repository` | Repository | The choice on the Add a record sheet for an archive, a library or a website. | none |
| `ui-submitter` | Submitter | The choice on the Add a record sheet for the person who made the tree. | none |
| `ui-research-note` | Research note | The choice on the Add a record sheet for a question or a note. | none |
| `ui-status` | Status | The list that says whether a question is open, in progress or resolved. | none |
| `ui-people-it-is-about` | People it is about | The part of a research note where you name the people. | none |
| `ui-take-photo` | Take photo | The button for a new photo with the camera. | none |
| `ui-add-photo` | Add photo | The button for a picture that is already on the device. | none |
| `ui-link-existing-media` | Link existing media | The button for a picture that is already in the tree. | none |
| `ui-export-all-to-a-folder` | Export all to a folder | The button that copies the pictures of a record to a folder. | none |
| `ui-view` | View | The choice that shows a picture. | none |
| `ui-details` | Details | The choice that shows the file name and the description of a picture. | none |
| `ui-export` | Export | The choice that copies one picture to a folder. | none |
| `ui-crop-and-deskew` | Crop & deskew | The title of the screen where you drag the corners of a document. | none |
| `ui-rotate` | Rotate | The button that turns a picture. | none |
| `ui-reset` | Reset | The button that puts a picture back as it was. | none |
| `ui-high-contrast` | High contrast | The theme for readers who need strong outlines and the clearest text. | none |
| `ui-ink-and-parchment` | Ink and parchment | The theme the app starts with. | none |
| `ui-saving-another-programs-file` | Saving another program's file | The part of Preferences for files that another program made. | none |

### 2.9 Android phone Alpha-2 additions

Read from the Android phone app on 10 November 2026, in the walk for the Android phone manual ([`content/platforms/android-phone/keys/ui-labels.ditamap`](../content/platforms/android-phone/keys/ui-labels.ditamap)). The keys are the labels the screens print.

| Key | Label as printed | What we say around it | Change |
|---|---|---|---|
| `ui-more-other-calendars` | More: other calendars | The button that shows the list of other calendars under a date. | none |

### 2.10 Windows Alpha-2 additions

Read from the Windows app (version 0.2.0.989) on 10 November 2026. The labels are in four key files: [`ui-labels-quick-start.ditamap`](../content/platforms/windows/keys/ui-labels-quick-start.ditamap), [`ui-labels-people.ditamap`](../content/platforms/windows/keys/ui-labels-people.ditamap), [`ui-labels-evidence.ditamap`](../content/platforms/windows/keys/ui-labels-evidence.ditamap) and [`ui-labels-workspaces.ditamap`](../content/platforms/windows/keys/ui-labels-workspaces.ditamap). Where a word such as *Name* or *Open* is on more than one screen, the row says which one.

| Key | Label as printed | What we say around it | Change |
|---|---|---|---|
| `ui-add-a-note-to` | Add a note to | The start of the line of choices on a person's page for adding a note. | none |
| `ui-add-a-source-to` | Add a source to | The start of the line of choices for adding a source to a fact. | none |
| `ui-add-an-event-to` | Add an event to | The start of the line of choices for adding an event. | none |
| `ui-add-note` | Add note | The button on a person's notes page that starts a new note. | none |
| `ui-add-person` | Add person | The button on the people list that starts a new person. | none |
| `ui-add-the-first-person` | Add the first person | The button on Home when the tree has nobody in it. | none |
| `ui-add-to-the-workspace` | Add to the workspace | The group in the Add a record sheet for things that are not about one person, such as a family or a research note. | none |
| `ui-address` | Address | The box for where a place that keeps records is, on the Where records are kept form. | none |
| `ui-all-people` | All people | The button under the search box that lists everyone in the tree. | none |
| `ui-attach-source-document` | Attach source document | The first part of the source form. It can be left alone. | none |
| `ui-back-to-the-list` | Back to the list | The button on the step that adds a source, that goes back to the list of sources. | none |
| `ui-baptism-record` | Baptism record | A form in the Add an event list that starts with a register title filled in. | none |
| `ui-birth-years` | Birth years | The line on a tree's card that shows the years people were born. | none |
| `ui-census-1841` | 1841 Census (England & Wales) | A form in the Add an event list for a census record. | none |
| `ui-census-date` | Census date | The box for the date of the census, on the census form. | none |
| `ui-change` | Change… | The link on the census form that picks another person for the household. | none |
| `ui-citation` | Citation | The button on a source's line that changes its page or the words of the entry. | none |
| `ui-completeness` | Completeness | The line on a tree's card that shows a percentage. | none |
| `ui-continue-with` | Continue with | The start of a button on Home that goes back to the person you opened last. | none |
| `ui-copy` | Copy | A button that makes a copy: on a person's page, a family's page, a note in the research log, or a source on a fact. | none |
| `ui-copyright-of-this-tree` | Copyright of this tree | The box on the Submitter form for the copyright words. | none |
| `ui-date` | Date | The box for the date of an event, on the event form. | none |
| `ui-date-of-the-entry` | Date of the entry | The box on the source step for the date of the entry in the source. | none |
| `ui-day` | Day | The box for the day, in a date on a person or family form. | none |
| `ui-death` | Death | The part of a person's page for their death, with a chip that counts its sources. | none |
| `ui-death-years` | Death years | The line on a tree's card that shows the years people died. | none |
| `ui-delete` | Delete | The button on a place that keeps records, or on a research note, that removes it. | none |
| `ui-delete-name` | Delete | The button beside a name on the Who made this tree page that removes it. | none |
| `ui-description` | Description | The box for a few words about an event, on the form for your own kind of event. | none |
| `ui-event-or-fact` | Event or fact | The heading of the page that opens when you choose one event. | none |
| `ui-everything-gdz` | Everything (.gdz, recommended) | The choice on the Save workspace as box that keeps the tree, notes and pictures in one file. | none |
| `ui-existing-person` | Existing person | The choice, and the title of the small window, for a person who is already in the tree. | none |
| `ui-family-tree-only-ged` | Family tree only (.ged) | The choice on the Save workspace as box that makes a family tree file with no pictures. | none |
| `ui-fewer-forms` | Fewer forms | The button at the end of the long Add a record list that hides the extra forms. | none |
| `ui-help` | Help | The button in the top bar that explains the screen you are on. | none |
| `ui-high-contrast` | High contrast | One of the four themes on the Preferences page, with strong outlines. | none |
| `ui-home` | Home | The menu item and page you meet when a tree is open, with the search box and the buttons to start. | none |
| `ui-how-reliable-it-is` | How reliable it is | The list on the source step that says how much weight the source deserves. | none |
| `ui-identity` | Identity | The part of a person's page that holds the names and the sex. | none |
| `ui-ink-and-parchment` | Ink and parchment | One of the four themes on the Preferences page. | none |
| `ui-kind` | Kind | The list in a contact row on a place that keeps records, for what sort of contact it is. | none |
| `ui-kind-of-event-in-words` | Kind of event, in words | The box where you name your own kind of event. | none |
| `ui-male` | Male | A choice in the Sex list on the form for the first person. | none |
| `ui-marriage` | Marriage | The part of a family's page for the marriage. | none |
| `ui-month` | Month | The list for the month, in a date on a person or family form. | none |
| `ui-more-details` | More details | The part of a page that holds the rest, such as the age at an event and its cause. | none |
| `ui-name` | Name | The box for the name of a place that keeps records, on the Where records are kept form. | none |
| `ui-not-stated` | Not stated | The first choice in the How reliable it is list. | none |
| `ui-number-or-address` | Number or address | The box in a contact row on a place that keeps records, for the number, email or website. | none |
| `ui-open` | Open | The button on a tree's card that makes it the open tree, and the button in the file window that opens the file you chose. | none |
| `ui-open-another-workspace` | Open another workspace | The button under the search box that goes to your list of trees. | none |
| `ui-other-event` | Other event | The choice in the Add an event to list for an event that has no form of its own. | none |
| `ui-other-names` | Other names | The part of the form for a person that holds other names. | none |
| `ui-page-or-reference-number` | Page or reference number | The box on the source step for where to look in the source. | none |
| `ui-partners` | Partners | The part of a family's page that names the two partners. | none |
| `ui-people` | People | The title of the page that lists everyone in the tree, one card for each person. | none |
| `ui-people-it-is-about` | People it is about | The part of a research note form that ties the note to people. | none |
| `ui-quality-0` | 0 · Unreliable or estimated | The lowest choice in the How reliable it is list. | none |
| `ui-quality-1` | 1 · Questionable | The second choice in the How reliable it is list. | none |
| `ui-quality-2` | 2 · Secondary evidence | The third choice in the How reliable it is list. | none |
| `ui-quality-3` | 3 · Direct and primary evidence | The highest choice in the How reliable it is list. | none |
| `ui-recent-people` | Recent people | The row on Home with a button for each person you opened lately. | none |
| `ui-register-title` | Register title | The box on the baptism form for the name of the register. | none |
| `ui-repository` | Repository | The choice in the Add to the workspace group for a place that keeps records. | none |
| `ui-research-note` | Research note | The choice in the Add to the workspace group for a question or idea. | none |
| `ui-saving-another-programs-file` | Saving another program's file | The third group on the Preferences page, with two switches. | none |
| `ui-search-existing-sources` | Search existing sources… | The box at the top of the Add source list for finding a source that is already in the tree. | none |
| `ui-sepia-and-slate` | Sepia and slate | One of the four themes on the Preferences page. | none |
| `ui-source` | Source | The choice in the Add a source to line for a new source. | none |
| `ui-status` | Status | The list on a research note form that says where the question stands. | none |
| `ui-status-open` | Open | The choice in the Status list for a question you will look at again. | none |
| `ui-submitter` | Submitter | The choice, and the title of the form, for the person who made the tree. | none |
| `ui-submitter-address` | Address | The box for the address of the person who made the tree, on the Submitter form. | none |
| `ui-submitter-contacts` | Telephone, email and website | The part of the Submitter form for ways to reach that person. | none |
| `ui-submitter-language` | Language | The box for the language of the person who made the tree, on the Submitter form. | none |
| `ui-submitter-name` | Name | The box for the name of the person who made the tree. It is the only box you must fill in. | none |
| `ui-telephone-email-website` | Telephone, email and website | The part of the form for a place that keeps records, for ways to reach it. | none |
| `ui-top-surname` | Top surname | The line on a tree's card that shows the most common last name. | none |
| `ui-type` | Type | The list on an event form for the kind of event. | none |
| `ui-type-baptism` | Baptism | The choice in the Type list for a baptism. | none |
| `ui-type-residence` | Residence | The choice in the Type list for where someone lived, often for a period. | none |
| `ui-use-an-existing-note` | Use an existing note | The button on a person's notes page that picks a note you have already written. | none |
| `ui-version` | Version | The line in the help that says which version of the app you have. | none |
| `ui-where-is-it-kept` | Where is it kept? | A box on an event form for where the record is kept. | none |
| `ui-where-it-is-kept` | Where it is kept | The box on the source step for where the source is kept. | none |
| `ui-words-copied` | The words copied from the record | The box on the source step for the words you copied from the record. | none |
| `ui-year` | Year | The box for the year, in a date on a person or family form. | none |
| `ui-back-to-all-notes` | Back to all notes | The button on the Use an existing note list that goes back to the page of notes. | none |
| `ui-hide-details` | Hide details | What the Show details button on a tree's card reads once the details are showing. | none |
| `ui-search-media-by-description` | Search media by description | The box in the Link existing media window for finding a picture that is already in the tree. | none |
| `ui-search-the-notes` | Search the notes | The box on the Use an existing note list for finding a note. | none |
| `ui-type-fact` | Fact | The last choice in the Type list on an event form, a general word for a kind that has no word of its own. The list has no choice named Event. | none |

### 2.11 iPhone and iPad Alpha-2 additions

Read from the iPhone and iPad apps on 11 November 2026, in the Alpha-2 walk ([`content/platforms/iphone/keys/ui-labels.ditamap`](../content/platforms/iphone/keys/ui-labels.ditamap) and [`content/platforms/ipad/keys/ui-labels.ditamap`](../content/platforms/ipad/keys/ui-labels.ditamap)). The other labels these pages use are the Android phone's, listed above.

| Key | Label as printed | What we say around it | Change |
|---|---|---|---|
| `ui-make-a-gedcom-7-copy` | Make a GEDCOM 7 copy | The choice, for a file another program made, that keeps a copy of its own in GEDCOM 7 and saves changes there. | none |
| `ui-just-look` | Just look | The choice, for a file another program made, that opens it to look at and saves nothing. | none |

## 3. Domain terms

The words the documentation uses for the ideas behind the app. A term in bold needs a glossary entry before a topic uses it. The seven entries that exist are in [`content/glossary/`](../content/glossary/).

| Say | It means | Glossary entry | Do not say |
|---|---|---|---|
| **workspace** | One family tree and everything kept with it: the family tree file with its research notes, and the pictures and other attached files. A GEDZIP file holds all of it. You can have more than one. | `workspace` | database, project, file |
| family tree | The tree of people and families that a workspace holds. Draw it with *Family*. | none (everyday words) | genealogy, ancestry chart |
| person | Someone in your tree. | none | individual, record |
| family | A group of people joined together in the tree, such as a couple. | none | household, unit |
| **fact** | Something you record about a person, such as a birth with its date. The menu says *Facts*. | `fact` | event, attribute, field |
| **source** | Where you found a fact: a certificate, a census page, or what someone told you. | `source` | citation, reference, evidence |
| **pedigree** | The name the screen gives to the tree it draws. | `pedigree` | pedigree chart |
| **family tree file** | A GEDCOM file that holds a whole family tree, with its research notes. It does not hold pictures or other attached files. | `family-tree-file` | tree file, export file |
| **GEDCOM** | The standard file format that family tree files are written in. GEDCOM 5.5.1 was published in 1999; GEDCOM 7 in 2021. When a reader saves a plain family tree file, the app asks which version: GEDCOM 7 (recommended) or GEDCOM 5.5.1 (for older programs). A version is a version of the standard, never of uFTi. | `gedcom` | V7 (as a name for a version of the app) |
| **GEDZIP** | One file that holds a whole workspace: the family tree with its research notes, and the pictures and other attached files. It is the preferred format for saving and sending. | `gedzip` | GDZ (use the label as shown on screen) |
| **saved copy** | A family tree file you make with *Save as…*. It stays as it was when you made it. | `saved-copy` | export, archive (unless the label says so). Not *backup*: that is the file the app makes for itself |
| **backup** | An older copy of a family tree file that the app makes for itself, the first time it saves after you start it. The word is in the file's name, so the page uses it (DEC-103). | `backup` | saved copy (that is the one you make), export |
| **dual year** | A year written with two numbers, such as 1731/32. In Britain, it marks a date from 1 January to 24 March, up to 1751, when the year began on 25 March. It shows the old year and the new one. | `dual-year` | double date, split year (unless a source prints the words) |
| **Gregorian calendar** | The calendar in use today. Britain changed to it in September 1752. uFTi assumes it unless you name another. | `gregorian-calendar` | new style (a source may use it; we explain it in the page) |
| **Julian calendar** | The calendar that came before the Gregorian one. Britain used it until September 1752. | `julian-calendar` | old style (a source may use it; we explain it in the page) |
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

## 6. The word for the reader's device

A topic shared by several mobile manuals names the device with the key `product-device` (platform strategy, section 3.1). Each manual defines it, once, in its own key map.

| Manual | `product-device` | Never |
|---|---|---|
| Android phone | phone | mobile, handset, smartphone, cell |
| Android tablet | tablet | slate |
| iPhone | iPhone | phone (in the iPhone manual, the device is named) |
| iPad | iPad | tablet (in the iPad manual, the device is named) |

Say "your phone", not "the device", where the key is used.
