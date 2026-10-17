# Contributing

Thank you for helping to improve the uFTi documentation.

**Current state:** the repository holds the plan and the build pipeline, and no documentation topics yet. Please open an issue to discuss an idea before sending anything. To build and check what is here, see [build/README.md](build/README.md): `pwsh build/scripts/bootstrap.ps1`, then `pwsh build/scripts/build.ps1 -Project fixture`, then `check-source.ps1` and `check-output.ps1`. Every pull request runs the same gates in CI, and a build warning fails it.

## Ground rules

- **Issue first.** Describe the change or the gap. Small, focused pull requests are easier to review.
- **Branches.** `dev` is the working branch and `main` holds releases. Branch from `dev` as `docs/<issue-number>-<short-slug>` and open a pull request into `dev` that closes the issue. Maintainers cut releases from `dev` into `main`.
- **Describe observable behaviour only.** The documentation covers what a released uFTi build does. Do not paste source code, internal design documents, issue numbers from other repositories, build identifiers or details of unreleased features.
- **No real family data.** Screenshots and examples use the illustrative Brontë dataset, and the app's other sample workspaces only where the plan says so. Never include information about living people.
- **Follow the standards** in [authoring/authoring-standards.md](authoring/authoring-standards.md): DITA 1.3, topic-based, accessible, British English.
- **Record decisions.** If a change settles or alters a decision, update [authoring/decision-log.md](authoring/decision-log.md) in the same pull request.

## Licence of contributions

By contributing you agree that your contribution is licensed under the [Apache License 2.0](LICENSE), as described in section 5 of the licence.
