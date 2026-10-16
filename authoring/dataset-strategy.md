# Dataset strategy

How we build the small illustrative dataset the manual teaches with: the family of the Reverend Patrick Brontë of Haworth and his literary children, shown as research in progress.

Part of the [authoring plan](authoring-plan.md). Status: Draft 0.4, 16 October 2026. Decisions are tracked in the [decision log](decision-log.md).

## 1. Decision and purpose

**DEC-025, amended by DEC-031.** The manual's running example is a small illustrative dataset about Patrick Brontë (1777 to 1861), perpetual curate of Haworth, and his family. It includes his children Charlotte, Emily and Anne, who wrote novels, and their brother Branwell. We build it **by using the process**: by performing the manual's own tasks, in order, in the app. And it shows **research as it is**: questions, competing evidence, searches that found nothing, conclusions with a stated confidence, and threads left open.

It lets us show the whole user journey with one story. A reader creates a workspace, adds and enriches people and families, adds notes, events, sources and repositories, and follows a research thread to a conclusion.

It is used for:

- the Quick Start, where a reader explores the bundled sample before typing anything (needs Q19);
- the first-family-tree tutorial, which builds the dataset from nothing;
- the examples in task, concept and reference topics;
- every screenshot, with the exceptions in [section 3](#3-scope);
- the worked examples in the good practice guide, so a reader meets the same people in the guide as in the tutorial.

## 2. Why this family

| Reason | Detail |
|---|---|
| Documented | The family is the subject of published scholarship, registers, census returns, certificates and archives, so every claim can be tied to evidence we have seen. |
| Long dead | Patrick outlived all six of his children, and none of them is known to have left children, so no living person appears. WP4b confirms this from sources before anyone relies on it. |
| Small and readable | One couple, six children and one later marriage: a tree a reader takes in at once, even on a phone. |
| Rich enough | It touches every feature the manual teaches ([section 4](#4-what-the-dataset-shows)). |
| Rich in contradictions | Works and records differ on names, places and dates. That is teaching material, not a problem: it gives the research threads real substance. |
| Familiar | Many readers know the story, and a Yorkshire setting suits a British English manual with UK-leaning examples (DEC-038). |

## 3. Scope

- **Core, about ten people.** Patrick Brontë. His wife Maria, born Branwell. Their six children: Maria, Elizabeth, Charlotte, Branwell, Emily and Anne. Arthur Bell Nicholls, Charlotte's husband. Two families: Patrick and Maria with their children, and Charlotte and Arthur.
- **Extensions, only if a topic needs them (Q21, decided in WP4b).** Maria's sister Elizabeth Branwell, who joined the household. Patrick's and Maria's parents, for a three-generation view. Household servants named in a census return.
- **Indicative size.** 10 to 20 people, 2 to 4 families, 30 to 50 events, 8 to 12 sources, 4 to 6 repositories, 10 to 15 notes, 3 to 6 media items and 3 to 5 research threads. WP4b fixes the real numbers.
- **Larger samples.** A few topics need more than a small tree, such as a five-generation view or search across thousands of people. For those, WP4 decides between extending this dataset upwards and using one of the app's larger sample workspaces. Either must pass the same privacy rules ([section 9](#9-privacy-and-care)).
- **Out of scope.** Settling debates that scholars have not settled: where a debate is useful for teaching, it is recorded as an open thread. Speculation about private lives. Living relatives of the family.

## 4. What the dataset shows

Every example below is a candidate. WP4b chooses real examples and records their evidence before they are used.

| Feature | Candidate example |
|---|---|
| Workspace and submitter | A workspace named "Brontë family of Haworth", with the author as submitter |
| Names | Patrick's birth surname, given in sources as Brunty and Prunty, and the spelling Brontë he adopted. The pen names Currer, Ellis and Acton Bell. Charlotte's married name, Nicholls. |
| Search | One person under several spellings, to show sound-alike search |
| Dates | Exact dates, dates that are only approximate, and a period such as Patrick's years at Haworth |
| Places | A hierarchy from the Parsonage at Haworth up to county and country, places whose county changed, and places in Ireland, Cornwall, Lancashire and Yorkshire |
| Events | Birth, baptism, marriage, death, burial, occupation, residence, education, and a custom event for the publication of a novel |
| Families | One couple with six children, and a later marriage |
| Notes | A shared note about the Parsonage, short notes on people, and research notes that hold a question and what was concluded |
| Repositories | The Brontë Parsonage Museum, a county archive service, The National Archives and the General Register Office |
| Sources and citations | Parish registers, census returns, death certificates, a probate record, a letter and a published biography: original, derivative and authored sources, and primary and secondary information |
| **Research threads** | A question, two or more pieces of evidence that disagree, how each was weighed, and either a conclusion with its confidence or a thread left open. Candidates: a birth year that differs between works; Patrick's surname and birthplace; an age in the 1841 census, which recorded adults' ages rounded down to a multiple of five, so it disagrees with a baptism by design. |
| **Negative evidence** | A search that found nothing, recorded as a fact about the search, not about the person |
| Age discrepancies | The guide's examples of ages understated at marriage and overstated at enlistment come from the dataset where it has a real case, and from a plainly fictional example where it has none |
| Media | A public-domain image, such as a portrait or a view of the Parsonage, with its licence recorded |
| Forms | A census household form for the Parsonage |
| Tree view | The family around Patrick and Maria, with the later marriage |
| Checks and export | Validating the finished workspace, and exporting it |

## 5. The journey

The stages follow the order a new reader would do things in. Each ends with a **saved state**, which the next stage starts from. Stage 0 is a newly installed app. Features and chapters are provisional until WP4 confirms them against the app.

| Stage | The reader's goal | What is added | Features shown | Chapters |
|---|---|---|---|---|
| 1. Create a workspace | Start a tree | An empty workspace, "Brontë family of Haworth", and the author as submitter | Workspaces, the create menu | S, 1, 2 |
| 2. Add people | Record who is in the family | Patrick and Maria, then their children: names, sex, birth and death dates and places | People, names, dates, places | S, 4 |
| 3. Link families | Show how they relate | The marriage of Patrick and Maria with the six children linked, and later the marriage of Charlotte and Arthur | Families, relationships, the tree view | 5, 3 |
| 4. Add events | Record what happened | Baptisms, burials, occupations, residences, education and publications | Events, complex dates | 6 |
| 5. Add notes | Keep context and questions | A shared note, short person notes, and research notes | Notes, research notes | 8 |
| 6. Add repositories and sources | Show where each fact came from | Repositories, then the sources held in them, then citations on facts with the quality of the evidence | Repositories, sources, citations | S, 7 |
| 7. Follow a research thread | Decide what to believe | A question, two sources that disagree, each weighed, and a conclusion with its confidence or an open question, recorded in a research note | Reconcile evidence, quality fields, research notes | 7, 8, guide |
| 8. Add media and a form | Enrich with a picture and a record | A public-domain image linked to a person, and a census household form | Media, forms | 9, 10 |
| 9. Check, search and share | Look after the tree | Validation, a search across name variants, and an export | Checks, search, export | 2, 3, 11 |

Chapter S is the Quick Start ([content model](content-model.md#3-the-quick-start)), which uses stages 1, 2 and 6 in miniature.

## 6. How it is built

The dataset is not prepared in advance and loaded. It is built by doing the tasks, and checked by a second route that must agree with the first (DEC-039).

1. **Specify (WP4b).** List every person, family, event, note, repository, source, media item and research thread, each tied to a stage and to the evidence register ([section 8](#8-evidence-sources-and-licensing)).
2. **Write each task by doing it.** An author writes a task topic by performing it in the app, starting from the previous stage's saved state and adding the next piece of data. The topic's steps are the steps they took, so every task is verified before it is reviewed.
3. **Replay it.** The capture scripts in the application repository replay the same journey, stage by stage, on each emulator, simulator and Windows profile, and capture the screens in the catalogue where they occur ([screenshot strategy](screenshot-strategy.md)). If a replay fails, the topic's steps are out of date.
4. **Build the reference workspace with the MCP.** A script in the application repository builds the same workspace straight from the specification through the app's own MCP tools, stage by stage. It is fast, repeatable and independent of any device.
5. **Compare.** The replayed workspace and the reference workspace are exported and compared at the end of each stage. A difference is a bug in a topic, in the specification, or in the app. Screenshots and task verification come only from the replay; the reference workspace is the check, and the source of the bundled sample (Q19).
6. **Save each stage.** The scripts export the workspace at the end of each stage. Any chapter can then start from the right point, and a reader can follow along from any stage.

The dataset, the topics and the screenshots come from the same run, so they cannot drift apart. A change to the specification is re-captured on the next release candidate (DEC-023).

## 7. Where things live

| Piece | Where |
|---|---|
| The specification and the evidence register, as plain text | This repository, in `content/sample-data/bronte/` (proposed) |
| The replay scripts and the MCP build script | The application repository (DEC-022, DEC-039) |
| The saved stage states and the finished workspace, as GEDCOM or GEDZIP | This repository, under one allowed path, if readers are to download them (Q18). That needs a narrow exception to the rule that ignores `*.ged`, `*.gdz` and `*.gedzip`. |
| A built-in sample in the app | The application repository. An app decision (Q19), and one the Quick Start depends on. |

## 8. Evidence, sources and licensing

This is a teaching dataset, so it has to be honest about what is known and how. It also has to model the practice the good practice guide teaches, which is managing evidence, not collecting facts.

1. **Nothing is invented.** Uncertain is not invented: an uncertain claim goes in with its evidence and its doubt. A claim with no evidence at all stays out.
2. **The evidence register.** For each claim, each piece of evidence: the source, how it was consulted (the original, an image, a transcription, an index, a published work), its reference, what it says, its quality (original, derivative or authored; primary or secondary information), who checked it and when. And the claim's status: confirmed by independent evidence; sources disagree, thread open; sources disagree, concluded, with the reasoning; single source; searched and not found. WP4b creates it. Nothing enters the dataset without its evidence.
3. **Contradictions are data.** When sources disagree, record both, record the thread that weighs them, and never choose silently. A conclusion says which evidence it rests on and how confident we are. A thread can stay open.
4. **Negative searches are recorded.** Looking and not finding is evidence about the search.
5. **Cite what you used.** If we saw a transcription or an index rather than the original record, the citation says so and does not claim the original as seen.
6. **Real, precise references.** Archive references, register names, folio and piece numbers are copied from the item, never reconstructed.
7. **Our own words.** Notes and summaries are written fresh. We never copy text from biographies, encyclopaedias, Wikipedia or museum pages. A short phrase may be quoted, with attribution, only where a note needs it.
8. **Authorities.** Published scholarship, public-domain works such as Elizabeth Gaskell's 1857 life of Charlotte Brontë, archive catalogues and civil registration indexes. Where authorities disagree, we record the disagreement.
9. **Media.** Public domain, or openly licensed on terms compatible with ours. Provenance and licence are recorded for each item. No scans from subscription sites or from archives that restrict reuse. No photographs of living people.
10. **A plain statement.** The manual says the dataset is a research workspace in progress, built for learning. It is not a complete or authoritative genealogy of the family.

**Licensing.** Our own text and structure are Apache-2.0, like everything here. Facts are not copyright. Third-party media keep their own terms, recorded in the register.

## 9. Privacy and care

- **No living people.** Everyone in the core dataset died long ago, and the latest death among them is over a century ago. WP4b confirms each date and confirms that the children left no descendants. The importer's allow-list ([screenshot strategy](screenshot-strategy.md#5-import)) is the people in the specification, plus any approved from another named sample workspace.
- **Plain treatment of hard subjects.** The family's story includes the early deaths of children, illness and addiction. Record dates and facts plainly. Do not speculate about causes or private lives beyond what sources support. Use the content-note pattern ([good practice strategy, section 9](good-practice-strategy.md#9-sensitive-subjects)) where a topic dwells on a death. The reading level means young readers, so the plain treatment matters doubly.
- **No sides in debates.** Where scholars disagree, the dataset records the evidence and the open thread.

## 10. How it is used

- **One story.** The same people appear in the Quick Start, the tutorial, the task examples, the screenshots and the guide. No other invented people.
- **A focus person for each chapter,** fixed in the screen catalogue.
- **Worked examples in the guide** come from the dataset, for example citing a baptism entry, classing a census return, or weighing two sources that disagree.
- **Spelling.** Write Brontë with the diaeresis in text. File names, keys and folders use `bronte`.
- **No tags.** The dataset is described in the manual in human terms only: people, families, facts, sources. Never a GEDCOM tag, record name or line of a file (DEC-030).
- **Other samples** remain for topics that need scale (see [section 3](#3-scope)).

## 11. The MCP and the data dictionary

**The MCP** (DEC-039). The app exposes its data model through MCP tools that can create workspaces, people, families, events, notes, sources, repositories and citations, validate a workspace and export it. That is the right tool for building the reference workspace from the specification, for checking the replayed workspace against it, and for producing the saved stage states and the bundled sample. It is the wrong tool for anything a reader sees: screenshots and task verification come from the real interface, because the manual documents the interface. The MCP itself is out of the manual's scope (DEC-002).

**The data dictionary** (DEC-030). The app's data model follows the GEDCOM 7 standard, whose structure definitions say what each kind of fact, name part, date, place and source holds, and which values are allowed. Those definitions, and the app's own schema resource, are the **source of meaning** for the field reference and the glossary: a term in the manual means what the standard means by it, in plain words, keyed by the label on screen. They are never the thing shown. No tag, record name or structure appears in the manual, because they are not human-centred.

## 12. Work packages

| Package | What it contributes |
|---|---|
| WP0 | The journeys are tested with the bundled sample where it exists, so the dataset is the first thing novices see. |
| WP4b | The specification, the stage map, the evidence register and the research threads, and the first checked set: people and families. |
| WP4 | The screen catalogue refers to stages and decides where a larger sample is needed. |
| WP5 | The importer checks each image's focus person against the allow-list. The existing pictures, which show other samples, are left behind. |
| WP7 | Builds stages 1, 2, 3, 6 and 7 as it writes the Quick Start and the pilot chapters. |
| WP8 | Completes stages 4, 5, 8 and 9. |
| WP9 | The guide's worked examples and the research-thread topics. |
| WP11 to WP13 | Replay the journey on each new manual. |
| WP16 | A second family for the Spanish edition ([section 13](#13-other-languages-other-families)). |

## 13. Other languages, other families

Each language edition has its own family, chosen by the same criteria, so that examples feel local and the records are in the reader's language (DEC-038). The journey stages, the screen catalogue and the evidence register are shared, and a second dataset slots into the same structure. The English edition leans towards the United Kingdom. A Spanish edition leans towards Latin America.

**Criteria for a family**

1. Well documented in public sources in that language: registers, census or padrón records, archives, published scholarship.
2. Long dead, with no known living descendants, so no living person can appear.
3. Neutral enough: not a figure of current political or religious division in the places where the edition is read.
4. Of public interest, such as a literary family, so readers recognise the story.
5. Rich in the contradictions research is made of: disputed dates, variant names, places whose names or borders changed.
6. Public-domain images available, with provenance.

**Candidates to check for Spanish.** None is chosen, and nothing below is asserted until WP16 checks it with a Spanish-speaking reviewer:

- *Sor Juana Inés de la Cruz* (New Spain, seventeenth century): a literary figure of the first rank, reported to have left no descendants, with a documented household and a well-known dispute over her year of birth, which is exactly the kind of thread the dataset exists to show. Leans Latin America.
- *Miguel de Cervantes* (Spain, sixteenth to seventeenth century): a well-documented family and baptism record, reported to have left no surviving line. Leans Spain, so a second choice for the stated preference.

WP16 gathers more candidates, checks them against the criteria, and records the choice and its evidence in the decision log.

## 14. Open points

| Point | Where decided |
|---|---|
| Where do the saved states and finished workspace live, and may readers download them? | Q18 |
| Does the app bundle the finished workspace as a built-in sample? The Quick Start depends on it. | Q19 |
| Who checks the evidence as a second reader, and which sources can they reach? | Q20 |
| Do we extend the core with parents and servants? | Q21, in WP4b |
| Which family for the Spanish edition, and who reviews it? | Q23, in WP16 |
