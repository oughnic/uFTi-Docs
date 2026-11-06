# The walk plan

How the machines and devices work together to walk the documented apps, record what a reader will see and capture fresh pictures, on the closed Alpha-1 build. Part of the [authoring plan](../authoring-plan.md). Written 6 November 2026 for [issue 129](https://github.com/oughnic/uFTi-Docs/issues/129). Decisions: DEC-209 and DEC-211. The first sheet it uses is [the dates, places and names walk](dates-places-names.md).

This plan is public. It names no machine, no account, no serial number, no build number beyond the released Alpha-1, and nothing from the application repository. Devices are named by model only.

## 1. What the walks are for

1. **Settle what the pages say.** Some statements in the pages were written from the app team's reading of the code. A walk shows them on a screen.
2. **Fresh pictures for Alpha-1.** Capture every documented device again, on the one closed build, so that every picture and every page describe the same app.

The application repository also walks targets that are not documented. They are tracked there (section 7), and this plan says nothing more about them.

## 2. Rules it keeps

- **Capture scripts stay in the application repository** (DEC-022). This repository holds the catalogue, the importer, the pictures, the manifests and the walk reports.
- **Pictures come from a release build, with the Brontë dataset only,** in the Oxford and slate theme, light, in en-GB, from a throwaway data folder (DEC-023 to DEC-025).
- **The importer refuses a picture from a different build.** Every leg runs the same build.
- **No serial number enters this repository.** The importer refuses a manifest that has one.
- **Raw captures never go into Git.** Only pictures that the importer accepts and a person has reviewed are committed.
- **A leg says which kind of build it ran.** A driven leg runs on a build with the DevFlow agent, and a hand leg runs on the closed package (section 6.2).

## 3. What is walked, and where

### 3.1 The environments

| Role | Operating system | What runs there |
|---|---|---|
| **The Mac** | macOS | The iPhone and iPad simulators, and the Mac app |
| **The Android host** | Windows | The Galaxy A41 (SM-A415F) and the Galaxy Z Fold 8, over adb |
| **The cloud Windows PC** | Windows, Intel | The Windows reference |
| **The Windows ARM PC** | Windows, Arm | The collector, and a parity walk of the ARM build |

WSL2 is available on all three Windows machines. It is a Linux twin of CI, so that `build.sh`, `output-hash.sh` and `check-output.ps1` can be run there as CI runs them.

### 3.2 The legs

A **leg** is one target on one environment.

| Leg | Target and device | Environment | Gives |
|---|---|---|---|
| `windows-x64` | Windows (WinUI), clean profile, 1280 by 800 at 200% | Cloud Windows PC | The **reference**: walk and pictures |
| `windows-arm64` | Windows (WinUI) on Arm | Windows ARM PC | A parity walk: does it behave the same? No pictures |
| `android-phone` | Galaxy A41, Android 12, 1080 by 2400 | Android host | Walk and pictures (DEC-088) |
| `android-fold` | Galaxy Z Fold 8 | Android host | A **behaviour walk only**: the tablet statements that are not confirmed (section 8). No pictures |
| `android-tablet` | Pixel Tablet emulator profile, Android 16, 2560 by 1600 | To be settled (section 10) | Pictures (DEC-181) |
| `iphone` | iPhone 17 Pro simulator, iOS 26.5 | Mac | Walk and pictures (DEC-184) |
| `ipad` | iPad Air 11-inch (M4) simulator, iOS 26.5 | Mac | Walk and pictures (DEC-187) |
| `mac` | The Mac manual's reference target | Mac | Walk and pictures, once the target is settled (section 10) |

The Android phone and the Fold share one host, and the two simulators share the Mac. Devices with different serial numbers can be driven at the same time. The Mac app uses the real screen, so it runs on its own, with nothing else using the mouse.

## 4. How the environments work together

```mermaid
flowchart TB
  app["App repository (private)<br/>builds, capture scripts, legs"]
  subgraph envs["Environments"]
    mac["The Mac<br/>iPhone and iPad simulators,<br/>Mac app"]
    android["The Android host<br/>Galaxy A41, Galaxy Z Fold 8"]
    cloud["Cloud Windows PC (Intel)<br/>Windows reference"]
    arm["Windows ARM PC<br/>ARM parity"]
  end
  drop["Shared private folder (OneDrive)<br/>capture folders, manifests,<br/>leg results"]
  collector["Collector on the Windows ARM PC<br/>validate, import, report"]
  docs["Docs repository (public)<br/>pictures, key maps, walk report"]
  app --> mac
  app --> android
  app --> cloud
  app --> arm
  mac --> drop
  android --> drop
  cloud --> drop
  arm --> drop
  drop --> collector
  collector --> docs
```

The sections that follow describe the boxes, in order.

### 4.1 A run, a build and its legs

A **run** has an id, such as `alpha-1-walk-1`, and one build: the closed Alpha-1, shown in the app as 0.1.0 (1). A run is a set of legs.

The list of legs belongs in the application repository, because it names the capture scripts and the device profiles, and it covers targets that are not documented. This repository keeps what it needs from each leg: the catalogue of keys for each manual, the importer, and the walk reports.

### 4.2 What a leg does

1. **Preflight.** Install the pinned build. Set the Oxford and slate theme, light, and en-GB. Start from a throwaway data folder. Check that the app shows the run's build. Write an **environment card**: operating system, version, screen size, scale. Add no serial number and no host name.
2. **Walk.** Do the sheet for the leg. `build/walks/New-WalkNotes.ps1 -Leg <leg>` writes a `notes.md` with one line for each row that names the leg. Mark each row Same, Different, Not found or Not done, and write what you saw.
3. **Capture.** Run the scripted replay from the application repository. If it is not ready, capture by hand as the [screenshot strategy](../screenshot-strategy.md#45-manual-capture-fallback) says.
4. **Drop.** Copy the result to the shared folder and stop. Nothing else in the leg depends on another machine.

The wrapper that does steps 1 and 4 the same way on every environment lives in the application repository, with the capture scripts it calls.

### 4.3 The shared folder

A private folder in OneDrive, synced to every machine. It holds one folder per leg, and nothing in it is committed to Git.

```
<run>/
  run.json                    the run id, the build, the legs and who owns each
  <leg>/
    leg-result.json           status, the build and its kind (closed or devflow), the environment card
    manifest.json             pictures legs: as the screenshot strategy describes, with no serial number
    screens/<name>.png        pictures legs: one file per key
    notes.md                  the sheet's rows, filled in, and anything else seen
    SHA256SUMS                every file of the leg but itself
  deny-list.txt               private: names that must never appear in the run (never committed)
  report/                     written by the collector
```

### 4.4 The collector

`build/walks/collect-walk.ps1 -Run <run>` runs on the Windows ARM PC, because the importer's crop and resize run on Windows. It fails when a leg is missing or not complete, when a leg ran another build, when a checksum does not match or a file is not listed, when a result file has a key that names a serial number, a host or an account, when a row is missing, unknown or has a result that is not one of the four words, or when a name on the private deny-list appears in any text file or in the report (it reports the file and the line, never the name). Then it merges the filled-in notes into one table with a column for each leg, lists the rows that are Different or Not found, and runs the importer for each pictures leg: with `-WhatIf` unless `-Import` is given. A Different row is a finding, not a failure. The report is `report/walk-report.md`, and nothing is committed or sent.

### 4.5 Review, then Git

Nothing is committed until a person has looked at it.

- **Pictures.** One pull request for each manual. The report's list of topics is the reviewer's checklist.
- **Words.** One small pull request for each kind of correction to the pages, and one for the walk report.

### 4.6 Where Claude sessions fit

State lives in the shared folder and on issue 129, not in a conversation. A session on each machine can run its legs and report in the same files, and one session can coordinate. Each leg ticks its line on issue 129 when it is dropped. The plan works with only people and scripts.

The Mac can run a session that the coordinating session starts over a saved SSH connection. It has the tools to run the walk scripts, so it can write a leg's notes, run a driver and drop the result without anyone at the keyboard. The cloud Windows PC and the Android host are not set up that way yet (section 10).

### 4.7 Driving a leg with DevFlow

DevFlow lets a script drive the app and read the screen. It can go to a page, find a control by its automation id, tap, fill a field, read the words on the screen and take a picture of the app's own window. It works on Windows, Android, the iOS simulators and Mac Catalyst. A driver reads the words the screen shows, so the *Seen* column is exact and not remembered.

- **Rows that suit a driver.** A row that does something and reads what follows: the date editor and its *Reads as* line (rows 1.5 to 1.14), the place box (3.1 to 3.3), the name prompt (4.1 to 4.5), the sources (5.1 to 5.5) and the worked case (6.2). A driver covers what it can and says which rows it left.
- **Rows that stay by hand.** Row 2.5 (the device's own settings), row 6.1 (reading our pages), the rows of section 7 (layout, and the file picker, which belongs to the device) and the rows of section 8 (the camera and its prompts, which are outside the app's window).
- **What a driver writes.** It fills the *Seen* column of `notes.md` with the words it read, and leaves *Result* as Not done. Whoever reviews the leg sets the result against *Our pages say*. A session may propose it and a person confirms it, because a Different row is a finding.
- **Controls need automation ids.** A driver finds a control by its id, not by where it sits. A control without one is reported to the app team, which adds it, and the row is walked by hand until then.
- **Pictures.** The driver's screenshot is of the app's own window, with no status bar and no notification, and it works while the screen is locked. That is what section 9 asks of the phones.
- **Where the driver lives.** In the application repository, with the capture scripts (DEC-022). This repository holds the sheet, the notes skeleton and the collector.

## 5. Order

```mermaid
flowchart LR
  p0["0 Prepare<br/>pin the build,<br/>environment cards"] --> p1["1 Smoke leg<br/>every environment"]
  p1 --> p2["2 Walks<br/>every leg"]
  p2 --> p4["3 Capture<br/>one manual at a time"]
  p4 --> p5["4 Collect<br/>and import"]
  p5 --> p6["5 Review<br/>and pull requests"]
  p6 --> p8["6 Close<br/>decisions, walk reports"]
  p6 -.-> p9["Later: the help leg<br/>on a newer build"]
```

1. **Prepare.** Install the closed Alpha-1 build on every environment. Write the environment cards.
2. **Smoke leg.** Start the app, open a tree, check the version and the theme, and drop the result. Every environment, at the same time.
3. **Walks.** Every leg, at the same time. Do the cloud Windows PC, the Galaxy A41 and the Mac first, because they settle the most open statements.
4. **Capture.** One manual at a time on a machine. Different manuals can run on different machines.
5. **Collect, review, close.** When the pictures and the sheet are in, DEC-193 and DEC-203 can move to Accepted.

## 6. The build: the closed Alpha-1

Every leg runs the closed Alpha-1 build. `build/publications.ini` does not change, and no new release is declared. The pictures replace the earlier ones for Alpha-1.

Some pages were written from the app team's answers about a build that is newer than Alpha-1. A row that differs on Alpha-1 is marked Different, with the build, and then a person decides whether the page or the release should move.

### 6.1 Help on help

The help links need a newer build than Alpha-1. The app cannot open `places.place` or `people.name` from a field until it has them, and the proposed help maps are meant for development builds of the app. So these rows cannot be walked on Alpha-1:

- Row 1.15 of the dates, places and names sheet (a help control on the date editor), row 3.4 (on a place field) and row 4.6 (on a name field).
- Whether the Help button on each screen opens the page that the help map names.

They move to a **help leg**, run later on a development build that reads the published help maps. It is a coordination item with the app team, and it belongs to the work in [issue 16](https://github.com/oughnic/uFTi-Docs/issues/16) and to the later Alpha-2 plan. The help leg needs three things before it can run: a build with the help links, the proposed help maps built into that build, and the pages live on the host.

### 6.2 Driven legs and the closed package

The DevFlow agent is compiled into development builds only. It is not in the closed Alpha-1 package. So a **driven** leg runs on a build of the Alpha-1 source with the agent, not on the package. The two come from one source and should behave the same, but they are not the same file.

- **The record says which.** The leg result records the kind of build, `closed` for the package and `devflow` for the build with the agent, and the version and build number the app shows. The collector fails a leg that does not say, and the report lists the kind for each leg and says when a run mixed the two.
- **A short walk by hand on the closed package** covers the rows that matter most: rows 1.3 and 1.14, and the rows of section 7, on the Galaxy A41. A row that is Different between the two kinds of build is a finding about the build, not about our pages.
- **Pictures.** The screenshot strategy takes pictures from release candidates only (DEC-023). Whether a picture from a build with the agent counts is an open point (section 10).

## 7. Targets that are not documented

The application repository walks other targets that we do not document and do not plan to release. It tracks them, and anything it learns from them, in its own issues and plans. This repository holds no detail about them, and no manual, picture or page describes them.

A leg for such a target may use the same environments and the same shared folder. Nothing from it reaches the importer, the pictures or the pages.

## 8. Rows that the walk is meant to settle

| Source | What it settles | Legs |
|---|---|---|
| [Dates, places and names sheet](dates-places-names.md) | The date editor, the place box, the name prompt, and the second line under a source | `windows-x64`, `windows-arm64`, `android-phone`, `iphone`, `ipad`, `mac` |
| The unconfirmed mobile differences ([issue 115](https://github.com/oughnic/uFTi-Docs/issues/115)) | Whether the form opens part of the way down, the file card delay, the full-screen sheet and its count, the sources count on tablets, and two file cards to a row | `android-phone`, `android-fold`, `iphone`, `ipad` |
| The camera route and the photos buttons ([issue 68](https://github.com/oughnic/uFTi-Docs/issues/68)) | The camera route on a device | `android-phone`, `android-fold` |
| The walk reports for Alpha-1 | Any picture or page that is out of date | Every leg |

## 9. Care on every leg

- **Clean profiles.** A generic user name, a throwaway data folder, no personal paths, no notifications and no other app in a picture.
- **The physical phones.** Capture inside the app, which leaves out the status bar and notifications. Check a picture of a system screen for personal information before it enters the shared folder.
- **The Fold.** Note which screen the app is on, the cover or the inner one, and the fold state, in the environment card.
- **Screens that depend on today's date or on random order** are flagged in the catalogue. A leg notes them and does not re-capture them for no reason.
- **No secrets in the shared folder.** It holds pictures, manifests and notes only.

## 10. Open points

| Point | Who decides |
|---|---|
| **The Mac manual's reference target.** [DEC-125](../decision-log.md) names AppKit and has not chosen a reference machine. The supported desktop target on a Mac in MAUI is Mac Catalyst, so the token `MacAppKit` and the reference may need another look. | Maintainer |
| **Where the Pixel Tablet emulator runs.** It needs an Intel machine with hardware virtualisation. | Maintainer |
| **The help leg:** the build, the date, and the published maps. | App team, with the maintainer |
| **Where the list of legs and the wrapper live.** The application repository is proposed (section 4.1). | Maintainer |
| **Sessions on the other machines.** The Mac can run one (section 4.6). Whether the cloud Windows PC and the Android host should, or be driven by hand. | Maintainer |
| **Pictures from a build with the agent.** Whether DEC-023's "release candidates only" allows a Release configuration build of the same source with the DevFlow agent, or asks for the closed package. The application repository says whether it can make such a build. | Maintainer, with the app team |

## 11. What gets built, in order

1. **Done.** The #129 sheet has an *On* column that names the legs for each row, and two new sections (phone and tablet differences, and the camera route). `build/walks/New-WalkNotes.ps1` writes a leg's notes from it.
2. **Done.** `build/walks/collect-walk.ps1`, with a test for each of its checks in `test-source-rules.ps1 -Only walks`.
3. **In the application repository, not started.** The list of legs, the wrapper, the environment card and the DevFlow driver (section 4.7). The drop-folder layout above is what the wrapper must write.
4. **Done.** The leg result has a `buildKind`, `closed` or `devflow`. The collector fails a leg that does not say or that says something else, lists the kind of each leg in the report, and says when the legs ran more than one kind. Each check has a case in `test-source-rules.ps1 -Only walks`.
5. **Then.** The first run: the smoke leg on every environment, then the walks. The Mac and the Galaxy A41 come first.
