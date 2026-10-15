# uFTi-Docs: working notes for Claude

## What this repository is

The user documentation for the **uFTi MAUI application**, authored in DITA 1.3 and published with DITA-OT 4.4.1 and the iStandUK GOV.UK plugin (`org.istanduk.gov-uk`) as a static website and a PDF/UA-1 document per platform. Public, Apache-2.0.

## Status

Planning only. Read `authoring/README.md` first. No DITA topics exist yet: write content only when the user asks, following the delivery plan in `authoring/authoring-plan.md`.

## Standing instructions

- **Scope is the MAUI app only** until the user widens it. Web, command-line and AI-assistant (MCP) surfaces are deferred.
- **This repository is public; the application repository is private.** Never paste material from the application repository: source, design documents, issue or PR numbers, CI or build identifiers, unreleased features. Document observable behaviour of released builds only.
- **Sample data only.** Screenshots and examples use the sample workspaces. `*.ged`, `*.gdz` and `*.gedzip` are git-ignored on purpose; do not force-add them.
- **Keep the decision log in sync.** Any decision made or changed goes into `authoring/decision-log.md` in the same change.
- **DITA rules.** Standard DITA 1.3 only: no specialisation, no Markdown topics. Follow `authoring/authoring-standards.md`. Include submaps with `mapref href`, never `mapref keyref`; avoid `chunk="to-content"`.
- **Warnings are failures.** Build messages starting `GOVK`, `DOTX` or `DSPDF` must be zero before anything is published.
- **Windows builds.** Run the toolkit with `dita.bat` from PowerShell, not the Unix `dita` script from Git Bash. Use a pinned toolkit in a short, user-writable folder, not `C:\Program Files`.
- **Never commit** `out/`, `.tools/` or downloaded tools. Pin tool versions by checksum in `build/tools.lock` once it exists.
- **Branding.** Use the plugin's `neutral` branding. Never `official` (GOV.UK crown) or `nhs`: those identities are restricted.
