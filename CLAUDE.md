# uFTi-Docs: working notes for Claude

## What this repository is

The user documentation for the **uFTi MAUI application**, authored in DITA 1.3 and published with DITA-OT 4.4.1 and the iStandUK GOV.UK plugin (`org.istanduk.gov-uk`) as a static website and a PDF/UA-1 document per platform. Public, Apache-2.0.

## Status

The plan, the toolchain and the first content (the Windows and Android phone Quick Starts) exist. Read `authoring/README.md` first. Write content only when the user asks, following the delivery plan in `authoring/authoring-plan.md`, starting from a template in `content/templates/`. The rules are in `authoring/authoring-standards.md`, `authoring/style-guide.md`, `authoring/terminology.md` and `authoring/metadata-vocabulary.md`; `pwsh build/scripts/check-source.ps1` enforces them, and `pwsh build/scripts/test-source-rules.ps1` proves the rules.

## Standing instructions

- **Scope is the MAUI app only** until the user widens it: Android, iOS and Windows (WinUI), with Android and iOS each covering phone and tablet, so five manuals. Web, command-line and AI-assistant (MCP) surfaces, and the app's AI features, are out of scope.
- **This repository is public; the application repository is private.** Never paste material from the application repository: source, design documents, issue or PR numbers, CI or build identifiers, unreleased features. Document observable behaviour of released builds only.
- **The Brontë dataset.** Screenshots and examples use the illustrative dataset in `authoring/dataset-strategy.md`, built by performing the manual's own tasks. It shows research as it is: every claim has its evidence in the register, contradictions are recorded as competing evidence rather than excluded, nothing is invented, and notes are in our own words: never copy text from biographies, Wikipedia or museum pages. Never real family data. `*.ged`, `*.gdz` and `*.gedzip` are git-ignored on purpose; do not force-add them. The one exception is the Brontë sample in `content/sample-data/bronte/stages/` (`*.ged` only, DEC-111), which `build/scripts/check-samples.ps1` checks: nobody in it who could be living.
- **Who it is for.** People who do not read manuals come first: the Quick Start, in-app help and the words on screen before the full manual (`authoring/content-model.md`).
- **Reading level.** Write for an average 11-year-old: short sentences, plain words, a glossary entry for every term (DEC-029).
- **Never show GEDCOM tags, structures or file contents** (DEC-030). Describe people, families, facts and sources in human terms.
- **Never state** price, "free", "forever", accounts, sign-in or where data is stored (DEC-040). Sync and AI do not appear until they ship.
- **DNA:** one topic on risks and issues, nothing more (DEC-037). **Video:** never embedded (DEC-034).
- **Idiom first.** Write for phone, tablet or desktop; use platform tokens only for installing, updating, permissions, files, accessibility features and backup (DEC-032).
- **Keep the decision log in sync.** Any decision made or changed goes into `authoring/decision-log.md` in the same change.
- **Branches.** `dev` is the default and integration branch. `main` holds releases only. Open an issue first, work on `docs/<issue>-<slug>` branches from `dev`, and open pull requests into `dev`. Releases go through `release/X.Y.Z` into `main`, tagged `vX.Y.Z`.
- **DITA rules.** Standard DITA 1.3 only: no specialisation, no Markdown topics. Follow `authoring/authoring-standards.md`. Include submaps with `mapref href`, never `mapref keyref`; avoid `chunk="to-content"`.
- **Warnings are failures.** Build messages starting `GOVK`, `DOTX` or `DSPDF` must be zero before anything is published.
- **Windows builds.** Run the toolkit with `dita.bat` from PowerShell, not the Unix `dita` script from Git Bash. Use a pinned toolkit in a short, user-writable folder, not `C:\Program Files`.
- **Never commit** `out/`, `.tools/` or downloaded tools. Pin tool versions by checksum in `build/tools.lock` once it exists.
- **Branding.** Use the plugin's `neutral` branding. Never `official` (GOV.UK crown) or `nhs`: those identities are restricted.
- **Theme.** The site and PDF use the app's Oxford and slate theme through `build/theme/ufti.css`. Colours live only in its tokens block. Never edit or rename the font files (their licence reserves the name). Run `pwsh build/theme/check-theme.ps1` after any stylesheet change.
- **Screenshots.** Capture scripts live in the application repository, never here. Follow `authoring/screenshot-strategy.md`: emulators and simulators, release candidates only, Oxford and slate light, the Brontë dataset only.
