# build/

Everything that turns the DITA source into the website and the PDF, and everything that checks the result. Built by WP1 ([build and quality](../authoring/build-and-quality.md)).

```text
build/
  tools.lock       every tool, pinned by version and SHA-256; read by the bootstrap scripts
  ditaval/         one DITAVAL filter per manual, from the tokens-per-manual table
  projects/        DITA-OT project files: common.xml (the parameters every manual shares) and one
                   deliverable per manual; fixture*.xml build the WP1 fixture, fixture-smoke.xml the
                   stock-html5 smoke build (DEC-042)
  scripts/         bootstrap, build, lint and check scripts (PowerShell everywhere; bash twins of
                   bootstrap and build for CI, Linux and macOS)
  theme/           the publisher stylesheet, its fonts and licences, and the theme checker
  vale/            Vale styles: the readability rules, the project's own rules, the British English
                   dictionary and the vocabulary
  fixtures/        small throwaway publications used to test the pipeline (never published)
```

Downloaded tools go in a git-ignored tools folder: `.tools/` at the repository root on Linux and macOS, and `%LOCALAPPDATA%\ufti-tools` on Windows, because the toolkit's `dita.bat` repeats its own path once per library and a deep checkout overruns the command line limit. `UFTI_TOOLS` overrides both. Build output goes in `out/`, also ignored. Nothing is installed into `C:\Program Files` or the system PATH (DEC-015).

## From a fresh clone

You need Git, PowerShell 7 and Java 17 or later (21 is what CI uses). Then:

```powershell
pwsh build/scripts/bootstrap.ps1
pwsh build/scripts/build.ps1 -Project fixture
```

`bootstrap.ps1` reads `tools.lock`, downloads each tool from its pinned address, refuses any file whose size or checksum differs, and installs: the DITA Open Toolkit with the GOV.UK plugin, DesignSystemPDF, Pagefind, veraPDF, the Nu HTML Checker, Vale, gitleaks and the plugin repository's checkers. `-BuildOnly` installs the first four. It is safe to run again. On Linux and macOS, `build/scripts/bootstrap.sh` and `build.sh` do the same.

`build.ps1 -Project <name>` builds one project file from `build/projects/` with `dita --project`, keeps the log under `out/logs/`, and fails on any `GOVK`, `DOTX`, `DOTJ`, `DOTA` or `DSPDF` warning, error or fatal message, and on `DOTJ047I` (an unresolved key). Each deliverable lands in `out/<deliverable>/`: the website, `print.html`, and the PDF.

Preview a site with Java's own static server (search needs HTTP, not a file path):

```powershell
jwebserver -d (Resolve-Path out/fixture-android-phone) -p 8000
```

## The quality gates

| Script | Runs | Needs |
|---|---|---|
| `check-source.ps1` | The theme checker, the structure lint (`lint.ps1`), Vale (prose, British spelling and the reading-level targets of DEC-029) and gitleaks over the whole history | The toolkit (Vale converts DITA with it), Vale, gitleaks |
| `check-output.ps1 -Deliverable <name>` | Over one built deliverable: build messages, HTML validity, one `h1` and one `main` per page, internal links, page metadata, axe-core at WCAG 2.2 AA, PDF/UA-1 with veraPDF (PDF/UA-2 advisory), fonts embedded and figures within the page and the theme's 110 mm cap (`PdfReport.java`), alternative text, the theme's stylesheet, fonts and licences in the output, the theme in a real browser (`theme-probe.mjs`), page weight, and determinism against a second build (`-CompareWith`; the search index is left out, because Pagefind's bytes differ between runs) | Java tools from the bootstrap; Python and Node for the plugin repository's checkers, or Docker for the pinned containers in `tools.lock`; `-AllowSkips` accepts a gate that cannot run |
| `lint.ps1` | File names, identifiers, metadata, platform tokens, keys and images per manual, diagram links, disclosure patterns, orphans and the help-map inventory; writes `out/applicability-matrix.csv` | Nothing beyond PowerShell |

The axe-core gate runs through `scripts/a11y.mjs`, which uses the plugin repository's pinned Playwright and axe-core and fails on every WCAG 2.2 AA violation except those in `scripts/a11y-exceptions.json`: each entry names the rule, the elements, the reason and the date (DEC-054). Keep that list short and remove an entry as soon as its cause is fixed upstream.

CI (`.github/workflows/ci.yml`) runs the same scripts: `lint`, a `build` per manual (twice, compared byte for byte), a `check` per output, the `smoke` build with the toolkit's stock html5 transformation, and a `build` on Windows through `dita.bat`. `deploy.yml` publishes from `main` only, and `release.yml` attaches PDFs, zipped sites and checksums to a release on a `v*` tag. Both wait for the first real publication project, `build/projects/site.xml` (WP7).

## Upgrading a tool

1. Check the upstream release and its checksum. For the plugin and DesignSystemPDF, also `gh attestation verify --repo iStandUK/govuk-dita-plugin`.
2. Change the version, address, size and checksum in `tools.lock`. Where the upstream publishes no checksum, write `PENDING`, run `bootstrap.ps1 -RecordPending`, and record what it prints.
3. Run `bootstrap.ps1`, then every gate. Upgrade the plugin and DesignSystemPDF together: they meet through the print contract.
4. Open a pull request. CI's caches are keyed by the hash of `tools.lock`, so the new versions are installed fresh.
