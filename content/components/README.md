# content/components/

A copy of the app's inventory of what each platform build ships: every library with its version, licence and copyright, then the fonts, the sample tree with the pictures it links to, and the runtimes. It is data. The page "Software components and licences" in each manual (help id `about.components`) is generated from it, so the page cannot drift from the build (DEC-248).

| File | Used for |
|---|---|
| `windows.json` | the Windows manual |
| `android.json` | the Android phone and Android tablet manuals |
| `ios.json` | the iPhone and iPad manuals |
| `maccatalyst.json` | the Mac manual |

## Keeping it current

The app team tells us when the lists change (a library is added or updated, a font or a sample changes). Then:

```powershell
pwsh build/scripts/import-components.ps1 -From <the app's docs/components folder>
pwsh build/scripts/new-components-topics.ps1
```

Commit the data and the four generated topics together. `lint.ps1` fails when a topic does not match its data, so a hand edit or a forgotten run is caught.

## What the copy leaves out

This repository is public and the application repository is private, so the import keeps only what the page needs. It drops the app's repository address and the paths of its source files. It also drops content that has neither a licence nor a copyright: those are the test trees that only a Debug build carries, and no build a reader installs ships them. If the app ever ships a third-party file, the app team must record its licence in the inventory, and it then appears here.

Never edit these files or the generated topics by hand.
