# The Alpha-2 Mac walk, on Mac Catalyst

What was walked on the Mac, what was found, and what is left. Part of the [authoring plan](../authoring-plan.md) and the [walk plan](walk-plan.md). Written 11 and 12 November 2026 for [issue 169](https://github.com/oughnic/uFTi-Docs/issues/169) and [issue 172](https://github.com/oughnic/uFTi-Docs/issues/172). Decision: DEC-236. The legs before it are [alpha-2-iphone.md](alpha-2-iphone.md) and [alpha-2-ipad.md](alpha-2-ipad.md).

This report is public. It names no machine, no account, no serial number and no build number of a build that is not released. It says only what a reader can see.

## 1. What was walked

- **The target.** Mac Catalyst, as the maintainer asked on 11 November 2026 (DEC-236).
- **The build.** The Alpha-2 build for Mac Catalyst, a Release configuration build with the DevFlow agent, under its own application identity, with its own data. Data from earlier walks was set aside first, so the app started from a first run.
- **The window.** 1280 by 800, in English (United Kingdom).
- **The look.** Oxford and slate, Light.
- **The data.** The Brontë sample, and a new tree built during the walk by following the Brontë walkthrough: Patrick Brontë, Maria Branwell and Charlotte Brontë, their family, a note, a place where records are kept, a source, a research question and the name of the tree's maker. A small family tree file made by another program was written for stage 9.

The first try stopped after Preferences because the Mac's screen was locked: with the screen locked, the app stops drawing. The second try stopped at stage 6 when the screen locked itself again. The third try, on 12 November, finished the walk.

| Stage | Walked |
|---|---|
| 0 | First run, the list on the left, the More list, Preferences, search and Refine by, a person's page with the tree beside it, the tree and its marriage sheet, the events and an event's page, a fact's sources. |
| 1 | Workspaces, the New workspace box, the new tree's Home. |
| 2 | The new person form, the date editor, the **+** sheet, the edit form, a date that is not sure. |
| 3 | The family form with a partner and an existing child, the family page, the tree. |
| 4 | The name question and the Discard question. |
| 5 | The Notes screen and the note form. |
| 6 | Where records are kept, a source with its citation and attachment step, the evidence page. |
| 7 | Research questions and notes, Who made this tree. |
| 9 | Save as… with the macOS Save panel, Add from file… with the macOS Open panel for a uFTi file and for another program's file, removing a tree and removing the tree in use, About uFTi. |

**Not walked.** Stage 8, the help rows on fields, and the address that **Help** opens (it opened the web browser, but the address was not read).

## 2. What was found

| # | Where | What a reader sees | Compared with the iPad |
|---|---|---|---|
| 1 | The window | The list on the left (**Home**, **Person**, **Family tree**, **Events**, **More**), the path at the top, a search button under the back arrow (not on Home), **+** and **Help** with its word. | Same as the iPad on its side |
| 2 | Search | Results in two columns, people on the left and events on the right. **Refine by** has Dates, Sex, Place, Event type, Approximate (sound-alike) matches and Clear filters. Searching **Currer** finds nothing; searching **Charlotte** finds her. | Same layout. Currer: see section 4 |
| 3 | A person's page | The person on the left and the **Family tree** on the right, with the divider. **Edit** opens a one-column form on the left. | Same |
| 4 | The tree | The marriage mark opens a sheet from the bottom, with the marriage line and each child. | Same |
| 5 | Create workspace | The box opens with **My family tree** selected, so typing replaces it. | On the iPhone, typing adds to it |
| 6 | The new person form | Opens at the top of the form. The date editor has Day, Month, Year, **Reads as**, **Not sure of the date?** and **Edit as text**. | Same |
| 7 | The **+** sheet | **Add a record** fills the window in a centred column, with **Add** and **Cancel** at its foot. Saving a form opened from **+** goes back to the screen you came from. | Fills the window |
| 8 | The name question | A box in the middle of the window, with **Use Patrick Brontë**, **Add a new person called Patrick Brontë** and **Cancel**. **Cancel** on the form then asks **Discard changes?** with **Keep editing** and **Discard**. | The Mac box has **Cancel** |
| 9 | Families | The two-column family form. A child's row runs across the page and fits on the Mac. **Set…** opens an **Existing person** box with **Find a person…**. The family page lights **Family tree**. | The row fits |
| 10 | The More places | Each has its line under the heading. While a form opened from **+** is open (the note, the place where records are kept, the research question, the tree's maker), the list on the left lights **Person**. | Same lines |
| 11 | Sources | The **Sources** sheet fills the window. **Save source**, then the citation step in two columns, then **Attach source document** with camera, folder and link buttons, then **Done**. **Compare records that disagree** opens the **Evidence** page. | Same steps |
| 12 | Research questions and Who made this tree | After **Saved**, the list still says there is nothing in it; the new item shows when the list is opened again. | As the iPhone |
| 13 | Save as… | A box in the middle: **Everything (.gdz, recommended)**, **Family tree only (.ged)**, **Cancel**. Then the macOS Save panel. The message afterwards names the version of the file format and how many things were changed to fit it. | macOS panel |
| 14 | Add from file… | The macOS Open panel. A uFTi file opens at once, with a box that counts what it holds and says the chosen file is left as it was. Another program's file opens the same page as on the iPhone and iPad (**Make a GEDCOM 7 copy**, **Just look**, **Cancel**), filling the window. The chosen file was left unchanged. | Same page |
| 15 | Remove | A box: "Remove '…' from your workspaces? This does not delete the family tree file on disk." with **Cancel** and **Remove**. Removing the tree in use makes another tree the one in use. | Walked on the Mac only |
| 16 | Home | After a person has been opened, Home shows **Continue with** and that person. | Same as the iPhone |
| 17 | Cancel on the edit form | Once, after the tree in use had been removed, **Cancel** on the edit form did nothing: no question, and the form stayed open. | A fault, to check |

## 3. What the tooling could not do

- The driver's own pictures of the app's window are stale on Mac Catalyst, so the pictures were taken by the system.
- The places in the list on the left and the radio buttons answer only to a click, not to the driver.
- The driver cannot choose a file in the macOS Open panel in the background; the files were opened with the screen taken over for a moment.
- The Mac locks its screen after about twenty minutes, and nothing can be clicked while it is locked.

## 4. What the manual has now

Nothing yet. The Mac manual has no places for pictures, and its platform token is not decided (DEC-236). The pictures from this walk are kept with the walk, ready for when it does. Pictures of About uFTi and of the macOS Open and Save panels are not for the site, because they show the build and the computer's own files.

## 5. Next

- Decide the Mac's platform token and give the Mac manual places for its pictures (DEC-236), then write the Mac pages from this report.
- Check the **Currer** search on the iPhone: the shared Android phone and iPhone page *Find a person* says that searching her pen name finds Charlotte.
- Send rows 2, 5, 10, 12, 13 and 17 to the app team with the other legs' findings (DEC-214).
