# build/fixtures/

Small throwaway publications used to test the pipeline. **Never published.** Their text is a stand-in that does not describe the app, their pictures are drawn shapes, and they are not written to the manual's standards of accuracy, only to its standards of form.

## wp1/

The WP1 fixture: three manuals (Android phone, Android tablet, Windows) from shared topics, through the tokens-per-manual table ([platform strategy, section 2.1](../../authoring/platform-strategy.md#21-attribute-vocabulary)) and the DITAVAL filters in `build/ditaval/`. It exercises each kind of topic the plan needs:

| Topic | Kind | What it proves |
|---|---|---|
| `topics/get-started/workspaces.dita` | Shared concept | The same page in every manual, a glossary term by key, a keyword that is a real alias. |
| `topics/get-started/add-a-person.dita` | Task with a variant and a picture by key | A phrase with `@platform` on the idiom tokens (`Touch`, `Pointer`), a UI label by key, a picture whose alternative text is the key's link text (DEC-011), a screen identifier for the help map (DEC-028). |
| `platforms/phone/topics/find-your-way-around.dita` | Idiom-specific concept | In the phone manual only, with no "on a phone" label (DEC-032). |
| `topics/get-started/your-first-steps.dita` | Shared concept with a diagram | A clickable SVG inlined through `svg-container` and `svgref` (DEC-036), with the same links as a list after it. |
| `glossary/workspace.dita` | Glossary entry | The glossary list in the back matter. |

Each manual has its own bookmap at the fixture root (the toolkit and the plugin treat the root map's folder as the publication, so nothing may sit above it), its own key map in `platforms/<slug>/keys/` with the same key names, and the shared chapter map `maps/structure/get-started.ditamap` with a relationship table. `screens.csv` is the help-map inventory the lint checks against (DEC-028).

The project files in `build/projects/` build it: `fixture` for all three manuals, `fixture-<slug>` for one, and `fixture-smoke` for the stock html5 smoke build (DEC-042).

```powershell
pwsh build/scripts/bootstrap.ps1
pwsh build/scripts/build.ps1 -Project fixture
pwsh build/scripts/check-source.ps1
pwsh build/scripts/check-output.ps1 -Deliverable fixture-android-phone
```
