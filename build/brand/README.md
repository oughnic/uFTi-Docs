# uFTi brand artwork

The uFTi logo and store art, as the app's team publishes them, kept unchanged for the documentation website and PDFs.

**These files are not under the Apache-2.0 licence of this repository, or any other.** Their terms of use are the app team's, in [`art/README.md`](art/README.md): copy and show them unchanged apart from scaling, only to publish uFTi's documentation or to say truthfully that something is about uFTi. Anything else needs written permission from Oughtibridge Ltd (DEC-165).

## Source

| | |
|---|---|
| Made by | The app's repository (private), folder `design/brand`, by its brand script from one stitch map. Never edit a file here: import again. |
| Artwork version | **1.3.0** |
| Tag | `brand-v1.3.0` |
| Commit | `98137e212216fa29f1bf39784df4d4a5a3e461fa` |

## What is here

| Path | What it is | Used for |
|---|---|---|
| `art/ufti-mark.svg` | The mark, no tile, for light backgrounds | The cover of each print document and PDF |
| `art/ufti-mark-on-dark.svg` | The mark, no tile, light thread, for dark backgrounds | The masthead |
| `art/ufti.ico` | 16, 32 and 48 pixel versions | The favicon (`govuk.favicon`) |
| `art/ufti-share-card.png` | 1200 × 630 | The share image (`govuk.og.image`) |
| `art/ufti-share-card-outlined.svg`, `ufti-hero-outlined.svg` | Share card and landscape hero | Kept; the Get the app pages and slides |
| `art/ufti-box-front-outlined.svg`, `ufti-play-feature-outlined.svg` | Box front, Google Play graphic | Kept for the stores and the Get the app pages |
| `art/ufti-store-poster-outlined.svg`, `ufti-store-box-art-outlined.svg` | Microsoft Store poster (9:16) and box art (1:1) | Kept for the Get the app pages |
| `art/ufti-app-icon.svg`, `ufti-app-icon-256.png`, `-1024.png`, `ufti-app.ico` | The desktop app icon (a tile with a margin) and the Windows program icon | Kept; the install pages can show what to look for |
| `art/ufti-sampler*.svg`, `.png`, `ufti-touch-icon.svg`, `ufti-icon-*.png` | The master, pixel versions, touch and store icons | Kept |
| `../theme/assets/brand/` | The four files the build ships beside the stylesheet: `ufti.ico`, `ufti-share-card.png`, `ufti-mark.svg`, `ufti-mark-on-dark.svg` | |

The app team's `.svg` files with live text are not kept. They load the app's fonts from a path in the app's repository and draw wrongly anywhere else: use the `-outlined` files.

## How to import a new version

1. Run `pwsh build/brand/import-brand.ps1 -Tag brand-v<version>`. It needs the GitHub CLI signed in with access to the app's repository. It only copies files and changes none (`-From <folder>` takes a local copy of `design/brand` instead).
2. Change the version, tag and commit in the table above (the script prints the commit), and look at the app's `art/README.md` for changed terms and claims.
3. Run `pwsh build/theme/check-theme.ps1`, build a deliverable and look at the masthead and a PDF cover.

## Rules

- The marks are background images in the masthead and on each cover: decoration only. The publication's name beside them says which publication it is, and the PDF leaves them untagged.
- Show the mark whole and at its own proportions. Never recolour, crop or redraw it.
- The art makes claims (every device, GEDCOM 7, evidence first, three themes). The app team keeps them in one list and says they must match what ships and what the documentation says, and never gain a price, an account, a sign-in or a storage claim. Review them when you import.
- Platforms appear in the art as plain device outlines. Never add a platform's own logo.
- The box and store art are not screenshots of the app. A picture of the app is a screenshot from the Brontë dataset.
