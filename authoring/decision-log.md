# Decision log

What has been decided, what is proposed, and what still needs an answer.

Part of the [authoring plan](authoring-plan.md). Status: Draft 0.1, 15 October 2026.

**How to use this log.** A decision is *Proposed* until the maintainer accepts it in a pull request, which changes its status to *Accepted* and records the date. Questions stay open until answered, and the answer becomes a decision. When a decision changes, edit its row and note why. Do not delete history.

## 1. Decisions

| ID | Decision | Status | Rationale | Revisit when |
|---|---|---|---|---|
| DEC-001 | The repository is public at `github.com/oughnic/uFTi-Docs` and licensed under Apache-2.0. | **Accepted** (maintainer instruction, 15 October 2026) | Requested by the maintainer. Apache-2.0 is a software licence, used here for the documentation by choice. | Reuse of the documentation (for example by translators) is hampered by it. |
| DEC-002 | Scope for now is the **MAUI application only**. Web, command-line and AI-assistant integrations are deferred. | **Accepted** (maintainer instruction, 15 October 2026) | Keeps the first release achievable. | The product team wants another surface documented. |
| DEC-003 | Authoring is in DITA and fully topic-based. | **Accepted** (maintainer instruction, 15 October 2026) | Requested by the maintainer. | n/a |
| DEC-004 | DITA profile: DITA 1.3, DTD-based, standard topic types, no specialisation, no Markdown topics. | Proposed | The plugin has full DITA 1.3 coverage. Avoiding specialisation keeps editors, tools and the plugin simple. | A structure rule cannot be enforced by lint. |
| DEC-005 | Toolchain: DITA Open Toolkit, the iStandUK GOV.UK plugin, and its companion DesignSystemPDF for PDF/UA-1. | **Accepted** (toolkit and plugin by maintainer instruction. DesignSystemPDF is how the plugin produces PDF/UA.) | See [build and quality](build-and-quality.md). | Upgrades follow the pinning policy. |
| DEC-006 | Platform output model: **one build per platform** from shared sources (option A). | Proposed | Uses mainstream DITA-OT features and gives each reader a self-contained manual and PDF. | WP2 result. |
| DEC-007 | Good practice is single-sourced as a part of every platform manual and also published standalone, with contextual cues in tasks. | Proposed | DITA-OT 4.4 cannot link between separately built publications. Readers need guidance in context. | WP2, or if option B is chosen. |
| DEC-008 | Branding: the plugin's `neutral` mode with a publisher stylesheet. Never `official` or `nhs`. | Proposed | Those identities are restricted to GOV.UK services and NHS organisations respectively. | n/a |
| DEC-009 | File names carry no type prefix, sit in area folders, and never change after publication. | Proposed | Names become URLs. | n/a |
| DEC-010 | Writing style: the GOV.UK style guide as the base, British English, with project overrides. | Proposed | Matches the Design System the site uses, and its plain English approach. | WP3 style guide. |
| DEC-011 | Screenshots are keys defined per platform. The key's link text is the alternative text. | **Accepted** (existing convention in the application repository's key maps) | Lets one topic serve every platform. | WP2 must prove alternative text reaches HTML and PDF. |
| DEC-012 | Disclosure boundary: only observable behaviour of released builds, and sample data only ([plan, section 7.4](authoring-plan.md#74-disclosure-boundary-and-privacy)). | Proposed | This repository is public and the application repository is private. | n/a |
| DEC-013 | The manual describes the latest release. Earlier versions are kept as tagged releases (PDF and zipped site). Whether they stay online is open. | Proposed | Avoids version conditionals in the source. | The support policy for old app versions is known. |
| DEC-014 | Host on GitHub Pages: the chooser at the root, each manual at `/<slug>/`. | Proposed | Free for public repositories. Static output suits it. | Q4. |
| DEC-015 | Use a pinned toolkit in a short, user-writable folder, run through `dita.bat`. Not `C:\Program Files`. | Proposed | Plugin installation needs write access, and the Windows launcher has path-length limits. | n/a |
| DEC-016 | Branching: trunk-based on `main`, with short-lived `docs/<issue>-<slug>` branches and pull requests. | Proposed | Simple for a small team. The application repository uses `dev` as its default branch, so confirm whether to match it. | Staged releases need an integration branch. |
| DEC-017 | The `NOTICE` copyright line names Nicholas Oughtibridge. | Proposed | Taken from the maintainer's git identity. | Q7. |
| DEC-018 | AI-assisted drafting follows the rules in [plan, section 7.5](authoring-plan.md#75-ai-assisted-drafting). | Proposed | Keeps AI to drafting and checking, with verification on real builds. | n/a |
| DEC-019 | Wave 1 reference platforms: Android phone and Windows (WinUI). | Proposed | The two heads that build on Windows today, and both have screenshot sets. | Q1. |

## 2. Open questions

| ID | Question | Why it matters | Default if unanswered | Needed by |
|---|---|---|---|---|
| Q1 | Which platforms are supported at v1? | Decides which manuals exist. | Android phone and Windows (WinUI). Others when confirmed. | Before WP4 |
| Q2 | Are phone and tablet separate manuals? | Doubles the work if yes. | No. One manual per operating system and head. | WP4 |
| Q3 | Are AI-assisted features visible in the app in scope, and how should they be described? | Content, and good practice theme 10. | Yes, as visible at release. | WP4 |
| Q4 | Where is the site hosted: the GitHub Pages address, or a custom domain? | Sets `govuk.site.url`, canonical URLs and the sitemap. | `https://oughnic.github.io/uFTi-Docs/` | WP1 |
| Q5 | Which brand assets exist (logo, colours, favicon, share image)? | WP6. | A plain masthead with the service name. | WP6 |
| Q6 | Is Spanish needed, and when? | Localisation-ready writing, and WP16. | Not for v1. | Before WP8 |
| Q7 | Who owns the copyright: an individual or an organisation? | `NOTICE` and any licence headers. | Nicholas Oughtibridge. | Before wider contributions |
| Q8 | Who reviews good practice content, and who reviews legal and data protection topics? | The review gate in the workflow. | The maintainer, with a volunteer genealogist to be found. | Before WP9 |
| Q9 | Do we accept community contributions, and by what process? | `CONTRIBUTING.md`. | Issues first. Pull requests after WP1. | WP1 |
| Q10 | Should the colophon say the content is AI-assisted and human-reviewed? | Transparency. | Yes. | WP10 |
| Q11 | Do both Windows heads (WinUI and WPF) ship to users? | The platform catalogue. | WinUI only, unless told otherwise. | With Q1 |
| Q12 | What should `robots.txt` say about AI crawlers? The plugin's default allows all. | Content reuse policy. | Allow all. | WP10 |
| Q13 | How are topic dates kept true? | `govuk.dates` and page metadata. | Dates off. | WP3 |
| Q14 | Who captures screenshots, with what tooling, and how often? | Risks R3 and R12. | The maintainer, with scripted capture, on each release candidate. | WP4 |
| Q15 | Does the app record DNA evidence? | Good practice theme 9. | No, so a short ethics and citation note only. | WP4 |

## 3. Change history

| Date | Change |
|---|---|
| 15 October 2026 | Draft 0.1 created with the initial plan. |
