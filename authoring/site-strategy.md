# Site strategy: ufti.com

What ufti.com holds, how the manuals sit under it, and what marketing collateral is needed.

Part of the [authoring plan](authoring-plan.md). Status: Draft 0.4, 16 October 2026. Decisions are tracked in the [decision log](decision-log.md).

## 1. Decision

uFTi will be hosted at **ufti.com** (DEC-033). The site is in two parts with one look: marketing pages at the root, and the documentation under `/docs/`. Both use the GOV.UK Design System with the uFTi theme, so a reader moving from a product page to the manual sees no seam.

## 2. Information architecture

| Path | Page | Purpose | Made by |
|---|---|---|---|
| `/` | Home | What uFTi is, for whom, and how to get it. Screenshots from the catalogue. | Marketing page |
| `/features/` | Features | What it does, in the reader's words, each linked to the manual. | Marketing page |
| `/get/` | Get uFTi | Store links and installers per platform, system requirements. | Marketing page |
| `/good-practice/` | Family history good practice | The guide, as a public resource in its own right. | DITA build of the guide |
| `/docs/` | Documentation | The device chooser: "What are you using uFTi on?" | DITA build (the chooser) |
| `/docs/<device>/` | A manual | One per device, Quick Start first. | DITA build |
| `/docs/<device>/start/` | Quick Start | The ten-minute start for that device. | DITA build |
| `/support/` | Support | How to get help, report a problem, give feedback. Links to issues. | Marketing page |
| `/about/` | About | Who makes it, the project's status, open-source status when it applies. | Marketing page |
| `/privacy/` | Privacy | What the app and the site do with data, stated as current behaviour with a date. | Marketing page, reviewed |
| `/accessibility/` | Accessibility statement | For the site and the manuals, following the GOV.UK template. | Marketing page |
| `/legal/` | Licences and trademarks | Apache-2.0, font and component licences, the uFTi name and logo. Terms of service when a service exists. | Marketing page |
| `/news/` or `/releases/` | What is new | Release notes for the app and the manuals. | Marketing page, fed from the manuals' "What is new" |

The manuals' footers link to the chooser, the accessibility statement, support and the source repository.

## 3. Marketing collateral

| Item | Notes |
|---|---|
| **Store listings** per platform: title, subtitle, description, keywords, screenshots and a feature graphic | Screenshots come from the screen catalogue, so they match the manual. Descriptions follow the same reading level. Store screenshot sizes are added to the catalogue. |
| **Logo and brand assets** | Needed by the theme (Q5), the stores and the press kit. |
| **Press kit** | Logo files, screenshots, a short description, a longer description, facts. |
| **Share image** | `govuk.og.image` for the manuals, and the same image for the site. |
| **Launch page** | A version of the home page for the first public release. |
| **Release notes** | One page per release, in plain words. |

## 4. Tooling

The marketing pages are few and change rarely. They are hand-authored HTML on the same Design System and theme stylesheet, kept in this repository under `site/`, assembled by a small script, and checked by the same gates as the manuals (valid HTML, accessibility, links, page weight). No static-site generator until the pages outgrow this, which is about fifteen pages or a second author.

Why not DITA for them: a marketing page needs layout freedom the manual does not. Why not a separate generator: a second toolchain, a second look and a second set of checks for a handful of pages.

## 5. Hosting

GitHub Pages serves a custom domain over HTTPS, so ufti.com can stay on it. Its limits are no custom headers (so the Content Security Policy is a `meta` tag, and `frame-ancestors` cannot be set), no server-side redirects, a soft size limit of about a gigabyte and a bandwidth limit of about a hundred gigabytes a month. A static host that supports headers and redirects (Q26) becomes worth it when the site needs them, when video or large downloads arrive, or when privacy-respecting logs are wanted (DEC-043). Moving a static site is a day's work, so the choice does not need making now.

The build parameters that depend on the address: `govuk.site.url` is `https://ufti.com/docs/<device>/` for each manual and `https://ufti.com/good-practice/` for the guide.

## 6. Business-model independence

The client is free today. Revenue may come later from AI models or a record-sync service. The documentation must not get in the way (DEC-040).

| Rule | Why |
|---|---|
| Topics never say "free", "always", "forever", "no account", "no sign-in" or where data is or is not stored. | Each becomes false the day a service ships. |
| Pricing, plans and account facts live on marketing pages, and in the manuals only through keys that can be changed in one place. | One edit, every manual. |
| The privacy page states current behaviour, with the app version and date it describes. | True today, honestly dated tomorrow. |
| Sync and AI do not appear in the manuals until they ship. The chapter structure leaves room: "Keep your tree in step across devices" and "Assistants" are reserved chapter names. | No rewriting, no broken promises. |
| Nothing in the documentation describes what the app does with data beyond what a user can observe. | Observable behaviour only, and nothing that constrains a future design. |

## 7. Open-source readiness

The documentation is already public and Apache-2.0. Nothing in the plan depends on the application repository staying private. If it opens (DEC-041):

- review the disclosure boundary (DEC-012), which exists only because the app is private;
- publish the contributor path: templates, lint, a local build in one command, and how AI assistance may be used;
- decide whether contributions need a sign-off (such as the Developer Certificate of Origin);
- keep the uFTi name and logo under a short trademark policy, since Apache-2.0 does not grant them.

## 8. Feedback and analytics

No analytics on the documentation for v1 (DEC-043): the plugin's sites set no cookies and make no third-party requests, and that is worth keeping. Feedback comes through a link on every page (the phase banner's feedback link) and the repository's issues. When the site moves to a host with privacy-respecting server logs, page-level use can be read without tracking readers.

## 9. Search engines

The plugin writes `sitemap.xml`, `robots.txt`, `llms.txt`, canonical links and Open Graph metadata for each manual. Five manuals share most of their text, so a search engine will pick one copy of a shared page to show; that is acceptable, and the chooser gets the reader to the right device. The guide is evergreen content and the main draw.

## 10. Work

WP6b delivers the site architecture, the marketing pages, the collateral list with owners, and the hosting decision. It depends on brand assets (Q5) and the hosting choice (Q26).
