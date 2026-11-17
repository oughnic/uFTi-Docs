# The Alpha-2 Windows walk

What was walked, what was found and what the Windows manual does about it. Part of the [authoring plan](../authoring-plan.md) and the [walk plan](walk-plan.md). Written 10 November 2026, with the retake of 17 November 2026 in section 6. Decisions: DEC-221 and DEC-255. This report names no machine, no account and nothing from the application repository.

## 1. What was walked

- **The build.** A Release build of the Windows app with the DevFlow agent, for a driven leg (walk plan, section 6.2). It is newer than the commit the walk plan names for Alpha-2, because the maintainer asked for the latest development build. The version the About page prints is recorded in `build/publications.ini` and in the picture manifest. The pictures were retaken on 17 November 2026 from build 0.2.0.993 (section 6), so the version now matches the other five manuals.
- **The set-up.** x64 Windows 11, a window 1280 by 800 at 200%, the Oxford and slate theme, light, en-GB, and a throwaway data folder. The Brontë tree was built by hand in the app, from empty, by the steps of the [Brontë walkthrough](../bronte-build-walkthrough.md).
- **How it was driven.** The words on each screen were read from the app. Buttons were pressed through the app's own automation, and pages were opened by route where a press on a list row does nothing. Pictures are the app's own capture, so no status bar or other program is in them.
- **What was done.** First run and the sample tree; removing a tree; creating a tree; who made the tree; the nine people; Patrick and Maria's family with six children and the 1812 marriage; Charlotte and Arthur's family and the 1854 marriage; a baptism, a residence period typed as text; a note; two repositories; a source on a person; the sheet of sources on a fact and its second step; a research note tied to a person; the Photos buttons; the 1841 census form as far as its first screen; search and Refine by; Preferences; About; the Save as sheets and the GEDCOM question (read, not completed). A second pass, after the first review, added: a note shared with a second person through Use an existing note, the Delete person question (read, then cancelled), Show details on a tree's card, the Type list of the Event form, and the family tree's buttons.

## 2. What could not be done

| What | Why | What the manual does |
|---|---|---|
| Pictures of the New workspace box, the Save as sheets, the Windows Save and Open windows and the camera | The walk machine cannot capture separate windows or sheets | Five Windows picture keys were removed. Three came back on 17 November 2026 (section 6). The message after Save as and the summary after a file opens are still described in words, and a person must capture them by hand. |
| The Windows Save window, the Windows Open window (Add from file…), the summary after a tree opens | They are Windows' own windows | The pages keep what the Alpha-1 pages said about them and list each sentence in section 4. |
| What Delete person does after it is confirmed, what the Help button opens, pressing a card in the family tree and the siblings chip, Compare records that disagree, saving a census household | Not done in this walk (Delete is permanent, Help left the app's window, and the driver could not press the chip) | Not claimed. See section 4. |

## 3. What was found

| # | Where | What a reader sees | What the manual does |
|---|---|---|---|
| 1 | A new tree with the name of a tree just removed | The two trees share one internal name, and the app shows the older tree's data until it is closed and opened again. After a restart with no tree, an empty tree called "default" appears. | Taught in *Create a workspace*, *Remove a workspace* and the Quick Start: remove the old tree, close and reopen the app, then create the new one. |
| 2 | First run | The app opens its own sample, the Brontë family of Haworth. | The Quick Start says so and tells the reader to name a practice tree differently. |
| 3 | The menu | Home, Person, Family tree, Events, then Workspaces, Notes, Where records are kept, Who made this tree, Research questions and notes, Preferences, About uFTi. | *Look around* and *The screens of the app* follow it. |
| 4 | Home | A search box, a Refine by button, All people, Open another workspace, and after use Continue with and Recent people. In a tree with nobody in it: Add the first person. | New pictures `img-nav-main`, `img-people-list`. |
| 5 | A person's page | A family tree sits beside the page. Each section has a Sources chip. A line says how the person was added and, with a source, "Sourced by …". | The pages and pictures follow. |
| 6 | The Add a record sheet | Its sections change with the person: parents, events, notes, sources, citation, a new person, and the workspace. | *Add another person* and the evidence pages. |
| 7 | A family | A partner is chosen by typing and choosing the line that appears. A child already in the tree is chosen in an *Existing person* window. A marriage added with Edit is saved as a marriage and the page reads "Marriage · 29 December 1812 · …". The earlier fault (a marriage date on the first form saved as a census) was not tried again. | *Add a family*, *Add a later family*, *See a family's page*. |
| 8 | Events | Listed in date order: a birth in 1817 comes before a baptism on 23 July 1817. A period typed as text reads back as "from 25 February 1820 to 7 June 1861". The Event form has a box *Kind of event, in words*. | *Add an event*, *Enter a period*, *Add an event of your own kind*. |
| 9 | A source added on a person | It attaches to Identity, Birth, Death and More details at once. | *Add a source* says so. |
| 10 | The sheet of sources | Shows each source with a *Quality: 2 · Secondary evidence* line, and Copy, Citation, Edit and Remove. Adding is two steps: a list, then the page or entry and *How reliable it is*. | *Look at the sources of a fact*. |
| 11 | A research note | It can be tied to people (*People it is about*), and its Status is a list. The walkthrough said it could not. | *Add a research note*. The walkthrough still says otherwise: fix it. |
| 12 | The date editor | *Kind of date* and *How much do you know?* show with *Not sure of the date?* on. The calendars are behind a button, *More: other calendars*. The *Reads as* line shows under the boxes once a date is typed. | The shared pages on dates are not changed (section 5). |
| 13 | Preferences | Four themes (High contrast, Ink and parchment, Oxford and slate, Sepia and slate), three appearances and a group *Saving another program's file* with two switches. | *Choose how it looks*. |
| 14 | Forms | The *Baptism record* form starts with the register title "Parish Baptism Register". The extra forms include censuses from 1871 to 1921 and the 1939 register. | A caution in *Add an event*. |
| 15 | Fill from document | A *Fill from document…* button shows on forms. | Not described (out of scope). |
| 16 | About | Lists modules and AI models. | Not pictured. |
| 17 | Not found | A screen for checking a tree for duplicates, and a screen for merging two people. | No task is written (walkthrough step 9.2). |

## 4. To walk by hand

A person must check each of these on a real Windows PC before the Windows manual is published:

- The Windows Save window and the Windows Open window, the summary after a tree is opened, and that new trees are saved in a folder named uFTi inside Documents (the walk used a throwaway folder).
- The pictures of the message after Save as and of the summary after a file opens, to put back the last two removed keys. The New workspace box, the Save workspace as question and the Which version of GEDCOM? question were captured on 17 November 2026 (section 6).
- What the list shows after Delete person is confirmed (the question was read and cancelled: it names the person and says "Also affects: 1 family, 2 events."); what the Help button opens; the family tree: pressing a card (the app's own name for it says it re-roots the chart), the round mark between partners (it says it opens family events), the generation buttons and the "+5 siblings" chip.
- Compare records that disagree; saving a household on the 1841 census form; an event of your own kind (the Type list has no "Event" and ends with "Fact"; the box "Kind of event, in words" was not used).
- That *Add the first person* opens the Basic details form, and that the Sex list has *Male* and *Female*.
- The page on photos: the camera, adding a file, and the fourth button.

## 5. What the shared pages say that the walk does not

These shared pages are not changed, because other manuals use them. Each needs a look when its manual is walked.

- *Dates*, *Kinds of date*, *Typing a date*: the *How much do you know?* question and *Kind of date* show only with *Not sure of the date?* on. In text mode the line is called *How the date reads* and fills in after the box is left.
- *Calendars*: the calendars are behind a button named *More: other calendars*. The page says *Calendar*.
- *Places*: the form also has *Place of marriage*, *Place* and *Place (required)*; a new child's place is set in a window. The page says there is no map; event pages have a *Map coordinates* box.
- *Names*: the person form has Prefix, Nickname, Surname prefix and Suffix, and rows for other names and for names in other languages. The same-name question was not seen with the Basic details form.
- *Dates in lists and order*: events in one year came out in date order here.
- *Say where you found it* (Quick Start): the chip reads *Sources: 0 +*, the form's button is *Save*, and the sheet's steps are different.
- *Five things to know*: the Windows menu says *Family tree*.
- *Your workspace and its files*: it names the GEDCOM versions by year; the sheet prints *GEDCOM 7 (recommended)* and *GEDCOM 5.5.1 (for older programs)*.

## 6. The retake of 17 November 2026

All 34 pictures of the manual were taken again, with the finished Brontë tree (stage 9, DEC-253) open, from the Alpha-2 Windows build, 0.2.0.993. This is the same build as the other five manuals. Decision: DEC-255. Issue 201.

**How.** The app's window at 1280 by 800 at 200% scaling, in the Oxford and slate theme, light, en-GB, driven through its own automation. Every form and question was cancelled or discarded, and the tree still had 9 people, 2 families and 88 events at the end. A picture of a box or a sheet that is not part of the page (the New workspace box, the Save workspace as question, the Which version of GEDCOM? question, the Remove workspace question) is a capture of the app's window, cut to the box (`capture: os` in the manifest). The pictures of sheets that fill the window have no black band, so they have no crop.

**What the finished tree changed in the pictures.**

- The People list and the search results show three chips on a card: sources, events and notes.
- Charlotte's page has a part named Other names (Currer · Bell and Charlotte · Nicholls). Her tree shows 18 events and 3 notes on her box.
- Patrick's page has three pictures under Photos, from the sample's media records, and a fourth button for saving them.
- Maria Branwell has three notes, the first shared with 7 other records. The family page of Patrick and Maria has a note about the two couples married the same day.
- Branwell's list has ten events. His baptism has no source. Emily's burial has one source, the Haworth burial register, with an entry number and a quality line.
- The 10 places where records are kept have no address and no notes yet. The six research notes have a status each and are not tied to people, so none says how many records it is linked from.
- Nobody is credited as maker of the tree. The page says so, and the picture shows that line.
- The search box on Home shows Continue with and Recent people once people have been opened.

**What a page said that the new build or tree does not.** Corrected in the pages: the number of events a Delete person question names (11 for Anne in the sample, where the old page said 2); the Showing chip (it shows once someone is opened; the first Home screen of a new session had none); the sheet of sources has its Add source button under the list, not at the foot; the repositories and research notes pages do not show an address or a link count unless one is entered; and the photos buttons page showed a tree with no pictures.

**New things seen, and not written.**

- Choosing a source that the fact already cites asks "This fact already cites …" and offers Edit its citation and Add another citation. The pages go straight to the second step.
- Closing the form of a new source or a note with Cancel, after something was typed, asks "Discard changes?". The pages say Cancel stops without saving.
- The sheet of sources for a fact with no sources has only Add source. Compare records that disagree is on a sheet with several sources, such as Emily's death, and was not on the sheets for her burial or for Branwell's baptism.
- The Save workspace as question names the file types, .gdz and .ged, and the second question is Which version of GEDCOM?.

**Not captured.** The message after Save as, and the summary after a file opens, because both need Windows' own Save and Open windows. The keys `img-save-as-message` and `img-import-summary` stay out of the key map. The camera is not captured.

**Care.** Before any picture was kept, the Workspaces screen was checked: it showed one card, Brontë family of Haworth, with 9 persons, 2 families and 88 events, and nothing else.
