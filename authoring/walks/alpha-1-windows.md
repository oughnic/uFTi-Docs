# The Alpha-1 Windows walk

What was walked, what was found and what the manual does about it. Part of the [authoring plan](../authoring-plan.md). Written 24 October 2026 for [issue 54](https://github.com/oughnic/uFTi-Docs/issues/54). Decisions: DEC-122 and DEC-123.

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
| 4 | Search results | A small round badge on a person's card shows 0 and has no label. | Not mentioned. |
| 5 | Notes | A round badge beside **Notes** shows 0 after a note was saved. It is not clear what it counts. | Not mentioned. |
| 6 | New person and Family forms | The **Save** button is below the first screen. The page must be scrolled. | The topics say to scroll. |
| 7 | New person, Family and Note forms | A button named **Fill from document…** shows. Documents are out of scope. | Described without it. |
| 8 | **About uFTi** | It shows AI models and document reading. These are out of scope. | The page is not pictured. |
| 9 | **Add a record** | Some words are hard: "No subject could plausibly have existed in the window 1861", "This form is for a different kind of record". | The topics do not repeat them. They are a candidate for plainer words. |
| 10 | **Save as…** | Nothing on screen says the copy was saved or where. The Windows save box opens in the reader's Documents folder. | [Keep it safe](../../content/platforms/windows/topics/keep-it-safe.dita) says to look in the folder. The save box is never pictured (DEC-122). |
| 11 | Opening a file | The summary writes the name with hyphens. The card writes it with spaces. A second file of the same name is called "(2)" on the card and "-2" in the summary. | [Open a family tree file](../../content/platforms/desktop/topics/open-a-family-tree-file.dita) says they are the same tree. |
| 12 | The top bar | The chip that starts with **Showing** keeps a person's name after the tree that person came from is removed. | Not mentioned. |
| 13 | Windows boxes | The name box, the remove question and the file pickers use the Windows blue and the Windows light or dark setting, not the app's theme. | Not mentioned. |
| 14 | The family form | A new child can be added in a row by name, or chosen from the tree with **Set…**, which opens a small window. The partner must be chosen from the list that opens as you type. Typing alone does not set it. | [Add a family with children](../../content/platforms/desktop/topics/add-a-family.dita). |
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
