# The Alpha-2 Android tablet walk

What was walked on the Android tablet, what was found, and what the manual does about it. Part of the [authoring plan](../authoring-plan.md) and the [walk plan](walk-plan.md). Written 15 November 2026 for [issue 176](https://github.com/oughnic/uFTi-Docs/issues/176). Decision: DEC-240. The walk before it is [alpha-1-android-tablet.md](alpha-1-android-tablet.md). The phone's walk is [alpha-2-android-phone.md](alpha-2-android-phone.md).

This report is public. It names no machine, no account, no serial number and no build number of a build that is not released. It says only what a reader can see.

## 1. What was walked

- **The build.** The latest Alpha-2 build of the app, version 0.2.0, as a Release configuration build with the DevFlow agent (DEC-213), installed fresh on the tablet, from a first run with its own empty data.
- **The tablet.** A Pixel Tablet-style emulator profile, 2560 by 1600 pixels at 320 dpi, on its side, with Android 15 (the profile in the screenshot strategy says Android 16, but only the Android 15 system image was installed). English (United Kingdom), font size 1.0, nothing else installed.
- **The look.** Oxford and slate, Light, chosen in Preferences before any picture.
- **The data.** The Brontë family only. The app's own sample was walked first. Then it was removed, and the tree was built in the app with the manual's own tasks: nine people, a person who made the tree, two families (Patrick and Maria with their six children, and Charlotte and Arthur), a source on Charlotte's birth with its citation, a note on Patrick, a place where records are kept and a research question. A copy of the tree was saved and opened again with **Add from file…**, and the opened copy was removed.

The walk followed [the Brontë walkthrough](../bronte-build-walkthrough.md) by stage.

| Stage | Walked |
|---|---|
| 0 | First run, the list on the left, Preferences, About, Home, search and **Refine by**, a person's page with the tree beside it, the tree and the events, the places that need a person, the **+** sheet in full, the Help buttons. |
| 1 | Remove the sample, make a tree, say who made it, the Workspaces screen. |
| 2 | Add nine people, the date and place boxes, change one person. |
| 3 | Add two families and the children of one, the family page, the family tree and the sheet from the marriage mark. |
| 4 | The page of an event. |
| 5 | A note. |
| 6 | A place where records are kept, a source, its citation and its attachment step. |
| 7 | A research question. |
| 9 | **Save as…** with both choices, as far as Android's own save screen; **Add from file…** with the saved copy; remove a tree. |

**Not walked.** Taking and adding a picture (the emulator has no camera scene), a census form and the register forms, an event of your own kind, a baptism, the date editor's other calendars, the name prompt and the place lists, **Other names**, portrait, the dark look beyond one picture. The rows of [the dates, places and names sheet](dates-places-names.md) for this leg were not marked: this walk covered the tablet's layout and the task steps, and the sheet is still to be walked on the tablet.

## 2. What was found

Rows marked **Different** are where the Alpha-1 tablet pages, or the Alpha-1 walk, say something else. They are findings for the one set of changes (DEC-214).

| # | Where | What a reader sees | Against the Alpha-1 pages |
|---|---|---|---|
| 1 | The list on the left | **Home**, **Person**, **Family tree** and **Events**, then below a line **Workspaces**, **Notes**, **Where records are kept**, **Who made this tree**, **Research questions and notes**, **Preferences** and **About uFTi**. There is no **More**. | Different: **Home** is new at the top, and **Workspaces** moved down. |
| 2 | First run | The app opens on **Home** for the Brontë sample (9 people, 2 families, 20 events), in the **Ink and parchment** theme. The list of trees holds that one tree only. | Different: Alpha-1 opened **Workspaces** and listed the app's other samples. |
| 3 | Home | The name of the tree, a line that counts people, families and events, a search box with **Search** and a button with a small icon that opens **Refine by**, **All people** and **Open another workspace**. After a person is opened, **Continue with** and **Recent people** appear. An empty tree shows **Add the first person**. | New. |
| 4 | Every screen | The path across the top (the tree, then each page you came through), a back arrow on a page you opened from another page, a chip that starts **Showing:** that names the person or the family, a **+** button and a **Help** button. A round help button sits beside most fields of a form. | Different: Alpha-1 had no **Help** button or field help buttons. |
| 5 | Help | **Help** on **Home** and on the **Add source** sheet opened the browser at the documentation's welcome page, not at a page for the screen. The app does not yet carry a map of the tablet pages. | Walked again once the Android tablet Alpha-2 pages are published (DEC-214). |
| 6 | Nobody open | **Person** says **Pick a person to see their record**, with **Find a person**, and the **Family tree** area beside it says the same for the tree. **Family tree**, **Events** and **Notes** each say to pick a person and have **Find a person**. | Different: **Events** and **Notes** showed only the search box. |
| 7 | A person's page | The details are in one column, with the family tree beside them on the tablet on its side, and a divider between. The tree has two steppers for the generations, **Return to focus** and **Fit to screen**. Dragging the divider by touch moves it both ways; the width stays when the reader leaves and comes back. The tree is not fitted again after the move, so a person can be cut off at the edge. | New. The Alpha-1 walk did not mention the tree beside the details. |
| 8 | A person's page, lower down | **Family** lists the partner (**Wife · years · Married 1812 Guiseley, Yorkshire**) and the children (**Daughter** or **Son**, with years). Under it **Add parents to…** and **Add a new family**, the three Photos buttons, **Edit**, **Add a record**, **Copy** and **Delete person**. | New. |
| 9 | The forms | **Add the first person** and **Edit** open one column of boxes with the family tree beside it. A person added from the **+** sheet opens two columns (birth beside death) with no tree. A line under each date says **Reads as…**. **Kind of name** is a list. | Different: Alpha-1 had two columns for every form. |
| 10 | Saving | The first person's page opens after **Save**. A later person added from the **+** sheet goes back to the page it was opened from. After **Back** from a form that was started, a box asks **Discard changes?**, with **Keep editing** and **Discard**. A person with no given name stops with **1 problem to fix before saving**. | Same as the phone for the later person. |
| 11 | The **+** sheet | A sheet in the middle of the screen with its own **Help** button, **Add** and **Cancel**. With Brontë people open it starts with parents, an event (the 1841, 1851 and 1861 censuses, **Baptism record**, **Burial record**, **Marriage register entry**, **Other event**), a note, a source and a citation, then a new person, then the workspace (**Family**, **Repository**, **Research note**, **Submitter**). **More forms** shows a count and nine more forms. | Different: the lists and wording changed. |
| 12 | A new tree | The **New workspace** box offers **My family tree** as the name. After **Create** the tree opens on **Home**. Removing the only tree leaves an empty tree named **default**. | To check against the page for **Add your first person**. |
| 13 | Families | **Add a new family** opens the **+** sheet with **Family** already chosen. The form fills **Husband / partner 1** or **Wife / partner 2** with the person in focus, and a name typed in the other box counts once it is chosen from the list. A child is chosen with **Set…** under **Existing person**, in a box with **Cancel** and **Done**. Typing the start of a name such as Patrick offers the father first. | New. |
| 14 | The family page and its tree | The page names both partners, then **Marriage · date · place**, **Partners**, **Marriage** with a sources chip, **Children**, **More details**, **Notes**, **Edit**, **Copy** and, lower down, **Delete family**. **View family tree** is at the top right. The tree shows the couple, **m. 1812**, and the children, with **Daughter** or **Son**. The marriage mark opens a sheet from the bottom with the marriage (**Opens the family**) and each child (**Shows their tree**). | Different. |
| 15 | Events | A list of the person's events, each with a date and a place and a count of sources, and **Add event**. An event's page has **Event or fact** with a sources chip, **More details** and **Notes**. | Same. |
| 16 | Sources | **Save source** leads to a citation step (**Page or reference number**, **How reliable it is** with **Not stated** and 0 to 3, **Date of the entry**, **Text of the entry**, **Note**, and the event and role boxes), and then an attachment step with the three Photos-style buttons and **Done**. The list for the fact shows the title and page with **Copy**, **Citation**, **Edit** and **Remove**. No **Compare records that disagree** button showed on an empty list or on a list of one; it showed under **Add source** once the fact had two sources. | Different: Alpha-1 had **Compare records that disagree** on an empty list. |
| 17 | Help on the **Add source** sheet | **Help** opens the browser, and the sheet stays open with the typed words kept. | The phone's fault is fixed on this build. |
| 18 | Notes | A person's notes are rows, with **Add note** and **Use an existing note**. The form has **Note**, **Format**, **Language** and **Translations**. | Different: Alpha-1 had one box. |
| 19 | The lists of the tree | **Where records are kept**, **Who made this tree** and **Research questions and notes** show each item with **Edit** and **Delete** (**Copy** too for a question). A new item showed in the list as soon as the screen was opened again. A research question has a **Status** list and **People it is about**. | Different: the lists are no longer empty text. |
| 20 | **Save as…** | A question offers **Everything** and **Family tree only**. **Family tree only** asks which version of the file to write. Android's own save screen then names the copy. The copy was saved in Download. | Same. |
| 21 | **Add from file…** | Android's file screen opens. A box then counts the people, families, events, sources and notes, says there are no pictures in the file and that the chosen file is left as it was. **OK** opens **Home** of the new tree, named like the first with **(2)** after it. | Same, with one new line: **Home** opens, with the **Refine by** panel still open. |
| 22 | **Preferences** | Four themes (**High contrast**, **Ink and parchment**, **Oxford and slate**, **Sepia and slate**), three looks, and a part named **Saving another program's file** with two switches. | Different: **High contrast** is new. |
| 23 | **Back** on a main screen | A box asks **Exit the app?** with **Cancel** and **Exit**. | New. |
| 24 | **About uFTi** | The version of the app. | Same. |

## 3. What the tooling could not do

- The agent's own capture shows the app's window only. Sheets and Android's own boxes (the question boxes, the **+** sheet, the sources sheets) are cut from a copy of the whole emulator screen, with the bars taken off, and halved so that the words are the same size as in the other pictures.
- A few controls did not answer a tap from the agent (a radio button, and a button that opens one of Android's own boxes). They were pressed by touch.
- A name with a letter that is not on the keyboard (Brontë) was typed through the agent, and in Android's own **New workspace** box by holding the letter on the keyboard.
- Android's own save screen, file screen and keyboard are not pictured, because they are Android's, not the app's (DEC-181).
- The emulator has no camera scene, so taking a photo was not walked.

## 4. What the manual has now

The pictures are new. All 37 pictures of the Android tablet manual were taken again on this build, and each has new alternative text. The pages were then corrected from section 2 (DEC-241, issue 178): the tour, Look around, the first person, finding and changing a person, the family tree, notes, Preferences, opening a file, sources, who made the tree, where records are kept, research questions and removing a tree are the tablet's own, and the pages for adding a person, a family and the events of a person are shared with the iPad and the Mac. There are no pages yet for a date, an event of your own, the forms for records or taking a photo, because this walk did not cover them.

## 5. Next

- Write the pages for a date, an event of your own, the forms for records and taking a photo, once a tablet walk covers them.
- Walk the dates, places and names sheet and the rows not walked here, on a tablet or an emulator with a camera scene.
- Walk the Help rows again once the Android tablet Alpha-2 pages are published, and when the app carries a help map for the tablet.
- Settle with the Android phone which pages can be shared again with the tablet (DEC-197, DEC-238).
