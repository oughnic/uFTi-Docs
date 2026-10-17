# Content model

How the documentation serves people who do not read manuals, and the people who do.

Part of the [authoring plan](authoring-plan.md). Status: Draft 0.4, 16 October 2026. Decisions are tracked in the [decision log](decision-log.md).

## 1. The goal

Make using uFTi as easy as possible without putting off anyone who does not want to read the manual. So the documentation is designed from the outside in: what a person meets first is the smallest thing that gets them to success, and depth is there for those who want it.

## 2. Tiers

| Tier | What it is | Who makes it | Form |
|---|---|---|---|
| **0. In the app** | The words on screen, empty states, first-run hints and the help button. Most people never leave this tier. | The app. The documentation supplies wording and the help map ([section 5](#5-in-app-help)). | UI text, a link per screen |
| **1. Start here** | The Quick Start: ten minutes to a first success ([section 3](#3-the-quick-start)). | This repository | Seven short pages per device, and a two-page PDF |
| **2. How do I** | Task topics, one goal each, reached from search, the help button or the task finder. | This repository | Task topics |
| **3. Understand** | Concepts, and the good practice guide. Optional depth, never required reading. | This repository | Concept topics, the guide |
| **4. Look up** | Field references, event types, date formats, shortcuts, glossary. | This repository, partly generated | Reference topics |

Rules that follow:

- A reader must be able to succeed at tier 1 without tiers 2 to 4.
- Every task topic answers "how do I" in its first sentence and its steps, before any explanation.
- A concept is linked from the tasks that need it, never put in the way of them.
- Depth is one link away, never one scroll away.

## 3. The Quick Start

One Quick Start per device (DEC-026). Ten minutes. Seven pages, each under 150 words with one picture:

1. **Get uFTi** on this device (platform-specific).
2. **Look around**: what the main screens are for (idiom-specific).
3. **Explore a family**: open the bundled Brontë sample and find Charlotte (needs Q19).
4. **Add your first person**: yourself, or someone you know.
5. **Say where you found it**: attach a source to one fact, the first good practice cue.
6. **Keep it safe**: back up or export, platform-specific.
7. **What next**: three links chosen by journey ([section 4](#4-user-journeys)).

Also at tier 1:

- **Five things to know**, one concept under 300 words: workspaces, people and families, facts and sources, where things are saved, how to get help.
- **I want to**, a task finder: about twenty links in the reader's words, on the manual's home page.

The Quick Start is its own bookmap, so the plugin gives it its own print document and a two-page PDF. It is the first content written (WP7), tested with novices, and translated first (DEC-038).

**Measure.** Four out of five novices complete the Quick Start unaided in ten minutes or less. That is success criterion 8 in the plan.

## 4. User journeys

Before the pilot, WP0 writes five to seven journeys and tests them with three to five people who have never used the app (DEC-027). A journey is one page:

| Field | Content |
|---|---|
| Trigger | What happened to make this person open the app. |
| Person | Which audience, and what they already have (a tree elsewhere, a box of papers, nothing). |
| Steps | What they try to do, in their words, in order. |
| Questions | What they ask at each step, and what would stop them. |
| Content | The tier and topics that answer each step. |
| Success | How they know they are done. |

Candidate journeys, to be confirmed in WP0:

1. **Starting from nothing.** "I know my grandparents' names."
2. **Bringing a tree across.** "My tree is in another program or website."
3. **Recording a find.** "I have a certificate. Where does it go?"
4. **Checking a doubt.** "Two records give different ages."
5. **A young person's project.** A school family-history project: living relatives, and what to share.
6. **Sharing with family.** "My cousin wants a copy."
7. **Getting a photo in.** "My aunt gave me a box of photographs."

What the journeys decide: the Quick Start's "what next" links, the order of chapters, the task finder, the in-app help map, and which topics are written first.

The journeys are drafted in [`journeys/`](journeys/README.md), with the Quick Start outlines for the wave-1 devices, the "Five things to know" outline, the task finder, the help-target list and the plan for the novice sessions (WP0, [issue #6](https://github.com/oughnic/uFTi-Docs/issues/6)).

## 5. In-app help

The app opens the right page for the screen the person is on (DEC-028). That reaches the people who will never look for a manual.

- **Help map.** A generated file, per device and language, that maps a screen identifier to a page URL. The source is DITA's `resourceid` element in each topic (`appname="ufti"`, `appid="people.edit"`), so the mapping lives with the content and is checked by the build. WP7b delivers it.
- **Embedded view.** The plugin can show a page's content without its masthead, contents and footer when the page is framed with `?embed=1` (`govuk.embed=yes`). An app that shows a page in a frame gets a clean help panel. Opened directly in a browser, the same address shows the full page, so a copied link always works.
- **What the app must do** (Q22): give each screen a stable identifier, and open a URL from a help control, in a frame or a browser. An offline fallback (bundling the Quick Start in the app) is a later question.
- **Rule.** Every screen in the inventory has a help target. The coverage check fails on a screen without one.

## 6. Learning modalities

People take in the same idea in different ways. The evidence does not support sorting readers into fixed "learning styles" and writing differently for each. It does support offering several routes to the same idea, so everyone can choose. That is universal design for learning, and it is the rule here (DEC-035).

Every key concept is offered four ways:

| Route | Form | Example |
|---|---|---|
| **See** | A diagram, often clickable, or a screenshot | A diagram of how a source, a citation and a fact relate, with links to each |
| **Read** | The concept topic | What a citation is and why it matters |
| **Do** | A task on the Brontë dataset the reader can follow in the app | Attach a source to Charlotte's birth |
| **Check** | A short checklist | Three questions to ask before you trust a record |

Diagrams are SVG, inlined by the plugin so links inside them work, with the rules in the [standards, section 7](authoring-standards.md#7-images-figures-and-tables). The sample dataset is the "do" route for every task.

## 7. Video and animation

Not embedded, ever (DEC-034). The plugin has no video component, an embedded object raises a build warning, and hosting video would change the site's size and its "no third-party requests" stance. If video is made, it is hosted elsewhere and linked, with captions and transcripts, and nothing in the manual depends on it. The [screenshot strategy, section 11](screenshot-strategy.md#11-video-and-animation) says how it would be made.

## 8. Reading level

Written for an average 11-year-old (DEC-029), measured and enforced. The rules are in the [standards, section 11](authoring-standards.md#11-writing-style).

## 9. Progressive disclosure

- The short description says what a topic is for in one sentence. It appears in the navigation, search results and link previews.
- A task shows its steps before any explanation. Explanation is a linked concept.
- Detail that most readers do not need goes under a collapsible heading where the plugin supports it (WP2 checks which DITA elements it renders as the Design System's details component), otherwise in a linked topic.
- Search is a first-class path: the words readers use ("archive" for repository, "family tree file" for GEDCOM) go in keywords so search finds the page.

## 10. Measures

| Measure | Target | How |
|---|---|---|
| Time to first success | 4 of 5 novices finish the Quick Start unaided in 10 minutes | Usability sessions, WP7 and each release |
| Search success | 4 of 5 "I want to" questions reach the right page in one search | Session tasks |
| Help map coverage | Every inventoried screen has a target | Coverage check in CI |
| Reading level | Every topic within the targets | Vale in CI |
| Modalities | Every key concept has see, read, do and check | Inventory column |
