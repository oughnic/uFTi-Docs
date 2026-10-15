# build/

Build configuration for the website and PDF outputs.

**This folder is empty on purpose.** It is filled by WP1 (toolchain and build pipeline). See the [delivery plan](../authoring/authoring-plan.md#8-delivery-plan) and [build and quality](../authoring/build-and-quality.md).

## Planned contents

```text
build/
  tools.lock     pinned tool versions and SHA-256 checksums
  ditaval/       one DITAVAL filter per platform
  projects/      DITA-OT project files, one deliverable per publication
  theme/         publisher stylesheet, logo, favicon, share image
  scripts/       bootstrap and build scripts (PowerShell for Windows, bash for CI)
  fixtures/      small throwaway publications used to test the pipeline (never published)
```

Downloaded tools go in `.tools/` at the repository root, which is git-ignored. Build output goes in `out/`, also ignored.
