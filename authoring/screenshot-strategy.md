# Screenshot strategy

How screenshots are chosen, captured, imported, reviewed and kept current.

Part of the [authoring plan](authoring-plan.md). Status: Draft 0.3, 16 October 2026. Decisions are tracked in the [decision log](decision-log.md).

## 1. Decisions

| Question | Decision | Log |
|---|---|---|
| Where do the capture scripts live? | In the **application repository**. | DEC-022 |
| What are screenshots captured on? | **Emulators and simulators** with pinned profiles on mobile, and a clean Windows profile or virtual machine at a fixed window size on Windows. | DEC-023 |
| When are they captured? | On **release candidates only**. | DEC-023 |
| Which theme? | The app's **Oxford and slate** theme, light variant, in every screenshot. | DEC-024 |
| Which data? | The **Brontë dataset**, built by replaying the manual's journey stage by stage ([dataset strategy](dataset-strategy.md)). | DEC-025 |

## 2. Principles

1. **Few.** A screenshot earns its place by orienting the reader (first sight of a screen), showing something hard to describe, or showing a result to check. Never one per step. Every task must still work with the images removed.
2. **Generated, not hand-made.** A script captures every screenshot the same way each time.
3. **Keys.** Every screenshot is a key with human-written alternative text ([platform strategy, section 4](platform-strategy.md#4-screenshots-as-keys)).
4. **Only what changed is committed.** A re-capture that changes nothing visible changes nothing in Git.
5. **The Brontë dataset only.** The pictures show the illustrative dataset the manual builds as it teaches, and any other sample workspace is named in the catalogue. No real family data and no living people ([disclosure boundary](authoring-plan.md#74-disclosure-boundary-and-privacy)).
6. **One look.** The screenshots, the website and the PDF all use the Oxford and slate theme, so the manual looks like the app ([theme](../build/theme/README.md)).

## 3. The screen catalogue

One public-safe list, in this repository, of every screenshot a manual may use. WP4 builds it from the inventory. Each entry has:

| Field | Meaning |
|---|---|
| `key` | The image key, such as `img-person-view`. The same key in every manual that has the screen. |
| `state` | The screen and its state in plain words: "Person page, view mode, Charlotte Brontë, after stage 4". It says what to show, not how to get there. |
| `workspace`, `stage`, `focus` | The workspace (the Brontë dataset, unless a larger sample is approved), the journey stage at which the screen is captured (1 to 8, [dataset strategy, section 5](dataset-strategy.md#5-the-journey)), and the person or record in focus. The focus must be on the allow-list: a person in the dataset specification, or one approved from another named sample workspace. |
| `manuals` | The manuals that have this screen. |
| `orientation` | Portrait or landscape. Phones are portrait. Tablets are landscape unless the layout changes in portrait. |
| `capture` | `in-app` (the app's own capture), `os` (an operating system dialog) or `device` (needs a physical device, an exception). |
| `notes` | Anything the script needs to know, such as "scroll to show the date of death". |

The catalogue drives everything else: the capture scripts implement it, the importer checks against it, and coverage reports compare it with the keys topics use. Budget: about 25 to 40 screens per manual. The existing sets have 21 to 27.

## 4. Capture

### 4.1 Where the scripts live

The scenario scripts need the app's automation identifiers and routes. Those are internals, so the scripts live in the application repository. They implement the catalogue, run a release candidate, and write a folder of PNG files and a manifest. **This repository never holds the scripts.** It holds the catalogue (what to capture), the importer, the images and the manifest.

### 4.2 The environment

| Manual | Captured on | Notes |
|---|---|---|
| Android phone | A phone emulator, current stable Android | Pinned device profile. Portrait. |
| Android tablet | A tablet emulator | Pinned profile. Landscape. |
| iPhone | An iPhone simulator | Needs a Mac. |
| iPad | An iPad simulator | Needs a Mac. Landscape. |
| Windows | The app on a **clean Windows profile or virtual machine**, at a fixed window size | A generic user name, so no personal paths or names appear. |

Every capture run sets these explicitly. It never relies on the machine's defaults:

- the **Oxford and slate theme, light variant**, chosen in the app's preferences (the dark variant appears once per manual, in the appearance topic);
- **en-GB**, and default text size and display scaling;
- a **throwaway app-data folder** that starts empty, or at the saved state of the stage being captured, so the app starts in a known state;
- a **normalised status bar** on mobile, using the emulator's status-bar override (a fixed clock, full battery and signal, no notifications);
- screens whose content does not depend on today's date or on random order. The catalogue flags any that do.

Profiles are pinned in the catalogue and recorded in the manifest. Changing a profile means re-capturing that whole manual.

### 4.3 How a screen is captured

**Replay the journey.** A run starts from an empty app and replays the manual's journey stage by stage ([dataset strategy, section 6](dataset-strategy.md#6-how-it-is-built)). It captures each catalogue screen at its stage and exports the saved state at the end of each stage. So the pictures, the topics' steps and the dataset all come from the same run, and a replay that fails means a topic's steps are out of date.

Navigate by route, not by simulated taps, which can be unreliable. Capture inside the app where the app's tooling allows it. That captures the app's own rendering, so status bars and notifications should not appear (WP2 confirms this on Android). Use operating-system capture only for operating-system dialogs, such as a permission prompt or a file picker.

**What an emulator cannot do.** The iOS Simulator has no camera, so camera flows on iPhone and iPad are described in words, without a screenshot. A physical-device capture is an exception the maintainer approves per screen, and the catalogue marks it `device`.

### 4.4 What a run produces

A folder per manual, holding `<name>.png` for each key (`img-person-view` is `person-view.png`) and a `manifest.json`:

```json
{
  "manual": "android-phone",
  "app": { "version": "0.1.0", "build": "release-candidate" },
  "theme": { "name": "oxford-slate", "version": "1.0.0", "variant": "light" },
  "locale": "en-GB",
  "dataset": { "name": "bronte", "specification": "..." },
  "device": { "kind": "emulator", "profile": "...", "os": "...", "width": 1080, "height": 2400, "orientation": "portrait" },
  "captured": "YYYY-MM-DD",
  "images": [
    { "key": "img-person-view", "file": "person-view.png", "sha256": "...", "width": 1080, "height": 2400,
      "stage": 4, "workspace": "Brontë family of Haworth", "focus": "Charlotte Brontë", "capture": "in-app" }
  ]
}
```

## 5. Import

An importer script in this repository (WP5) takes a capture folder and:

1. **validates** it against the catalogue: every key the manual should have is present, nothing else is, and the theme, variant, locale and device profile are the expected ones, or it stops;
2. **checks privacy:** the focus person is on the allow-list, which is the people in the dataset specification plus any approved from another named sample workspace;
3. **strips metadata** from the PNG files, then caps the width (about 1080 pixels for phones and 1600 for tablets and Windows, to be confirmed) and **optimises losslessly**;
4. **compares each image with the committed one** with a small tolerance, so anti-aliasing noise does not count as a change;
5. **writes only what changed**, and updates the manifest, including the app version each image was last verified against;
6. **updates the manual's key map,** keeping existing alternative text, and gives each new key a placeholder that fails the build until a person writes it;
7. **writes a report:** new, changed, unchanged, missing and orphaned images, and for every changed key the topics that use it.

## 6. Review

- GitHub's image diff shows each changed picture in the pull request.
- The report's list of topics is the reviewer's checklist: "does the text still match the picture?"
- Alternative text is rewritten only when the meaning of the picture changes, never because pixels changed.
- A new screen needs its alternative text, its catalogue entry and a topic that uses it.

## 7. Release-candidate cycle

1. The app team tags a release candidate.
2. The capture scripts run for each manual, in the application repository.
3. The importer runs on a branch cut from `release/X.Y.Z`.
4. The change report is reviewed and the affected topics are updated.
5. The pull request merges into the release branch, with all gates green ([build and quality](build-and-quality.md#4-quality-gates)).

Captures happen on release candidates only. Between releases the images are not touched, and a change to the app's interface that affects a screenshot is caught by the next release candidate.

## 8. Accessibility and sizing

- **No information exists only in a screenshot,** and nothing is burned into one: no callouts, arrows or labels. Text describes the control by name.
- **The family tree view** gets a written description in the topic, so a reader who cannot see the picture loses nothing.
- **Alternative text** is in the key map, one sentence, describing what the screen shows and why it matters. It never begins "Screenshot of".
- **No device frames.** They add noise, size and licensing questions.
- **Size.** A phone screenshot is tall and narrow, so the stylesheet limits every figure's height on screen and in the PDF, so that none outgrows a screen or a page. WP6 verifies the PDF.

## 9. Storage

Optimised PNG files in Git, changed files only, with no Git LFS to start. Five manuals of about 35 images at roughly 120 KB is about 20 MB for a full first set. Revisit at about 500 MB, or if re-captures make history grow quickly.

## 10. Who does what

| Piece | Where | Work package |
|---|---|---|
| Screen catalogue | This repository | WP4 |
| Importer, manifest format, key-map update | This repository | WP5 |
| The dataset specification and verification log | This repository | WP4b |
| Journey replay and capture scenarios, and the run script | Application repository | Tracked there, one per manual as it joins (wave 1 first) |
| Emulator, simulator and clean-profile setup | Application repository and the maintainer's machines | With each manual |
| Existing Android phone and Windows key maps, kept for their key names (the pictures show other samples and are replaced by Brontë captures) | This repository | WP5 |
| Verifying the PDF size and layout of figures | This repository | WP6 |

## 11. Open points

| Point | Where decided |
|---|---|
| Which emulator and simulator profiles? | WP4, then pinned in the catalogue |
| Does in-app capture on Android leave out the status bar? | WP2 |
| Width caps and the comparison tolerance | WP5 |
| Does a feature need a physical device (`device`)? | Per screen, in WP4 |
