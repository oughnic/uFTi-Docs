# uFTi brand artwork

The uFTi logo and store art, as the application's team publishes them, ready for the documentation website and PDFs. The mark is a cross-stitch tree on linen, stitched in the Oxford and slate colours, with its fruit in the app's three evidence colours.

**These files are not under the Apache-2.0 licence of this repository.** The uFTi name, the mark and the box and store art belong to Oughtibridge Ltd. You may copy them only to publish this documentation, or to say, truthfully, that you are writing about uFTi. Do not use them for anything else, and do not alter them. The licence of the rest of the repository does not give you the right to use them.

## Source

| | |
|---|---|
| Where they are made | The application's repository (folder `design/brand`), by its brand script from one 16 × 16 stitch map. Never edit the files here by hand: import them again. |
| Imported from | Branch `feat/1655-sampler-icon`, commit `99a15e3c464ee72dada93e56c62943645bd00c02` (25 October 2026). Change this line each time you import. |
| What the import changes | Each `<text>` becomes the outline of the same glyphs, so the file needs no font and draws the same when it is used as an image. Nothing else is changed. |

## What is here

| Path | What it is | Used for |
|---|---|---|
| `art/ufti-sampler.svg` | The 1024 master | The cover of each PDF (`ufti-mark.svg` is a copy) |
| `art/ufti-sampler-16.svg`, `-32`, `-48` | Pixel versions | The favicon (16, 32 and 48), and the masthead (32) |
| `art/ufti-hero.svg` | Landscape hero, 1920 × 1080 | The share image |
| `art/ufti-box-front.svg` | Box front, 1200 × 1600 | Kept for the Get the app pages and the stores |
| `art/ufti-play-feature.svg` | Google Play feature graphic | Kept for the stores; not used in the documentation |
| `../theme/assets/brand/` | What the build ships beside the stylesheet: `ufti.ico`, `ufti-share.png` (1200 × 630), `ufti-mark.svg`, `ufti-mark-small.svg` | `govuk.favicon`, `govuk.og.image` and `ufti.css` |

## How to import new artwork

1. Fetch the app's `design/brand/*.svg` into a folder (the repository is private: use `gh api` or a checkout).
2. Run `pwsh build/brand/import-brand.ps1 -From <that folder>`. It needs Docker only: it runs in the Playwright container that `build/tools.lock` pins, with opentype.js 1.3.4, and it uses the fonts in `build/theme/assets/fonts`.
3. Change the commit in the table above, run `pwsh build/theme/check-theme.ps1`, and build a deliverable to look at it.

## Rules

- The mark appears in the masthead and on the cover of each PDF as a background image: decoration only, never the only way to know which site this is. The name beside it says that.
- Show the mark whole, at its own proportions, on its own tile. Do not recolour it, crop it or put it on a busy background.
- Platforms appear in the art as plain device outlines. Never add a platform's own logo.
- Do not put the box or store art in a manual as a screenshot. A picture of the app is a screenshot from the app, from the Brontë dataset.
