# Screens that need an in-app help target

Part of [WP0](README.md) and [WP7b](../authoring-plan.md#8-delivery-plan). Status: 3 November 2026. Every screen in the app gets a help target. That is the page the app opens when the reader chooses Help on that screen ([content model, section 5](../content-model.md#5-in-app-help), DEC-028).

This list was a draft of 40 screens guessed from the plan. It is now the app's own list of its 24 screens (DEC-189), and for each one, the page that answers it. [`build/help/screens.csv`](../../build/help/screens.csv) holds the same 24 identifiers for the build.

## Rules

- **The app owns the identifiers.** The docs adopt them. A screen the docs cannot map is reported to the app team, not renamed here.
- **One target per screen.** A page may answer several screens, and a part of a page (a nested topic) may answer one ([authoring standards, section 2.1](../authoring-standards.md#21-nested-topics)).
- **Operating-system screens** need no target: the file picker, the share sheet, the camera and permission prompts. The manual describes them in words.
- **The help page itself** needs no target.
- **A map holds only the app's screens.** A task identifier in a topic (such as `workspaces.remove`) is for search and is left out.
- **A screen with no page** is left out of the map, and the app opens the manual's home page. It is a known gap: its row in `build/help/screens.csv` says `gap`, and the lint fails when a page is written and the mark stays (DEC-194).

## The screens, and the page on Windows

The Windows manual comes first because it has the most pages that match the app's screens. The other manuals take the same pages where their topics match; the build reports each device's gaps. "Walked" means the screen was opened in the Alpha-1 walk ([the Windows walk](../walks/alpha-1-windows.md)).

| Screen | In plain words | The page that answers it on Windows | State |
|---|---|---|---|
| `about` | About uFTi | *The screens of the app*, the part on **About uFTi** | Mapped. The page is not pictured (the walk found it shows AI features). |
| `add.record` | The list that starts a new record | *Add another person* | Mapped. The page explains the list for a person only. |
| `events.date` | The date editor | *Dates* | Mapped. The editor was not opened in the Alpha-1 walk: check its labels. |
| `events.list` | A person's events | *See the events of a person* | Mapped. |
| `families.view` | A family's page | none | **No page.** *Add a family with children* makes a family. It does not describe the page. Walk it. |
| `forms.compose` | A form for a new record | none | **No page.** Only the person, family and note forms were walked. |
| `home` | The home screen | none | **No page.** The Alpha-1 walk names no home screen. Confirm it exists on the build. |
| `more` | The More list | none | **Not on Windows.** The computer's menu has no More. The phone and the iPad do. |
| `notes.list` | The notes | *The screens of the app*, the part on **Notes** | Mapped. |
| `notes.record` | The notes on one record | none | **No page.** Confirm how it differs from `notes.list`. |
| `people.edit` | Add or change a person | *Add your first person* | Mapped. *Add another person* and *Change a person* have task identifiers. |
| `people.list` | A list of people | none | **No page.** The Alpha-1 menu has no list of people; search shows people. Confirm. |
| `people.merge` | Merge two people | none | **No page.** The walk did not cover duplicates. |
| `people.relatives` | A person's relatives | none | **No page.** Not in the Alpha-1 walk. |
| `people.view` | A person's page | *Look around* | Mapped. |
| `repositories.list` | Where records are kept | *The screens of the app*, the part on the three lists of the whole tree | Mapped to a short description. Adding one was not walked. |
| `research.list` | Research questions and notes | *The screens of the app*, the same part | Mapped to a short description. Adding one was not walked. |
| `search` | Search | *Find a person* | Mapped. |
| `settings` | Settings | *Choose how the app looks* | Mapped. The Windows menu names the screen **Preferences**. |
| `sources.sheet` | Add a source to a fact | *Say where you found it* | Mapped to the Quick Start page. |
| `sources.view` | The sources of a fact | *Look at the sources of a fact* | Mapped. |
| `submitters.list` | Who made this tree | *The screens of the app*, the same part | Mapped to a short description. Adding one was not walked. |
| `tree.view` | The family tree | *See a family tree* | Mapped. |
| `workspaces.list` | Your family trees | *The screens of the app*, the part on **Workspaces** | Mapped. |

**16 of the 24 screens have a page on Windows. Eight do not.** The other manuals have fewer: they have no tour part for the list screens yet (the Android and iOS tours are not split into parts), and the Mac manual holds only a few pages. Run `pwsh build/scripts/new-help-map.ps1` to see the figures for each device.

## What the docs need from the app team

1. **Do any ids need renaming?** None needs it for the docs. Each of the 24 maps to a page the docs write. The ones to check are the eight with no page: say whether they are on the build the docs describe, and what each one shows.
2. **Forms.** `forms.compose` is the screen that holds any form. If a form later needs a page of its own, tell the docs its identifier and the docs write the page, or point it at a shared one.
3. **Dates.** The one page on dates is `events.date`. Every screen that takes a date can point there.
4. **The date editor shows a typed example in the file format's own short codes.** The docs never show those (DEC-030), so they cannot quote the example. A plain-words example would let *Dates* describe it.

## What WP4 must do with this list

1. Walk the app on each device, for the eight screens with no page, and write them.
2. Add the nested parts to the tour of each phone and tablet, so their list screens land on a part.
3. Mark screens that mention AI features, which are documented without them (DEC-020).
4. Measure which screens differ on a tablet, so each device's map is right.
