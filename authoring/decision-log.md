# Decision log

What has been decided, what is proposed, and what still needs an answer.

Part of the [authoring plan](authoring-plan.md). Status: Draft 0.2, 15 October 2026.

**How to use this log.** A decision is *Proposed* until the maintainer accepts it in a pull request, which changes its status to *Accepted* and records the date. Questions stay open until answered, and the answer becomes a decision. When a decision changes, edit its row and note why. Do not delete history.

## 1. Decisions

| ID | Decision | Status | Rationale | Revisit when |
|---|---|---|---|---|
| DEC-001 | The repository is public at `github.com/oughnic/uFTi-Docs` and licensed under Apache-2.0. | **Accepted** (maintainer instruction, 15 October 2026) | Requested by the maintainer. Apache-2.0 is a software licence, used here for the documentation by choice. | Reuse of the documentation (for example by translators) is hampered by it. |
| DEC-002 | Scope for now is the **MAUI application only**. Web, command-line and AI-assistant integrations are deferred. | **Accepted** (maintainer instruction, 15 October 2026) | Keeps the first release achievable. | The product team wants another surface documented. |
| DEC-003 | Authoring is in DITA and fully topic-based. | **Accepted** (maintainer instruction, 15 October 2026) | Requested by the maintainer. | n/a |
| DEC-004 | DITA profile: DITA 1.3, DTD-based, standard topic types, no specialisation, no Markdown topics. | Proposed | The plugin has full DITA 1.3 coverage. Avoiding specialisation keeps editors, tools and the plugin simple. | A structure rule cannot be enforced by lint. |
| DEC-005 | Toolchain: DITA Open Toolkit, the iStandUK GOV.UK plugin, and its companion DesignSystemPDF for PDF/UA-1. | **Accepted** (toolkit and plugin by maintainer instruction. DesignSystemPDF is how the plugin produces PDF/UA.) | See [build and quality](build-and-quality.md). | Upgrades follow the pinning policy. |
| DEC-006 | Output model: **one build per manual** (option A), with **one manual per device idiom**: Android phone, Android tablet, iPhone, iPad and Windows. | Proposed | Uses mainstream DITA-OT features, gives each reader a self-contained manual and PDF, and lets one topic and one image key serve every manual with no idiom labels in the text. | WP2 result, and Q16. |
| DEC-007 | Good practice is single-sourced as a part of every manual and also published standalone, with contextual cues in tasks. | Proposed | DITA-OT 4.4 cannot link between separately built publications. Readers need guidance in context. WP2 also tests a link-out variant to limit duplication. | WP2, or if option B is chosen. |
| DEC-008 | Branding: the plugin's `neutral` mode with the publisher stylesheet in `build/theme/` (DEC-024). Never `official` or `nhs`. | Proposed | Those identities are restricted to GOV.UK services and NHS organisations respectively. | n/a |
| DEC-009 | File names carry no type prefix, sit in area folders, and never change after publication. | Proposed | Names become URLs. | n/a |
| DEC-010 | Writing style: the GOV.UK style guide as the base, British English, with project overrides. | Proposed | Matches the Design System the site uses, and its plain English approach. | WP3 style guide. |
| DEC-011 | Screenshots are keys defined per manual. The key's link text is the alternative text. | **Accepted** (existing convention in the application repository's key maps) | Lets one topic serve every manual. | WP2 must prove alternative text reaches HTML and PDF. |
| DEC-012 | Disclosure boundary: only observable behaviour of released builds, and sample data only ([plan, section 7.4](authoring-plan.md#74-disclosure-boundary-and-privacy)). | Proposed | This repository is public and the application repository is private. | n/a |
| DEC-013 | The manual describes the latest release, which is what `main` holds. Earlier versions are kept as tagged releases (PDF and zipped site). Whether they stay online is open. | Proposed | Avoids version conditionals in the source. | The support policy for old app versions is known. |
| DEC-014 | Host on GitHub Pages, publishing from `main` only: the chooser at the root, each manual at `/<slug>/`. | Proposed | Free for public repositories. Static output suits it. Only releases are published. | Q4. |
| DEC-015 | Use a pinned toolkit in a short, user-writable folder, run through `dita.bat`. Not `C:\Program Files`. | Proposed | Plugin installation needs write access, and the Windows launcher has path-length limits. | n/a |
| DEC-016 | Branching: **`dev` is the default and integration branch, and `main` holds releases.** Work on `docs/<issue>-<slug>` branches from `dev`, merged by pull request. Releases go through `release/X.Y.Z` into `main`, tagged `vX.Y.Z`. Urgent fixes use `hotfix/<slug>` from `main`. | **Accepted** (maintainer instruction, 15 October 2026) | Matches the maintainer's existing workflow. | n/a |
| DEC-017 | The copyright holder is **Oughtibridge Ltd** (`NOTICE`). | **Accepted** (maintainer instruction, 15 October 2026) | Maintainer instruction. | n/a |
| DEC-018 | AI-assisted drafting follows the rules in [plan, section 7.5](authoring-plan.md#75-ai-assisted-drafting). | Proposed | Keeps AI to drafting and checking, with verification on real builds. This is about how we write, not about the app's AI features. | n/a |
| DEC-019 | Supported platforms: **Android** (phone and tablet idioms), **iOS** (iPhone and iPad idioms) and **Windows** (WinUI). Other MAUI heads are not documented. | **Accepted** (maintainer instruction, 15 October 2026) | The three platforms MAUI supports for uFTi. | The product team adds a supported platform. |
| DEC-020 | **AI features of the app, and guidance on using AI tools, are out of scope** for now. | **Accepted** (maintainer instruction, 15 October 2026) | Maintainer instruction. | The product team wants them documented. |
| DEC-021 | Waves: wave 1 is Android phone and Windows. Wave 2 is Android tablet, then iPhone and iPad. | Proposed | Wave 1 already has screenshot sets. Android tablet shares an operating system with wave 1. iOS needs a Mac and devices. | A Mac build host and devices are available, or priorities change. |
| DEC-022 | **Screenshot capture scripts live in the application repository.** This repository holds the screen catalogue, the importer, the images and a manifest ([screenshot strategy](screenshot-strategy.md)). | **Accepted** (maintainer instruction, 15 October 2026) | The scripts need the app's automation identifiers and routes, which sit behind the disclosure boundary. | n/a |
| DEC-023 | **Screenshots are captured on emulators and simulators** with pinned profiles (and on a clean Windows profile or virtual machine for Windows), **on release candidates only.** | **Accepted** (maintainer instruction, 15 October 2026) | Reproducible, no personal data, and no capture effort between releases. | A flow cannot run on an emulator, such as the iOS camera. That is handled as a per-screen exception. |
| DEC-024 | **The documentation uses the app's Oxford and slate theme throughout.** Screenshots are captured in its light variant. The website and PDF use the publisher stylesheet in [`build/theme/`](../build/theme/README.md), with the theme's colours and fonts: Source Serif 4 and Atkinson Hyperlegible Next. | **Accepted** (maintainer instruction, 15 October 2026) | The manual looks like the app. Both fonts are open-licensed, and the colours are checked for WCAG 2.2 AA. | The app changes its theme or fonts. |

## 2. Open questions

| ID | Question | Why it matters | Default if unanswered | Needed by |
|---|---|---|---|---|
| Q4 | Where is the site hosted: the GitHub Pages address, or a custom domain? | Sets `govuk.site.url`, canonical URLs and the sitemap. | `https://oughnic.github.io/uFTi-Docs/` | WP1 |
| Q5 | Which brand assets exist (logo, colours, favicon, share image)? | WP6. | A plain masthead with the service name. | WP6 |
| Q6 | Is Spanish needed, and when? | Localisation-ready writing, and WP16. | Not for v1. | Before WP8 |
| Q8 | Who reviews good practice content, and who reviews legal and data protection topics? | The review gate in the workflow. | The maintainer, with a volunteer genealogist to be found. | Before WP9 |
| Q9 | Do we accept community contributions, and by what process? | `CONTRIBUTING.md`. | Issues first. Pull requests after WP1. | WP1 |
| Q10 | Should the colophon say the content is AI-assisted and human-reviewed? | Transparency. | Yes. | WP10 |
| Q12 | What should `robots.txt` say about AI crawlers? The plugin's default allows all. | Content reuse policy. | Allow all. | WP10 |
| Q13 | How are topic dates kept true? | `govuk.dates` and page metadata. | Dates off. | WP3 |
| Q15 | Does the app record DNA evidence? | Good practice theme 9. | No, so a short ethics and citation note only. | WP4 |
| Q16 | Should phone and tablet have separate manuals (assumed), or share one manual per operating system? | Five outputs against three. Separate manuals let one topic and one image key serve every manual, with no idiom labels in the text. | Separate manuals. | WP2 and WP4 |
| Q17 | Should the site follow the reader's dark-mode preference, using the theme's dark variant? | Every plugin and Design System component would need checking on dark, which needs a real build. | No. Light only for v1. | WP6 |

## 3. Answered questions

| ID | Question | Answer | Recorded in |
|---|---|---|---|
| Q1 | Which platforms are supported at v1? | Android, iOS and Windows (WinUI). | DEC-019 |
| Q2 | Are phone and tablet separate manuals? | Android and iOS cater for both idioms. Separate manuals are assumed, pending Q16. | DEC-019, DEC-006, Q16 |
| Q3 | Are AI-assisted features in scope? | No. | DEC-020 |
| Q7 | Who owns the copyright? | Oughtibridge Ltd. | DEC-017 |
| Q11 | Do both Windows heads ship to users? | No. Only Windows (WinUI) is supported. | DEC-019 |
| Q14 | Who captures screenshots, with what tooling, and how often? | Scripts in the application repository, on emulators and simulators, on release candidates only. | DEC-022, DEC-023 |

## 4. Change history

| Date | Change |
|---|---|
| 15 October 2026 | Draft 0.1 created with the initial plan. |
| 15 October 2026 | Draft 0.2. Maintainer decisions applied: supported platforms and idioms (DEC-019), AI out of scope (DEC-020), copyright holder (DEC-017) and branching model (DEC-016). Question Q16 added. |
| 15 October 2026 | Screenshot decisions (DEC-022, DEC-023) and the Oxford and slate theme (DEC-024) recorded. Q14 answered. Question Q17 added. |
