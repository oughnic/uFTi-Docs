# Good practice strategy

How we teach family history research good practice to readers who are new to it.

Part of the [authoring plan](authoring-plan.md). Status: Draft 0.4, 16 October 2026. Decisions are tracked in the [decision log](decision-log.md).

## 1. Why this content exists

Many uFTi readers are new to family history research. A tree application makes it easy to record a claim and just as easy to copy someone else's. Without a method, trees fill up with facts that are uncited, unchecked, or attached to the wrong person.

uFTi has features that support good method: sources, repositories, citations, research notes, a way to reconcile evidence and quality fields on dates. The manual should help readers use them well, at the moment they matter, without delivering a lecture.

## 2. Principles

- **Help, do not lecture.** Advice appears where the reader is making a decision.
- **Never required reading.** The guide is optional depth. A cue in a task is one line and one link, and nobody has to read the guide to use the app (DEC-026).
- **Method over trivia.** How to decide what to believe, what to record and what to share.
- **A tree shows conclusions; research is a process.** A family tree file, like the screens of the app, holds what the researcher currently concludes. The route to it (what each source said, where they disagreed, how they were weighed, what is still open) survives only if the researcher keeps it on purpose. The guide says so, and shows how (DEC-117).
- **Show how uFTi supports it.** Every piece of guidance ends with links to the tasks that put it into practice.
- **Cite authorities. Do not invent rules.**
- **Be honest about uncertainty.** Where practice varies, say so and say why.
- **Be inclusive and respectful.** Make no assumptions about families, names or cultures.
- **Do not assume a country.** Where practice depends on place, say so.
- **Be neutral.** No endorsement of commercial record services.
- **Write in plain English.** No jargon without an explanation.

## 3. Scope boundary

| In scope | Out of scope (link to an authority instead) |
|---|---|
| Research method and planning | Tutorials on searching particular record types or archives |
| Recording and citing | Reading old handwriting |
| Evaluating and reconciling evidence | Comparisons of other software or services |
| Handling uncertainty | Legal advice |
| Privacy and ethics, especially for living people | Medical genetics guidance |
| Sharing, export, backup and preservation | Commercial endorsements |
| The risks and issues of DNA testing, in one topic (DEC-037) | How to use DNA, or recording DNA as evidence (DEC-037). AI tools and AI features (DEC-020). |

Out-of-scope subjects get a short pointer to an authoritative guide, except AI, which is simply not covered. The link check covers those links.

## 4. Where good practice appears

| Mechanism | What it is | DITA form | Example |
|---|---|---|---|
| **Contextual cue** | A short, labelled hint inside a task or concept, at the point of decision, with one link to the guide | A callout pattern chosen in WP2 | In "Add a source": a cue about recording where you found the record |
| **Guide concept** | A short explanation of a method idea | `concept` in the guide part | Original, derivative and authored sources |
| **Guide task or checklist** | Something to do or check, tied to uFTi | `task`, or `reference` for checklists | Check a record before you add it |
| **Learning path** | The first-tree tutorial, interleaving doing and good practice | A map with `collection-type="sequence"` | Your first family tree |
| **Glossary entry** | A plain definition of a research term | `glossentry` | Primary information |

- **Wiring.** Relationship tables in the maps link each task to the guide topics behind it, and back. A cue is never the only place something is explained.
- **Cue rules.** One idea, no more than about 40 words, one link. Cues never block or scold.
- **Where the guide lives.** As a part in every platform manual and as a standalone publication, built from the same topics (DEC-007).

## 5. Themes and candidate topics

Provisional. WP4 turns this into an inventory of about 40 to 60 topics.

| # | Theme | Candidate topics | Main types | uFTi features to link (confirm in WP4) |
|---|---|---|---|---|
| 1 | **Start well** | Start with yourself and work backwards. Collect what the family already has. Set a research question. Keep a research log. | concept, task | Workspaces, research notes |
| 2 | **Sources and evidence** | Original, derivative and authored sources. Primary and secondary information. Direct, indirect and negative evidence. Judging reliability. What "reasonably exhaustive" means. Recording where you looked. | concept, reference | Sources, repositories, evidence reconciliation, research notes |
| 3 | **Citing sources** | Why cite. What a good citation holds. Citing online records, images, family stories and DNA results. Keeping a consistent style. | concept, task, reference | Source and citation fields, repositories |
| 4 | **Recording facts accurately** | Names and their variants. Dates and uncertainty. Calendars, including the 1752 change in Britain. Places and boundaries that change. Relationship types: biological, adoptive, step, foster. Ages and approximations. | concept, task, reference | Complex dates (quality, precision, calendar), places, name fields, relationship types |
| 5 | **Analysing and concluding** | Managing a research thread: the question, the evidence for and against, and a conclusion with its confidence, or a thread left open. Comparing evidence. Resolving conflicts, and the common ones: an age understated at marriage, overstated at enlistment, or rounded down in the 1841 census. Same name, same person? Separating a hypothesis from a conclusion. Why not to copy unsourced online trees. Writing down a conclusion. Why a tree file holds conclusions while research is a process, and how to keep the route to a conclusion visible (DEC-117). | concept, task | Reconcile evidence, quality fields, research notes |
| 6 | **Looking after your tree** | Regular checks. Duplicates and careful merging. Sanity checks on dates and ages. Backups. | concept, task, reference | Checks, duplicates, backup (candidate) |
| 7 | **Privacy and ethics** | Living people. Sensitive findings. Permission and sharing. Data protection basics. Copyright of records and images. | concept, reference | Export and privacy options (to confirm) |
| 8 | **Sharing and keeping your research** | Choosing an export format. GEDCOM and its limits: it holds conclusions, not the research that led to them (DEC-117). Preserving media and notes. Passing it on. | concept, task | GEDCOM export, packaged exports (to confirm) |
| 9 | **DNA: risks and issues** | One topic only (DEC-037): what a test cannot prove, consent, privacy, unexpected results, and who else a result affects. No how-to, and no recording of DNA. | concept | None |
## 6. How research stages map to uFTi

This follows the five elements of the Genealogical Proof Standard (research reasonably exhaustively, cite sources, analyse and correlate evidence, resolve conflicts, write a sound conclusion), summarised in our own words.

| Stage | The researcher asks | uFTi features that help (confirm in WP4) |
|---|---|---|
| Plan | What do I want to find out? | Research notes |
| Collect | What have I found, and where? | Sources, repositories, media |
| Cite | Could someone else find it again? | Citations |
| Analyse | What does this evidence say? Do sources agree? Which thread does it belong to? | Reconcile evidence, date quality, research notes |
| Conclude | What do I believe, and how sure am I? | Events and facts, quality fields, notes |
| Share | What can I safely share? | Export, privacy options |
| Maintain | Is my tree still sound? | Checks, backups |

## 7. Sources of authority and rules for using them

| Area | Candidate authorities (verify the current edition before use) |
|---|---|
| Research method and proof | Board for Certification of Genealogists, *Genealogy Standards*, second edition, including the Genealogical Proof Standard |
| Source citation | Elizabeth Shown Mills, *Evidence Explained* |
| Data model and exchange | GEDCOM, the FamilySearch specification the app is built around |
| Records and archives | The National Archives research guides |
| Data protection | Information Commissioner's Office guidance |
| Ethics | Codes of conduct from genealogical societies and professional bodies |
| Plain English and accessibility | GOV.UK style guide and content design guidance |

Rules:

1. **Verify before use.** Check the current edition and wording of an authority before relying on it.
2. **Paraphrase.** Do not copy text, tables or examples from copyrighted works. Quote briefly, with attribution, only where a short quotation is needed.
3. **Cite.** Every guide topic ends with a "Further reading" list of authorities, as external related links.
4. **Prefer free, open sources** for links, and say when a resource is paid or members-only.
5. **Say when authorities differ,** and explain the choice made.
6. **Check links.** The link check runs in CI, and a human reviews the external links at each release.
7. **Legal and data protection topics** need expert review and carry a short statement that they are general information, not legal advice.

## 8. Writing and review rules

- **A fixed shape for guide concepts,** using ordinary DITA sections with standard titles: *Why it matters*, *What to do*, *Example*, *Common mistakes*, *In uFTi*, *Further reading*. No specialisation. A lint rule checks the titles.
- **Reading level.** The same targets as the manual (DEC-029): plain words, short sentences, and a glossary entry for every term.
- **Four routes.** Each key idea has a diagram, the concept, a task on the dataset and a checklist (DEC-035).
- **Examples** come from the Brontë dataset ([dataset strategy](dataset-strategy.md)), so a reader meets the same people in the guide as in the tutorial. Where an idea needs a case the dataset does not have, use a plainly fictional example. Never use a real private individual.
- **Length.** Aim for 500 words or fewer per concept.
- **Terms.** Link the first use of a research term in a topic to its glossary entry.
- **Accessibility.** Worked examples are text, not images. Tables have header rows.
- **Review.** A named, experienced genealogist reviews every guide topic and every cue (Q8). The review is recorded in the pull request.
- **Cycle.** Review the guide at least once a year, and sooner if a standard changes. Update `revised` dates only after a substantive review.

## 9. Sensitive subjects

Family history touches adoption, illegitimacy, unexpected parentage, same-sex relationships, gender identity, enslavement, forced migration, institutions, crime, mental illness, infant death, suicide and abuse.

- Write factually, respectfully and neutrally.
- Assume nothing about the reader's family or about what a "normal" family looks like.
- Explain historical terms in context. Quote an offensive historical word only when it is needed, and explain it.
- Where a topic may distress, add a short, standard content note at the top.
- Protect living people and children by default. Never use real living individuals in examples.
- Where a discovery may be upsetting, point to general sources of support without recommending a particular service.

## 10. Open points

| Point | Where decided |
|---|---|
| Who reviews the guide, and who reviews legal and data protection topics? | Q8 |
| Which callout pattern do we use for cues? | WP2 |
| Is the guide also published standalone? | DEC-007 |
| Should examples lean towards the UK? | Decide in WP3 with the style guide |
