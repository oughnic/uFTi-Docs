# Dataset strategy

How we build the small illustrative dataset the manual teaches with: the family of the Reverend Patrick Brontë of Haworth and his literary children.

Part of the [authoring plan](authoring-plan.md). Status: Draft 0.3, 16 October 2026. Decisions are tracked in the [decision log](decision-log.md).

## 1. Decision and purpose

**DEC-025.** The manual's running example is a small illustrative dataset about Patrick Brontë (1777 to 1861), perpetual curate of Haworth, and his family. It includes his children Charlotte, Emily and Anne, who wrote novels, and their brother Branwell. We build it **by using the process**: by performing the manual's own tasks, in order, in the app.

It lets us show the whole user journey with one story. A reader creates a workspace, adds and enriches people and families, and then adds notes, events, sources and repositories.

It is used for:

- the first-family-tree tutorial, which builds the dataset from nothing;
- the examples in task, concept and reference topics;
- every screenshot, with the exceptions in [section 3](#3-scope);
- the worked examples in the good practice guide, so a reader meets the same people in the guide as in the tutorial.

## 2. Why this family

| Reason | Detail |
|---|---|
| Documented | The family is the subject of published scholarship, registers, census returns, certificates and archives, so every fact can be tied to a source we check. |
| Long dead | Patrick outlived all six of his children, and none of them is known to have left children, so no living person appears. WP4b confirms this from sources before anyone relies on it. |
| Small and readable | One couple, six children and one later marriage: a tree a reader takes in at once, even on a phone. |
| Rich enough | It touches every feature the manual teaches ([section 4](#4-what-the-dataset-shows)). |
| Honest about evidence | Works differ on some names, places and dates, which is real material for the good practice guide. |
| Familiar | Many readers know the story, and a Yorkshire setting suits a British English manual. |

## 3. Scope

- **Core, about ten people.** Patrick Brontë. His wife Maria, born Branwell. Their six children: Maria, Elizabeth, Charlotte, Branwell, Emily and Anne. Arthur Bell Nicholls, Charlotte's husband. Two families: Patrick and Maria with their children, and Charlotte and Arthur.
- **Extensions, only if a topic needs them (WP4b decides).** Maria's sister Elizabeth Branwell, who joined the household. Patrick's and Maria's parents, for a three-generation view. Household servants named in a census return.
- **Indicative size.** 10 to 20 people, 2 to 4 families, 30 to 50 events, 8 to 12 sources, 4 to 6 repositories, 10 to 15 notes and 3 to 6 media items. WP4b fixes the real numbers.
- **Larger samples.** A few topics need more than a small tree, such as a five-generation view or search across thousands of people. For those, WP4 decides between extending this dataset upwards and using one of the app's larger sample workspaces. Either must pass the same privacy rules ([section 9](#9-privacy-and-care)).
- **Out of scope.** Claims that scholars debate, such as who wrote what. Speculation about private lives. Living relatives of the family.

## 4. What the dataset shows

Every example below is a candidate. WP4b chooses real examples and verifies each before it is used.

| Feature | Candidate example |
|---|---|
| Workspace and submitter | A workspace named "Brontë family of Haworth", with the author as submitter |
| Names | Patrick's birth surname (given as Brunty, perhaps also Prunty) and the spelling Brontë he adopted. The pen names Currer, Ellis and Acton Bell. Charlotte's married name, Nicholls. |
| Search | One person under several spellings, to show sound-alike search |
| Dates | Exact dates, dates that are only approximate, and a period such as Patrick's years at Haworth |
| Places | A hierarchy from the Parsonage at Haworth up to county and country, places whose county changed, and places in Ireland, Cornwall, Lancashire and Yorkshire |
| Events | Birth, baptism, marriage, death, burial, occupation, residence, education, and a custom event for the publication of a novel |
| Families | One couple with six children, and a later marriage |
| Notes | A shared note about the Parsonage, short notes on people, and research notes that record a question and what was concluded |
| Repositories | The Brontë Parsonage Museum, a county archive service, The National Archives and the General Register Office |
| Sources and citations | Parish registers, census returns, death certificates, a probate record, a letter and a published biography: original, derivative and authored sources |
| Evidence and uncertainty | Facts where sources differ or are thin |
| Media | A public-domain image, such as a portrait or a view of the Parsonage, with its licence recorded |
| Forms | A census household form for the Parsonage |
| Tree view | The family around Patrick and Maria, with the later marriage |
| Checks and export | Validating the finished workspace, and exporting it |

## 5. The journey

The stages follow the order a new reader would do things in. Each ends with a **saved state**, which the next stage starts from. Stage 0 is a newly installed app. Features and chapters are provisional until WP4 confirms them against the app.

| Stage | The reader's goal | What is added | Features shown | Chapters |
|---|---|---|---|---|
| 1. Create a workspace | Start a tree | An empty workspace, "Brontë family of Haworth", and the author as submitter | Workspaces, the create menu | 1, 2 |
| 2. Add people | Record who is in the family | Patrick and Maria, then their children: names, sex, birth and death dates and places | People, names, dates, places | 4 |
| 3. Link families | Show how they relate | The marriage of Patrick and Maria with the six children linked, and later the marriage of Charlotte and Arthur | Families, relationships, the tree view | 5, 3 |
| 4. Add events | Record what happened | Baptisms, burials, occupations, residences, education and publications | Events, complex dates | 6 |
| 5. Add notes | Keep context and questions | A shared note, short person notes, and research notes | Notes, research notes | 8 |
| 6. Add repositories and sources | Show where each fact came from | Repositories, then the sources held in them, then citations on facts with the quality of the evidence | Repositories, sources, citations, reconcile evidence | 7 |
| 7. Add media and a form | Enrich with a picture and a record | A public-domain image linked to a person, and a census household form | Media, forms | 9, 10 |
| 8. Check, search and share | Look after the tree | Validation, a search across name variants, and an export | Checks, search, export | 2, 3, 11 |

## 6. How it is built

The dataset is not prepared in advance and loaded. It is built by doing the tasks.

1. **Specify (WP4b).** List every person, family, event, note, repository, source and media item, each tied to a stage and to a row in the verification log ([section 8](#8-accuracy-sources-and-licensing)).
2. **Write each task by doing it.** An author writes a task topic by performing it in the app, starting from the previous stage's saved state and adding the next piece of data. The topic's steps are the steps they took, so every task is verified before it is reviewed.
3. **Replay it.** The capture scripts in the application repository replay the same journey, stage by stage, on each emulator, simulator and Windows profile, and capture the screens in the catalogue where they occur ([screenshot strategy](screenshot-strategy.md)). If a replay fails, the topic's steps are out of date.
4. **Save each stage.** The scripts export the workspace at the end of each stage. Any chapter can then start from the right point, and a reader can follow along from any stage.
5. **Check the result.** The finished workspace is validated in the app and compared with the specification. A difference is a bug in one or the other.

The dataset, the topics and the screenshots come from the same run, so they cannot drift apart. A change to the specification is re-captured on the next release candidate (DEC-023).

## 7. Where things live

| Piece | Where |
|---|---|
| The specification: people, families, events, notes, sources and the verification log, as plain text | This repository, in `content/sample-data/bronte/` (proposed) |
| The replay scripts | The application repository (DEC-022) |
| The saved stage states and the finished workspace, as GEDCOM or GEDZIP | This repository, under one allowed path, if readers are to download them (Q18). That needs a narrow exception to the rule that ignores `*.ged`, `*.gdz` and `*.gedzip`. |
| A built-in sample in the app | The application repository. An app decision (Q19). |

## 8. Accuracy, sources and licensing

This is a teaching dataset, so it must be right. It also has to model the practice the good practice guide teaches.

1. **No invented facts.** Every fact comes from a source we have checked. If we cannot check it, it stays out. Or it goes in as an explicitly uncertain claim, with the doubt recorded, which teaches the uncertainty features.
2. **The verification log.** For each fact: the claim, the source consulted, how it was consulted (the original, an image, a transcription, a published work), who checked it and when, and the result. WP4b creates it. Nothing enters the dataset until its row is complete.
3. **Cite what you used.** If we saw a transcription or an index rather than the original record, the citation says so and does not claim the original as seen.
4. **Real, precise sources.** Archive references, register names, folio and piece numbers are copied from the item, never reconstructed.
5. **Our own words.** Notes and summaries are written fresh. We never copy text from biographies, encyclopaedias, Wikipedia or museum pages. A short phrase may be quoted, with attribution, only where a note needs it.
6. **Authorities.** Published scholarship, public-domain works such as Elizabeth Gaskell's 1857 life of Charlotte Brontë, archive catalogues and civil registration indexes. Where authorities disagree, we record the disagreement.
7. **Media.** Public domain, or openly licensed on terms compatible with ours. Provenance and licence are recorded for each item. No scans from subscription sites or from archives that restrict reuse. No photographs of living people.
8. **A plain statement.** The manual says the dataset is an example for learning. It is not a complete or authoritative genealogy of the family.

**Licensing.** Our own text and structure are Apache-2.0, like everything here. Facts are not copyright. Third-party media keep their own terms, recorded in the log.

## 9. Privacy and care

- **No living people.** Everyone in the core dataset died long ago, and the latest death among them is over a century ago. WP4b confirms each date and confirms that the children left no descendants. The importer's allow-list ([screenshot strategy](screenshot-strategy.md#5-import)) is the people in the specification, plus any approved from another named sample workspace.
- **Plain treatment of hard subjects.** The family's story includes the early deaths of children, illness and addiction. Record dates and facts plainly. Do not speculate about causes or private lives beyond what sources support. Use the content-note pattern ([good practice strategy, section 9](good-practice-strategy.md#9-sensitive-subjects)) where a topic dwells on a death.
- **No sides in debates.** Where scholars disagree, the dataset records the neutral fact and the disagreement.

## 10. How it is used

- **One story.** The same people appear in the tutorial, the task examples, the screenshots and the guide. No other invented people.
- **A focus person for each chapter,** fixed in the screen catalogue.
- **Worked examples in the guide** come from the dataset, for example citing a baptism entry, classing a census return, or reconciling two sources.
- **Spelling.** Write Brontë with the diaeresis in text. File names, keys and folders use `bronte`.
- **Other samples** remain for topics that need scale (see [section 3](#3-scope)).

## 11. Work packages

| Package | What it contributes |
|---|---|
| WP4b | The specification, the stage map and the verification log, and the first checked set: people and families. |
| WP4 | The screen catalogue refers to stages and decides where a larger sample is needed. |
| WP5 | The importer checks each image's focus person against the allow-list. The existing pictures, which show other samples, are left behind. |
| WP7 | Builds stages 1, 2, 3 and 6 as it writes the pilot chapters. |
| WP8 | Completes stages 4, 5, 7 and 8. |
| WP9 | The guide's worked examples. |
| WP11 to WP13 | Replay the journey on each new manual. |

## 12. Open points

| Question | Where decided |
|---|---|
| Where do the saved states and finished workspace live, and may readers download them? | Q18 |
| Does the app bundle the finished workspace as a built-in sample? | Q19 |
| Who checks the facts as a second reader, and which sources can they reach? | Q20 |
| Do we extend the core with parents and servants? | Q21, in WP4b |
