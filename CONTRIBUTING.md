# Contributing

Thank you for helping to improve the uFTi documentation.

**Current state:** the repository is in its planning phase and holds no documentation topics yet. For now, please open an issue to discuss an idea before sending anything. Once the toolchain work package has landed (see the [authoring plan](authoring/authoring-plan.md#8-delivery-plan)), this guide will gain build and review instructions.

## Ground rules

- **Issue first.** Describe the change or the gap. Small, focused pull requests are easier to review.
- **Branches.** `dev` is the working branch and `main` holds releases. Branch from `dev` as `docs/<issue-number>-<short-slug>` and open a pull request into `dev` that closes the issue. Maintainers cut releases from `dev` into `main`.
- **Describe observable behaviour only.** The documentation covers what a released uFTi build does. Do not paste source code, internal design documents, issue numbers from other repositories, build identifiers or details of unreleased features.
- **No real family data.** Screenshots and examples use the illustrative Brontë dataset, and the app's other sample workspaces only where the plan says so. Never include information about living people.
- **Follow the standards** in [authoring/authoring-standards.md](authoring/authoring-standards.md): DITA 1.3, topic-based, accessible, British English.
- **Record decisions.** If a change settles or alters a decision, update [authoring/decision-log.md](authoring/decision-log.md) in the same pull request.

## Licence of contributions

By contributing you agree that your contribution is licensed under the [Apache License 2.0](LICENSE), as described in section 5 of the licence.
