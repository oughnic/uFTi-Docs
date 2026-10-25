# build/

Everything that turns the DITA source into the website and the PDF, and everything that checks the result. Built by WP1 ([build and quality](../authoring/build-and-quality.md)).

```text
build/
  tools.lock       every tool, pinned by version and SHA-256; read by the bootstrap scripts
  publications.ini what is published, and as which uFTi app release (the one place a release is
                   declared); read by the build scripts (DEC-141)
  ditaval/         one DITAVAL filter per manual, from the tokens-per-manual table
  projects/        DITA-OT project files: common.xml (the parameters every manual shares) and one
                   deliverable per manual; fixture*.xml build the WP1 fixture, fixture-smoke.xml the
                   stock-html5 smoke build (DEC-042); a manual and a Quick Start for each platform build the
                   real content (WP7); site-root.xml builds the root and platform pages of the published
                   tree from sources that build-site writes
  scripts/         bootstrap, build, lint and check scripts (PowerShell everywhere; bash twins of
                   bootstrap and build for CI, Linux and macOS)
  theme/           the publisher stylesheet, its fonts and licences, and the theme checker
  vale/            Vale styles: the project's own rules, the vendored readability package, the British English
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

The whole publishable tree has its own scripts, `build-site.ps1` and `build-site.sh`, described below.

`build.ps1 -Project <name>` builds one project file from `build/projects/` with `dita --project --verbose`, keeps the full log under `out/logs/` (the console shows only the messages), and fails on any `GOVK`, `DOTX`, `DOTJ`, `DOTA` or `DSPDF` warning, error or fatal message, and on `DOTJ047I`, an unresolved key, which the toolkit logs only at the verbose level. Each deliverable lands in `out/<deliverable>/`: the website, `print.html`, and the PDF. A manual or Quick Start named in `publications.ini` is built with the site address, PDF name and footer links that its release gives, and the build fails if the file is wrong.

Preview a site with Java's own static server (search needs HTTP, not a file path):

```powershell
jwebserver -d (Resolve-Path out/fixture-android-phone) -p 8000
```

## The publishing tree

`out/site/` is the whole site as one tree for a static host (build and quality, section 7): a root, a folder for each platform, and below it a folder for each uFTi app release, each holding the manual and its Quick Start as a website and a PDF. The release is declared once for each platform in `publications.ini`.

```powershell
pwsh build/scripts/build-site.ps1 -Archive      # builds every manual and Quick Start, the root pages, the tree, the archives
pwsh build/scripts/check-site.ps1               # checks the tree again: shape, releases, hosting configuration, every link
```

`build-site.sh` is the bash twin (it needs `pwsh` for the check). `-Keep <folder of zips>` puts earlier releases back in the tree, `-Reuse` uses the deliverables already under `out/`, and `-NoCheck` leaves out the check. To publish a new release, change `release` and `app-version` in `publications.ini` after the old release's archive is kept (section 7.4). `.github/workflows/site.yml` builds the tree in CI and keeps it as an artefact.

## The quality gates

| Script | Runs | Needs |
|---|---|---|
| `check-source.ps1` | The theme checker, the structure lint (`lint.ps1`), Vale (prose, British spelling, the words the standards rule out and the reading-level targets of DEC-029), gitleaks over the whole history, and the sample-file gate (`check-samples.ps1`: family tree files only in `content/sample-data/bronte/stages/`, and nobody in them who could be living, DEC-111) | The toolkit (Vale converts DITA with it), Vale, gitleaks |
| `check-output.ps1 -Deliverable <name>` | Over one built deliverable: build messages, HTML validity, one `h1` and one `main` per page, internal links, page metadata, axe-core at WCAG 2.2 AA, PDF/UA-1 with veraPDF (PDF/UA-2 advisory), fonts embedded and figures within the page and the theme's 110 mm cap (`PdfReport.java`), alternative text, the theme's stylesheet, fonts and licences in the output, the theme in a real browser (`theme-probe.mjs`), page weight, and determinism against a second build (`-CompareWith`; the search index is left out, because Pagefind's bytes differ between runs) | Java tools from the bootstrap; Python and Node for the plugin repository's checkers, or Docker for the pinned containers in `tools.lock`; `-AllowSkips` accepts a gate that cannot run |
| `Import-Screenshots.ps1` | Not a gate: imports a capture folder into one manual's pictures, after checking the manifest, the keys, the alternative text and the privacy allow-list; strips, caps and compresses the PNG files (DEC-085). `-WhatIf` runs the checks only | PowerShell 7; Windows to resize |
| `check-site.ps1` | Over the assembled tree in `out/site/`: the folders, every release's `version.json`, website and PDFs, `staticwebapp.config.json`, and every link in every page (a manual to its Quick Start, the root to a platform, the base address followed into the tree), the exact letter case of each, the canonical addresses and the sitemaps | PowerShell 7 only |
| `lint.ps1` | The structure rules of the [authoring standards](../authoring/authoring-standards.md#131-which-rules-are-checked-and-by-what): files, identifiers, the shape of each topic type, metadata and the help identifier, platform tokens, keys and images per manual, diagrams, disclosure patterns, orphans, templates and the help-map inventory; writes `out/applicability-matrix.csv` | Nothing beyond PowerShell |
| `publish-samples.ps1 -Output <folder>` | Not a gate: runs the sample-file gate, then assembles the Brontë sample files byte for byte with `bronte-sample-SHA256SUMS` and `bronte-sample-manifest.json`, for the application to pull (DEC-121) | Nothing beyond PowerShell and git |
| `test-source-rules.ps1` | Not a gate on content: it proves the rules. Every rule that `lint.ps1`, Vale and the sample-file gate enforce has a case that must fail, and it builds every template with the toolkit, which validates it against the DITA 1.3 DTD. `-Only lint,vale,templates,samples,publications` and `-Filter` narrow it. The `publications` cases prove the release rule: every form of release that must be refused is, and the pictures' app version must agree | The toolkit and Vale (the `publications` cases need neither) |

The axe-core gate runs through `scripts/a11y.mjs`, which uses the plugin repository's pinned Playwright and axe-core and fails on every WCAG 2.2 AA violation except those in `scripts/a11y-exceptions.json`: each entry names the rule, the elements, the reason and the date (DEC-054). Keep that list short and remove an entry as soon as its cause is fixed upstream.

CI (`.github/workflows/ci.yml`) runs the same scripts: `lint` (the source gates, then the rule tests), a `build` per manual (twice, compared byte for byte), a `check` per output, the `smoke` build with the toolkit's stock html5 transformation, and a `build` on Windows through `dita.bat`. `deploy.yml` publishes from `main` only, and `release.yml` attaches PDFs, zipped sites and checksums to a release on a `v*` tag. Both wait for the first real publication project, `build/projects/site.xml` (WP7).

## Publishing the Brontë sample

The walkthroughs' sample files, the `*.ged` files in `content/sample-data/bronte/stages/`, are published for the application to pull in (DEC-121). The repository is public, so no token is needed.

| Where | What it holds |
|---|---|
| The pre-release `bronte-sample-latest` | The newest files. `.github/workflows/samples.yml` updates it on each push to `dev` that changes the stage files. Its download addresses never change. |
| Each version release (`vX.Y.Z`) | The same files, attached by `release.yml`. A released application pins one of these. |

Each publication holds the `*.ged` files, `bronte-sample-SHA256SUMS` for `sha256sum -c`, and `bronte-sample-manifest.json` (the name to show on screen, the commit, and each file's name, size, SHA-256 and GEDCOM version). **The file names are the contract and stay stable.** The sample-file gate runs before anything is assembled, so nothing it refuses is published. A pull request that touches the files runs the assembly without publishing.

To pull and check the files:

```bash
gh release download bronte-sample-latest --repo oughnic/uFTi-Docs --dir samples
(cd samples && sha256sum -c bronte-sample-SHA256SUMS)
```

The same files are at `https://github.com/oughnic/uFTi-Docs/releases/download/bronte-sample-latest/<file name>`. To see what would be published from a checkout: `pwsh build/scripts/publish-samples.ps1 -Output out/samples`.
## Upgrading a tool

1. Check the upstream release and its checksum. For the plugin and DesignSystemPDF, also `gh attestation verify --repo iStandUK/govuk-dita-plugin`.
2. Change the version, address, size and checksum in `tools.lock`. Where the upstream publishes no checksum, write `PENDING`, run `bootstrap.ps1 -RecordPending`, and record what it prints.
3. Run `bootstrap.ps1`, then every gate. Upgrade the plugin and DesignSystemPDF together: they meet through the print contract.
4. Open a pull request. CI's caches are keyed by the hash of `tools.lock`, so the new versions are installed fresh.
