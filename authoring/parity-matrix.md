# The parity matrix

Where each task and each help screen stands in the six manuals: Windows, Android phone, Android tablet, iPhone, iPad and the Mac (Mac Catalyst). Part of the [authoring plan](authoring-plan.md). Written 17 November 2026 for [issue 196](https://github.com/oughnic/uFTi-Docs/issues/196), from the Alpha-2 publication.

This page is public. It names no machine, no account and nothing from the application repository. It says what the pages hold, and nothing more.

## 1. What parity means here

Where the app does the same thing on two devices, each device's manual has a page for it. The words may differ, because each manual is written for its own device (DEC-032). The page may be shared, or the device may have its own, as the platform strategy decides.

Parity does not mean the same pages. A computer has files beside a tree, and a phone does not. A phone has a camera, and most computers do not. These are differences of the device. They are listed in section 5, and they are not gaps.

**How a gap is closed (DEC-251).** The maintainer's direction of 17 November 2026: reuse DITA content, and use DITAVAL for the differences between platforms, pictures included. So a missing page is written once and shared, and what differs on a device is a variant that its DITAVAL file keeps or drops. A copy for one device is the last resort. DEC-252 sets the limits on variants: no cap, any token in any topic, and sizes counted for each manual.

## 2. How it was made, and how to keep it

- **The pages.** For each manual, the pages in the Alpha-2 publication, found by title. A page counts for a task when its title names the task, or when the notes below say which page covers it.
- **The help screens.** The help map of each device (`pwsh build/scripts/new-help-map.ps1`), against the screens in `build/help/screens.csv`.
- **Keeping it.** Make the table again when a manual gains or loses a page, and when the app team changes the list of screens. A row marked *read* needs a read of the pages. A row marked *walk* needs the app on the device.

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
| Say who made this tree | Yes | Yes | Yes | Yes | No | Yes | Read, then walk |
| Take a photo of a document | No | Yes | No | No | No | No | Decision (issue 68) |
| Where your trees are saved | Yes | No | No | No | No | No | Read: DEC-168 allows it on every device |

Notes:

- **Get the app.** Windows had a page and lost it in the Alpha-2 rewrite. The iPhone, iPad and Mac pages wait for the maintainer's decision on how readers get each app. None may name a store listing that is not public, or say who may get a build before release.
- **Find help and the version.** On the Android phone this is also the missing `about` help target.
- **Take a photo of a document.** The other mobile manuals cover the camera inside *The Photos buttons*. Whether the Android phone's page should be shared, or the others should have one, is for the maintainer.

### 4.2 Tasks that the Windows manual has as pages of their own

Read on 17 November 2026: each Windows page against the pages of the other five manuals. Most of these tasks are covered inside a page that the mobile manuals share, so they are not gaps. Three are.

| Windows page | On the other five devices | Result |
|---|---|---|
| Create a workspace | Steps inside *Add your first person*, in every mobile manual | Covered |
| Move between workspaces | Not covered. *The screens of the app* only says that **Open another workspace** shows your trees. The walk reports name the screen, its cards and a line about switching, but not the button on a card | **Gap.** Walk, or ask the app team |
| Remove a person | Inside *Change a person*, with the warning that it cannot be undone and that the person leaves every family and event, on the Android phone and iPhone, and from 17 November 2026 on the Android tablet, iPad and Mac too | Covered. Closed by reuse of the phone's lines (DEC-199, DEC-251) |
| Use one note for several people | Inside *Add a note to a person*. The Android tablet had the button; from 17 November 2026 the Android tablet, iPad and Mac also say how to use one note for more than one person, as the phone does | Covered. Closed by reuse of the phone's lines. The iPhone and Mac buttons were not walked (DEC-199) |
| See a family's page | Inside *Add a family with children*: the page lists the partners, the marriage and the children, and says how to change them. The help screen `families.view` opens it | Covered, shorter than Windows |
| Add a later family | *Add a family with children* starts from a person who is already in the tree | Covered |
| Add a source to a person | Inside *Look at the sources of a fact* | Covered |
| Add an event of your own kind | Inside *Add an event*, shared by all five | Covered |
| Enter a period | Inside *Add an event*, shared by all five | Covered |
| Add a photo to a person | *The Photos buttons*: the folder and the camera. The Mac's camera is not described, because the walk did not try it | Covered |
| Events, notes and sources | A chapter page on Windows. The three tasks have their own pages elsewhere | Not a gap |
| Use a form for a real record | *Forms for records you have seen* | The same task |
| Add a repository | *Add a place where records are kept* | The same task |
| Add an event to a person | *Add an event* | The same task |

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

1. **Done (17 November 2026): the read of section 4.2.** Of the Windows-only tasks, two were thin or missing on some devices, and one is a gap on all five.
2. **Done (17 November 2026): what a read settled, closed by reuse with no walk (DEC-199, DEC-251).**
   - *Change a person*: give the Android tablet, iPad and Mac the phone's lines on removing a person.
   - *Add a note to a person*: give the Android tablet, iPad and Mac the phone's lines on using one note for several people.
   - Do each by sharing the lines, with a variant only where a device differs. Do not make a copy for a device.
3. **Read the rest of section 4.1:** *Say who made this tree* on the iPad, and *Where your trees are saved* on every device but Windows. Say for each whether a read settles it.
4. **Walk what is left,** device by device, and write the pages once, with variants for the differences (the walk plan; DEC-213). The walks are: *Move between workspaces*, *Find help and the version* on the two Android manuals, and *Open a family tree file* on the Android phone (issue 194).
5. **Get the app** pages, when the maintainer has decided how readers get each app (issue 66).
6. **Make the table again,** and close the epic when no row says No without a reason in section 5.
