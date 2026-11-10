# The Alpha-2 Android phone walk

What was walked on the Android phone, what was found, and what the manual does about it. Part of the [authoring plan](../authoring-plan.md) and the [walk plan](walk-plan.md). Written 10 November 2026 for [issue 129](https://github.com/oughnic/uFTi-Docs/issues/129) and [issue 162](https://github.com/oughnic/uFTi-Docs/issues/162). Decisions: DEC-230 to DEC-233. The walk before it is [alpha-1-android-phone.md](alpha-1-android-phone.md).

This report is public. It names no machine, no account, no serial number and no build number of a build that is not released. It says only what a reader can see.

## 1. What was walked

- **The build.** The latest development build of the app, version 0.2.0, as a Release configuration build with the DevFlow agent (DEC-213), installed under a separate application identity so that no other install on the phone was touched. It started from a first run with its own empty data.
- **The phone.** A Samsung Galaxy A41, model SM-A415F, Android 12, 1080 by 2400 pixels, portrait, with the three-button navigation. The text size was set to 1.0 for the pictures and put back afterwards. The camera permission was revoked afterwards.
- **The look.** Oxford and slate, Light, in English (United Kingdom). The pictures are the app's own capture, or a copy of the phone's screen for sheets and boxes, with the status bar cut off.
- **The data.** The Brontë family only. The tree was built in the app by the manual's own tasks: nine people and the scratch people that the tasks delete, two families (Patrick and Maria with their six children, and Charlotte and Arthur), the events of Branwell, Patrick and Charlotte, two notes, a place where records are kept, a person who made the tree, a source with its citation, and a research question.

The walk followed [the Brontë walkthrough](../bronte-build-walkthrough.md) by stage, and the rows of [the dates, places and names sheet](dates-places-names.md) for the `android-phone` leg.

| Stage | Walked |
|---|---|
| 0 | First run, the bar, the More list, Preferences with the dark look, the Help buttons, About, search, a person's page, the tree and the events. |
| 1 | Create a tree, say who made it, the Workspaces screen. |
| 2 | Add the people, the date editor, places, other names, change and delete a person. |
| 3 | Add two families, the family page, the tree. |
| 4 | A baptism, a period, an event of your own kind, the order of a life. |
| 5 | A note, and one note for two people. |
| 6 | A place where records are kept, a source, a citation, the evidence page. |
| 7 | A research question that names a person. |
| 8 | The Photos buttons, the camera route and a census form (read, not saved). |
| 9 | Search and Refine by, Save as… as far as the phone's own save screen, remove a tree. |

**Not walked.** Add from file… and Add photo (the phone's own file screen lists the other things on the phone), Link existing media, a saved copy and opening it again, sharing a copy, rotation, the Hebrew and French Republican calendars, the third match of the name question, and the Julian worked cases. The manual does not teach them yet, except where it says so.

## 2. What was found

Rows marked **Different** are where the walkthrough, the sheet or a page said something else. They are findings for the one set of changes (DEC-214, changed by issue 162). The three faults (5, 6 and 22) went to the app team on 10 November 2026, at the maintainer's instruction and ahead of the other legs; the rest stay here for the one list (DEC-214).

| # | Where | What a reader sees | What the manual does |
|---|---|---|---|
| 1 | The bar | Five places: **Home**, **Person**, **Family tree**, **Events** and **More**. Workspaces moved into the **More** list. | [The screens of the app](../../content/platforms/android-phone/topics/tour-of-the-screens.dita) and the Quick Start page are rewritten. |
| 2 | Home | The first screen. It names the tree, counts people, families and events, has the search box, **All people** and **Open another workspace**, and once people are opened, **Continue with** and **Recent people**. A new tree offers **Add the first person**. | [Find a person](../../content/platforms/android-phone/topics/find-a-person.dita), [Add your first person](../../content/platforms/android-phone/topics/add-your-first-person.dita). |
| 3 | Every screen | A round **Help about this screen** button, and a round help button beside every field. Both open docs.ufti.com in the phone's browser. | Mentioned in the tour. Walked again once the Alpha-2 pages are published (DEC-214). |
| 4 | Add a record | The sheet fills the screen and has its own Help button. It depends on who is open: with a person open it starts with parents, an event, a note, a source and a citation. **More forms** shows a count (19 with nobody open). **Event details** does not exist: the choice is **Other event**. | [Add an event](../../content/platforms/android-phone/topics/add-an-event.dita), [Forms for records you have seen](../../content/platforms/android-phone/topics/forms-for-records.dita). |
| 5 | Saving | After **Save** on several forms (a family, a second person with the same name, an event, a repository) a box asks **Discard changes?** although the record is saved. Choosing **Discard** only closes the form. | The tasks say so. A fault, sent to the app team. |
| 6 | New items in lists | After a save from the **+** sheet, the list of people who made the tree and the list of places where records are kept did not show the new item until the screen was left and opened again. | The tasks say so. A fault, sent to the app team. |
| 7 | Dates | The calendar list sits behind **More: other calendars**, as the page says. **March 15, 1900** reads as 15 March 1900. **Julian 12 February 1731/32** reads as 12 February 1731/32 (Julian). **31 February 1900** is kept and saved with no message. | [Enter a date](../../content/platforms/android-phone/topics/enter-a-date.dita). The shared date pages say that **March 15, 1900** is kept as typed: to change in the one set of changes. |
| 8 | Names | **Pen name** is now a kind of name, with **Birth name**, **Married name**, **Also known as**, **Name taken on immigrating**, **Maiden name**, **Professional name** and **Other**. A search for a pen name finds the person. | [Change a person](../../content/platforms/android-phone/topics/change-a-person.dita). The walkthrough's **Professional name** with "Pen name" in words is out of date. |
| 9 | A name already in the tree | Same as the page: the box says the name is already in this tree, with **Use** and **Add a new person called**. | [Add another person](../../content/platforms/android-phone/topics/add-another-person.dita). |
| 10 | Delete a person | The question names the person: **Delete Test Person?** | [Change a person](../../content/platforms/android-phone/topics/change-a-person.dita). The walkthrough says it does not name them. |
| 11 | Families | A marriage typed on the first form is saved as a marriage, not as a census. A child is chosen with **Set…** under **Existing person**, and a typed name counts only once it is chosen from the list. Children sort by birth year, with people who have no birth year last. | [Add a family with children](../../content/platforms/android-phone/topics/add-a-family.dita). |
| 12 | The tree | **Return to focus**, **Fit to screen**, two steppers for generations, event and note counts on the cards, and a button such as **+5 siblings**. | [See a family tree](../../content/platforms/android-phone/topics/see-a-family-tree.dita), with a description in words. |
| 13 | Events | An event of your own kind has a box, **Kind of event, in words**. The list shows **Event** and the event's page shows the word. The walkthrough says there is no such box. | [Add an event](../../content/platforms/android-phone/topics/add-an-event.dita). |
| 14 | Sources | **Save source** attaches the source at once. The second step is the **Citation** button: **Page or reference number**, **How reliable it is** (from **Not stated** and 0 to 3), **Date of the entry**. The sheet shows the entry and a **Quality** line. **Compare records that disagree** still shows once a fact has a source. | [Look at the sources of a fact](../../content/platforms/android-phone/topics/look-at-the-sources-of-a-fact.dita). |
| 15 | Research notes | **Status** is a list (**Open**, **In progress**, **Resolved**), and a note has **People it is about**. The walkthrough says a note cannot name people. | [Add a research question](../../content/platforms/android-phone/topics/add-a-research-note.dita). |
| 16 | Notes | **Use an existing note** and **Add note** are on the Notes screen. A shared note says it is shared with another record. | [Add a note to a person](../../content/platforms/android-phone/topics/add-a-note.dita). |
| 17 | Photos | The buttons are named **Take photo**, **Add photo** and **Link existing media**, and a fourth, **Export all to a folder**, appears once there is a picture. The camera route is as the sheet says, then **Crop & deskew** and a description that is required. | [The Photos buttons](../../content/platforms/android-phone/topics/the-photos-buttons.dita), [Take a photo of a document](../../content/platforms/android-phone/topics/take-a-photo.dita). |
| 18 | Census form | A household lists only the family who were alive on the census date. The census date is filled in. | [Forms for records you have seen](../../content/platforms/android-phone/topics/forms-for-records.dita). The walkthrough says it lists everyone. |
| 19 | Preferences | Four themes (**High contrast** is new), three looks, and a part named **Saving another program's file** with two boxes. The app starts in **Ink and parchment**. | [Choose how the app looks](../../content/platforms/android-phone/topics/choose-how-it-looks.dita). |
| 20 | Removing a tree | Removing the open tree opens the other one at once. With none left, the screen says **No workspace open**. | [Remove a tree from the list](../../content/platforms/android-phone/topics/remove-a-workspace.dita). |
| 21 | The form's start | A person's form opened part of the way down from **Edit** and from **Add the first person**, and at the top from the **+** sheet once. | [Change a person](../../content/platforms/android-phone/topics/change-a-person.dita) says it may. |
| 22 | The Help button on a sheet | The Help button on the Add source sheet opened the browser and closed the sheet, so the typed words were lost. | Not described. A fault, sent to the app team. |

## 3. The sheet's rows

Of the 47 rows for this leg, 20 are Same, 15 are Different and 12 were not done. The Different rows are 1.8, 1.12, 1.14, 1.15, 2.2, 2.6, 3.2, 3.4, 4.6, 5.1 to 5.5 and 8.3. Rows 1.15, 3.4 and 4.6 are Different for the reason DEC-214 gives, and are walked again once the pages are published.

## 4. What the tooling could not do

- A driver finds the date boxes by their ids in this build. The list of matches under a place box or a person box has no ids, so those were chosen by hand.
- The agent's capture shows the app's own screen only. Sheets and boxes (the **+** sheet, the question boxes, the source sheets) are cut from a copy of the phone's screen, with the bars taken off, as before (DEC-172).
- A sheet and a box can only be told apart from the app behind it in the copy of the screen. The pictures of boxes are cropped to the box.
- The phone's own save, file and camera screens are not pictured, because they show the other things on the phone.

## 5. What the manual has now

The manual's Android phone pages are written from this walk. Where a page is shared with the iPhone and was wrong for this phone, the Android phone has its own copy until the iPhone walk settles the same rows (DEC-231). The new pages are *Add an event*, *Enter a date, even one you are not sure of*, *Forms for records you have seen*, *Take a photo of a document*, *Say who made this tree*, *Add a place where records are kept* and *Add a research question*. The pictures were taken again on this build.

## 6. Next

- Walk again, on a phone with nothing else on it or on an emulator: Add from file…, Add photo, Link existing media, a saved copy and opening it, sharing.
- Walk the help rows again once the Alpha-2 pages are published.
- Settle with the iPhone and the tablets which Android phone copies can become shared pages again (DEC-197).
- The other findings go to the app team once, with the other legs' (DEC-214).
