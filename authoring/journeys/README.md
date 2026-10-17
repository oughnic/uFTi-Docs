# User journeys and Quick Start design (WP0)

What people are trying to do when they open uFTi, and the ten-minute Quick Start designed from it. These are authoring documents, not DITA topics. They are not published.

Part of the [authoring plan](../authoring-plan.md#8-delivery-plan), work package WP0, tracked as [issue #6](https://github.com/oughnic/uFTi-Docs/issues/6). Status: draft for testing, 16 October 2026. Decisions are in the [decision log](../decision-log.md). The format and the goals come from the [content model](../content-model.md), sections 3 and 4.

## 1. What is here

| Document | What it is | State |
|---|---|---|
| [Journey 1: Starting from nothing](journey-1-starting-from-nothing.md) | "I know my grandparents' names." | Draft, to test |
| [Journey 2: Bringing a tree across](journey-2-bringing-a-tree-across.md) | "My tree is in another program or website." | Draft, to test |
| [Journey 3: Recording a find](journey-3-recording-a-find.md) | "I have a certificate. Where does it go?" | Draft, to test |
| [Journey 4: Checking a doubt](journey-4-checking-a-doubt.md) | "Two records give different ages." | Draft, to test |
| [Journey 5: A young person's project](journey-5-a-young-persons-project.md) | A school project: living relatives, and what to share. | Draft, to test |
| [Journey 6: Sharing with family](journey-6-sharing-with-family.md) | "My cousin wants a copy." | Draft, to test |
| [Journey 7: Getting a photo in](journey-7-getting-a-photo-in.md) | "My aunt gave me a box of photographs." | Draft, to test |
| [Quick Start outline: Android phone](quick-start-android-phone.md) | Seven pages, each with its picture, steps and links. | Draft, to test |
| [Quick Start outline: Windows](quick-start-windows.md) | The same seven pages for Windows. | Draft, to test |
| ["Five things to know" outline](five-things-to-know.md) | One concept, under 300 words, read in two minutes. | Draft, to test |
| [Task finder: "I want to"](task-finder.md) | Twenty entries in the reader's words, each mapped to a topic. | Draft, to test |
| [Screens that need a help target](help-targets.md) | Forty screens from the app's visible navigation. | Draft, for WP4 |
| [Novice sessions: the plan](novice-session-plan.md) | How to test all of this with three to five people. | Ready to run |

## 2. How to use these documents

1. Read the seven journeys. Each is one page.
2. Run the sessions from the [session plan](novice-session-plan.md). It needs nothing else.
3. Write up the findings as the plan says, in this folder.
4. Revise the journeys, the Quick Start outlines, the task finder and the help-target list from the findings.
5. Accept them into the plan. The proposed decisions DEC-056 to DEC-059 then become accepted, and the chapter order in [section 5](#5-what-the-journeys-decide) replaces the provisional outline in the plan.
6. Pass the findings about the app's own first-run experience to the app team.

WP0 is done when all six steps are done ([plan, section 8](../authoring-plan.md#8-delivery-plan)).

## 3. What is fixed, and what is provisional

**Fixed by the plan.** Seven Quick Start pages of under 150 words with one picture each (DEC-026). Journeys before build (DEC-027). The reading level (DEC-029). No GEDCOM tags (DEC-030). Nothing about price, accounts or where data lives (DEC-040). The Brontë dataset for every example (DEC-025). Idiom first, platform at the edges (DEC-032).

**Provisional until WP4.** Every screen name, label and route through the app. These documents say what we expect to see. Each one marks what is **to confirm**. Nobody has yet walked a release build with these pages in hand: that is what the sessions are for.

**Depends on two open questions.** Q19, whether the app bundles the Brontë sample: Quick Start page 3 needs it. Q22, whether every screen has a Help control: the help-target list is built either way.

## 4. Devices

The journeys and outlines are written for the two wave-1 devices, Android phone and Windows (DEC-021). Each journey has a section on what differs on a tablet or an iPhone. In short:

- A **tablet** shows the list and the page side by side, like Windows, so fewer people lose their place. Pictures are landscape. Everything else follows the phone.
- An **iPhone or iPad** needs its own Quick Start pages 1 and 6: the App Store, and the share sheet with Files. Camera screens have no screenshot, because the simulator has no camera.

## 5. What the journeys decide

The content model gives the journeys five things to decide. They are the Quick Start's what-next links, the order of chapters, the task finder, the in-app help map, and which topics are written first. Here is each.

### 5.1 The Quick Start's what-next links

Seven journeys become three links and the task finder (DEC-057).

| Link on page 7 | Journeys | Opens |
|---|---|---|
| Build your first tree | 1, 5 | The first-tree tutorial |
| Bring your tree across | 2 | Import a family tree file |
| Record what you have found | 3, 7 | Add a source to a fact, Add a photo |
| I want to | 4, 6 and the rest | The [task finder](task-finder.md) |

### 5.2 The order of chapters

Proposed. The [provisional outline](../authoring-plan.md#34-provisional-manual-outline) put files and workspaces at chapter 2 and search at chapter 3. The journeys say people meet those later: everyone starts by adding people, and most meet import, export and sharing only in Journeys 2 and 6.

| # | Chapter | Why here | Journeys |
|---|---|---|---|
| S | Start here: the Quick Start | First, by design | All |
| 0 | Front matter | | |
| 1 | Get started: install, first launch, a tour, create a workspace, the first-tree tutorial | Everyone's first hour | 1, 5 |
| 2 | People | The first thing everyone adds | 1, 5 |
| 3 | Families and the tree | The second thing, and the first picture of success | 1, 5 |
| 4 | Events, dates and places | The first facts, and the first uncertain date | 1, 3, 4, 5 |
| 5 | Sources, citations and evidence | The first document, and the first doubt | 3, 4 |
| 6 | Photos and media | The box of photographs | 3, 5, 7 |
| 7 | Notes and research notes | Stories, then questions | 1, 4, 5 |
| 8 | Find and browse | Needed once the tree is bigger than a screen | 2, 3 |
| 9 | Bring in, share and keep safe: workspaces, import, export, sharing, backup | The switcher and the steward | 2, 6 |
| 10 | Create records with forms | | |
| 11 | Keep your tree healthy | | 2 |
| 12 | Settings, language and accessibility | | |
| 13 | Troubleshooting and support | | |
| 14 | Reference | | |
| GP | Good practice guide | | |

Three things change from the provisional outline. Workspaces and files move from chapter 2 to chapter 9, and "create a workspace" stays in Get started. Find and browse moves from chapter 3 to chapter 8. People, families, events, sources, media and notes all move up. Reserved chapter names are unchanged (DEC-040).

### 5.3 The task finder

Twenty entries, in the [task finder](task-finder.md). Twelve are in the first release.

### 5.4 The in-app help map

Forty screens, in the [help-target list](help-targets.md). Twenty-four are in the first release.

### 5.5 The topics written first

The ten tasks for the minimum first release (DEC-044), from the journeys:

1. Create a workspace
2. Add a person
3. Add a parent, partner or child
4. View the family tree
5. Find a person
6. Add an event
7. Add a source to a fact
8. Add a photo
9. Import a family tree file
10. Export a family tree file

Near misses, written straight after: Add a note, Enter a date you are not sure of, Add a research note, Share a copy of your tree.

## 6. What the journeys found about the app

Each journey ends with notes for the app team, tier 0 of the content model. Gathered here, before any session has run:

- The first screen needs one line that says what to do (Journey 1).
- The words *submitter*, *repository*, *citation* and the date *quality* words need plain labels or hints (Journeys 1, 3, 4).
- A person in no family needs a nudge to add one (Journey 1).
- An import needs a summary: what came in, what was skipped, where the photos are (Journey 2).
- Export needs to say what the copy contains, and whether living people or pictures can be left out (Journey 6, Q27).
- A way to share a picture of the tree would complete the school project (Journey 5, Q28).
- Merging someone else's changes is asked for and not possible. It belongs with the reserved sync chapter (Journey 6).

The sessions will add to this list. It goes to the app team when WP0 closes.

## 7. Conventions in these documents

- **"Their words"** are in quotation marks. They are what we expect people to say. The sessions replace them with what people said.
- **Tiers** follow the content model: *Screen* is tier 0, *Quick Start* is tier 1, *Task* is tier 2, *Concept* and *Guide* are tier 3, *Reference* and *Glossary* are tier 4.
- **Topic titles** are provisional. WP4's inventory fixes them.
- **Picture keys** follow the screenshot strategy: `img-<area>-<what>`, the same key in every manual.
- **Bold labels** are what we expect to see on screen. **To confirm** marks anything nobody has checked against a release build.
- **The reading level** is the manual's (DEC-029): short sentences, plain words, British English.
