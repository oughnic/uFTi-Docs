# content/

The DITA source for the documentation: maps, topics, keys and images.

**So far** the Windows Quick Start and "Five things to know" (WP7, [issue #15](https://github.com/oughnic/uFTi-Docs/issues/15)). The rest of the manual follows the [delivery plan](../authoring/authoring-plan.md#8-delivery-plan).

## What is here

```text
content/
  ufti-quick-start-windows.ditamap   the Windows Quick Start as its own publication
  ufti-manual-windows.ditamap        the Windows manual: the Start here chapter so far
  maps/structure/quick-start.ditamap the seven pages in order, shared by both
  topics/quick-start/                the pages written for the idiom (2 to 5 and 7), the chapter
                                     introduction, and "Five things to know"
  platforms/windows/topics/          the pages for one platform (1 and 6)
  platforms/windows/keys/            the manual's own keys: pictures (images.ditamap) and the words on
                                     screen (ui-labels.ditamap)
  platforms/windows/images/          its pictures, written by build/scripts/Import-Screenshots.ps1
  keys/product.ditamap               product facts shared by every manual
  glossary/                          one glossentry per term
  sample-data/bronte/                the Brontë dataset: its specification and evidence register (WP4b)
```

Build and check it with the scripts in [`build/`](../build/README.md):

```powershell
pwsh build/scripts/build.ps1 -Project quick-start-windows
pwsh build/scripts/check-output.ps1 -Deliverable quick-start-windows
```

## Planned layout

This is the rest of the layout, a proposal. WP2 confirms or changes it (see [platform strategy, section 7](../authoring/platform-strategy.md#7-map-patterns)). The reasons for the layout so far are in the decision log (DEC-045, DEC-080).

```text
content/
  ufti-manual-<slug>.ditamap   one bookmap per manual, at the root: the toolkit and the plugin treat
                               the root map's folder as the publication, and nothing may sit above it
  ufti-quick-start-<slug>.ditamap  one Quick Start per manual, beside it
  good-practice-guide.ditamap  the standalone guide
  maps/structure/    shared chapter maps, one per chapter, included from the bookmaps
  topics/            platform-neutral topics, one folder per area (people, sources, ...)
  platforms/<slug>/  keys/, images/ and topics/ that exist for one platform only
  good-practice/     topics for the good practice guide
  glossary/          glossentry topics
  keys/              shared key maps: product facts, versions, UI labels, terms
  images/            shared diagrams
  diagrams/          clickable SVG diagrams
  sample-data/bronte/  the Brontë dataset: its specification and evidence register (WP4b)
```

Conventions for names, identifiers and markup are in [authoring-standards.md](../authoring/authoring-standards.md).
