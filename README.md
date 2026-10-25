# Published documentation

This branch holds the built uFTi documentation, nothing else. It is written by the Site workflow of the
source repository (the `publish` job), never by hand, and each publication replaces it.

- `site/` is the tree: a root page, one folder for each platform, and below each platform one folder for
  each uFTi app release, with the manual and the Quick Start as a website and a PDF.
- To serve it, use `site` as the app location (Azure Static Web Apps) with no build step.
- The sources are on the `dev` branch of the same repository.
