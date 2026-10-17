# Quick Start outline: Android phone

Part of [WP0](README.md). Status: draft for testing, 16 October 2026. The shape is set by the [content model, section 3](../content-model.md#3-the-quick-start): seven pages, ten minutes, each under 150 words with one picture. Pages 1 and 6 are for Android. The rest are for the phone idiom ([platform strategy, section 2.3](../platform-strategy.md#23-idiom-first-platform-at-the-edges)).

Labels in **bold** are what we expect to see on screen. WP4 confirms every one against the app. Page 3 depends on Q19, the bundled sample.

## The seven pages at a glance

| # | Title | Picture (key) | Journeys served | The one link at the end |
|---|---|---|---|---|
| 1 | Get uFTi | `img-start-first-run` | All | Page 2 |
| 2 | Look around | `img-nav-main` | All | Page 3 |
| 3 | Explore a family | `img-person-view` | 5, and anyone unsure what a finished tree looks like | Page 4 |
| 4 | Add your first person | `img-person-add` | 1, 5 | Page 5 |
| 5 | Say where you found it | `img-citation-add` | 3, and the seed of 4 | Page 6 |
| 6 | Keep it safe | `img-workspace-export` | 1, 6, 7 | Page 7 |
| 7 | What next | `img-tree-view` | All, by journey | Three journey links and the task finder |

## Page 1: Get uFTi

Platform-specific: Android. Picture: `img-start-first-run`, the first screen after installing, with the sample workspace offered.

**Steps**

1. Open the **Play Store** on your phone.
2. Search for **uFTi**.
3. Choose **Install**. When it has finished, choose **Open**.
4. uFTi opens on the **Workspaces** screen. A workspace is one family tree.

You will see a sample workspace, **Brontë family of Haworth**. It is there to practise in. Your own tree comes later, on page 4.

**To confirm:** the store, the first screen, and whether anything asks for permission at first run.

## Page 2: Look around

Idiom-specific: phone. Picture: `img-nav-main`, a workspace open with the main navigation showing.

**Steps**

Every workspace has the same main screens. On a phone they are in the bar at the bottom.

- **People**: everyone in the tree.
- **Families**: couples and their children.
- **Tree**: the family drawn as a picture.
- **Sources**: where each fact came from.

Two more things to find:

- The **+** button adds a person, a family, a source and more.
- **Help** opens the page about the screen you are on.

Try it: open **People**, then come back with your phone's back button.

**To confirm:** the names and order of the main screens, where the bar sits, and the Help control (Q22).

## Page 3: Explore a family

Idiom-specific: phone. Picture: `img-person-view`, Charlotte Brontë's page with her facts and their sources.

**Steps**

1. On **Workspaces**, open **Brontë family of Haworth**.
2. Choose **People**. Find **Charlotte Brontë**, or type *Charlotte* in search.
3. Open her page. You see her birth, her marriage and her death. Each fact shows where it was found.
4. Choose her father, **Patrick**, to jump to his page.
5. Choose **Tree**. You see Patrick, Maria and their six children.

Look around as much as you like. This is a sample to practise in. Your own tree starts on the next page.

**Depends on:** Q19. If the app does not bundle the sample, this page opens a downloaded file instead, and becomes platform-specific.

## Page 4: Add your first person

Idiom-specific: phone. Picture: `img-person-add`, the add-person form as it looks when adding Patrick Brontë.

**Steps**

1. Go back to **Workspaces**. Choose **New workspace**.
2. Give it a name, such as *My family*. If it asks who made this tree, type your name.
3. Choose **+**, then **Person**.
4. Type a first name and a last name. Start with yourself, or someone you know well.
5. If you know the birth date, add it. If not, leave it blank.
6. Choose **Save**.

The person's page opens. That is your first person. Everything else in uFTi hangs off people like this one.

**To confirm:** what the new-workspace form asks for, and the label the app uses for the person who made the tree.

## Page 5: Say where you found it

Idiom-specific: phone. Picture: `img-citation-add`, adding a source to Charlotte Brontë's birth.

**Steps**

1. On the person's page, open the birth. If there is none, add one with **+**.
2. Choose **Add source**.
3. Choose **New source**. Type where you know this from. For example: *My birth certificate*, or *Mum told me*.
4. Choose **Save**.

The birth now shows its source. In the Brontë sample, every fact has one. Later, when two records disagree, this is how you will know what to believe.

**To confirm:** the labels for adding a source to a fact, and the fewest fields a source needs.

## Page 6: Keep it safe

Platform-specific: Android. Picture: `img-workspace-export`, the export choices for a workspace.

**Steps**

1. Go to **Workspaces**.
2. Open the menu for your workspace. Choose **Export**.
3. Choose a family tree file.
4. Choose **Share**. Pick somewhere you can get it back from later: your email, or a cloud drive.
5. Do this again after you add a lot.

A copy somewhere else means you can always get your tree back.

**Rule:** this page says nothing about where the app keeps your tree (DEC-040). It says only how to make a copy.

**To confirm:** the export choices and the share step.

## Page 7: What next

Idiom-specific: phone. Picture: `img-tree-view`, the tree around Patrick and Maria.

**Steps**

You have a tree, a person, a fact with its source, and a copy. Well done. What do you want to do now?

- **I have a few names.** Build your first tree, one family at a time.
- **My tree is in another program.** Bring your tree across.
- **I have a certificate or a photo.** Record what you have found.

For anything else, see **I want to** on the manual's home page. And **Five things to know** takes two minutes.

**Links by journey**

| Link | Journeys | Target |
|---|---|---|
| Build your first tree | [1](journey-1-starting-from-nothing.md), [5](journey-5-a-young-persons-project.md) | The first-tree tutorial |
| Bring your tree across | [2](journey-2-bringing-a-tree-across.md) | Import a family tree file |
| Record what you have found | [3](journey-3-recording-a-find.md), [7](journey-7-getting-a-photo-in.md) | Add a source to a fact, Add a photo |
| I want to | [4](journey-4-checking-a-doubt.md), [6](journey-6-sharing-with-family.md) and the rest | The [task finder](task-finder.md) |

## Pictures for the screen catalogue

Fields follow the [screenshot strategy, section 3](../screenshot-strategy.md#3-the-screen-catalogue). Stages are from the [dataset strategy, section 5](../dataset-strategy.md#5-the-journey).

| Key | State, in plain words | Stage | Focus | Capture | Notes |
|---|---|---|---|---|---|
| `img-start-first-run` | The first screen after installing, with the sample offered | 0 | none | in-app | Platform-specific. Portrait. |
| `img-nav-main` | A workspace open, main navigation showing | 2 | the workspace | in-app | Idiom-specific. Crop to show the whole bar. |
| `img-person-view` | Charlotte Brontë's page: facts with their sources | 6 | Charlotte Brontë | in-app | Scroll so birth and source show together. |
| `img-person-add` | The add-person form, filled in for Patrick Brontë, before Save | 2 | Patrick Brontë | in-app | |
| `img-citation-add` | Adding a source to Charlotte's birth, before Save | 6 | Charlotte Brontë | in-app | |
| `img-workspace-export` | The export choices for the workspace | 9 | the workspace | in-app | Platform-specific. The share sheet itself is an OS screen and is not shown. |
| `img-tree-view` | The tree around Patrick and Maria, with the six children | 3 | Patrick Brontë | in-app | Portrait. Needs a written description in the topic. |

## Wave 2 notes

- **Android tablet** shares pages 1 and 6 with the phone, because the platform is the same. Pages 2 to 5 and 7 need landscape pictures, and page 2 needs its own words if the navigation sits elsewhere. To measure in WP4.
- **iPhone and iPad** need their own pages 1 and 6: the App Store, and the share sheet with Files. The rest follows the phone and the tablet.

## Open points

| Point | Where decided |
|---|---|
| Does the app bundle the sample? | Q19 |
| Does every screen have a Help control? | Q22 |
| The labels in bold | WP4 |
| Does the Quick Start measure its ten minutes from page 1 or page 2? | The [session plan](novice-session-plan.md) says how it is timed. |
