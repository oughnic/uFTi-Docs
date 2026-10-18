# Vale configuration

Prose lint for the DITA topics: the reading-level targets (DEC-029), British English spelling, and the words the standards rule out or advise against. The configuration file is `.vale.ini` at the repository root; `check-source.ps1` runs it with the toolkit on the PATH, because Vale converts each topic with the toolkit's stock html5 transformation before measuring it. The rules are explained in the [style guide](../../authoring/style-guide.md), and each has a case in [`test-source-rules.ps1`](../scripts/test-source-rules.ps1) that must fail.

| Path | What it is |
|---|---|
| `styles/uFTi/` | The project's own rules, listed below. |
| `styles/Readability/` | The readability package, version 0.2.0, vendored unchanged with its MIT licence (pinned in `build/tools.lock`). **Not switched on:** its two Flesch rules carry the formulas we use, but their messages say "above 70" and "below 8" whatever threshold a project sets, so `uFTi.ReadingEase` and `uFTi.GradeLevel` restate them (DEC-071). It stays for the formulas and for its other measures. |
| `styles/config/dictionaries/` | SCOWL's `en_GB-ise` Hunspell dictionary, 2020.12.07, with its BSD-style licence. Accents are stripped in that word list, so names with them go in the vocabulary. |
| `styles/config/vocabularies/uFTi/accept.txt` | Names and terms the dictionary lacks: the product name, the Brontë family, Haworth, and the names of keyboard keys. |

Both licences are recorded in the repository's `NOTICE`.

## The rules in `styles/uFTi/`

| Rule | Level | What it checks | Source |
|---|---|---|---|
| `ReadingEase` | error | Flesch reading ease of 70 or more, per topic | DEC-029 |
| `GradeLevel` | error | Flesch-Kincaid grade of 6 or less, per topic | DEC-029 |
| `AverageSentence` | error | An average sentence of 15 words or fewer, per topic | DEC-029 |
| `LongSentence` | error | No sentence over 25 words | DEC-029 |
| `Spelling` | error | British English, with the vocabulary | DEC-010 |
| `Avoid` | error | "simply", "just", "easy", "please", "via", "e.g." and the like | Standards, section 11 |
| `Positional` | error | "above", "below", "the previous section" | Standards, section 2 |
| `BusinessModel` | error | Price, "free", accounts, sign-in, where data is kept | DEC-040 |
| `GedcomTags` | error | A file tag, structure or line | DEC-030 |
| `ProductName` | error | uFTi in any other capital pattern | Style guide, section 5 |
| `Dates` | error | A date not written 1 January 2026 | Style guide, section 6 |
| `ColourCues` | error | A control named by its colour | Standards, section 10 |
| `NeutralVerbs` | warning | "click", "tap", "press" | Standards, section 11 |
| `PositionCues` | warning | A control named by where it sits | Standards, section 10 |
| `PlainWords` | warning | A long word where a plain one will do | Style guide, section 5 |
| `Terminology` | warning | A word the terminology list replaces | Terminology list |

An error fails `check-source.ps1`. A warning is advice.

## How Vale measures a topic

Vale converts the file to HTML with the toolkit and measures that. It sees one topic alone, so a word that comes from a key is not in the count. It counts the short description, paragraphs, steps, list items and table cells; each list item is a sentence of its own. It does not count titles or headings. The details, and what the Quick Start scored, are in the [style guide, section 3](../../authoring/style-guide.md#3-reading-level).

## An exception for one topic

DEC-029 allows a topic over the line only for a UI label, a proper name or a term with a glossary entry. Add a section to `.vale.ini` for that one file, switching off only the rule that needs it, with the reason and the day in a comment above it. The pull request says why. There are none yet. A test shows that such a section works, and works for one file only.

## Adding a rule

1. Add the file to `styles/uFTi/`, with a comment that says which standard or decision it comes from. Remember that Vale joins the entries of `raw` into one pattern, so write alternatives inside one entry.
2. Add a case to `test-source-rules.ps1` that makes it raise.
3. Run `pwsh build/scripts/test-source-rules.ps1 -Only vale`, then `check-source.ps1` to see what it does to the real topics.
4. Record the decision, and add the rule to the table above and to the [standards, section 13](../../authoring/authoring-standards.md#131-which-rules-are-checked-and-by-what).
