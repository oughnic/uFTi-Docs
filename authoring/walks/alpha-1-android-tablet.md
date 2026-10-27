# The Alpha-1 Android tablet walk

What was walked, what was found and what the manual does about it. Part of the [authoring plan](../authoring-plan.md). Written 27 October 2026 for [issue 20](https://github.com/oughnic/uFTi-Docs/issues/20). Decisions: DEC-180 to DEC-182. The Android phone walk is [alpha-1-android-phone.md](alpha-1-android-phone.md).

The app is the Alpha-1 build for Android (shown in the app as version 0.1.0 (1)), in the Oxford and slate theme and the light look, on a Pixel Tablet emulator (2560 by 1600 pixels, landscape, Android 16, English (United Kingdom), font size 1.0) with nothing else on it. The data is the Brontë dataset only. The pictures are made by the same journeys as the phone walk. This report says what a reader can see. It names no code, no issue and no build of the application repository (DEC-040, and the standing rule that this repository is public).

## 1. What was walked

- **First run.** The Workspaces screen, with the app's own samples. Two of them (not the Brontë sample) were taken off the list with **Remove**, which also walked [Remove a tree from the list](../../content/platforms/android-tablet/topics/remove-a-workspace.dita) to the end.
- **Preferences.** Oxford and slate and Light were chosen before any picture.
- **Create a workspace.** The New workspace box, then the New person form straight away. Patrick Brontë was added with dates and places. Maria Branwell was added from the **+** sheet, by **Basic details**.
- **Add a family.** Patrick and Maria, their marriage and Charlotte as a new child, with the small windows for her birth date and place. The family page, its tree, the sheet from the marriage mark, and the family form opened again with **Edit**.
- **A source and a note.** One source on Patrick's birth, through the whole run of screens. One note on Patrick.
- **The Photos buttons.** The camera (as far as the camera screen), the folder (as far as Android's own file screen) and the chain (the list of the tree's pictures), each left without adding anything.
- **A copy.** **Save as…** with both choices, through Android's own save screen to the end. The GEDZIP copy was saved in Download.
- **Open a family tree file.** **Add from file…** with the GEDZIP copy, through Android's own file screen to the box that follows and the new card.
- **Every place in the list on the left.** Search and its **Refine by** list, a person's page and its form, an event, the sources of a fact, the **+** sheet in full with **More forms**, the three empty lists, **Preferences**, **About uFTi**, and the places that need a person with no person open.

Not walked: taking a photo (the emulator's camera shows nothing), adding a picture from the tablet, a GEDZIP copy with pictures, the forms for a census or a register entry, portrait, and the dark look.

## 2. What was found

| # | Where | What a reader sees | What the manual does |
|---|---|---|---|
| 1 | The left side | A list of places in place of the phone's bar: **Workspaces**, **Person**, **Family tree** and **Events**, then, below a line, the six places the phone keeps under **More**. There is no **More**. | The tablet pages say "the list on the left". |
| 2 | The top of every screen | A line names the tree and the page, such as the tree, then a person, then their family. Each name in it goes back to that page. | [The screens of the app](../../content/platforms/android-tablet/topics/tour-of-the-screens.dita) says so. |
| 3 | First run | The app starts in the **Ink and parchment** theme, following the system's light or dark setting. | The pictures are taken after choosing Oxford and slate and Light. |
| 4 | Saving the first person | The person's page opens, with a short "Saved" message. The phone goes back to the screen it came from. Saving a later person goes back, as on the phone. | [Add your first person](../../content/platforms/android-tablet/topics/add-your-first-person.dita) follows it. |
| 5 | Forms | Two columns: the names on the left, the dates and places on the right. A child in the Family form is a row, not a card. | The pages say where things are. |
| 6 | The Family form | When **Set…** has been used for a birthplace, the button shows only the start of a long place, such as "Thornton, near". | The page says the button shows "what you typed, or the start of it". |
| 7 | The Family form | A name typed in a partner box counts only once chosen from the list. If the keyboard changes the word first, the box says to choose a person from the list or clear it. | The page already says to choose the person from the list. |
| 8 | Search | The results are in two columns, people and events. The phone's three buttons for everything, people only and events only are not there. | [Find a person](../../content/platforms/android-tablet/topics/find-a-person.dita) leaves them out. |
| 9 | Sources | An empty list has **Add source** and **Compare records that disagree**. | The page names both. |
| 10 | **Save as…** | The question is cut off in the middle of a line, as on the phone. After the save, a line at the bottom says where the copy went, such as "in the folder Download". When the save screen is left at the top of the tablet's storage, the line says "in the folder 0". | Keep it safe names the folder to choose. |
| 11 | **Add from file…** | A box names the tree, counts what it holds, and says uFTi keeps its own copy. A card for a file whose name matches another card has the same name. | [Open a family tree file](../../content/platforms/android-tablet/topics/open-a-family-tree-file.dita) tells the reader to use **Show details** to tell them apart. |
| 12 | Removing the open tree | Another tree on the list becomes the open one. | [Remove a tree from the list](../../content/platforms/android-tablet/topics/remove-a-workspace.dita) says so. |
| 13 | No person open | **Family tree** says "Select a person to view their family tree." **Events** and **Notes** show only the search box. | [A page says no person is selected](../../content/platforms/android-tablet/topics/a-page-says-no-person-selected.dita) covers both. |
| 14 | A person's form | **Edit** can open the form part of the way down, where the person's page was scrolled. | [Change a person](../../content/platforms/android-tablet/topics/change-a-person.dita) says to scroll up. |
| 15 | The Workspaces cards | A card with one family says "1 families". | Not mentioned. |

## 3. What the tooling could not do

The pictures are copies of the whole emulator screen. The status bar and the gesture bar are cut off, and a box or a sheet is cut to itself. Android's own save screen, file screen, permission question and keyboard are never pictured, because they are Android's, not the app's (DEC-181). The cutting and scaling are done before import, because the importer's own crop and resize run on Windows only.

## 4. Next walk

- Taking a photo and adding a picture from the tablet, and a GEDZIP copy with pictures, on a tablet emulator with a camera scene or a real tablet.
- Portrait, and the dark look in the appearance topic.
- The forms for a census and a register entry.
