# Adversarial review of Draft 0.3

A deliberate attempt to find what is wrong with the plan, written on 16 October 2026 against the goals stated that day. Each finding records what changed because of it. The decisions it produced are DEC-026 to DEC-044 in the [decision log](decision-log.md).

## 1. The goals the plan was tested against

- **Make uFTi as easy as possible to use, without putting off anyone who does not want to read the manual.**
- The client will be **free**. Revenue may come later from **AI models** or a **record-sync service** across clients and platforms. The documentation must not block either.
- The project **may go open source** later.
- The maintainer's questions, answered in [section 4](#4-answers-to-the-questions-asked).

## 2. Verdict in one paragraph

Draft 0.3 is a sound plan for a *manual*. The goal is a product most people never read the manual for. The plan optimised the wrong thing: completeness over time-to-first-success, five full manuals over one ten-minute start, and a tidy dataset over the untidy reality of research. The toolchain, platform model, theme and dataset choices hold up. What changes is the shape of the content and the order of the work: journeys and a Quick Start first, in-app help as a deliverable, a dataset that shows research as it is, a measurable reading level, and a site plan for ufti.com.

## 3. Findings

Severity: **Blocker** (the plan would miss its goal), **Major** (a costly gap or wrong turn), **Minor** (a rule missing), **Observation** (worth recording, no change forced).

| # | Severity | Finding | Response | Where |
|---|---|---|---|---|
| F1 | Blocker | **Manual-first plan, manual-last goal.** Success criteria measure coverage (every feature has a topic). Nothing measures how fast a new user succeeds, and nothing reaches the person who never opens the manual. | A tiered content model: in-app help, a Quick Start, how-to, understanding, reference. The Quick Start is the first deliverable, not the last. Time-to-first-success becomes a success criterion. | [Content model](content-model.md), DEC-026, DEC-044, plan sections 1.5 and 3.1 |
| F2 | Blocker | **"Verified facts only" misreads research.** Draft 0.3 said a fact that cannot be verified stays out. Real research is managing threads and contradictory evidence: ages understated at marriage, overstated at enlistment, census ages rounded. A dataset that hides that teaches the wrong lesson and leaves the app's evidence features undemonstrated. | The dataset models research in progress: research questions, competing evidence, negative searches, conclusions with confidence, threads left open. The verification log becomes an evidence register that records what we found, where, and how it bears on each claim, contradictions included. | [Dataset strategy](dataset-strategy.md), DEC-031 |
| F3 | Major | **No measurable reading level.** "Plain English" is an intention. The target is an average 11-year-old. | Targets per topic: Flesch Reading Ease 70 or more, Flesch-Kincaid grade 6 or less, average sentence 15 words or fewer. Measured by Vale in CI. A glossary entry for every term that fails. | [Standards, section 11](authoring-standards.md#11-writing-style), DEC-029 |
| F4 | Major | **Platform as the organising axis.** Most of what differs for a reader is the idiom (phone, tablet, desktop): layout, navigation, gestures. The operating system matters at the edges: installing, updating, permissions, files, accessibility features, backup. The plan organised by platform. | Idiom first, platform at the edges. Topics are written for an idiom; platform tokens are used only for the edge list. Outputs stay one per device, and the chooser asks "What device?". | [Platform strategy, section 2.3](platform-strategy.md#23-idiom-first-platform-at-the-edges), DEC-032 |
| F5 | Major | **No plan for ufti.com.** The plan assumed the manuals are the whole web presence, on GitHub Pages with no domain. A product needs marketing pages, store listings, a privacy page, support, an accessibility statement, and the manuals under them. | A site strategy: marketing at the root, manuals under `/docs/`, the good practice guide as a public resource, a collateral list, hosting options. | [Site strategy](site-strategy.md), DEC-033, Q4 answered |
| F6 | Major | **Statements that could block the business model.** A topic that says "uFTi is free", "your data never leaves your device" or "there is no account" becomes false the day a sync service or a paid model ships. | Topics never state pricing, "free", "forever", accounts or data-location promises. Those live on marketing pages and in keys. Sync and AI are absent until shipped, and the structure leaves room for them. | [Site strategy, section 6](site-strategy.md#6-business-model-independence), DEC-040 |
| F7 | Major | **Spanish deferred while the app ships Spanish.** The app launches in British English and Spanish. English-only documentation leaves Spanish-speaking users with nothing on day one. | Spanish at v1 for the Quick Start and installation, the full manual later. A Spanish edition uses its own family, chosen by criteria, leaning Latin America. | Plan WP16, DEC-038, Q6 answered, Q23 |
| F8 | Major | **No exit from a young toolchain.** The plugin is 1.x and the PDF generator 0.x, both from one organisation. Pinning limits surprise; it does not give a way out. | Keep the DITA pure. A smoke build with the toolkit's stock HTML5 transformation runs in CI to prove the sources never depend on the plugin. | [Build and quality, section 4](build-and-quality.md#4-quality-gates), DEC-042 |
| F9 | Major | **Screenshot replay is an operations programme the plan does not own.** Five devices, scripted replay, every release candidate: that is real engineering in the application repository, with no fallback if it slips. | Wave 1 only before v1. A manual capture fallback that follows the same catalogue and manifest, so documentation is never blocked by automation. The owner is named. | [Screenshot strategy, section 4.5](screenshot-strategy.md#45-manual-capture-fallback) |
| F10 | Major | **No user journeys before building.** The plan jumps from audiences to an inventory of 150 topics. The dataset journey is a feature journey, not a user journey. | WP0: five to seven journeys, one page each, tested with novices before the pilot. They decide the Quick Start, the chapter order and the in-app help map. | [Content model, section 4](content-model.md#4-user-journeys), DEC-027 |
| F11 | Minor | **GEDCOM tags would leak.** Field references and the glossary would naturally reach for tags and record names. They are not human-centred. | Never show tags, structures or raw file content. The GEDCOM 7 structure definitions are the source of *meaning* for fields, rendered in plain words. | [Standards, section 1](authoring-standards.md#1-dita-profile), DEC-030 |
| F12 | Minor | **DNA scope too wide.** The guide planned a DNA theme if the app supported it. | One topic: the risks and issues of DNA testing. No how-to, no recording DNA. | [Good practice strategy, section 5](good-practice-strategy.md#5-themes-and-candidate-topics), DEC-037, Q15 answered |
| F13 | Minor | **One modality.** Text and screenshots only. People take things in differently, and the evidence is that offering several routes to the same idea helps everyone, while sorting readers into fixed "learning styles" does not. | Universal design: every key concept is offered as see, read, do and check. Clickable diagrams, the sample to play with, tasks, checklists. | [Content model, section 6](content-model.md#6-learning-modalities), DEC-035 |
| F14 | Minor | **No diagram standard.** The plugin inlines SVG so links inside it work, and the plan said nothing about it. | Clickable SVG diagrams as a standard element, with accessibility rules, theme colours and a PDF fallback. | [Standards, section 7](authoring-standards.md#7-images-figures-and-tables), DEC-036 |
| F15 | Minor | **Video unconsidered.** Embedding video would raise a plugin warning, cut across the "no third-party requests" stance, and swell hosting. | Video is never embedded. If made, it is hosted elsewhere and linked, with captions and transcripts, and the manual stands without it. | [Screenshot strategy, section 11](screenshot-strategy.md#11-video-and-animation), DEC-034 |
| F16 | Observation | **The GOV.UK look may feel institutional** for a family product. The theme brings the app's fonts and colours, but the layout still says "government service". | Test in the pilot's usability sessions. Keep marketing pages on the same Design System so there is one look. Recorded as risk R16. | Plan section 9 |
| F17 | Observation | **A PDF of a phone app's manual has few readers.** It is a stated requirement, so it stays, but it should not shape the website. | The PDF link sits in the footer. The guide's PDF and the Quick Start's two-page PDF are the ones people are likely to want. | [Content model, section 3](content-model.md#3-the-quick-start) |
| F18 | Observation | **Over-planning.** About two thousand lines of plan and no topics. | A minimum viable set for the first app release (DEC-044), and the pilot starts as soon as the toolchain passes. | Plan section 8 |
| F19 | Observation | **No feedback loop.** No analytics by design, so no idea what readers use or where they fail. | None for v1. A feedback link and issues. Revisit with ufti.com hosting, where privacy-respecting logs exist. | DEC-043 |
| F20 | Observation | **The good practice guide is a marketing asset.** Evergreen "how to start family history" content draws people to a free client, which is the business model. | The guide is a first-class public resource on ufti.com, linked from the marketing navigation, not buried in the manuals. | [Site strategy, section 2](site-strategy.md#2-information-architecture) |
| F21 | Observation | **DITA is a contributor barrier** if the project goes open source. | Templates, lint and AI-assisted drafting lower it. If the app opens, review the contributor path and the disclosure boundary. | DEC-041 |
| F22 | Observation | **Some UI words fail the 11-year-old test.** "Repository" and "Submitter" are the app's labels. The manual must use them, and can explain them, but cannot change them. | WP4 produces a plain-language audit of UI labels for the app team. The documentation is a usability test of the product. | Plan WP4 |
| F23 | Observation | **Young readers.** An 11-year-old reading level implies school projects and young family members. That raises sharing, living relatives and hard subjects. | A journey for a young person's first tree. Content notes for hard subjects already exist. | [Content model, section 4](content-model.md#4-user-journeys) |
| F24 | Minor | **The guide could preach.** | Never required reading. A cue is one line. The guide is optional depth, offered where it helps. | [Good practice strategy, section 2](good-practice-strategy.md#2-principles) |

## 4. Answers to the questions asked

| Question | Answer | Where |
|---|---|---|
| A Quick Start? | Yes, and first. One per device, ten minutes, seven short pages with one picture each, ending with "what next" by journey. It is its own bookmap, so it gets its own two-page PDF. | [Content model, section 3](content-model.md#3-the-quick-start) |
| Video? | Not embedded. If made at all: short silent clips, and later narrated overviews, hosted elsewhere and linked, with captions and transcripts. Nothing in the manual depends on them. Not at v1. | DEC-034, [screenshot strategy, section 11](screenshot-strategy.md#11-video-and-animation) |
| User journeys before build? | Yes. They are cheap, and they decide the Quick Start, the chapter order and the help map. WP0, before the pilot. | DEC-027 |
| Verified facts, or research threads? | The review agrees with the correction. The dataset shows research as it is: competing evidence, negative searches, open questions, conclusions with confidence. | DEC-031 |
| Platform or idiom? | Idiom for the body of the content; platform for installing, updating, permissions, files, accessibility features and backup. Outputs stay one per device. | DEC-032 |
| ufti.com and marketing collateral | A site strategy: marketing at the root, manuals under `/docs/`, the guide public, a collateral list including store listings, and hosting options. | DEC-033, [site strategy](site-strategy.md) |
| Use the MCP to create the Brontë dataset? | Yes, for a reference workspace built from the specification and for validation. No, for screenshots and task verification, which must come from the real interface. The two routes must agree. | DEC-039 |
| Use the GEDCOM data dictionary for field definitions? | Yes, as the source of meaning, never as something shown. The field reference is generated from the structure definitions in plain words, keyed by the label on screen. | DEC-030 |
| Other families for other languages? | Yes. One family per language edition, chosen by criteria, with the journey and screen catalogue shared. For Spanish, lean Latin America. Candidates to check are listed; none is chosen. | DEC-038, [dataset strategy, section 13](dataset-strategy.md#13-other-languages-other-families) |
| Language for an 11-year-old | Made measurable and enforced. | DEC-029 |
| Clickable SVG diagrams | Adopted as a standard element. The plugin inlines SVG so links work. | DEC-036 |
| Learning styles | Several routes to each idea for everyone, not a sorting of readers. | DEC-035 |
| DNA | Risks and issues only. | DEC-037 |
| GEDCOM tags | Never shown. | DEC-030 |
| UK-leaning English, Latin America for Spanish | Recorded as the example policy for each edition. | DEC-038 |

## 5. What was challenged and kept

- **DITA, topic-based.** Right for single-sourcing five manuals, a guide and a Quick Start from one set of topics, and for in-app help by stable identifiers. The cost is the contributor barrier (F21).
- **The plugin and PDF/UA.** The plugin gives accessibility, semantics and metadata for free. The exit strategy (F8) makes the dependence safe.
- **Five manuals by device.** The reader gets exactly their device. Idiom-first authoring (F4) keeps the cost down.
- **The Brontë family.** A good choice made better by showing its contradictions (F2).
- **Apache-2.0 for the documentation.** Compatible with a later open-source app.

## 6. Not blinkered: things outside the documentation that the plan now feeds

- A plain-language audit of UI labels (F22).
- A request to the app for an in-app help hook: a per-screen identifier and a way to open a URL (Q22).
- A request to bundle the finished Brontë workspace as a sample (Q19), which makes the Quick Start possible without typing.
- A note that the app's own first-run experience is tier 0 of the content model, and that the documentation can supply its wording.
