# The Alpha-2 iPhone walk

What was walked on the iPhone, what was found, and what the manual does about it. Part of the [authoring plan](../authoring-plan.md) and the [walk plan](walk-plan.md). Written 11 November 2026 for [issue 169](https://github.com/oughnic/uFTi-Docs/issues/169) and [issue 170](https://github.com/oughnic/uFTi-Docs/issues/170). Decisions: DEC-235 and DEC-237. The walk before it is [alpha-1-iphone-ipad.md](alpha-1-iphone-ipad.md).

This report is public. It names no machine, no account, no serial number and no build number of a build that is not released. It says only what a reader can see.

## 1. What was walked

- **The build.** The Alpha-2 build of the app, version 0.2.0, as a Release configuration build with the DevFlow agent (DEC-213), installed under a separate application identity, from a first run with its own empty data.
- **The device.** The iPhone 17 Pro simulator, iOS 26.5, 1206 by 2622 pixels, portrait, in English (United Kingdom). The status bar was set to a fixed time and is cut off every picture.
- **The look.** Oxford and slate, Light, chosen in Preferences before any picture.
- **The data.** The Brontë sample, and a second tree built in the app by the manual's own tasks: Patrick Brontë, Maria Branwell, Charlotte Brontë and Arthur Bell Nicholls, the family of Patrick and Maria with Charlotte, a note, a place where records are kept, a maker of the tree, a source with its citation and a research question. A scratch person, Test Person, was added and deleted.

The walk followed [the Brontë walkthrough](../bronte-build-walkthrough.md) by stage.

| Stage | Walked |
|---|---|
| 0 | First run, the bar, the More list, Preferences, Help, About, search, a person's page, the tree and the events. |
| 1 | Create a tree, say who made it, the Workspaces screen. |
| 2 | Add people, the date editor (by its boxes and as text), places offered as you type, other names, the name question, delete a person. |
| 3 | A family made from people in the tree, with a child and a marriage; the family page; the tree and its marriage sheet. |
| 5 | A note. |
| 6 | A place where records are kept, a source, its citation, the evidence page. |
| 7 | A research question that names a person. |
| 9 | Search and Refine by, Save as… to the phone, opening the saved copy, opening a file another program made, removing a tree. |

**Not walked.** Stage 8 apart from the census form (pictures and the camera), *Use an existing note*, a saved copy that includes pictures, sharing, rotation, and the help rows on fields.

## 2. What was found

Rows marked as a fault are for the app team, in the one list (DEC-214, changed by issue 162). The rest are what the pages must say.

| # | Where | What a reader sees | Same as the Android phone? |
|---|---|---|---|
| 1 | The bar | Five places: **Home**, **Person**, **Family tree**, **Events** and **More**. Workspaces is in the **More** list. | Yes |
| 2 | Home | The first screen. It names the tree and counts its people, families and events, with a search box, **All people** and **Open another workspace**, and once a person has been opened, **Continue with**. A new tree offers **Add the first person**. Results of a search show on the same page, under **All**, **People** and **Events**. | Yes |
| 3 | The top of a screen | A back arrow and the path to the screen, then a search button, **+** and a round help button. On Home the search button is not shown, because Home has the search box. | Nearly: no search button on Home |
| 4 | The More list | **Workspaces**, **Notes**, **Where records are kept**, **Who made this tree**, **Research questions and notes**, **Preferences**, **About uFTi** and **Help**, which "Opens the guide to this screen in your web browser". | Yes |
| 5 | Help | The help button opens the welcome page of the documentation in Safari, as expected until the Alpha-2 pages are published (DEC-214). | Yes |
| 6 | Preferences | Four themes (**High contrast** is new), three looks, and **Saving another program's file** with two boxes. The app starts in **Ink and parchment**. | Yes |
| 7 | Workspaces | Each card shows its counts, the years of birth and death, the top surname and how complete the tree is, with **Show details**, **Open**, **Save as…** and **Remove**. After **Copy** on a person, a **Paste** button shows. | Yes, and the Paste button is new |
| 8 | Create workspace | The box starts with "My family tree", and typing adds to it. The same name is accepted and becomes "(2)". The new tree opens on its Home. | Yes |
| 9 | Who made this tree | After **Save** the new name shows at once, marked "(default)", with a line about the tree's copyright. | Better: the Android phone needed the list opened again |
| 10 | Person form | The form opened part of the way down, from **Add the first person** and from **Edit**. Every field has a round help button. **Save** is at the foot of a long form. | Yes |
| 11 | Dates | Day, a list of months, and Year, with a *Reads as* line, **Not sure of the date?** and **Edit as text**. Typed text is read when you leave the box. Maria Brontë's birth in the sample reads "between 1813 and 1814" under **Between two dates** and **The year**. | Yes |
| 12 | Places | Typing a place that is in the tree offers it in a list under the box. | Yes |
| 13 | Other names | The kinds are **Birth name**, **Married name**, **Also known as**, **Name taken on immigrating**, **Maiden name**, **Professional name**, **Pen name** and **Other**. | Yes |
| 14 | A name already in the tree | A box: "“Test Person” is already in this tree." with **Use Test Person**, **Add a new person called Test Person** and **Cancel**. | Yes |
| 15 | Delete person | "Delete Test Person? They will be removed and unlinked from any families, events and relationships. This cannot be undone." | Yes |
| 16 | Families | **Husband / partner 1** is filled in from the person. A partner is found by typing and choosing from the list. A child is chosen with **Set…** under **Existing person**. A marriage typed on this first form is saved as a marriage. Save opens the family's page. | Yes |
| 17 | The tree | Steppers for generations, **Return to focus**, **Fit to screen**, counts on the cards, a marriage mark that opens a sheet, and a button such as **+5 siblings**. | Yes |
| 18 | Events | The event's page has an **Event or fact** part and a long **More details** part (age, cause, sort date, agency, religion, address, map coordinates, telephone, email, fax, website, restriction), then **Notes** and **Photos**, and **Edit**, **Copy** and **Delete event**. | Yes |
| 19 | Sources | On the iPhone, **Save source** does not attach the source at once. The next step is headed "Add *title* to this fact" and asks for the page or reference, **How reliable it is**, the date of the entry, the text, the event and the role, with an **Add source** button. Then **Attach source document**, then **Done**. **Compare records that disagree** shows even before a fact has a source. | No: different order |
| 20 | Notes, places, research | The Notes screen has **Add note** and **Use an existing note**. A research note has **Status** (**Open**, **In progress**, **Resolved**) and **People it is about**. | Yes |
| 21 | New items in lists | After a save from the **+** sheet, **Where records are kept** and **Research questions and notes** do not show the new item until you go to another place, such as Home, and come back. Going back with the arrow is not enough. | Yes; a fault |
| 22 | Save as… | "Save workspace as. Everything keeps the tree, notes and pictures; the family tree only has no pictures, for other programs." with **Everything (.gdz, recommended)**, **Family tree only (.ged)** and **Cancel**, then **Which version of GEDCOM?**. The phone's save screen opens at **On My iPhone**. The message afterwards names a folder, *File Provider Storage*, that the reader never sees. | The message: a fault |
| 23 | Opening a file | A file that uFTi wrote opens with a box that counts what it holds. A file another program made opens a page first: **Make a GEDCOM 7 copy** or **Just look**, each with a line that says what it does, and **Cancel**. **Just look** opens the tree, and its box says "Opened to look at: uFTi will not change this file." | New |
| 24 | Opening the same file again | Opening a saved copy of a tree gave a second card with exactly the same name as the first. | A fault |
| 25 | Removing a tree | "Remove '…' from your workspaces? This does not delete the family tree file on disk." Removing the open tree opened the sample. | Yes |
| 26 | The path at the top | Going to Home from a page under More, or from **All people**, showed Home with the old path still at the top, such as "… › Where records are kept", and the first tap left **More** lit. | A fault |
| 27 | Leaving a form | Tapping the lit **Person** tab dropped a half-filled form from **Add the first person** with no question. From the **+** sheet the same tap asks **Discard changes?**. | A fault |
| 28 | After a delete | The chip still read "Showing: Test Person" after Test Person was deleted. | A fault |
| 29 | The forms for records (12 November, on a second iPhone 17 Pro simulator with the same build) | With Charlotte open, the **+** sheet lists the 1841 and 1851 censuses, **Baptism record**, **Burial record** and **Marriage register entry** under her events, and **More forms (10)**: the later censuses, each with a line that nobody here was alive then, the 1939 register, **Birth record** ("already recorded here") and **Family note**. The 1841 census form says "Adding to the household of" with **Change…**, fills in the census date (6 June 1841), and asks for the source's title and place, where it is kept (class HO 107 filled in, then piece, folio, page and schedule), the registration district, sub-district and enumeration district, and a row for each household member, linked to the person. | Same as the Android phone page |
| 30 | The household of a census | For the 1841 census, the form chose the household of Arthur Bell Nicholls and Charlotte, a marriage of 1854, though Charlotte lived with her father in 1841. | For the app team |
| 31 | Events (stage 4, 12 November) | With Charlotte open, **+** then **Other event** then **Add** opens the event form: **Type** (a list from Birth to Fact, ending with **Event**), **Kind of event, in words**, the date, **Time of day**, **Place** with matches from the tree, and more. A baptism (29 June 1816, Thornton) saved, went back to Home, and showed in her events between her birth and her marriage. **Add event** under the events opens the same form directly. A residence with **Edit as text** turned on and "from 25 February 1820 to 31 March 1855" reads back the same and shows in the list at once. **Event** with "Publication" in **Kind of event, in words** shows as "Event" in the list, and as Publication when opened. | Same as the Android phone page |

## 3. What the tooling could not do

- The month, sex and other lists are the phone's own wheels. They were turned by hand, not by the driver.
- The boxes the phone draws (the name question, **Discard changes?**, the Save as questions, **Remove workspace**) are cut from a copy of the simulator's screen.
- The camera does not exist on a simulator.

## 4. What the manual has now

The pictures were taken again on this build, for every key the iPhone manual uses, with new alternative text, and nine new ones: Home, the first run, the More list, all the people, the date editor, a date that is not sure, the name question, the evidence page and the page for another program's file.

The pages were written from this report (DEC-238). The iPhone now shares the Android phone's pages for rows 1 to 20 and 25: the tour, Look around, Find a person, See a family tree, See the events of a person, Look at the sources of a fact, Add another person, Change a person, Add a family, Add a note, Choose how it looks, Enter a date, Say who made this tree, Add a place where records are kept, Add a research question and Remove a tree. Inside those pages, the iPhone differences are marked: no search button on Home (row 3), the marriage sheet (row 17), **Save source** then the citation step then the attachment step (row 19), the name shown at once in Who made this tree (row 9), and the lists to open again (row 21). *Add your first person* starts from the sample tree's Home, *Keep it safe* starts from **More**, and *Open a family tree file* has the page for another program's file (row 23). Since 12 November the iPhone also shares *Add an event* (row 31), and the iPhone, the iPad and the Mac share *Forms for records you have seen* (row 29), and a page of their own, *Find help and the version*, answers About uFTi.

## 5. Next

- Walk the pictures and the camera of stage 8, and *Use an existing note* on the iPhone.
- Walk stage 4 on the iPad and the Mac, which do not share *Add an event* yet.
- The faults (rows 21, 22, 24, 26, 27 and 28) and row 30 go to the app team once, with the other legs' (DEC-214).
