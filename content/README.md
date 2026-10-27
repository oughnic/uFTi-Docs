# content/

The DITA source for the documentation: maps, topics, keys and images.

**So far** the Windows and Android phone Quick Starts and "Five things to know" (WP7, [issue #15](https://github.com/oughnic/uFTi-Docs/issues/15)), and the start of the chapter "Bring in, share and keep safe" ([issue #34](https://github.com/oughnic/uFTi-Docs/issues/34)). The rest of the manual follows the [delivery plan](../authoring/authoring-plan.md#8-delivery-plan).

## What is here

```text
content/
  ufti-quick-start-windows.ditamap   the Windows Quick Start as its own publication
  ufti-manual-windows.ditamap        the Windows manual: the Start here chapter, and so far the start of
                                     "Bring in, share and keep safe"
  ufti-quick-start-android-phone.ditamap, ufti-manual-android-phone.ditamap   the same for the Android phone
  ufti-quick-start-android-tablet.ditamap, ufti-manual-android-tablet.ditamap   the same for the Android tablet
  maps/structure/quick-start.ditamap the Quick Start pages in order, shared by both
  maps/structure/bring-in-share-and-keep-safe.ditamap   the pages of that chapter, shared by both
  topics/quick-start/                the pages the same on every device, the chapter introduction, and
                                     "Five things to know"
  topics/workspaces/                 the introduction to "Bring in, share and keep safe"
  platforms/windows/topics/, platforms/android/topics/   the pages for one platform (getting the app, keeping a copy)
  platforms/desktop/topics/, platforms/phone/topics/     the pages that differ by device idiom (adding a person, looking
                                     around, opened files and copies, which file to send; files beside your tree is for a computer only)
  platforms/<manual>/keys/           the manual's own keys: pictures (images.ditamap) and the words that
                                     only that device shows (ui-labels.ditamap)
  platforms/<manual>/images/         its pictures and crops.json (what was cropped, and why), written by
                                     build/scripts/Import-Screenshots.ps1
  keys/                              product facts, and the words on screen that every device shows
  glossary/                          one glossentry per term
  site/                              the accessibility statement and the privacy policy: pages of the site
                                     itself, at the top of the published tree, not part of a manual (DEC-150)
  templates/                         starting points for every kind of topic, map and diagram; in no
                                     map, so never published (WP3, templates/README.md)
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
