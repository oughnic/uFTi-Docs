# The Brontë build walkthrough

How we walk through every feature of the app in turn, build the Brontë family file as we go, and come out with the user guide, the help text and the pictures. Each step says what a reader should be able to do afterwards.

Part of the [authoring plan](authoring-plan.md). Status: Draft for review, 9 November 2026, after the first walk on Windows. Proposed in DEC-216; the changes from that walk are DEC-218. Decisions are tracked in the [decision log](decision-log.md).

## 1. What this document adds

Other documents say what the dataset is, how pictures are taken and how help works. This one puts them in the order you do them.

| Question | Where it is answered |
|---|---|
| What goes in the Brontë file, with what evidence? | [Dataset strategy](dataset-strategy.md) and [the specification](../content/sample-data/bronte/README.md) |
| How is a picture taken, checked and imported? | [Screenshot strategy](screenshot-strategy.md) |
| What are the tiers, the help map and the four learning routes? | [Content model](content-model.md) |
| Which screens need help? | [Help targets](journeys/help-targets.md) |
| How is a walk driven and recorded? | [Walk plan](walks/walk-plan.md) |
| **In what order do we do all of it, and what does each step teach?** | **Here** |

The stages are the nine in [dataset strategy, section 5](dataset-strategy.md#5-the-journey), with stage 0 for a newly installed app. This document does not renumber them, because the screen catalogue and the stage map refer to them.

## 2. Ground rules

1. **Build by doing.** A task topic's steps are the steps taken in the app (DEC-039). If a step cannot be done, the topic is not written.
2. **Nothing invented.** Every fact entered has a row in the [evidence register](../content/sample-data/bronte/evidence-register.md). When sources disagree, both go in.
3. **Set the look first.** The app first starts in Ink and parchment and follows the system. Every run chooses Oxford and slate and Light in Preferences before any picture is taken (DEC-024).
4. **Release candidates only.** Pictures come from a release candidate, or from a Release build of its source with the DevFlow agent (DEC-023, DEC-213).
5. **Keep these out of every page and picture:** file-format tags and short codes (DEC-030), price and accounts (DEC-040), the app's AI features, sync, and any build number before release.
6. **Only the Brontë tree is shown.** The app's other sample trees are never named or pictured.
7. **This repository is public.** Findings are written here in plain words, with no application source and no application issue numbers.
8. **A driver does not mark results.** A driven step fills in what was seen. A person decides whether the page and the screen agree ([walk plan, section 4.7](walks/walk-plan.md)).

## 3. The loop for every step

Each step goes round the same loop, once on the reference device.

| # | Do this | It produces |
|---|---|---|
| 1 | Read the step's learning objective and its records in the specification. | The aim of the step |
| 2 | Do the task in the app, from the previous step's state. Write down each control's words exactly. | The real steps, and a growing tree |
| 3 | Write or correct the task topic from those steps, from a template in `content/templates/`. | The user guide (tier 2) |
| 4 | Link the concept, reference and glossary entries it needs. | Depth, one link away (tiers 3 and 4) |
| 5 | Add the help identifier to the topic and check the help line in [section 7](#7-help-text). | The in-app help (tier 0) |
| 6 | Take the step's picture, if it has one, and write its alternative text. | The picture and its key |
| 7 | Check the step's **You know it worked when** line. | Proof the topic is right |

At the end of each stage, export the tree as that stage's saved state. Then replay the finished stage on each other device, and note any difference as a variant or a finding.

**Pictures stay few.** A picture must orient the reader, show something hard to describe, or show a result to check. Every task must still work without its pictures. The budget is 25 to 40 screens per manual ([section 8](#8-the-pictures)).

**How a learning objective is written.** "After this step, you can…" followed by something a reader could be seen doing. The reader-facing form goes in the topic's short description or opening lines. Research steps also have a good practice objective, marked **Good practice**, from the [good practice strategy](good-practice-strategy.md).

**How far each step has been checked**

| Mark | Meaning |
|---|---|
| Walked | Walked on Alpha-2 across the legs. The labels below are the ones read from the screen. |
| Part walked | Some of it was walked on Alpha-2, or it was walked only on Alpha-1. Confirm the labels. |
| Walked on Windows | Walked once on the Windows app, on an Arm PC, entering only the step's named records. The labels below are the ones read from the screen. Not yet replayed on the other devices. |
| Not walked | Nobody has done this on the current build. Labels here are expected, not seen. |

## 4. The order at a glance

| Stage | Reader's goal | Focus person | Steps | Manual chapters | Saved state |
|---|---|---|---|---|---|
| 0 | Meet the app | Charlotte, in the sample | 0.1 to 0.5 | S, 1, 12 | None |
| 1 | Start a tree | None | 1.1 to 1.3 | S, 1, 2 | Empty tree with its maker |
| 2 | Record the people | Charlotte | 2.1 to 2.7 | S, 4, 6 | 9 people with births and deaths |
| 3 | Show how they relate | Patrick | 3.1 to 3.4 | 5, 3 | 2 families; the tree draws |
| 4 | Record what happened | Branwell | 4.1 to 4.4 | 6 | Every stage 4 event |
| 5 | Keep context and questions | Maria | 5.1 to 5.2 | 8 | 12 notes |
| 6 | Say where it came from | Emily | 6.1 to 6.4 | S, 7 | Repositories, sources, citations |
| 7 | Decide what to believe | Anne and Patrick | 7.1 to 7.4 | 7, 8, guide | 5 research threads |
| 8 | Add a picture and a record | Patrick | 8.1 to 8.3 | 9, 10 | A picture and a census household |
| 9 | Look after the tree | Patrick | 9.1 to 9.7 | 2, 3, 11, 13 | The finished file |

## 5. Before the first step

| Item | Setting |
|---|---|
| Build | The release candidate, or a Release build of its source with the DevFlow agent |
| Data | A throwaway app-data folder that starts empty |
| Language | English (United Kingdom), default text size and scaling |
| Reference device | Windows, because it has the most pages that match the app's screens ([help targets](journeys/help-targets.md)). Windows pictures need the x64 reference profile; the Arm PC is for checking that the pages match, not for pictures. |
| Replay devices | Android phone, Android tablet, iPhone, iPad, Mac, each with the profile pinned in [screenshot strategy, section 4.2](screenshot-strategy.md#42-the-environment) |
| Notes | Use the walk folder outside the repositories, as for any walk |

## 6. The steps

### Stage 0: meet the app

**Stage objective.** After this stage, you can open the app, find your way around and get help.

#### 0.1 Install and open the app

- **Learning objective.** After this step, you can install uFTi on your device and open it for the first time.
- **Status.** Part walked.
- **Brontë data.** None. The first run opens the Brontë family of Haworth.
- **Do.** Install the build. Open it. Note what the first screen says.
- **Guide.** *Get uFTi* (platform).
- **Picture.** `img-start-first-run`, stage 0.
- **You know it worked when** the app shows the Brontë family of Haworth.

#### 0.2 Look around

- **Learning objective.** After this step, you can name the main screens and say what each one is for.
- **Status.** Walked.
- **Brontë data.** The sample tree.
- **Do.** Visit Home, Person, Family tree, Events and More (the desktop menu on a computer). Note how a phone, a tablet and a computer differ.
- **Guide.** *Look around*, *The screens of the app*, *A page says no person is selected*.
- **Help.** `home`, `more`.
- **Picture.** `img-nav-main`.
- **You know it worked when** you can reach each main screen and come back.

#### 0.3 Explore a family

- **Learning objective.** After this step, you can find one person and see who they are related to.
- **Status.** Part walked.
- **Brontë data.** Charlotte (P05), in the sample.
- **Do.** Search for Charlotte. Open her page. Look at Identity, Birth, Death, More details, Family and Photos. Open the family tree from her.
- **Guide.** Quick Start *Explore a family*; *Find a person*; *Five things to know*; *About the sample*.
- **Help.** `people.view`.
- **Picture.** `img-person-view`, `img-family-tree-charlotte`.
- **You know it worked when** you can say who Charlotte's parents are.

#### 0.4 Choose how the app looks

- **Learning objective.** After this step, you can change the app's theme and choose light or dark.
- **Status.** Walked.
- **Do.** Open Preferences. Choose Oxford and slate, then Light. **Every capture run does this first.** Take the dark picture once per manual, in this topic only.
- **Guide.** *Choose how the app looks*; accessibility features (chapter 12). The app has no language setting, so the manual does not offer one.
- **Help.** `settings`.
- **Picture.** `img-preferences`.
- **You know it worked when** the pages change colour and stay that way after the app is reopened.

#### 0.5 Find help and the version

- **Learning objective.** After this step, you can open the help page for the screen you are on, and find the version to quote if you report a problem.
- **Status.** Part walked. The help buttons open the welcome page until the Alpha-2 pages are published (DEC-214).
- **Do.** Press Help on a screen with a help button. Open About uFTi and read the version.
- **Guide.** *The screens of the app*, the part on About uFTi; troubleshooting (chapter 13).
- **Help.** `about`.
- **Picture.** None. The About page shows AI features, so it is not pictured.
- **You know it worked when** the help page matches the screen you came from. Check this after publishing.

### Stage 1: start a tree

**Stage objective.** After this stage, you can start a new tree, say who made it and move between trees.

#### 1.1 Create the tree

- **Learning objective.** After this step, you can start a new family tree and give it a name.
- **Status.** Walked on Windows. That typing adds to the name in the box is still to be checked by hand.
- **Brontë data.** "Brontë family of Haworth".
- **Do.** Open Workspaces. Press **Create workspace**. A system window titled *New workspace* opens. Clear the name box first, because it starts filled with "My family tree" and typing adds to it. Enter the name. Press **Create**. If the sample is still there, the app accepts the same name and shows the new tree with "(2)" after it. See [open point 1](#11-open-points).
- **Guide.** *Create a workspace*; *Your workspace and its files*; glossary *workspace*.
- **Picture.** `img-create-workspace-dialog`.
- **You know it worked when** the new tree is open and has nobody in it.

#### 1.2 Say who made the tree

- **Learning objective.** After this step, you can record who made this tree, so anyone who receives a copy knows who to ask.
- **Status.** Walked on Windows.
- **Brontë data.** The author as submitter. Use a role name such as "uFTi documentation". Never a private person's details.
- **Do.** Open *Who made this tree*. Press **+**. On *Add a record*, choose *Submitter* under *Add to the workspace*, then **Add**. Enter the name. Save.
- **Guide.** New task *Say who made this tree*.
- **Help.** `submitters.list`.
- **Picture.** `img-submitters`.
- **You know it worked when** the name is in the list, marked "(default)".

#### 1.3 Move between trees

- **Learning objective.** After this step, you can see your trees, tell them apart and open the one you want.
- **Status.** Walked on Windows.
- **Brontë data.** The new tree and the sample, if it was kept.
- **Do.** Open Workspaces. Read a tree's card. *Show details* adds the file's name and a line that names the file format, so do not picture a card with its details open (DEC-030). Press **Open** on another tree, then come back.
- **Guide.** *The screens of the app*, the part on Workspaces.
- **Help.** `workspaces.list`.
- **Picture.** `img-workspaces`.
- **You know it worked when** the tree you chose has the *Active* badge and its card comes first.

### Stage 2: record the people

**Stage objective.** After this stage, you can add people with names, dates and places, and correct them later.

**Good practice.** Enter what the record says, not what you hope it says. A date you are unsure of is entered as unsure.

#### 2.1 Add the first person

- **Learning objective.** After this step, you can add a person with a name, a sex and the dates and places you know.
- **Status.** Walked.
- **Brontë data.** Patrick Brontë (P01): born 17 March 1777, County Down, Ireland; died 7 June 1861, Haworth.
- **Do.** Add a person with Basic details. Save.
- **Guide.** *Add your first person*.
- **Help.** `people.edit`.
- **Picture.** `img-person-add`.
- **You know it worked when** his page shows both dates and both places.

#### 2.2 Add the others, including two with the same name

- **Learning objective.** After this step, you can add more people, and tell apart two people who share a name.
- **Status.** Walked.
- **Brontë data.** P02 to P09. Maria the mother (P02) goes in as Maria Branwell, as in the committed sample, and Maria the daughter (P03) as Maria Brontë. The list then shows the same first name twice, with different years.
- **Do.** Add each person from the record in [people.md](../content/sample-data/bronte/people.md). Note that Basic details and Birth record saved a second person with the same name without asking.
- **Guide.** *Add another person*.
- **Help.** `add.record`, `people.list`.
- **Picture.** `img-add-record`, new `img-people-list`.
- **You know it worked when** All people lists nine people and both Marias show different years.

#### 2.3 Enter dates, sure and unsure

- **Learning objective.** After this step, you can enter an exact date, a part date and a date you are not sure of, and read how the app has understood it.
- **Good practice.** An uncertain year is a range with a reason, never a guess.
- **Status.** Walked.
- **Brontë data.** Exact: Charlotte, 21 April 1816. Year only: Maria (P02), 1783. A range: Maria the daughter (P03), 1813 or 1814 (thread T04).
- **Do.** Use Day, Month and Year. Switch on *Not sure of the date?* for *Kind of date* and *How much do you know?*. Try Edit as text, and read the *Reads as* line after leaving the box. *Between two dates* with *The year* gives two Year boxes joined by "and". The *Not sure of the date?* switch cannot be turned off while such a kind is chosen. Lists show only the first year of a range.
- **Guide.** *Dates*, *Typing a date*, *Kinds of date*, *Dates in lists and order*. *Calendars* and *An old-style date* use their own example, because the Brontë dates are all after 1752.
- **Help.** `events.date`.
- **Picture.** New `img-date-editor` and `img-date-not-sure`. Take them **before leaving the box**, because the box then rewrites the date in short capital forms that no page may show (DEC-030).
- **You know it worked when** the *Reads as* line says what you meant.

#### 2.4 Enter places

- **Learning objective.** After this step, you can enter a place from smallest to largest, and record it as it was named at the time.
- **Status.** Walked.
- **Brontë data.** Thornton, near Bradford, Yorkshire. Penzance, Cornwall. Banagher, King's County, now County Offaly (P09).
- **Do.** Enter each place. Reuse one the app offers.
- **Guide.** *Places*.
- **Help.** `places.place`.
- **Picture.** None, unless the review finds the words are not enough.
- **You know it worked when** the same place reads the same on two people's pages.

#### 2.5 Enter names that change

- **Learning objective.** After this step, you can record a birth surname, a married name, a pen name and another spelling, and still find the person.
- **Status.** Walked. Confirmed on Windows.
- **Brontë data.** Patrick: Brunty, Prunty, Branty. Charlotte: Nicholls, Currer Bell. Emily: Ellis Bell. Anne: Acton Bell. Branwell (P06), known by his middle name.
- **Do.** Open the person. Press **Edit**. Under *Other names* press **Add row**, and fill in *Kind of name*, *Given name(s)* and the surname. The kinds include *Birth name*, *Married name* and *Also known as*, but not a pen name: use *Professional name* and write "Pen name" in *Kind, in words*. Enter Branwell in *Nickname*. Save.
- **Guide.** *Names*.
- **Help.** `people.name`.
- **Picture.** `img-person-edit`, Charlotte.
- **You know it worked when** a search for "Currer" finds Charlotte and a search for "Brunty" finds Patrick.

#### 2.6 Correct a person

- **Learning objective.** After this step, you can change something you entered and see the change.
- **Status.** Walked on Windows.
- **Brontë data.** Enter Anne's birthplace wrongly on purpose in a scratch copy, then correct it.
- **Do.** Open the person. Press **Edit**: the page itself turns into boxes. Change it. Press **Save** at the foot of the page.
- **Guide.** *Change a person*.
- **You know it worked when** the person's page shows the corrected value.

#### 2.7 Remove a person added by mistake

- **Learning objective.** After this step, you can remove a person you added by mistake, and know what goes with them.
- **Status.** Walked on Windows. The Copy button is still to be checked on the closed build.
- **Brontë data.** A scratch person, "Test Person". **Never a person in the specification.**
- **Do.** Add the scratch person. Press **Delete person**. The app asks: "Delete this person? They will be removed and unlinked from any families, events and relationships. This cannot be undone." It does not name the person, so check the page's heading first. Copy said "Could not copy to the clipboard on this device." on a build run from its folder, so find out what it copies on the closed build.
- **Guide.** New task *Remove a person*, with *Change a person*.
- **You know it worked when** All people is back to nine.

### Stage 3: show how they relate

**Stage objective.** After this stage, you can join people into families and read the family tree.

#### 3.1 Make a family from people already in the tree

- **Learning objective.** After this step, you can make a family from people already in your tree, without making copies of them.
- **Status.** Walked on Windows.
- **Brontë data.** F01: Patrick and Maria (P02), with the six children P03 to P08.
- **Do.** Press **+**, then *Family* under *Add to the workspace*. Find each parent by typing in the box and choosing a match. For each child press **Add row**, then **Set…**, find the child and press **Done**. Leave *Marriage date* empty: see step 3.2. Also type a name that is already in the tree, and read the question the app asks on Save. With one match it says that the name "is already in this tree"; with more it says *matches N people in this tree*. The choices are *Use* and *Add a new person called*.
- **Guide.** *Add a family with children*; *Add a parent, partner or child*.
- **Picture.** `img-family-form`, `img-family-children`, and new `img-name-question`. On iPhone, iPad, Mac and Windows the question is a system window that the in-app capture cannot draw, so it needs an operating-system capture.
- **You know it worked when** there are still nine people, and each child's page shows both parents.

#### 3.2 Add the marriage and read the family's page

- **Learning objective.** After this step, you can add a marriage to a family and find it on the family's page.
- **Status.** Walked on Windows. *No page exists yet.*
- **Brontë data.** E010: 29 December 1812, St Oswald's church, Guiseley. One source gives 18 December (D01). Enter the date most sources give; the other goes in at stage 7 with its source.
- **Do.** Open the family. Press **Edit**. Enter *Marriage date* and *Place of marriage*. Save. **A date entered on the form that first makes a family was saved as a Census on Windows, not a marriage. The app team has been told. Until it is fixed, make the family first and add the marriage with Edit.**
- **Guide.** New task *See a family's page*.
- **Help.** `families.view`.
- **Picture.** `img-family-page`.
- **You know it worked when** the family's page shows the marriage.

#### 3.3 Add a later marriage

- **Learning objective.** After this step, you can add another family for someone already in the tree.
- **Status.** Walked on Windows, with the marriage added by Edit.
- **Brontë data.** F02: Charlotte and Arthur Bell Nicholls (P09), E061, 29 June 1854, Haworth church. No children.
- **Do.** On Charlotte's page press **Add a record**, then *Family* under *Add to the workspace*. Charlotte is filled in as wife. *Add a new family* shows on the page only for someone in no family. Find Arthur. Save, then add the marriage with **Edit**, as in step 3.2.
- **Guide.** *Add a second family for a person*. See [open point 2](#11-open-points) about a true second marriage.
- **Picture.** `img-tree-marriage`.
- **You know it worked when** Charlotte appears both as a child in F01 and as a partner in F02.

#### 3.4 Read the family tree

- **Learning objective.** After this step, you can read the family tree, move around it and choose whose tree you see.
- **Status.** Walked. On Windows, moving by pressing a card is still to be checked by hand.
- **Brontë data.** Patrick in focus, two generations and the later marriage.
- **Do.** Open the family tree from Patrick. Move to Charlotte. Turn a phone to landscape.
- **Guide.** *See a family tree*, with a written description of the tree for readers who cannot see the picture.
- **Help.** `tree.view`.
- **Picture.** `img-family-tree`.
- **You know it worked when** you can reach Charlotte's husband from Patrick.
- **Save stage 3.** Compare it with the committed sample in [`stages/`](../content/sample-data/bronte/stages/README.md).

### Stage 4: record what happened

**Stage objective.** After this stage, you can record a whole life as a series of events.

#### 4.1 Add a baptism and a burial

- **Learning objective.** After this step, you can add an event to a person, and choose the right kind of record.
- **Status.** Walked on Windows.
- **Brontë data.** Branwell (P06): baptised 23 July 1817, Thornton; his death is already in from stage 2.
- **Do.** On his page press **Add a record**, then *Event details*. Choose *Baptism*, and enter the date and place. Open *More forms* to see the rest. **The *Baptism record* form starts with a register's title, so use it only for a register you have seen.** Branwell's date comes from a dictionary of biography.
- **Guide.** *Add an event*, and the shared *Fill in a form* page.
- **Help.** `add.record`, `forms.compose`.
- **Picture.** `img-add-record-lower`, `img-add-record-more-forms`, `img-event-detail`.
- **You know it worked when** the baptism appears among his events.

#### 4.2 Add something that lasted

- **Learning objective.** After this step, you can record something that went on for years, such as a home or a job.
- **Status.** Walked on Windows. The occupation rows were not entered.
- **Brontë data.** E014: Residence, from 25 February 1820 to 7 June 1861, Haworth Parsonage. Occupation rows in [events.md](../content/sample-data/bronte/events.md).
- **Do.** Use *Event details*, kind *Residence*. With Edit as text on, enter the period.
- **Guide.** *Enter a period*, inside *Kinds of date*.
- **You know it worked when** the date reads as a period, from one date to another.

#### 4.3 Add an event of your own kind

- **Learning objective.** After this step, you can record an event that is not on the list.
- **Status.** Part walked on Windows. A person should decide how the page tells this.
- **Brontë data.** E057: Publication, *Poems by Currer, Ellis, and Acton Bell*, May 1846.
- **Do.** Use *Event details*, kind *Event*. There is no box for naming a new kind, so start the box labelled *Notes* with the word: "Publication: *Poems by Currer, Ellis, and Acton Bell*".
- **Guide.** New task *Add an event of your own kind*.
- **You know it worked when** the Events list shows the word Publication in the event's line.

#### 4.4 Read a life in order

- **Learning objective.** After this step, you can read a person's events in date order, and see where an event without a date goes.
- **Status.** Walked. On Windows, events in the same year were in alphabetical order: a burial came before a death three days earlier, and a dated baptism before a birth given only as a year.
- **Brontë data.** Branwell, with every stage 4 event.
- **Do.** Open the Events screen. Open one event.
- **Guide.** *See the events of a person*; *Dates in lists and order*.
- **Help.** `events.list`.
- **Picture.** `img-events`.
- **You know it worked when** the baptism comes before the death.

### Stage 5: keep context and questions

**Stage objective.** After this stage, you can keep what you know beside the person it belongs to.

#### 5.1 Add a note to a person or family

- **Learning objective.** After this step, you can add a note to a person or a family.
- **Status.** Walked on Windows.
- **Brontë data.** N02 to N10 and N16 to N17. Maria (P02) in focus. Write only the words in [notes.md](../content/sample-data/bronte/notes.md), which are our own.
- **Do.** Add a note to Maria. Read it back.
- **Guide.** *Add a note*.
- **Help.** `notes.record`.
- **Picture.** `img-note-form`.
- **You know it worked when** the note shows with Maria.

#### 5.2 Use one note in several places

- **Learning objective.** After this step, you can write one note once and link it to several people, and find every note in the tree.
- **Status.** Walked on Windows, on two people.
- **Brontë data.** N01, the note on Haworth Parsonage, linked from P01 to P08.
- **Do.** With the first person showing, open *Notes*, press **Add note**, write the note and press **Save**. With the next person showing, press **Use an existing note** and choose it. Open the list of notes.
- **Guide.** New task *Use one note for several people*.
- **Help.** `notes.list`.
- **Picture.** `img-notes`.
- **You know it worked when** the same note shows on two people, with "Shared with 1 other record" under it.

### Stage 6: say where it came from

**Stage objective.** After this stage, you can show where each fact came from, and how good that evidence is.

**Good practice.** Cite what you actually saw. If you saw a transcription, say so.

#### 6.1 Record where records are kept

- **Learning objective.** After this step, you can record an archive or office that holds a record.
- **Status.** Walked on Windows.
- **Brontë data.** R01 to R10, starting with the Brontë Parsonage Museum (R01) and The National Archives (R05).
- **Do.** Open *Where records are kept*. Press **+**, then *Repository* under *Add to the workspace*. Add one, with its website in a row under *Telephone, email and website*.
- **Guide.** New task *Add a repository*; glossary entry.
- **Help.** `repositories.list`.
- **Picture.** `img-repositories`.
- **You know it worked when** the archive is in the list.

#### 6.2 Add a source

- **Learning objective.** After this step, you can describe a source so that someone else could find it.
- **Status.** Walked.
- **Brontë data.** S03 to S13. S13 is the Haworth burial register, seen only as a volunteer transcription, so the source says that.
- **Do.** New source. The Author box is under More details.
- **Guide.** *Add a source*; glossary *source*.
- **Picture.** `img-source-new`, `img-sources-list`.
- **You know it worked when** the source is in the list.

#### 6.3 Attach a source to a fact

- **Learning objective.** After this step, you can say where you found a fact, and give the page or entry.
- **Good practice.** One fact, its own source, its own reference.
- **Status.** Walked.
- **Brontë data.** Emily's burial, with S13. Confirm the row in the register first.
- **Do.** Add the burial first, with Event details. Open the fact's sources. Add the source. On the next step enter the page or reference and *Date of the entry*.
- **Guide.** *Say where you found it*; *Add a source to a fact*.
- **Help.** `sources.sheet`.
- **Picture.** `img-sources-empty`, `img-source-attach`, `img-citation-add`.
- **You know it worked when** the fact shows that it has a source.

#### 6.4 Read a fact's evidence

- **Learning objective.** After this step, you can read what supports a fact and how good the evidence is.
- **Good practice.** Original or copy? First-hand or second-hand? Those are two different questions.
- **Status.** Walked. On Windows the sheet shows the title and the reference, but not the quality.
- **Brontë data.** Emily's burial.
- **Do.** Open the sources of the fact. The quality is *How reliable it is* when you add the source, and it is on the page *Compare records that disagree* opens, where that is offered ([default quality](default-quality.md)). Change it where the register disagrees.
- **Guide.** *Look at the sources of a fact*; concept on the quality of evidence.
- **Help.** `sources.view`.
- **Picture.** `img-sources-one`.
- **You know it worked when** the quality on screen matches the register row.

### Stage 7: decide what to believe

**Stage objective.** After this stage, you can follow a question through evidence that disagrees and record what you decided, and how sure you are.

**Good practice.** Never choose silently. A conclusion names its evidence. A question can stay open.

#### 7.1 Write down the question

- **Learning objective.** After this step, you can record a research question before you start to answer it.
- **Status.** Walked on Windows.
- **Brontë data.** T01, "What was Patrick's surname at birth, and when did he become Brontë?", in its research note N11.
- **Do.** Open *Research questions and notes*. Press **+**, then *Research note*. Enter the text and a *Status*, which is a plain box. The note cannot be tied to a person, so name the person in the text.
- **Guide.** New task *Add a research note*.
- **Help.** `research.list`.
- **Picture.** `img-research-notes`.
- **You know it worked when** the question is in the list.

#### 7.2 Record two records that disagree

- **Learning objective.** After this step, you can keep two records that disagree, side by side, without deleting either.
- **Status.** Part walked on Windows. When *Compare records that disagree* is offered has been put to the app team.
- **Brontë data.** T03, how old Anne was when she died (Anne in focus). D01, the date of the 1812 marriage, is a simpler alternative.
- **Do.** Add the second source to the fact. Both stay on the sheet. *Compare records that disagree* was offered on a birth and not on a burial. It opens *Evidence*: the conclusion, and what each source says. How to record a source that says something different has not been found.
- **Guide.** New task *Record evidence that disagrees*.
- **Picture.** New `img-compare-records`.
- **You know it worked when** both records are still there.

#### 7.3 Reach a conclusion, and say how sure you are

- **Learning objective.** After this step, you can weigh evidence, state a conclusion and say what it rests on.
- **Good practice.** Two records from one informant count as one piece of evidence.
- **Status.** Walked on Windows.
- **Brontë data.** T05: why the 1841 census gives Patrick's age as 60. Adults' ages in that census were rounded down to a multiple of five, so the census and the baptism disagree by design.
- **Do.** Complete the research note, as text, with the evidence, the reasoning and the confidence.
- **Guide.** Worked example in the good practice guide.
- **You know it worked when** a stranger could follow your reasoning from the note alone.

#### 7.4 Leave a question open, and record where you looked

- **Learning objective.** After this step, you can leave a question open honestly, and record a search that found nothing.
- **Good practice.** Not finding something is a fact about the search, not about the person.
- **Status.** Walked on Windows.
- **Brontë data.** T02, where in County Down Patrick was born. NS1: Charlotte's death in 1855 is not indexed under Brontë, and was found under Nicholls.
- **Do.** There is no separate place for a search. Write it in the research note: where you looked, under what name and what came back.
- **Guide.** New task *Record a search that found nothing*.
- **You know it worked when** the note says where you looked and why you stopped.

### Stage 8: add a picture and a record

**Stage objective.** After this stage, you can add a picture to a person and use a form that matches a real record.

**Good practice.** Say where a picture came from and who may reuse it.

#### 8.1 Add a picture from a file

- **Learning objective.** After this step, you can add a picture to a person, describe it for people who cannot see it, and say where it came from.
- **Status.** Part walked.
- **Brontë data.** M08, the portrait of Patrick, with its licence from [media.md](../content/sample-data/bronte/media.md). M01 waits until its licence is settled.
- **Do.** In the person's Photos area, add from a file. Write the description the app asks for.
- **Guide.** *Add a photo*; *The Photos buttons*; *Files beside your tree*.
- **Picture.** `img-photo-link`.
- **You know it worked when** the picture is on Patrick's page.

#### 8.2 Take a picture with the camera

- **Learning objective.** After this step, you can photograph a document, straighten it and add it to a person.
- **Status.** Walked on the Android phone. A simulator has no camera, so iPhone and iPad are described in words.
- **Brontë data.** None in the file. Photograph a plain sheet of paper for the walk, and never anything private.
- **Do.** Allow the camera. *Take photo*. In *Crop & deskew* drag the corners and press *Done*. In *Describe this image* write a description. Then revoke the permission.
- **Guide.** *Take a photo* (platform).
- **Picture.** None. Words only, as the camera is an operating-system screen.
- **You know it worked when** a picture card appears in Photos.

#### 8.3 Use a form for a real record

- **Learning objective.** After this step, you can pick the form that matches your record, and fill in a whole household at once.
- **Status.** Part walked. **Saving a census for a new household failed on the Alpha-2 walk.** The Brontës use an existing household, so walk that path, and check the new-household path again on the next build. On Windows the form was read but not saved, because the image has not been read.
- **Brontë data.** E015: the 1841 census, Haworth, 6 June 1841, once its image has been read. This may need the extension people X01 and X03. Patrick's age is written as 60. Do not correct it.
- **Do.** From Patrick, Add a record, *More forms*, 1841 Census. Choose his household. Check the date already filled in. Fill in the household. The household lists everyone in the family, even people who had died by that date, so remove each one who was not there.
- **Guide.** *Fill in a form*; *Record a census household with a form*.
- **Help.** `forms.compose`.
- **Picture.** New `img-household-choice` and `img-census-form`.
- **You know it worked when** the census shows among Patrick's events. Write down what it adds for the rest of the household.
- **Also.** Name the other forms in the reference (birth, baptism, marriage, burial records and the 1851 to 1921 censuses and the 1939 register). The 1861 census is the last that could include Patrick, so the later forms have no Brontë example.

### Stage 9: look after the tree

**Stage objective.** After this stage, you can find anyone, keep a safe copy, and give someone else a copy.

#### 9.1 Find someone by another name

- **Learning objective.** After this step, you can find a person when you only know another spelling or name.
- **Status.** Walked on Windows. A search for Maria is still to be checked by hand.
- **Brontë data.** Search for Brunty, Prunty and Nicholls. Search Maria for the two people who share the name.
- **Do.** Search. Under *Refine by*, switch on *Approximate (sound-alike) matches*.
- **Guide.** *Find a person*; *Search and refine*.
- **Help.** `search`, `home`.
- **Picture.** `img-search-results`, `img-search-refine`.
- **You know it worked when** Brunty finds Patrick, and Bruntee finds the Brontës with sound-alike matches on, and nobody with them off.

#### 9.2 Check the tree, and deal with duplicates

- **Learning objective.** After this step, you can spot two entries that might be the same person.
- **Status.** Not walked. **On Alpha-2 we have found no screen for checking a tree, and merging two people is reserved with no screen.** Do not write a task for either. Write a short concept on what a careful reader looks for, using the two Marias, who are *not* duplicates.
- **Help.** `people.merge` stays without help until a screen exists.

#### 9.3 Make a copy of the tree

- **Learning objective.** After this step, you can make a copy of your tree and find it again.
- **Status.** Part walked (Alpha-1). On Windows the first question was walked, and no copy has been saved on Alpha-2.
- **Brontë data.** The finished tree.
- **Do.** In Workspaces, press **Save as…**. Choose *Everything (.gdz, recommended)* or *Family tree only (.ged)*. Windows then opens its own Save window. Note where it was saved.
- **Guide.** *Keep it safe* (platform); *Which file to send*; *Where your trees are saved* (Windows); glossary *backup*, *saved copy*, *family tree file*.
- **Picture.** `img-save-as-choice`, `img-save-as-version`, `img-save-as-message`.
- **You know it worked when** the file is there and has a size.

#### 9.4 Bring a tree in, and prove the copy works

- **Learning objective.** After this step, you can open a tree from a file, read what the app says it brought in, and be sure that your copy is whole.
- **Status.** Part walked (Alpha-1). **Exporting and opening again were not on the Alpha-2 walk, so do this one by hand on the closed build.**
- **Brontë data.** The file from 9.3, opened into an empty throwaway folder.
- **Do.** Add from file. Read the summary. Compare the counts with the stage 9 saved state. Spot-check Charlotte, one source and one research note.
- **Guide.** *Open a family tree file*; *Opened files and copies*; *Import a family tree file*.
- **Picture.** `img-import-summary`.
- **You know it worked when** the counts match, and Charlotte's names, sources and picture are still there.

#### 9.5 Send a copy to someone

- **Learning objective.** After this step, you can send a copy of your tree to someone, and know what is in it and what is not.
- **Status.** Not walked.
- **Brontë data.** The finished tree.
- **Do.** Export. Use the device's share route. Write down whether photos and notes go with it.
- **Guide.** *Share a copy of your tree*. The privacy topic waits for the app to offer that choice (Q27).
- **You know it worked when** the other person can open the file.

#### 9.6 Remove a tree

- **Learning objective.** After this step, you can remove a tree from the app and know what happens to the file.
- **Status.** Walked. On Windows the next tree opens and the file stays in its folder.
- **Brontë data.** A scratch tree. **Never the Brontë build.**
- **Do.** In Workspaces, Remove. Write down the question the app asks.
- **Guide.** *Remove a workspace*.
- **Picture.** `img-remove-workspace`.
- **You know it worked when** the tree has gone from the list, and you can say whether the file is still on the device.

#### 9.7 Finish the file and the guide

- **Learning objective.** For the authors: after this step, the guide, the help and the file agree with each other.
- **Status.** Not started.
- **Do.** Export the finished tree. Compare it with the reference workspace ([dataset strategy, section 6](dataset-strategy.md#6-how-it-is-built)). Offer it to the app team as a fuller sample (DEC-112, DEC-116). Write the one DNA topic (DEC-037) and the troubleshooting chapter from what the walk actually went wrong on.
- **You know it worked when** the two workspaces match, or each difference is explained.

## 7. Help text

Help has three layers.

| Layer | What it is | How this walk feeds it |
|---|---|---|
| The words on screen | Labels, hints and empty states | Each step records the exact words. Wording that does not work goes to the app team once, with the walk's findings. |
| The help button | A map from each screen to a page | Each topic carries its `resourceid`. The map is built by `build/scripts/new-help-map.ps1`, and says `published` only once every page exists (DEC-196). |
| The Quick Start and task finder | Ten minutes to a first success, and "I want to" | Stages 0, 1, 2 and 6 in miniature. Each entry links to a step's topic. |

**The screens.** These are the 25 in `build/help/screens.csv`. The help line is the draft opening sentence of the page, in the reader's words. All are drafts until the step is walked.

| Screen | Step | Draft help line | Page state |
|---|---|---|---|
| `about` | 0.5 | See which version of uFTi you have. | Has a page |
| `add.record` | 2.2, 4.1 | Choose what you want to add. | Has a page; widen beyond people |
| `events.date` | 2.3 | Enter a date, even one you are not sure of. | Has a page |
| `events.list` | 4.4 | See everything that happened in a person's life, in order. | Has a page |
| `families.view` | 3.2 | See a family: the partners, their children and their marriage. | **Write** |
| `forms.compose` | 4.1, 8.3 | Fill in a form that matches your record. | **Write** |
| `home` | 0.2, 9.1 | Start here: find a person or carry on where you left off. | Has a page |
| `more` | 0.2 | Find the parts of the app that are not on the main bar. | **Write** for phone and tablet |
| `notes.list` | 5.2 | See all the notes in this tree. | Short description; expand |
| `notes.record` | 5.1 | Read or add the notes on this person or family. | Short description; expand |
| `people.edit` | 2.1 | Add a person, or change what you know about them. | Has a page |
| `people.list` | 2.2 | See everyone in this tree. | **Write** |
| `people.merge` | 9.2 | No help until the screen exists. | Reserved |
| `people.name` | 2.5 | Enter a name, and any other names this person used. | Check against *Names* |
| `people.view` | 0.3 | See what is known about this person. | Has a page |
| `places.place` | 2.4 | Enter a place, from the smallest part to the largest. | Check against *Places* |
| `repositories.list` | 6.1 | Keep a list of the places where records are kept. | Short description; expand |
| `research.list` | 7.1 | Keep track of the questions you are trying to answer. | Short description; expand |
| `search` | 9.1 | Find a person, even under another name. | Has a page |
| `settings` | 0.4 | Choose how the app looks. | Has a page |
| `sources.sheet` | 6.3 | Say where you found this fact. | Has a page |
| `sources.view` | 6.4 | See what supports this fact. | Has a page |
| `submitters.list` | 1.2 | Say who made this tree. | Short description; expand |
| `tree.view` | 3.4 | See how the family fits together. | Has a page |
| `workspaces.list` | 1.3 | See your family trees and open the one you want. | Has a page |

Page state is for Windows. The other manuals have fewer pages; `new-help-map.ps1` lists each one's gaps.

**The task finder.** Entries map to steps like this:

| Entry | Step | Entry | Step |
|---|---|---|---|
| 1 Start my family tree | 1.1 | 11 Bring in a tree | 9.4 |
| 2 Add a person | 2.1, 2.2 | 12 Make a copy | 9.3 |
| 3 Add parents, partner or children | 3.1 | 13 Fix a mistake or remove a person | 2.6, 2.7 |
| 4 See my tree as a picture | 3.4 | 14 Add a second family | 3.3 |
| 5 Find someone | 9.1 | 15 Record where a document is kept | 6.1 |
| 6 Record a birth, marriage or death | 2.1, 3.2, 4.1 | 16 Keep track of a question | 7.1 |
| 7 A date I am not sure of | 2.3 | 17 Two records that do not agree | 7.2 |
| 8 Say where I found something | 6.3 | 18 Send my tree to someone | 9.5 |
| 9 Add a photo | 8.1, 8.2 | 19 Keep living people private | Waits for Q27 |
| 10 Write down what someone told me | 5.1 | 20 What the Brontë sample is for | 0.3 |

## 8. The pictures

Every picture is captured at its stage, with its focus person on the [allow-list](../content/sample-data/bronte/allow-list.md).

| Key | Step | Stage | Focus | Note |
|---|---|---|---|---|
| `img-start-first-run` | 0.1 | 0 | None | First run |
| `img-nav-main` | 0.2 | 0 | None | Crop any other sample tree |
| `img-person-view` | 0.3 | 0 | Charlotte | |
| `img-family-tree-charlotte` | 0.3 | 0 | Charlotte | Written description in the topic |
| `img-preferences` | 0.4 | 0 | None | Dark variant once |
| `img-create-workspace-dialog` | 1.1 | 1 | None | |
| `img-submitters` | 1.2 | 1 | None | |
| `img-workspaces` | 1.3 | 1 | None | Crop other sample trees and any file path |
| `img-person-add` | 2.1 | 2 | Patrick | |
| `img-add-record` | 2.2 | 2 | Charlotte | |
| `img-people-list` (new) | 2.2 | 2 | None | |
| `img-date-editor` (new) | 2.3 | 2 | Charlotte | Before leaving the box |
| `img-date-not-sure` (new) | 2.3 | 2 | Maria (P03) | Before leaving the box |
| `img-person-edit` | 2.5 | 2 | Charlotte | |
| `img-family-form` | 3.1 | 3 | Patrick | |
| `img-family-children` | 3.1 | 3 | Patrick | |
| `img-name-question` (new) | 3.1 | 3 | Patrick | System window on Apple devices and Windows |
| `img-family-page` | 3.2 | 3 | Patrick | |
| `img-tree-marriage` | 3.3 | 3 | Charlotte | |
| `img-family-tree` | 3.4 | 3 | Patrick | Written description in the topic |
| `img-add-record-lower` | 4.1 | 4 | Branwell | |
| `img-add-record-more-forms` | 4.1 | 4 | Branwell | |
| `img-event-detail` | 4.1 | 4 | Branwell | |
| `img-events` | 4.4 | 4 | Branwell | |
| `img-note-form` | 5.1 | 5 | Maria (P02) | |
| `img-notes` | 5.2 | 5 | None | |
| `img-repositories` | 6.1 | 6 | None | |
| `img-source-new` | 6.2 | 6 | None | |
| `img-sources-list` | 6.2 | 6 | None | |
| `img-sources-empty` | 6.3 | 6 | Emily | Before the source is added |
| `img-source-attach` | 6.3 | 6 | Emily | |
| `img-citation-add` | 6.3 | 6 | Emily | |
| `img-sources-one` | 6.4 | 6 | Emily | |
| `img-research-notes` | 7.1 | 7 | Patrick | |
| `img-compare-records` (new) | 7.2 | 7 | Anne | |
| `img-photo-link` | 8.1 | 8 | Patrick | |
| `img-household-choice` (new) | 8.3 | 8 | Patrick | |
| `img-census-form` (new) | 8.3 | 8 | Patrick | |
| `img-search-results` | 9.1 | 9 | Patrick | |
| `img-search-refine` | 9.1 | 9 | Patrick | |
| `img-save-as-choice` | 9.3 | 9 | None | |
| `img-save-as-version` | 9.3 | 9 | None | |
| `img-save-as-message` | 9.3 | 9 | None | |
| `img-import-summary` | 9.4 | 9 | None | |
| `img-remove-workspace` | 9.6 | 9 | None | A scratch tree |

That is 45, above the budget of 25 to 40 per manual. A manual only takes the keys for its idiom, and the three `img-save-as` pictures may be Windows only. If a manual still goes over 40, drop first the pictures that show a result the words already give (`img-sources-list`, `img-add-record-lower`).

**Where a driver cannot reach**

| Limit | What to do |
|---|---|
| iPhone and iPad tab bar, People cards, the second Add source step | Go by route, or do it by hand |
| System sheets on iPhone, iPad and Mac | By hand, or an operating-system capture |
| Android: a scrolled page comes out stretched | Capture at the top of the page, or by hand |
| The in-app capture leaves out the Add a record page and the sources sheet on the Android phone | Capture by hand |
| Windows: system windows (the name question, Save as, Add from file) | Capture by hand. The Save window needs a person |

A hand capture follows the same catalogue entry ([screenshot strategy, section 4.5](screenshot-strategy.md#45-manual-capture-fallback)).

## 9. What is left out

| Left out | Why |
|---|---|
| The app's AI features | Out of scope. Pages and pictures are written without them (DEC-020). |
| Sync and web, command-line and assistant surfaces | Out of scope |
| DNA features | One topic on risks and issues (DEC-037) |
| The app's other sample trees | The Brontë family is the only dataset shown |
| Merging people, checking a tree | No screen on Alpha-2 (step 9.2) |
| Spanish | A later edition with its own family (DEC-038) |

## 10. From the walk to the published site

1. Finish stages 0 to 9 on the reference device.
2. Replay on the other devices. Record variants and findings.
3. Make the one set of page changes (DEC-214).
4. Import the pictures, write their alternative text, and review the change report.
5. Set `release` and `app-version` in `build/publications.ini`, after archiving the old release.
6. Build. Messages starting `GOVK`, `DOTX` or `DSPDF` must be zero.
7. Run `build/scripts/check-source.ps1`, `build/scripts/check-samples.ps1` and `check-site.ps1`.
8. Publish, so the help map can move from proposed to published.
9. Walk the help rows again (1.15, 3.4 and 4.6 of the sheet), now that their pages exist.
10. Run the Quick Start with novices. Four of five must finish alone in ten minutes.

## 11. Open points

| # | Point | Proposed answer |
|---|---|---|
| 1 | The first-run sample is called "Brontë family of Haworth", the same as the tree we build. | Answered on Windows: the app accepts the same name and shows the new tree with "(2)" after it, until the sample is removed and the app restarted. For the capture run, explore the sample at stage 0, then remove it before stage 1. For readers, tell them to give their practice tree a different name. |
| 2 | Arthur Bell Nicholls's second marriage (E146) is the only true second family, but his wife is not in the core. | Keep the core as it is. Step 3.3 teaches with Charlotte. Adding her needs a privacy row and an allow-list row first. |
| 3 | The date box rewrites dates in short capital forms, which no page may show. | Picture the box before it is left, and describe the *Reads as* line. The app team has been told. |
| 4 | Which reader-facing name goes with a shared note, if the app has one | The app says *Shared with 1 other record*. Use "shared note". |
| 5 | Second reader of the evidence register (Q20) | Still needed before the file goes out as the sample. |
| 6 | The app has no kind of name for a pen name. | Use *Professional name*, with "Pen name" in *Kind, in words*, and say so on the *Names* page. Ask the app team for the kind. |
| 7 | The app has no way to name your own kind of event. | Use the kind *Event* and start the *Notes* box with the word, as in step 4.3. A person decides whether the page tells it that way. |
| 8 | A research note cannot be tied to a person. | Name the person in the note. Change the specification, which attaches each note to people. |
| 9 | Only named records were entered on the first walk, so the saved states of stages 4 to 9 are not reached. | Enter the rest at each stage when the walk is repeated on the reference device. |
