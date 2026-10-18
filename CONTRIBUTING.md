# Contributing

Thank you for helping to improve the uFTi documentation.

**Where things stand.** The repository holds the plan, the build and checking pipeline, and the first real content: the Quick Start and "Five things to know" for Windows and for the Android phone. The rest of the manual follows the [delivery plan](authoring/authoring-plan.md#8-delivery-plan). Please open an issue to discuss an idea before you send anything. A small, focused pull request is easier to review than a big one.

## The one rule about the private application repository

This repository is public. **The application repository is private.** Nothing from it goes into this one:

- no source code or snippets, and no project, class or file names;
- no internal design documents or decision records;
- no issue or pull request numbers from any other repository, and no build or CI identifiers;
- no unreleased features, and no security details;
- no local paths, and no real family data or information about living people.

What you **may** write is what a person can see in a released build: the labels exactly as they appear on screen, the steps, and screenshots of the Brontë dataset. If you are not sure whether something is allowed, leave it out and ask in the issue. The structure lint fails on a local path, a link to another repository, an issue number written `#123` and a work marker, and a secret scanner reads the whole history. Those checks are a net, not the rule: the rule is yours to keep. The full boundary is in the [plan, section 7.4](authoring/authoring-plan.md#74-disclosure-boundary-and-privacy).

Files that hold family trees (`*.ged`, `*.gdz`, `*.gedzip`) are git-ignored on purpose. Do not force-add them.

## Set up

You need Git, PowerShell 7 and Java 17 or later (CI uses 21). On Windows, run the toolkit from PowerShell, not from Git Bash. Then, from a fresh clone:

```powershell
pwsh build/scripts/bootstrap.ps1
```

That downloads each tool from its pinned address, checks its size and checksum, and installs it outside the repository (`%LOCALAPPDATA%\ufti-tools` on Windows, `.tools/` elsewhere). It is safe to run again. [build/README.md](build/README.md) has the detail, including how to upgrade a tool.

## Write a topic

1. **Find or open the issue** for the topic, and read what is already decided: the [authoring standards](authoring/authoring-standards.md) (how the DITA is written), the [style guide](authoring/style-guide.md) (how the words read), the [terminology list](authoring/terminology.md) (the plain word for each label and term) and the [metadata vocabulary](authoring/metadata-vocabulary.md).
2. **Start from a template** in [content/templates/](content/templates/README.md). Copy it, give it its real name, make the `id` the same, read the comment at its top, then delete the comment.
3. **Do the task in the app** on the device, with the Brontë dataset. Write what you saw. Do not write what you expect.
4. **Use keys.** Every label comes from a key (`<uicontrol keyref="ui-..."/>`), every picture from an image key, and every link from a topic key. If a label is missing, add it to the right key map and to the terminology list.
5. **Put the topic in a map** with its key, which is its file name.
6. **Write for an 11-year-old.** Short sentences, plain words, a glossary entry for every hard term, and nothing about price, accounts, where data is kept, or a file's contents.

## Check before you push

Run these from the repository root. Each is the same check CI runs.

```powershell
pwsh build/scripts/check-source.ps1
```

That runs the theme checker, the structure lint, Vale (British spelling, the words the standards rule out, and the reading level) and the secret scanner. Errors fail it. Warnings are advice: read each one and answer it or leave it on purpose.

If you changed a template, a lint rule or a Vale rule, also run the rule tests. Every rule that a machine checks has a case that must fail, and they build every template with the toolkit:

```powershell
pwsh build/scripts/test-source-rules.ps1
```

If you added or changed a topic, build the manual that includes it and check the output:

```powershell
pwsh build/scripts/build.ps1 -Project quick-start-windows
pwsh build/scripts/check-output.ps1 -Deliverable quick-start-windows
```

Projects are in `build/projects/`. A build message that starts `GOVK`, `DOTX` or `DSPDF` fails the build: **warnings are failures.** The output checks need Python and Node, or Docker; see [build/README.md](build/README.md).

## Pictures

Screenshots are never captured here. The capture scripts live in the application repository, and they run on emulators, simulators or the reference device, on release candidates, in the Oxford and slate light theme, showing only the Brontë dataset ([screenshot strategy](authoring/screenshot-strategy.md)). A capture run leaves a folder with `manifest.json` and a `screens/` folder. To bring it in:

```powershell
pwsh build/scripts/Import-Screenshots.ps1 -Capture <capture folder> -WhatIf
```

`-WhatIf` runs every check and prints the report without writing anything. The importer checks the manifest, that every key is one the manual expects, that the picture's subject is on the [allow-list](content/sample-data/bronte/allow-list.md), and that the manifest names no device identifier. Then it strips, caps and compresses each picture, and writes only those that differ. Run it again without `-WhatIf` to import. If a picture needs a crop (to hide a part of the screen that may not be shown), record it in the manual's `crops.json` with the reason.

**You write the alternative text.** The importer never does. It is the key's `linktext` in the manual's `images.ditamap`: one sentence about what the picture shows and why it matters, never starting "Image of" or "Screenshot of".

## Branches and pull requests

- **Issue first.** Describe the change or the gap.
- **Branch from `dev`** as `docs/<issue-number>-<short-slug>`. `dev` is the default and integration branch. `main` holds releases only. Maintainers cut a release from `dev` through `release/X.Y.Z` into `main`, tagged `vX.Y.Z`.
- **Open a pull request into `dev`** that closes the issue. Say which topics and which devices it covers. Say which topics were drafted with AI help ([plan, section 7.5](authoring/authoring-plan.md#75-ai-assisted-drafting)).
- **The `ci` check must pass,** on a branch that is up to date with `dev`. If `dev` has moved, merge it into your branch. Nobody can bypass this, administrators included. Every conversation on the pull request must be resolved before it merges.
- **Record decisions.** If a change settles or alters a decision, update [authoring/decision-log.md](authoring/decision-log.md) in the same pull request. If several people work at the same time, agree who uses which decision numbers first, so that they do not clash.
- **Changing a rule is a decision.** A change to the standards, the style guide, a template or a lint or Vale rule goes in the decision log, and its test changes with it.

## Review checklist

The author ticks these before asking for a review. The reviewer checks them again.

- [ ] It builds with no warnings in every manual that includes it, and `check-source.ps1` passes.
- [ ] The file name, `id`, title and short description follow the standards. The metadata is complete, with the help identifier if the topic explains a screen.
- [ ] It makes sense when reached from search, with no "above" or "below".
- [ ] Every label is a key, spelt as the app prints it. Every hard word has a glossary entry.
- [ ] Every step has been done in the app on each device it covers, by someone other than the author.
- [ ] Every picture has alternative text that helps when the picture cannot be seen, and shows only the Brontë dataset.
- [ ] Examples come from the Brontë dataset, spelt as it spells them.
- [ ] It says nothing about price, accounts or where data is kept, shows no file tag or file contents, and mentions nothing from the application repository.
- [ ] A plain-language review has read it aloud ([style guide, section 11](authoring/style-guide.md#11-checklist-for-the-plain-language-reviewer)).

## Licence of contributions

By contributing you agree that your contribution is licensed under the [Apache License 2.0](LICENSE), as described in section 5 of the licence.
