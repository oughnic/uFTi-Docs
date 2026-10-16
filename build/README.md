# build/

Build configuration for the website and PDF outputs.

**Only `theme/` exists so far.** It holds the publisher stylesheet and fonts (see [theme/README.md](theme/README.md)). The rest is filled by WP1 (toolchain and build pipeline). See the [delivery plan](../authoring/authoring-plan.md#8-delivery-plan) and [build and quality](../authoring/build-and-quality.md).

## Planned contents

```text
build/
  tools.lock     pinned tool versions and SHA-256 checksums
  ditaval/       one DITAVAL filter per platform
  projects/      DITA-OT project files, one deliverable per publication
  theme/         publisher stylesheet, fonts and their licences, theme checker (exists); logo, favicon, share image (WP6)
  scripts/       bootstrap and build scripts (PowerShell for Windows, bash for CI)
  fixtures/      small throwaway publications used to test the pipeline (never published)
```

Downloaded tools go in `.tools/` at the repository root, which is git-ignored. Build output goes in `out/`, also ignored.
