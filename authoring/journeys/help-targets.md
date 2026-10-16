# Screens that need an in-app help target

Part of [WP0](README.md). Status: draft for testing, 16 October 2026. Every screen in the app gets a help target. That is the page the app opens when the reader chooses Help on that screen ([content model, section 5](../content-model.md#5-in-app-help), DEC-028). This list is the first draft. WP4 replaces it with the inventory taken from the running app.

## Where this list comes from

- The app's visible navigation, as the plan records it in the [provisional outline](../authoring-plan.md#34-provisional-manual-outline). That gives workspaces, people, families and the tree, search, and events with their dates and places. It also gives sources and repositories, notes and research notes, photos and media, forms, settings and About.
- The seven [journeys](README.md), which say which screens people reach first.

## Rules

- **One target per screen.** A screen with several states (view, add, edit) gets one target per state only where the reader's question differs. Viewing a person and editing a person are different questions. Adding and editing a person are the same question.
- **Identifiers** follow the content model's example, `people.edit`: the area, a dot, the screen. Lower case, no spaces. They are proposals. The app team gives each screen its stable identifier (Q22), and the docs then use those.
- **Operating-system screens** need no target: the file picker, the share sheet, the camera and permission prompts. The manual describes them in words.
- **The help page itself** needs no target.
- **First release** means the screen is on the Quick Start route or in the top ten tasks (DEC-044), so its topic and target come first.

## The screens

| Area | Screen, in plain words | How the reader gets there | Proposed identifier | Topic that answers it | Journeys | First release |
|---|---|---|---|---|---|---|
| Start | Workspaces list, the first screen | Opening the app | `workspaces.list` | Concept: Workspaces. Quick Start page 1 | All | Yes |
| Start | New workspace | Workspaces, then **+** or **New workspace** | `workspaces.create` | Task: Create a workspace | 1, 5 | Yes |
| Start | Workspace menu: rename, export, delete | The menu on a workspace | `workspaces.view` | Task: Manage your workspaces | 6 | Yes |
| Start | Import a family tree file | Workspaces, then Import | `workspaces.import` | Task: Import a family tree file | 2 | Yes |
| Start | Import summary | After an import finishes | `workspaces.import-summary` | Reference: What an import keeps and what it does not | 2 | Yes |
| Start | Export | The workspace menu, then Export | `workspaces.export` | Task: Export a family tree file | 1, 6, 7 | Yes |
| People | People list | **People** | `people.list` | Task: Find a person | All | Yes |
| People | Person page | A person in the list | `people.view` | Concept: The person page | All | Yes |
| People | Add or edit a person | **+** then **Person**, or Edit on a person | `people.edit` | Task: Add a person. Task: Edit or remove a person | 1, 5 | Yes |
| People | Names, if its own screen | A person, then their names | `people.names` | Task: Enter a name you are not sure of | 1 | No. To confirm |
| Families | Families list | **Families** | `families.list` | Concept: People and families | 1 | Yes |
| Families | Family page | A family in the list | `families.view` | Task: Add a parent, partner or child | 1, 5 | Yes |
| Families | Add or edit a family | **+** then **Family**, or Edit on a family | `families.edit` | Task: Add a family | 1, 5 | Yes |
| Families | Add a member to a family | A family, then add a member | `families.add-member` | Task: Add a child to a family | 1, 5 | Yes |
| Tree | The family tree | **Tree** | `tree.view` | Task: View the family tree | 1, 5 | Yes |
| Search | Search | The search box | `search` | Task: Find a person | 2, 3 | Yes |
| Events | Add or edit an event | A person or family, then **+** on facts | `events.edit` | Task: Add an event | 1, 3 | Yes |
| Events | The date editor | An event, then its date | `events.date` | Task: Enter a date you are not sure of. Task: Say how sure you are about a date | 1, 4, 5 | Yes |
| Events | Place picker or place page | An event, then its place | `places.edit` | Task: Add a place | 3 | No |
| Sources | Sources list | **Sources** | `sources.list` | Concept: Sources, citations and evidence | 3 | Yes |
| Sources | Source page | A source in the list | `sources.view` | Task: Add a source to a fact | 3 | Yes |
| Sources | Add or edit a source | **+** then **Source**, or Edit on a source | `sources.edit` | Task: Add a source | 3 | Yes |
| Sources | Add a source to a fact | A fact, then **Add source** | `citations.edit` | Task: Add a source to a fact. Quick Start page 5 | 3 | Yes |
| Sources | Repositories list | Sources, then Repositories. To confirm | `repositories.list` | Task: Add a repository | 3, 7 | No |
| Sources | Repository page | A repository in the list | `repositories.view` | Task: Add a repository | 3, 7 | No |
| Sources | Add or edit a repository | **+** then **Repository**, or Edit | `repositories.edit` | Task: Add a repository | 3, 7 | No |
| Sources | Where evidence is weighed | To confirm in WP4 | `evidence.reconcile` | Task: Record evidence that disagrees | 4 | No |
| Notes | Notes list | **Notes** | `notes.list` | Task: Add a note | 1 | No |
| Notes | Add or edit a note | **+** then **Note**, or Edit on a note | `notes.edit` | Task: Add a note | 1, 5 | Yes |
| Notes | Research notes list | **Research notes** | `research.list` | Task: Find a research note | 4 | No |
| Notes | Add or edit a research note | **+** then **Research note**, or Edit | `research.edit` | Task: Add a research note | 3, 4 | No |
| Photos | Media list | **Media** or **Photos** | `media.list` | Task: Find a photo | 7 | No |
| Photos | Photo page | A photo in the list or on a person | `media.view` | Task: Add details to a photo | 7 | Yes |
| Photos | Add a photo, from the camera or from files | **+** then **Photo** | `media.add` | Task: Add a photo | 3, 5, 7 | Yes |
| Forms | Forms list | **+** then **Form** | `forms.list` | Concept: Create records with forms | None yet | No |
| Forms | A census household form | Forms, then the census form | `forms.census` | Task: Record a census household with a form | None yet | No |
| Checks | Check results | The menu, then Check. Candidate | `checks.results` | Task: Check your tree | 2 | No |
| Checks | Duplicates | The menu, then Duplicates. Candidate | `duplicates.list` | Task: Find and merge duplicates | None yet | No |
| Settings | Settings | The menu, then Settings | `settings` | Task: Change language, appearance and text size | None yet | No |
| Settings | About | The menu, then About | `about` | Reference: About uFTi | None yet | No |

Forty screens. The screenshot strategy budgets 25 to 40 screens per manual, so the two lists should end up close.

## Counts

| | Screens |
|---|---|
| First release | 24 |
| Later | 16 |
| To confirm against the app | 6, marked in the table |

## What WP4 must do with this list

1. Walk the app on each wave-1 device and replace the "how the reader gets there" column with what is there.
2. Add, remove and rename screens. Keep the identifiers stable once the app team adopts them.
3. Mark screens that mention AI features, which are documented without them (DEC-020).
4. Measure which screens differ on a tablet, so the help map per device is right.
5. Hand the identifier list to the app team as the docs' side of Q22.
