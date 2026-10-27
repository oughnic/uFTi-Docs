# content/site/

The two pages that belong to the documentation site itself, not to a manual: the accessibility statement (`accessibility.dita`) and the privacy policy (`privacy.dita`). They are published at the top of the tree, at `https://docs.ufti.com/accessibility/` and `https://docs.ufti.com/privacy/`, and the footer of every page links them (DEC-150).

## The home page

`welcome.dita` is not a page of its own. The build writes it as `home.html` in the root build, moves its body into the top of `index.html` (above the list of devices, which it headings **Choose your device**) and removes `home.html`; `check-site.ps1` fails if the words are not there. Its pictures are in `images.ditamap`, and the files are copied to `images/` at the root of the tree (the hero from `build/brand/art/`, two pictures from the manuals). Say only what is true now and about the apps (DEC-173 to DEC-175).

## How they are built

`build/scripts/build-site.ps1` and `build-site.sh` copy each topic here into the sources of the root build as `<name>/index.dita`, list it in the root map with `toc="no"`, and build it with the plugin's neutral branding and the repository theme, like the platform pages. A new topic in this folder becomes a page at `/<name>/`, but the site also needs a link to it and a name `build/publications.ini` cannot give to a platform: add it deliberately.

## What may be said

- **Accessibility statement.** Claim only what a check in `build/` does, and say what is not done (DEC-151). When a check changes, change the statement in the same pull request.
- **Privacy policy.** Claim only what is verified in the built output or confirmed by the app team or the maintainer, and say it in plain words (DEC-153). Never say where a family tree is kept, and never mention price, accounts, sign-in, sync or AI (DEC-040). Re-check it whenever the app starts to use the network for something new. It is dated; change the date whenever it is checked.
- Both are written for a reader of about 11 and explain their hard words in a closing section, "Words we use" (DEC-155).
