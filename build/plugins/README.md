# build/plugins/

Small DITA-OT plugins that belong to this repository. `bootstrap.ps1` and `bootstrap.sh` install each folder here into the toolkit, after the GOV.UK plugin, and install it again when a file in it changes. Nothing here is downloaded, so `tools.lock` does not pin it.

| Folder | What it adds |
|---|---|
| `ufti.strings-es/` | The Spanish words that the GOV.UK plugin generates (Contents, Skip to main content, Search, Glossary and the rest), for the Spanish Quick Start (DEC-258). The plugin has no Spanish file of its own; its string registry takes further languages from other plugins. |

To add a language, copy `ufti.strings-es/`, rename the plugin, and change the language code and the words. Take the ids from `strings-en-gb.xml` in the GOV.UK plugin, and check them again when the plugin is upgraded.
