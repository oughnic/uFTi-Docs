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
| `/docs/` | Documentation | The device chooser: "What are you using uFTi on?" | DITA build (the root of the documentation tree) |
| `/docs/<device>/` | A device's versions | The versions of uFTi that have a Quick Start and a manual for that device, newest first, each with its PDFs. | DITA build (written from the releases in the tree) |
| `/docs/<device>/<release>/` | A manual | The manual for one uFTi app release on that device, as a website and a PDF. | DITA build |
| `/docs/<device>/<release>/start/` | Quick Start | The ten-minute start for that release on that device, as a website and a PDF. | DITA build |
| `/docs/<device>/latest/` | The current release | A redirect to the current release's manual (and `latest/start/` to its Quick Start). It is for people; the app links to its own release. | Hosting configuration |
| `/support/` | Support | How to get help, report a problem, give feedback. Links to issues. | Marketing page |
| `/about/` | About | Who makes it, the project's status, open-source status when it applies. | Marketing page |
| `/privacy/` | Privacy | What the app and the site do with data, stated as current behaviour with a date. | Marketing page, reviewed |
| `/accessibility/` | Accessibility statement | For the site and the manuals, following the GOV.UK template. | Marketing page |
| `/legal/` | Licences and trademarks | Apache-2.0, font and component licences, the uFTi name and logo. Terms of service when a service exists. | Marketing page |
| `/news/` or `/releases/` | What is new | Release notes for the app and the manuals. | Marketing page, fed from the manuals' "What is new" |

The manuals' footers link to the chooser, the other versions of that device's manual (and the Quick Start beside the manual, or the manual beside the Quick Start), the accessibility statement, support and the source repository.

### 2.1 Releases below devices

`<device>` is a folder named for the platform: `windows`, `android-phone`, `iphone`, `ipad`, `macos` (and `android-tablet` when that manual exists). `<release>` is a **uFTi app release**: `Alpha-1`, `Alpha-2`, `Beta-1`, `RC-1`, `1.0`, `1.2.3` (DEC-141). It is not this repository's version, the plugin's or the toolkit's. Each device has its own release, because the apps are walked and released one at a time. The first is `Alpha-1`. A release folder is complete in itself: the manual's website and PDF, with the Quick Start's website and PDF in `start/`. The PDF names carry the release (`ufti-user-manual-windows-Alpha-1.pdf`), so a downloaded file says which version it is.

An earlier release stays at its address, unchanged, when a later one is published (DEC-143). Its page in the device's list says so by listing it below the newer one, and its footer says which version it is and links to the others. The documentation does not say that an old release is out of date, because a reader may still have that app. The tree and how it is built are in [build and quality, section 7](build-and-quality.md#7-the-publishing-tree).

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

The documentation tree is meant for **Azure Static Web Apps** (DEC-142), a static host that sets headers and redirects. It serves the tree as built: no build runs in Azure. The finished tree is pushed to the `publish` branch (DEC-144), and that branch, with its root as the app location, is what Azure deploys. The tree's own configuration, `staticwebapp.config.json`, is written by the build and ships at the root of the tree. It redirects `<device>/latest/` to the current release, caches the current release for minutes and an earlier release for a day, gives PDFs their content type, and shows `not-found.html` with the status 404. The pages keep `govuk.csp=meta` (a `meta` tag), so they behave the same in the app's help frame and need no header.

The marketing pages (section 4) are not part of the tree. Where they are hosted is still open. If Static Web Apps serves only the documentation, it is bound to the address that `base-url` in `build/publications.ini` names, and that value is the only one to change. GitHub Pages remains a possible host for the marketing pages: it serves a custom domain over HTTPS but sets no custom headers and has no redirects, a soft size limit of about a gigabyte and a bandwidth limit of about a hundred gigabytes a month.

The build parameters that depend on the address come from the release in `build/publications.ini`, not from the project files: `govuk.site.url` is `https://ufti.com/docs/<device>/<release>/` for each manual, with `start/` below it for the Quick Start, and `https://ufti.com/good-practice/` for the guide.

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
