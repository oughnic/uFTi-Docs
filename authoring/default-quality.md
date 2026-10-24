# Default quality

What quality the app gives a source by default when it records how much weight the source deserves for a fact, and why. The source for the manual's reference topic and for the good practice guide's topic on the same subject.

Part of the [authoring plan](authoring-plan.md). Status: Draft, 21 October 2026. Decisions: DEC-118 (accepted) and DEC-119 (proposed) in the [decision log](decision-log.md). The defaults in section 3 are the owner's, confirmed on 21 October 2026. Nothing here is published until it has been checked against the released build (DEC-118).

## 1. What quality means here

Quality is how much weight a source deserves for one fact, judged from how the information was recorded. It is not a verdict on whether the fact is true (DEC-119, proposed). A citation holds one quality, because a citation is the link between one fact and one source.

The GEDCOM standard describes it as the submitter's evaluation of how credible a piece of information is, based on its supporting evidence. It says the value is not meant to replace the reader's own judgement, and GEDCOM 7.0 adds that the numbers have no arithmetic meaning. The standards describe the four levels by the kind of evidence. We keep their order and their meaning, and say them in plain words.

| Level | The standards call it | In plain words |
|---|---|---|
| 3 | Direct and primary | Made at the time, by someone who knew, or the best evidence there is |
| 2 | Secondary | Written down officially some time after the event, or passed on second-hand |
| 1 | Questionable | Told to someone and written down, such as an interview, a census answer or a family story, or open to bias |
| 0 | Unreliable | A guess or an estimate, or known to be wrong |

The manual never prints the tag's name (DEC-030). The names of the levels on a page follow the labels on the app's evidence screen once those are plain words. Each term gets a glossary entry and a row in the [terminology list](terminology.md) when its name is settled.

## 2. What a default is

A default is a starting point, set from the kind of record and the kind of fact. The reader can change it. The manual says what each default is and how to change it. The guide says why each default is what it is, so that a reader sees a choice and not a fact.

## 3. The defaults

The reasons are first drafts for the owner to confirm.

| Kind of record | What the quality is for | Default | Why |
|---|---|---|---|
| A civil birth registration | The birth | 3, direct and primary | It is the primary record of a birth, unless maternity notes become available, which is very unlikely. We let the registration stand in for the birth and treat it as made at the time of it (DEC-118). Arguably the event recorded is the registration, not the birth, and the guide says so. |
| A census return | That the person was in the household, at that address, on census night | 3, direct and primary | The return was made at the time, and the household was there to be counted. |
| A census return | Marital status | 2, secondary | Whoever answered the enumerator gave it, and it was taken as given. |
| A census return | Occupation | 2, secondary | The household gave it in its own words, and it was taken as given. |
| A census return | Birthplace | 1, questionable | Whoever answered gave it from memory and may not have known it. It is the weakest of the census details. |
| Any fact where the reader has reconciled rival sources | The source whose value lost | 0, unreliable, with a note | The reader sets this by reconciling. It records that the source's value differs from the conclusion, and keeps the source cited. It is not a default for any kind of record. |

Marking a source down is a conclusion, not a property of the record. A census return that gives a wrong age was still made at the time, and it is still the evidence of what the household said. The guide explains the difference between that and being right (section 5).

## 4. Not decided yet

No default has been decided for these. Until it is, the manual does not state one, and the guide helps the reader choose.

- A person's age in a census.
- Baptism, marriage, death and burial records.

The owner has observed that a marriage entry is usually made during the marriage, while a birth or a death is registered some time after it. That affects the choice for each kind of record. The Irish death entry in the dataset is a worked case: the death was registered 29 days after it, and the person who gave the details was a nurse who was present.

## 5. What the manual and the guide say

**The manual** has one reference topic, "Default quality", with the table in section 3 in the reader's words, and one line in the task that attaches a source: the app sets a quality, and the reader can change it. It does not argue the case. It links to the guide.

**The guide** has one concept topic under the theme "Sources and evidence", and one worked example under "Analysing and concluding". The concept topic covers:

- What quality is, and what it is not: how much weight a source deserves for a fact, not whether the fact is true.
- The three questions that sit behind it, kept apart: what kind of source it is, whether the informant knew first-hand, and whether the evidence answers the question.
- Why each default is what it is, with the reasons in section 3.
- That a record can be good evidence of what was said and still say something wrong, and that being wrong is found by comparing other evidence, not by the record's type.
- That a tree file records conclusions while research is a process (DEC-117), so the route to a conclusion has to be kept in citations and notes.

## 6. Worked examples from the Brontë dataset

- **A civil birth registration.** All the Brontë births come before civil registration, so this default needs a plainly fictional example (dataset strategy, section 4).
- **Two records, one informant.** The first memorial tablet and the Haworth burial register give the same ages, a year too low for Branwell and Emily. Thread T03 shows why they count as one piece of evidence.
- **A rule, not a lie.** The 1841 census rounds adults' ages down. Patrick's age of 60 is correct under the rule (thread T05).
- **A record made after the event.** The Irish death entry of 1906 (section 4).

The sample file's own quality values follow the dataset's grading (DEC-115). They are not the app's defaults.

## 7. Where the wording comes from

- [GEDCOM 7.0, the citation quality term](https://gedcom.io/terms/v7/QUAY) and its [enumerations](https://github.com/FamilySearch/GEDCOM/blob/main/specification/gedcom-3-structures-4-enumerations.md).
- [GEDCOM 5.5.1](https://gedcom.io/specifications/ged551.pdf), the certainty assessment.
- Elizabeth Shown Mills, [QuickLesson 17, the evidence analysis process map](https://www.evidenceexplained.com/content/quicklesson-17-evidence-analysis-process-map), for keeping the kind of source, the informant and the evidence apart, and for accuracy being judged by comparing evidence.
- The Family Historian users' group, [citation assessments](https://fhug.org.uk/kb/kb-article/v7-citation-assessments/), for rating each item of information and not the whole document.

We paraphrase these sources and do not copy their text (dataset strategy, section 8).
