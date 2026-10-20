# The Brontë sample files

The saved stage files of the Brontë dataset ([specification](../README.md)). This is the only folder in the repository where a family tree file may be committed (DEC-063, DEC-111). `build/scripts/check-samples.ps1` checks everything here: only `*.ged` files; each with a header and a trailer; no submitter record, contact detail or file path; every person on the [allow-list](../allow-list.md) and dead by 1930. The manuals never show these files' contents (DEC-030).

## The first sample: stage 3

| File | What it is | Size | SHA-256 |
|---|---|---|---|
| `stage-3-families.ged` | The sample, as GEDCOM 5.5.1. This is the file for the app to register. | 3,331 bytes | `85b0f0c84a3968ea48a946fc849b14d5fc878ab0756adbca33d2c802d29de137` |
| `stage-3-families.V7.ged` | The same tree as GEDCOM 7, which the app writes beside the first. | 4,478 bytes | `00e4b202e4047d8ab208079cbfdd1718346389bea03225ea2a2fa4022cd8fda6` |

Both are kept byte for byte, with the line endings the app wrote (`.gitattributes`), so the checksums hold on every machine.

**The name to show on screen:** Brontë family of Haworth.

**What it holds.** The nine people of the core specification, with their births, deaths and places. The family of Patrick Brontë and Maria Branwell, with their six children and their marriage of 29 December 1812. The family of Charlotte Brontë and Arthur Bell Nicholls, with their marriage of 29 June 1854. Twenty events in all: nine births, nine deaths and two marriages. Where the sources disagree about a year, the birth is a range (Maria, Elizabeth, Anne and Arthur). Arthur's death is in December 1906, with no day, at Banagher. The civil death index gives the registration area as Birr, so that place stays open (C147).

**What it leaves out.** Baptisms and burials, notes, repositories, sources and the evidence for each fact, the alternative dates in the specification, and the other names the family used (Brunty, Currer Bell and so on). Maria is entered under the name Maria Branwell, and each place has its county added. This is stage 3 of the journey, not the finished workspace. A fuller file from a later stage replaces it as a data change (DEC-112).

**How it was made.** The Windows walker typed it into the app on 19 October 2026, from the specification, on a development build with a fresh data folder: about 180 actions, with no file edited. The app wrote the file. One change was made afterwards, by editing the file, as the maintainer asked: the five lines of one source, "England and Wales Marriage Register", were taken out of each file. The marriage form fills that title in by default, so it is not evidence anyone checked, and the walker's tool could not reach the source in the app. A person can remove it there: the marriage row in Charlotte's Facts list, then Remove on the Sources sheet. Nothing else differs from what the app wrote. The 5.5.1 file before the change had 3,431 bytes and the SHA-256 `70fde23d08219b0eeece88fbfc8d616a5507c2e32f5955b632e8a7f82bdc7682`.

**Where the data comes from.** It was entered by hand from the specification ([people](../people.md), [families](../families.md), [events](../events.md)), whose claims have their evidence in the [register](../evidence-register.md). The register is a draft until a second reader has checked it (Q20).

**Licence.** Our text and structure are Apache-2.0, like the rest of this repository. The facts are not ours to own. The files hold no third-party text or media. The copyright line in the header (Oughtibridge Ltd) is written by the app.

**Who could be living.** Nobody. The nine people died between 1821 and 1906 ([privacy check](../privacy-check.md)), and the gate refuses anyone who is not on the allow-list.

## For the app

Register `stage-3-families.ged` as the first-run sample, under the name above. Use the other file only if the app prefers GEDCOM 7.

## Changing these files

A new file comes from a later stage built in the app, with the specification and the register updated in the same change. Add it here, update this README and the decision log, and run `pwsh build/scripts/check-source.ps1`. Never force-add a family tree file anywhere else.
