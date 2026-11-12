# The Alpha-2 Mac walk, on Mac Catalyst

What was walked on the Mac, what was found, and what is left. Part of the [authoring plan](../authoring-plan.md) and the [walk plan](walk-plan.md). Written 11 and 12 November 2026 for [issue 169](https://github.com/oughnic/uFTi-Docs/issues/169) and [issue 172](https://github.com/oughnic/uFTi-Docs/issues/172). Decisions: DEC-236 and DEC-239. The legs before it are [alpha-2-iphone.md](alpha-2-iphone.md) and [alpha-2-ipad.md](alpha-2-ipad.md).

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
| 4 | The name question and the Discard question. On 12 November, events: a baptism from **Other event**, a residence typed as a period, and an event of its own kind. |
| 5 | The Notes screen and the note form. |
| 6 | Where records are kept, a source with its citation and attachment step, the evidence page. |
| 7 | Research questions and notes, Who made this tree. |
| 8 | On 12 November, the photos buttons on a person's page: the folder, the **Describe this image** box, the chain with and without a picture in the tree, and the fourth button. |
| 9 | Save as… with the macOS Save panel, Add from file… with the macOS Open panel for a uFTi file and for another program's file, removing a tree and removing the tree in use, About uFTi. On 12 November, **Just look** for another program's file, and **Save as…** from that tree. |

**Not walked.** Stage 8 apart from the forms (walked on the iPhone) and the photos buttons, the camera (its question would change the Mac's privacy settings), the help rows on fields, and the address that **Help** opens (it opened the web browser, but the address was not read).

## 2. What was found

| # | Where | What a reader sees | Compared with the iPad |
|---|---|---|---|
| 1 | The window | The list on the left (**Home**, **Person**, **Family tree**, **Events**, **More**), the path at the top, a search button under the back arrow (not on Home), **+** and **Help** with its word. | Same as the iPad on its side |
| 2 | Search | Results in two columns, people on the left and events on the right. **Refine by** has Dates, Sex, Place, Event type, Approximate (sound-alike) matches and Clear filters. Searching **Currer** finds nothing; searching **Charlotte** finds her. | Same layout. Currer: see below |
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
| 18 | Events | The event form is the iPhone's, in a centred column. **Type** is a wheel with **Done**, ending with **Event**. A baptism saved and went back to the screen it started from. **Add event** under the events opens the form directly. A period typed with **Edit as text** turned on reads back and saves; an **Event** with its own words shows as "Event" in the list and with its words when opened. | Same as the iPhone |
| 19 | The photos buttons | Three buttons and "No attachments yet." The folder opens the macOS Open panel. The first choice of a picture opened the **Describe this image** box, "A short description is required for accessibility.", with **OK** and **Cancel**; after **OK**, "Saved" and a fourth button with a down arrow. That button opens the macOS panel for choosing a folder, with **Open** and **Cancel**. | The first choice works on the Mac. On the iPad it added nothing |
| 20 | The chain button | With no picture in the tree: **Link existing media**, "Search media by description", "No media in this workspace yet." and **Close**. With one picture: the picture, its description and "Used by 1 record(s)". The app did not close. | The iPad closed when a picture was in the tree |
| 21 | The picture on the page | Just after it was added, the picture showed only as a thin strip under the buttons. After the page was opened again it showed full size, but **Edit**, **Add a record**, **Copy** and **Delete person** were about two screens further down, after an empty space. | The iPad showed the picture full size at once |
| 22 | **Just look** | The box counts what the file holds and says "Opened to look at: uFTi will not change this file." The tree opens on Home. Nothing on Home, the card or **Show details** says that the tree is only for looking at, and the line under **Workspaces** still says that changes are saved as you go. | As the iPhone's box |
| 23 | Changing a tree opened with **Just look** | **Edit** opens the form as usual. **Save** then gives a box "Couldn't save", which names the tree differently from its card and suggests opening the file again "in place", a choice the page does not offer. **Cancel** then closes the form without the **Discard changes?** question. Nothing was kept, and the chosen file was left unchanged. | Not walked on the iPhone or iPad |
| 24 | **Save as…** from a tree opened with **Just look** | Writes a copy in the folder chosen, with the message of row 13, but adds no card. The copy, opened with **Add from file…**, has a card of its own and can be changed. | Not walked on the iPhone or iPad |

**Currer.** On 12 November the iPhone, with the same build, also found nothing for **Currer**. The sample tree that the app opens with gives Charlotte Brontë one name only, with no pen name, so the search is right and the page was wrong. The shared *Find a person* page now gives the iPhone the example of **Patrick**, which finds Patrick Brontë and his son Patrick Branwell Brontë, as its picture shows. The Android phone keeps the Currer example, which its walk saw; whether its walk used the sample the app opens with is to be checked.

## 3. What the tooling could not do

- The driver's own pictures of the app's window are stale on Mac Catalyst, so the pictures were taken by the system.
- The places in the list on the left and the radio buttons answer only to a click, not to the driver.
- The driver cannot choose a file in the macOS Open panel in the background; the files were opened with the screen taken over for a moment.
- The Mac locks its screen after about twenty minutes, and nothing can be clicked while it is locked.

## 4. What the manual has now

The Mac manual documents Mac Catalyst under its own token, `MacCatalyst` (DEC-239). It shares the iPad pages, and the shared Android phone pages that the iPad uses, and it has its own tour, *Look around*, *Keep it safe* and *Open a family tree file*, because those pages are full of the iPad and its Files app. The manual now has the chapter *Work with your tree*. The places where the Mac differs are marked inside the shared pages: the name question with **Cancel** (row 8), the lists that need opening again (row 12), and the name in the New workspace box that typing replaces (row 5). *Say who made this tree* is shared with the Android phone, whose list also needs opening again.

The 45 pictures the Mac manual uses were taken of the app's window in this walk and cut below its title bar, with new alternative text. Four were taken for the pages after the walk: all the people, the middle of a person's page, **More forms**, and the version question of **Save as…** for a family tree file. The pictures of About uFTi and of the macOS Open and Save panels are not used.

The pages for the AppKit Mac, written before the walk, were removed: no manual uses them any more. Since 12 November the Mac also shares *The Photos buttons* (rows 19 to 21), with the macOS panel in place of the Files screen, the **Describe this image** box, and how to reach the buttons past a picture. The camera's question is not described for the Mac. *Open a family tree file* now says what **Just look** does when you try to change the tree, and that the copy from **Save as…** must be opened before it can be changed (rows 22 to 24). It also shares *Add an event* (row 18), *Forms for records you have seen* and *Find help and the version*.

## 5. Next

- Check rows 23 and 24 on the iPhone and iPad: their *Open a family tree file* pages still say that **Save as…** on the card makes a copy you can edit.
- Walk the camera on the Mac. It needs the maintainer's word, because answering its question changes the Mac's privacy settings.
- On 12 November, at the maintainer's request, rows 22 to 24 were sent to the app team: rows 22 and 23 as a fault, row 24 as a request.
- On 12 November, at the maintainer's request, row 21 was sent to the app team as a fault, and row 20 was added to the iPad's report of the chain button closing the app.
- Check the **Currer** search on the Android phone, in the sample tree that the app opens with. If it finds nothing there, the Android phone needs another example too, and a new picture.
- On 12 November, at the maintainer's request, rows 5, 10, 12, 13 and 17, the path word "Submitter", the "Tap to manage sources" names and the sample's missing pen name were sent to the app team, with the iPhone's and the iPad's.
