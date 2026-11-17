# The parity matrix

Where each task and each help screen stands in the six manuals: Windows, Android phone, Android tablet, iPhone, iPad and the Mac (Mac Catalyst). Part of the [authoring plan](authoring-plan.md). Written 17 November 2026 for [issue 196](https://github.com/oughnic/uFTi-Docs/issues/196), from the Alpha-2 publication.

This page is public. It names no machine, no account and nothing from the application repository. It says what the pages hold, and nothing more.

## 1. What parity means here

Where the app does the same thing on two devices, each device's manual has a page for it. The words may differ, because each manual is written for its own device (DEC-032). The page may be shared, or the device may have its own, as the platform strategy decides.

Parity does not mean the same pages. A computer has files beside a tree, and a phone does not. A phone has a camera, and most computers do not. These are differences of the device. They are listed in section 5, and they are not gaps.

## 2. How it was made, and how to keep it

- **The pages.** For each manual, the pages in the Alpha-2 publication, found by title. A page counts for a task when its title names the task, or when the notes below say which page covers it.
- **The help screens.** The help map of each device (`pwsh build/scripts/new-help-map.ps1`), against the screens in `build/help/screens.csv`.
- **Keeping it.** Make the table again when a manual gains or loses a page, and when the app team changes the list of screens. A row marked *check* needs a read of the pages. A row marked *walk* needs the app on the device.

## 3. What is at parity

| What | Windows | Android phone | Android tablet | iPhone | iPad | Mac |
|---|---|---|---|---|---|---|
| Privacy policy (`about.privacy`) | Yes | Yes | Yes | Yes | Yes | Yes |
| Components and licences (`about.components`) | Yes | Yes | Yes | Yes | Yes | Yes |
| Who can see your tree | Yes | Yes | Yes | Yes | Yes | Yes |
| Pictures from a website | Yes | Yes | Yes | Yes | Yes | Yes |
| Opened files and copies | Yes | Yes | Yes | Yes | Yes | Yes |
| Which file to send | Yes | Yes | Yes | Yes | Yes | Yes |
| Keep it safe | Yes | Yes | Yes | Yes | Yes | Yes |
| The dates, places and names pages | Yes | Yes | Yes | Yes | Yes | Yes |
| The Quick Start and Five things to know | Yes | Yes | Yes | Yes | Yes | Yes |

The privacy policy is one source. The components page is generated for each device family from the app's inventory (DEC-248), and so it is the same kind of page everywhere, with different contents.

## 4. The gaps

### 4.1 Pages that one or more devices lack

| Task | Windows | Android phone | Android tablet | iPhone | iPad | Mac | Needs |
|---|---|---|---|---|---|---|---|
| Get the app | No | Yes | Yes | No | No | No | Decision, then pages (issue 66) |
| Open a family tree file | Yes | No | Yes | Yes | Yes | Yes | Walk (issue 194) |
| Find help and the version | Yes | No | No | Yes | Yes | Yes | Walk |
| Say who made this tree | Yes | Yes | Yes | Yes | No | Yes | Check, then walk |
| Take a photo of a document | No | Yes | No | No | No | No | Decision (issue 68) |
| Where your trees are saved | Yes | No | No | No | No | No | Check: DEC-168 allows it on every device |

Notes:

- **Get the app.** Windows had a page and lost it in the Alpha-2 rewrite. The iPhone, iPad and Mac pages wait for the maintainer's decision on how readers get each app. None may name a store listing that is not public, or say who may get a build before release.
- **Find help and the version.** On the Android phone this is also the missing `about` help target.
- **Take a photo of a document.** The other mobile manuals cover the camera inside *The Photos buttons*. Whether the Android phone's page should be shared, or the others should have one, is for the maintainer.

### 4.2 Tasks that the Windows manual has as pages of their own

The other five manuals cover some of these inside other pages. The last column says where, from a search of the pages. *Check* means that the page has to be read to see whether the task is really covered.

| Windows page | On the other devices | Needs |
|---|---|---|
| Create a workspace | Not found as a task. *Add your first person* may start a tree | Check, then walk |
| Move between workspaces | Not found | Walk |
| Remove a person | Inside *Change a person* on the Android phone only | Check, then walk |
| See a family's page | Inside *See a family tree* on the iPad only | Check, then walk |
| Add a later family | Inside *Add a family with children* | Check |
| Add a source to a person | Inside *Look at the sources of a fact* | Check |
| Use one note for several people | Inside *Add a note to a person* on the Android phone only | Check |
| Add an event of your own kind | Inside *Add an event* on the Android phone only | Check |
| Enter a period | Inside *Enter a date, even one you are not sure of* | Check |
| Add a photo to a person | Inside *The Photos buttons* | Check |
| Events, notes and sources | The three tasks are separate pages | None: a chapter page on Windows |
| Use a form for a real record | *Forms for records you have seen* | None: the same task |
| Add a repository | *Add a place where records are kept* | None: the same task |
| Add an event to a person | *Add an event* | None: the same task |

### 4.3 Help screens

The app has 27 screens. This is the state of their help pages, from the maps for Alpha-2.

| Screen | Windows | Android phone | Android tablet | iPhone | iPad | Mac |
|---|---|---|---|---|---|---|
| `people.merge` | No | No | No | No | No | No |
| `about` | Yes | No | Yes | Yes | Yes | Yes |
| `more` | No | Yes | No | Yes | Yes | Yes |
| The other 24 | Yes | Yes | Yes | Yes | Yes | Yes |

`people.merge` is a known gap on the app side too. The Android tablet has a page for `about`, and it has no page called *Find help and the version*, so check what that page is. Whether the screen `more` exists on Windows and on the Android tablet is for the app team.

### 4.4 Builds and pictures

Every manual says it was checked against Alpha-2. The version that each manual's pictures record is in `build/publications.ini`. The Windows manual's pictures come from an earlier build of Alpha-2 than the other five. Decide whether to take them again before the next publication.

## 5. Differences that are not gaps

| What | Why |
|---|---|
| *Files beside your tree* only on Windows | A phone, a tablet or a Mac keeps its own copy of the file, so nothing sits beside the tree (DEC-100, DEC-247) |
| *Take a photo of a document* | A phone has a camera that a computer may not have |
| Different words for the same task | Each manual is written for its device (DEC-032) |
| The tablet and iPad pages for the person beside the tree | The screen shows two things at once |
| *Keep it safe* and *Who can see your tree* once for each device family | The backup, sync and file rules of each system are different (DEC-249) |

## 6. Work to do, in order

1. **Read the pages** for each *Check* row, and say for each whether the task is covered. This needs no app and no walk. It turns most of section 4.2 into done or into a *Walk* row.
2. **Write what a read can settle:** the pages that need only what the other devices already say, with the device's own words, once the maintainer agrees.
3. **Walk what is left,** device by device, and write the pages from the walk (the walk plan; DEC-213).
4. **Get the app** pages, when the maintainer has decided how readers get each app (issue 66).
5. **Make the table again,** and close the epic when no row says No without a reason in section 5.
