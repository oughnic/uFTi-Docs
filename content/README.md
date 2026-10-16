# content/

The DITA source for the documentation: maps, topics, keys and images.

**This folder is empty on purpose.** Authoring starts with the pilot slice (WP7) once the toolchain, platform strategy and standards work packages are done. See the [delivery plan](../authoring/authoring-plan.md#8-delivery-plan).

## Planned layout

This is a proposal. WP2 confirms or changes it (see [platform strategy, section 7](../authoring/platform-strategy.md#7-map-patterns)).

```text
content/
  maps/              publication maps and bookmaps, one per platform plus the good practice guide
  topics/            platform-neutral topics, one folder per area (people, sources, ...)
  platforms/<slug>/  keys/, images/ and topics/ that exist for one platform only
  good-practice/     topics for the good practice guide
  glossary/          glossentry topics
  keys/              shared key maps: product facts, versions, UI labels, terms
  images/            shared diagrams
  quick-start/       the Quick Start pages, one folder per device idiom
  diagrams/          clickable SVG diagrams
  sample-data/bronte/  the Brontë dataset: its specification and evidence register (WP4b)
```

Conventions for names, identifiers and markup are in [authoring-standards.md](../authoring/authoring-standards.md).
