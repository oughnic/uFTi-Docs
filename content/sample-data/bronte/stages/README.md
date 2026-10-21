# The Brontë sample files

The saved stage files of the Brontë dataset ([specification](../README.md)). This is the only folder in the repository where a family tree file may be committed (DEC-063, DEC-111). `build/scripts/check-samples.ps1` checks everything here: only `*.ged` files; each with a header and a trailer; no submitter record, contact detail or file path; every person on the [allow-list](../allow-list.md) and dead by 1930. The manuals never show these files' contents (DEC-030).

## The first sample: stage 3

| File | What it is | Size | SHA-256 |
|---|---|---|---|
| `stage-3-families.ged` | The sample, as GEDCOM 5.5.1. This is the file for the app to register. | 3,331 bytes | `85b0f0c84a3968ea48a946fc849b14d5fc878ab0756adbca33d2c802d29de137` |
| `stage-3-families.V7.ged` | The same tree as GEDCOM 7, which the app writes beside the first. | 4,478 bytes | `00e4b202e4047d8ab208079cbfdd1718346389bea03225ea2a2fa4022cd8fda6` |

Both are kept byte for byte, with the line endings the app wrote (`.gitattributes`), so the checksums hold on every machine.

**The name to show on screen:** Brontë family of Haworth.

**What it holds.** The nine people of the core specification, with their births, deaths and places. The family of Patrick Brontë and Maria Branwell, with their six children and their marriage of 29 December 1812. The family of Charlotte Brontë and Arthur Bell Nicholls, with their marriage of 29 June 1854. Twenty events in all: nine births, nine deaths and two marriages. Where the sources disagree about a year, the birth is a range (Maria, Elizabeth, Anne and Arthur). Arthur's death is in December 1906, with no day, at Banagher. The register entry gives 2 December 1906 at Banagher (C147), which a later stage can use.

**What it leaves out.** Baptisms and burials, notes, repositories, sources and the evidence for each fact, the alternative dates in the specification, and the other names the family used (Brunty, Currer Bell and so on). Maria is entered under the name Maria Branwell, and each place has its county added. This is stage 3 of the journey, not the finished workspace. A fuller file from a later stage replaces it as a data change (DEC-112).

**How it was made.** The Windows walker typed it into the app on 19 October 2026, from the specification, on a development build with a fresh data folder: about 180 actions, with no file edited. The app wrote the file. One change was made afterwards, by editing the file, as the maintainer asked: the five lines of one source, "England and Wales Marriage Register", were taken out of each file. The marriage form fills that title in by default, so it is not evidence anyone checked, and the walker's tool could not reach the source in the app. A person can remove it there: the marriage row in Charlotte's Facts list, then Remove on the Sources sheet. Nothing else differs from what the app wrote. The 5.5.1 file before the change had 3,431 bytes and the SHA-256 `70fde23d08219b0eeece88fbfc8d616a5507c2e32f5955b632e8a7f82bdc7682`.

**Where the data comes from.** It was entered by hand from the specification ([people](../people.md), [families](../families.md), [events](../events.md)), whose claims have their evidence in the [register](../evidence-register.md). The register is a draft until a second reader has checked it (Q20).

**Licence.** Our text and structure are Apache-2.0, like the rest of this repository. The facts are not ours to own. The files hold no third-party text or media. The copyright line in the header (Oughtibridge Ltd) is written by the app.

**Who could be living.** Nobody. The nine people died between 1821 and 1906 ([privacy check](../privacy-check.md)), and the gate refuses anyone who is not on the allow-list.

## The second sample: stage 3 with sources

| File | What it is | Size | SHA-256 |
|---|---|---|---|
| `stage-3-families-with-sources.ged` | The stage 3 tree with its sources, as GEDCOM 5.5.1. | 23,364 bytes | `3ceed7e82e82c50df35cc36845509973c38be569d1c70c60670e4a419de7a801` |
| `stage-3-families-with-sources.V7.ged` | The same file as GEDCOM 7. | 23,395 bytes | `afd963221d4972e5b6c896992ec85fc95cba45e74eee6934d5a7758f9b92adc6` |

Both are kept byte for byte, as the tools wrote them. The stage 3 files above are not changed.

**The name to show on screen:** Brontë family of Haworth, as for stage 3.

**What it adds to stage 3.** Twenty-two sources, and 119 citations that attach them to the facts they bear on: the nine births, the nine deaths, the two marriages, and who the children and the spouses are. A citation says, in our words, what that source gives for the fact (a date, a place or an age), where in the source when the register gives a locator, and how good the evidence is. The sources are the ones the [evidence register](../evidence-register.md) cites for those facts. Arthur Bell Nicholls's death also has its day now, 2 December 1906, from the certified copy of the Irish register entry (C147, issue 35). Nothing else about the people, the families and the events changes. The dates and places are stage 3's.

**Where sources disagree, all of them are in the file.** Each fact keeps the value the register concludes, or the range where it concludes nothing, and cites every source on it, the ones that give a different value included. No rival event is added. Nothing is chosen silently: the value on the fact is the register's, and the value a source gives is in its citation. These are the facts with competing sources.

| Fact | In the file | Other values, in the citations | Register |
|---|---|---|---|
| Patrick's birthplace | County Down | Emdale (Cambridge alumni database, Discover Northern Ireland), Ahaderg (DNB, Shorter, Leyland), Drumballyroney (Antrim Now) | T02, C001 |
| Maria Branwell's death | 15 September 1821 | 22 September (Women in Cornwall) | D04, C013 |
| Marriage of Patrick and Maria | 29 December 1812 | 18 December (Shorter). The plaque at the church gives the day but not the right weekday | D01, C015 |
| Marriage of Charlotte and Arthur | 29 June 1854 | 19 June (DNB) | D02, C066 |
| Branwell's death | 24 September 1848 | 26 September (DNB) | D08, C088 |
| Ages at death of Branwell, Emily and Anne | none on the event | 30, 29 and 27 (first tablet, burial register for the first two); 31, 30 and 29 (1858 tablet, museum); 28 for Anne (her gravestone) | T03, C090, C109, C131 |
| Births of Maria, Elizabeth and Anne | a range, as in stage 3 | the year each source gives, and the age on the tablets | T04, C020, C025, C120 |
| Arthur Bell Nicholls's birth | 1817 to 1819 | 1817 (Shorter), 1819 (Antrim Now), and an age of 87 at death (Irish death index and register) | D06, C140 |

**Left unreconciled on purpose.** The file holds each fact's value as the register concludes it, with every source cited and none marked down for disagreeing. It does not record the weighing: that is in the register, the threads and, when a reader does it, in a research note. The manual's evidence chapters start from this state and show how to document a conclusion drawn from conflicting evidence, so the file is not changed to look reconciled (DEC-117).

**How good the evidence is.** The quality value of each citation follows the register's kinds (original, derivative or authored; primary or secondary information) and how we saw the evidence.

- **3, primary.** An original record, seen as a copy of the page: the Irish death register entry. It is the only one in the file.
- **2, secondary.** The memorial tablets and Charlotte's will and probate, which we read through printed transcriptions. Index entries, the Cambridge reference work, and the newspaper report of Patrick's funeral as Shorter quotes it. An authored work where it reports a register entry or prints a letter, an eyewitness account or the subject's own words.
- **1, questionable.** An authored account that gives no record for the point: a biography's own statement, a local history, a news feature, a museum or tourism page, and the plaque at Guiseley, which we saw as a photograph on a local history page.

One citation is rated 3, 49 are rated 2 and 69 are rated 1. Most of what we could open is second-hand, and the file says so. The values are a first judgement. The second reader (Q20) may change any of them. They are not the app's defaults: the manual explains those and the reasons for them (DEC-118).

**Where each fact's citations come from.** Each row names the register rows the citations rest on, and the specification's ids of the sources cited ([sources.md](../sources.md)).

| Fact | Register | Sources cited | Citations |
|---|---|---|---|
| Patrick Brontë, birth | C001, T02 | S01, S05, S06, S07, S10, S23, S24 | 7 |
| Patrick Brontë, death | C040, C046 | S05, S06, S07, S09, S12, S18 | 6 |
| Maria Branwell, birth | C010 | S01, S03, S06, S07, S27 | 5 |
| Maria Branwell, death | C013 | S01, S03, S04, S06, S27 | 5 |
| Maria Brontë, birth | C020 | S01, S03, S06, S07, S18 | 5 |
| Maria Brontë, death | C023 | S01, S03, S04, S06, S07 | 5 |
| Elizabeth Brontë, birth | C025 | S01, S03, S06, S07, S18 | 5 |
| Elizabeth Brontë, death | C028 | S01, S03, S04, S06, S07 | 5 |
| Charlotte Brontë, birth | C030 | S01, S06, S07, S10, S11 | 5 |
| Charlotte Brontë, death | C070 | S02, S03, S04, S06, S07, S08, S12 | 7 |
| Patrick Branwell Brontë, birth | C080 | S01, S06, S07, S10, S11 | 5 |
| Patrick Branwell Brontë, death | C088, C090, C089 | S02, S03, S04, S06, S07, S12, S13, S18 | 8 |
| Emily Jane Brontë, birth | C100 | S01, S06, S07, S10, S11 | 5 |
| Emily Jane Brontë, death | C107, C109, C108 | S02, S03, S04, S06, S07, S12, S13, S18 | 8 |
| Anne Brontë, birth | C120 | S01, S04, S06, S07, S10, S11 | 6 |
| Anne Brontë, death | C128, C131, C130 | S02, S03, S04, S06, S07, S11, S12, S18, S20 | 9 |
| Arthur Bell Nicholls, birth | C140, D06 | S07, S24, S33, S35 | 4 |
| Arthur Bell Nicholls, death | C147 | S24, S25, S33, S35 | 4 |
| Patrick and Maria, marriage | C015 | S01, S05, S06, S07, S21 | 5 |
| Charlotte and Arthur, marriage | C066 | S02, S06, S12, S24 | 4 |
| Patrick and Maria, their children | C018 | S01, S03, S06 | 3 |
| Charlotte and Arthur, husband and wife | C150 | S03, S08, S12 | 3 |

**What it leaves out.** What stage 3 left out, apart from sources: baptisms and burials, notes, the other names the family used, the census, and the second marriage. Repositories are not records of their own either. The body that holds a source (a church, an archive, a registry office) is named in the source, and stage 6 adds repositories as records. The web addresses in the specification are not in the file, because the gate refuses a web page as a contact detail.

**How it was made.** On 20 October 2026, with the app's own tools (DEC-039), from the stage 3 file. The file was loaded, Arthur's death date was changed, the 22 sources and 119 citations were added one at a time, and the workspace was exported twice, as GEDCOM 5.5.1 and as GEDCOM 7. No file was edited by hand. The stage 3 file was loaded without its header copyright line, because the export writes that line itself. The header of the new file is the same as stage 3's, and so is every person, family and event except Arthur's death date. The tools mark each record they make or change with a date and a note naming the tool, so the sources and the two families carry one. The header date is stage 3's. The GEDCOM 7 file has no per-record external identifiers, which stage 3's GEDCOM 7 file has, because the 5.5.1 file it was built from does not hold them.

**Where the data comes from.** The specification and the evidence register, as for stage 3, with the register updated on 20 October 2026 for issue 35. Every citation traces to a register row named above. The register is a draft until a second reader has checked it (Q20), so the citations are too.

**Licence.** As for stage 3, with one addition. The file now names the titles and authors of published works, as any citation does, and gives short statements of what each says, in our words. It copies no text from them. It holds no third-party media.

**Who could be living.** Nobody in the tree: the same nine people, who died between 1821 and 1906. The source records name the authors of published works, as any citation does. They are not people in the tree.

## For the app

Register `stage-3-families.ged` as the first-run sample, under the name above, as before. `stage-3-families-with-sources.ged` is the fuller sample the owner asked for on 20 October 2026. Whether the app registers it in place of stage 3 is the app project's decision (DEC-112, DEC-114). The owner has said that the GEDCOM 7 file of this second sample is the basis for the app's seed in due course (DEC-116). Use the first sample's GEDCOM 7 file only if the app prefers GEDCOM 7.

## Changing these files

A new file comes from a later stage built with the app's own tools, or from an earlier file changed with them (DEC-114), with the specification and the register updated in the same change. Add it here, update this README and the decision log, and run `pwsh build/scripts/check-source.ps1`. Never force-add a family tree file anywhere else.
