# Security and privacy

This repository is public and holds the source of the uFTi user documentation and the scripts that build it. Nothing here runs on a server and no reader is tracked, so the things worth reporting privately are different from a software project's.

## What to report privately

Please report these **privately**, not as a public issue, so that nothing is spread further before it is fixed:

- **A private-data leak.** Information about a living person, real family data, or anything about a named person that is not from a published historical source. Also any material that belongs to the private application repository: source code, design documents, internal identifiers or details of unreleased features.
- **A security problem** in the build scripts, the workflows, the published website or the PDFs, or a tool pinned in `build/tools.lock` that has a known vulnerability affecting us.
- **Anything you are not sure about.** We would rather hear it privately and say it is fine.

Use GitHub's **Report a vulnerability** form in the repository's Security tab. If that form is not available to you, open an issue that says only that you have something to report privately, with no detail, and a maintainer will arrange a private channel.

Please include where you found it (the file, page or PDF and the version or commit), what it is, and any steps to reproduce. We aim to acknowledge a report within five working days and to say what we will do within a further ten. We will credit you if you wish, or not at all if you prefer.

## What to report in the open

- **An accessibility barrier** on the website or in a PDF: open an issue with the `accessibility` label. Say what you were using (device, browser or assistive technology) and what stopped you. This is not sensitive, and fixing it in the open helps others.
- **A mistake in the documentation,** a broken link, or a build problem: an ordinary issue.

## What is covered

The latest release only, which is what `main` holds and what is published. Older releases stay available as tagged archives and are not updated.

## How we keep risk down

- Every tool is pinned by version and SHA-256 and verified on every install (`build/tools.lock`).
- Workflow actions are pinned to full commit SHAs, run with read-only permissions, and are kept current by Dependabot.
- A secret scanner runs over the whole history on every pull request, and push protection is on.
- The published site is static, same-origin, with a Content Security Policy in every page, no cookies, no third-party requests and no analytics.
- Screenshots and examples use an illustrative dataset about people who died long ago, never real family data.
