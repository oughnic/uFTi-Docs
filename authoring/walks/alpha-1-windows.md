# The Alpha-1 Windows walk

What was walked, what was found and what the manual does about it. Part of the [authoring plan](../authoring-plan.md). Written 24 October 2026 for [issue 54](https://github.com/oughnic/uFTi-Docs/issues/54). Decisions: DEC-122 and DEC-123. The retest on the next Alpha build is in section 5 ([issue 63](https://github.com/oughnic/uFTi-Docs/issues/63), DEC-125).

The app is the Windows Alpha-1 build (version 0.1.0.1, a development build), in the Oxford and slate theme and the light look, in a window 1280 by 800 on a 200% display. The data is the Brontë dataset only. This report says what a reader can see. It names no code, no issue and no build of the application repository (DEC-040, and the standing rule that this repository is public).

## 1. What was walked

- **First run.** The app opens with its own two samples and no Brontë sample. The samples were removed, as a reader may, and the empty Workspaces screen was read.
- **Create a workspace.** Name box, then the New person form straight away. Patrick Brontë was added with dates and places. Maria Branwell was added from the **+** list, by **Basic details**.
- **Add a family.** Patrick and Maria, their marriage, and Charlotte as a new child. The tree for the family was drawn.
- **A source and a note.** One source on Patrick's birth, with the full run of sheets. One note on Patrick.
- **A copy.** **Save as…**, the choice of file, the choice of version, and the Windows save box.
- **Open a file.** **Add from file…** with the nine-person Brontë sample, and the summary after it opens.
- **Every menu item**, with the sample open, and a search, the refine list, a person's page, an event, the sources of a fact, the **+** list in full, **Preferences** and **About uFTi**.
- **Remove a tree from the list.**

Not walked: taking a photo, adding a picture from a file, the forms for a census or a register entry, adding a place, a repository, a submitter or a research note, a GEDZIP copy, and checks for duplicates. The manual does not teach them yet.

## 2. What was found

| # | Where | What a reader sees | What the manual does |
|---|---|---|---|
| 1 | First run | The app opens with two other samples. The Brontë sample is not there. | The Quick Start does not promise the sample. A page that explores it waits for the app to include it. |
| 2 | First run | The look follows the system, so it may be dark. | [Choose how the app looks](../../content/platforms/desktop/topics/choose-how-it-looks.dita) says how to set light. |
| 3 | A person's page | **Events**, **Notes** and **Family tree** say "Select a person" or "No person selected" until someone is open. | [A page says no person is selected](../../content/platforms/desktop/topics/a-page-says-no-person-selected.dita). |
| 4 | Search results | A small round badge on a person's card shows 0 and has no label. | Fixed in the next Alpha build (section 5): [Find a person](../../content/platforms/desktop/topics/find-a-person.dita) says what the badge counts. |
| 5 | Notes | A round badge beside **Notes** shows 0 after a note was saved. It is not clear what it counts. | Fixed in the next Alpha build (section 5): the badge says *Sources: 0*. The Notes picture is made again. |
| 6 | New person and Family forms | The **Save** button is below the first screen. The page must be scrolled. | The topics say to scroll. |
| 7 | New person, Family and Note forms | A button named **Fill from document…** shows. Documents are out of scope. | Described without it. |
| 8 | **About uFTi** | It shows AI models and document reading. These are out of scope. | The page is not pictured. |
| 9 | **Add a record** | Some words are hard: "No subject could plausibly have existed in the window 1861", "This form is for a different kind of record". | Fixed in the next Alpha build (section 5): the reasons are in plain words, and [Add another person](../../content/platforms/desktop/topics/add-another-person.dita) quotes one. |
| 10 | **Save as…** | Nothing on screen says the copy was saved or where. The Windows save box opens in the reader's Documents folder. | Fixed in the next Alpha build (section 5): [Keep it safe](../../content/platforms/windows/topics/keep-it-safe.dita) describes the message. The save box is never pictured (DEC-122). |
| 11 | Opening a file | The summary writes the name with hyphens. The card writes it with spaces. A second file of the same name is called "(2)" on the card and "-2" in the summary. | Fixed in the next Alpha build (section 5): [Open a family tree file](../../content/platforms/desktop/topics/open-a-family-tree-file.dita) no longer has the note about hyphens. |
| 12 | The top bar | The chip that starts with **Showing** keeps a person's name after the tree that person came from is removed. | Fixed in the next Alpha build (section 5): [A page says no person is selected](../../content/platforms/desktop/topics/a-page-says-no-person-selected.dita) says the chip clears. |
| 13 | Windows boxes | The name box, the remove question and the file pickers use the Windows blue and the Windows light or dark setting, not the app's theme. | Not mentioned. |
| 14 | The family form | A new child can be added in a row by name, or chosen from the tree with **Set…**, which opens a small window. The partner must be chosen from the list that opens as you type. Typing alone does not set it. | Partly fixed in the next Alpha build (section 5): [Add a family with children](../../content/platforms/desktop/topics/add-a-family.dita) says a whole name that only one person has is taken. The child rows are unchanged. |
| 15 | **Photos** | The three buttons have icons and no words. The chain button links a picture already in the tree. | [The Photos buttons](../../content/platforms/desktop/topics/the-photos-buttons.dita). Taking a photo and adding a file are not described. |
| 16 | The Brontë sample | It has no repositories, submitters, notes or research notes. | The three empty pages are pictured as they are. |
| 17 | A source | **Remove** beside a source: the manual says it takes the source off the fact. The effect on the source itself was not tested. | To be checked on the next walk. |

## 3. What the tooling could not do

The automation tool opens no result card, list row or native box. The walk used the real mouse and keyboard, with the PC unlocked, and cut the pictures of native boxes from the real screen (DEC-122). A lock screen stops all of this.

## 4. Next walk

- Add a picture from a file and take a photo, and write the topics.
- Add a repository, a submitter and a research note.
- A census form and a register-entry form.
- Test the **Remove** button on a source.
- Bring in the Brontë sample when the app includes it, and write the Quick Start page that explores it.

## 5. The next Alpha build

Walked on 24 October 2026 for [issue 63](https://github.com/oughnic/uFTi-Docs/issues/63). The app team fixed several findings on their development branch, which is not a release. This walk used a build made from that branch, in the same Oxford and slate light look and window as before. The version it prints is still 0.1.0.1 (1), so the date is what tells the two builds apart. The data is the Brontë dataset and the Brontë sample only. Decision: DEC-125.

Each finding of section 2 is marked below. *Fixed* means it was seen on screen in this walk.

| # | In the next Alpha build | What was seen |
|---|---|---|
| 1 | Changed | The first run now opens the Brontë family of Haworth sample, beside two other samples. The Quick Start is not changed in this walk. See section 6. |
| 2 | Not retested | The look was set to light before the walk. |
| 3 | Not retested | |
| 4 | **Fixed** | The badge on a person's card in the search results reads *Sources: 10* and *Sources: 11*. |
| 5 | **Fixed** | The badge beside **Notes** reads *Sources: 0*. |
| 6 | Not fixed | **Save** is still below the first screen on the New person and Family forms. |
| 7 | Not fixed | **Fill from document…** still shows on the New person and Family forms. The app team moves document reading to a later alpha. The manual still describes the forms without it. |
| 8 | Not fixed | **About uFTi** still lists AI models and document reading. It stays out of the manual. |
| 9 | **Fixed** | The **More forms** list says, for example, "This form covers 1881, and going by the dates in the tree, nobody here was alive then.", "What this form records is already recorded here." and "This form adds a different kind of record from the one you have open." |
| 10 | **Fixed** | After **Save as…** a message at the bottom of the screen names the file and the folder, and says which version of GEDCOM it wrote. It stays on screen for as long as it was left, and goes when it is chosen. The Windows save box still opens in the Documents folder. |
| 11 | **Fixed** | The summary after a file opens is titled *Opened Brontë family of Haworth (2)*, as its card is. It now also says how many pictures the file has, and if it holds anything the app does not show. |
| 12 | **Fixed** | The **Showing** chip is empty after the tree its person came from is removed. The second crumb in the top line still named the removed tree until the app was started again. |
| 13 | Not fixed | The name box, the remove question, the question *Discard changes?* and the file boxes still use the Windows look. |
| 14 | **Fixed** (partner) | A full name typed in the partner box is taken when one person has that name: the family was saved with that partner. When two people have the name, the box turns red and says "Choose a person from the list for 'Wife / partner 2', or clear the box." The child rows were not retested. |
| 15 | Not retested | |
| 16 | Not retested | The sample is now the one the app brings with it. |
| 17 | Not retested | |

Seen on the way, not investigated: after **Save** on the Family form, the form stayed on screen for several seconds, and choosing another page in that time asked *Discard changes?* The family had been saved.

Pictures made again: the search results, the summary after a file opens, the Workspaces screen and the Notes page. New pictures: the message after **Save as…** and the end of the **Add a record** list. The other pictures were not made again. The screens they show were looked at again where a fix could reach them (a person's page, the Events list, the chips that count sources), and the words on them did not change.

## 6. For a later walk

- The first run now holds the Brontë sample. The Quick Start page that explores it can be written, and the first-run picture and the Quick Start steps about the first screen need a new look.
- Test the **Remove** button on a source, the child rows of the Family form, and the Photos buttons on this build.
