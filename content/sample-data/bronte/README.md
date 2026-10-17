# The Brontë dataset: specification and evidence register

The manual teaches with one small dataset about the family of the Reverend Patrick Brontë of Haworth, built by performing the manual's own tasks in the app and shown as research in progress (DEC-025, DEC-031). This folder is its specification: what goes into the workspace at each stage of the journey, and the evidence for every claim.

**Plain statement.** This is a research workspace in progress, built for learning. It is not a complete or authoritative genealogy of the family. Where the sources we found disagree, we say so. Where we could not find something, we say that too.

**Status.** Draft specification from work package WP4b, 16 October 2026 ([issue #11](https://github.com/oughnic/uFTi-Docs/issues/11)). Drafted with AI assistance and reviewed by the maintainer in the pull request. The second reader's check (Q20) is pending: every row of the evidence register is marked "Draft" until a named person has checked it.

## The files

| File | What it holds | Records |
|---|---|---|
| [people.md](people.md) | The nine people of the core, their names and variants, and the extension people that are not in the core | P01 to P09; X01 to X05 |
| [families.md](families.md) | The two families and what the sources say about the marriages | F01, F02 |
| [events.md](events.md) | Every event, with dates and places exactly as each source gives them | E001 to E148 |
| [notes.md](notes.md) | The shared note, the person and family notes, and one research note per thread | N01 to N17 |
| [repositories.md](repositories.md) | The archives and offices that hold the sources | R01 to R10 |
| [sources.md](sources.md) | Everything we consulted, how we consulted it, and the references copied from each item; and the sources named but not opened | S01 to S31 |
| [media.md](media.md) | Placeholders for images, with the licence check each needs. No image is included | M01 to M04 |
| [research-threads.md](research-threads.md) | Five threads for stage 7, the smaller discrepancies concluded in the register, and the negative searches | T01 to T05; D01 to D12; NS1 to NS6 |
| [evidence-register.md](evidence-register.md) | One row per claim: evidence, kind, status, who checked it | C001 to C150 |
| [privacy-check.md](privacy-check.md) | The evidence that every person in the core died long ago and left no descendants | |
| [allow-list.md](allow-list.md) | The people a screenshot may show | |
| [teaching-moments.md](teaching-moments.md) | What we found that the manual can teach with, and what could not be verified | |

## The stage map

The journey's stages are defined in the [dataset strategy, section 5](../../../authoring/dataset-strategy.md#5-the-journey). Each stage ends with a saved state. This is what each stage adds from this specification.

| Stage | The reader's goal | What this specification supplies | Focus person |
|---|---|---|---|
| 1 | Create a workspace | A workspace named "Brontë family of Haworth", with the author as submitter | None |
| 2 | Add people | P01 to P09 with their names, variants, sex, and the birth and death events marked stage 2 in [events.md](events.md) | P05 Charlotte |
| 3 | Link families | F01 and F02, with the marriage events E010 and E061 | P01 Patrick |
| 4 | Add events | Every event marked stage 4: baptisms, burials, education, occupations, residences, publications, the will and the probate | P06 Branwell |
| 5 | Add notes | N01 (shared), N02 to N10 and N16 to N17 (people and families) | P02 Maria |
| 6 | Add repositories and sources | R01 to R10; the sources S03 to S13 attached to the facts they support, with their kind and quality from the register | P07 Emily |
| 7 | Follow a research thread | T01 to T05, each recorded in its research note N11 to N15, with the register rows it concludes or leaves open | P08 Anne (T03) and P01 Patrick (T01, T02, T05) |
| 8 | Add media and a form | M01 once its licence is settled; the 1841 census household (E015) once the image has been read, which may need the extension people X01 and X03 | P01 Patrick |
| 9 | Check, search and share | The duplicate names (P02 and P03), the name variants of P01 for sound-alike search, the negative searches NS1 and NS6 for "where I looked", validation and export | P01 Patrick |

Stage 0 is a newly installed app. The Quick Start uses stages 1, 2 and 6 in miniature, with Charlotte as its focus.

## How to read the evidence register

Each row in [evidence-register.md](evidence-register.md) has:

- **Claim**: a stable id (C001 to C150) that the other files cite.
- **What is claimed**: one sentence, in our words.
- **Evidence**: each source that bears on it, by source id, with what it says, quoted or closely paraphrased. If a source was consulted as a transcription or an index, [sources.md](sources.md) says so and the register does not claim the original was seen.
- **Kind**: O (original), D (derivative) or A (authored), and P (primary information) or S (secondary information). The abbreviations are explained at the top of the register.
- **Status**: one of five words.
- **See**: the thread (T), discrepancy (D) or negative search (NS) that weighs it.
- **Checked**: "Draft" until a second reader replaces it with their initials and date.

| Status | Meaning | Count |
|---|---|---|
| Confirmed | Independent evidence agrees and nothing credible contradicts it | 61 |
| Disagree, concluded | Sources disagree; a thread or discrepancy row says which we follow and how sure we are | 12 |
| Disagree, open | Sources disagree and we do not conclude | 4 |
| Single source | One source only; true as far as we know, but unconfirmed | 21 |
| Not found | We looked in the places named and did not find it | 3 |

**Two records, one informant.** Where two records agree because they came from the same person (the first memorial tablet and the burial register, for example), the register treats them as one piece of evidence. Thread T03 explains.

## Conventions

- **Ids** are stable. A record keeps its id when it changes; a deleted record's id is not reused.
- **Dates and places are copied as each source gives them.** "Sept. 15th, 1821, in the 39th year of her age" stays as written in the evidence column. The claim column gives the plain form. An uncertain year is a range with its thread, never a guess.
- **Our own words.** Notes and summaries are written fresh. Short quotations from sources appear in quotation marks with the source id. Nothing is copied from biographies, encyclopaedias or museum pages into the notes.
- **No GEDCOM tags, record names or file contents** anywhere in these files (DEC-030). People, families, facts, sources.
- **Spelling.** Brontë with the diaeresis in text; `bronte` in file names and ids. Names of other people and places are spelled as the sources spell them.
- **Numbers.** The real numbers of the specification: 9 people (plus 5 extension candidates), 2 families, 85 event rows (9 births, 8 baptisms of which 2 not found, 3 marriages, 9 deaths, 9 burials of which 2 dated, 12 education, 17 occupation, 8 residence, 10 publication, 5 other), 17 notes, 10 repositories, 31 sources, 4 media placeholders, 5 research threads, 12 smaller discrepancies and 6 negative searches.

## How the build script reads this

The reference workspace is built from this specification through the app's own tools (DEC-039), stage by stage, by a script in the application repository. The files are Markdown tables with one record per row and a stable id in the first column (DEC-045), so a script can parse them without a second format. The build order is the stage column: a record enters the workspace at the stage its row names, and the saved state at the end of each stage includes every record of that stage and earlier. The replayed workspace from the capture scripts must match it at the end of each stage.

## Licensing

Our text and structure are Apache-2.0, like the rest of this repository. The facts are not ours to own. Quotations from the sources are short and attributed. Third-party media, when added, keep their own terms, recorded in [media.md](media.md).

## Changing this specification

Open an issue, change the files on a branch, and update the evidence register in the same change. A new claim needs a row with its evidence. A changed conclusion needs its thread updated. A person added to the core needs a privacy row and an allow-list row. Decisions go in the [decision log](../../../authoring/decision-log.md).

## What happens next

- **Second reader (Q20):** checks the register rows, starting with the open threads and the single-source rows, and the items in [teaching-moments.md](teaching-moments.md#what-could-not-be-verified).
- **WP7** builds stages 1, 2, 3, 6 and 7 from this specification while writing the Quick Start and the pilot chapters.
- **WP8** completes stages 4, 5, 8 and 9, reads the 1841 census image, and settles the media items.
- **WP9** writes the research-thread topics and the guide's worked examples from T01 to T05 and the teaching moments.
