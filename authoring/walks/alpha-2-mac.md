# The Alpha-2 Mac walk, on Mac Catalyst

What was walked on the Mac, and why the walk stopped. Part of the [authoring plan](../authoring-plan.md) and the [walk plan](walk-plan.md). Written 11 November 2026 for [issue 169](https://github.com/oughnic/uFTi-Docs/issues/169) and [issue 172](https://github.com/oughnic/uFTi-Docs/issues/172). Decision: DEC-236.

This report is public. It names no machine, no account, no serial number and no build number of a build that is not released.

## 1. What was walked

- **The target.** Mac Catalyst, as the maintainer asked on 11 November 2026 (DEC-236).
- **The build.** The Alpha-2 build for Mac Catalyst, a Release configuration build with the DevFlow agent, under its own application identity, with its own data. Data from an earlier walk was set aside first, so the app started from a first run.
- **The window.** Pinned to 1280 by 800 by the driver.

| What | Seen |
|---|---|
| First run | Home of the Brontë sample, in Ink and parchment. The list of places down the left side, and **+** and **Help** at the top, as on the iPad on its side. |
| Preferences | The same as on the iPhone and the iPad: four themes, three looks, and **Saving another program's file**. Oxford and slate and Light were chosen. |

## 2. Why the walk stopped

The Mac's screen was locked. With the screen locked, the app stopped drawing: every picture taken after Preferences showed the same frame, so none of them is kept. The boxes that macOS draws (a new workspace, the name question, Save as… and the file panels) cannot be driven either. The driver can read the words on a screen and press buttons, but it cannot open a person from a search result or from the list of people on the Mac.

## 3. Next

- Walk the Mac again with the screen unlocked and nothing else using the mouse (walk plan, section 3.2), following the Brontë walkthrough as the iPad leg did, and take the pictures then.
- Give the Mac manual places for its pictures, and decide its platform token for Mac Catalyst (DEC-236).
