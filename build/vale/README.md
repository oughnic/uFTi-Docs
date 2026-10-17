# Vale configuration

Prose lint for the DITA topics: the reading-level targets (DEC-029), British English spelling, and the words the standards rule out. The configuration file is `.vale.ini` at the repository root; `check-source.ps1` runs it with the toolkit on the PATH, because Vale converts each topic with the toolkit's stock html5 transformation before measuring it.

| Path | What it is |
|---|---|
| `styles/Readability/` | The readability package, version 0.2.0, vendored unchanged with its MIT licence (pinned in `build/tools.lock`). Only Flesch reading ease and Flesch-Kincaid grade are on, with the thresholds set in `.vale.ini`. |
| `styles/uFTi/` | The project's own rules: average and longest sentence (DEC-029), business-model words (DEC-040), GEDCOM tag patterns (DEC-030), words to avoid, positional references, neutral verbs, and British spelling. WP3 expands them into the full style guide. |
| `styles/config/dictionaries/` | SCOWL's `en_GB-ise` Hunspell dictionary, 2020.12.07, with its BSD-style licence. Accents are stripped in that word list, so names with them go in the vocabulary. |
| `styles/config/vocabularies/uFTi/accept.txt` | Names and terms the dictionary lacks: the product name, the Brontë family, Haworth. |
