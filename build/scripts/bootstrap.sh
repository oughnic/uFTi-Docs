#!/usr/bin/env bash
# Downloads the pinned tools into .tools/ and verifies their checksums: the bash twin of
# bootstrap.ps1, for CI, Linux and macOS. Reads build/tools.lock. Java 17 or later must be
# installed. Safe to run again.
#
#   build/scripts/bootstrap.sh [--tools-dir DIR] [--build-only] [--only a,b,c] [--force]
#
# Copyright 2026 Oughtibridge Ltd, Apache-2.0.
set -euo pipefail

here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
root=$(cd "$here/../.." && pwd)
LOCK="$root/build/tools.lock"
tools_dir="${UFTI_TOOLS:-$root/.tools}"
mode=all; only=""; force=""
while [ $# -gt 0 ]; do
  case "$1" in
    --tools-dir) tools_dir=$2; shift 2 ;;
    --build-only) mode=build; shift ;;
    --only) only=$2; shift 2 ;;
    --force) force=1; shift ;;
    -h|--help) sed -n '2,8p' "$0"; exit 0 ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
done
mkdir -p "$tools_dir/downloads" "$tools_dir/.installed"
tools_dir=$(cd "$tools_dir" && pwd)
DL="$tools_dir/downloads"; MARK="$tools_dir/.installed"

case "$(uname -s)-$(uname -m)" in
  Linux-x86_64) PLATFORM=linux-x64 ;;
  Linux-aarch64) PLATFORM=linux-arm64 ;;
  Darwin-x86_64) PLATFORM=macos-x64 ;;
  Darwin-arm64) PLATFORM=macos-arm64 ;;
  *) echo "unsupported platform: $(uname -s) $(uname -m)" >&2; exit 1 ;;
esac
echo "Tools folder: $tools_dir ($PLATFORM)"

# ---- the lock file ---------------------------------------------------------------------------

lock_raw() { # tool key -> value, or nothing
  awk -v s="[$1]" -v k="$2" '
    $0 == s { f = 1; next }
    /^\[/ { f = 0 }
    f && index($0, k " = ") == 1 { print substr($0, length(k) + 4); exit }' "$LOCK"
}
lock_get() { # tool key -> the platform's value, a fallback platform's (Apple silicon runs x64 under Rosetta), else the plain one
  local v; v=$(lock_raw "$1" "$2.$PLATFORM")
  [ -n "$v" ] || { [ "$PLATFORM" = macos-arm64 ] && v=$(lock_raw "$1" "$2.macos-x64"); }
  [ -n "$v" ] || v=$(lock_raw "$1" "$2"); printf '%s' "$v"
}
lock_keys() { # tool prefix -> the keys that start with the prefix
  awk -v s="[$1]" -v p="$2" '
    $0 == s { f = 1; next }
    /^\[/ { f = 0 }
    f && index($0, p) == 1 { sub(/ = .*/, ""); print }' "$LOCK"
}

# ---- helpers ---------------------------------------------------------------------------------

sha256() { if command -v sha256sum > /dev/null; then sha256sum "$1" | cut -c1-64; else shasum -a 256 "$1" | cut -c1-64; fi; }
need_java() {
  local min; min=$(lock_raw java minimum)
  command -v java > /dev/null || { echo "Java $min or later is needed and 'java' is not on the PATH" >&2; exit 1; }
  local v; v=$(java -version 2>&1 | sed -n 's/.*version "\([0-9]*\)\(\.\([0-9]*\)\)\{0,1\}.*/\1 \3/p' | head -1)
  local major=${v%% *}; local minor=${v#* }
  [ "$major" = 1 ] && major=$minor
  [ "${major:-0}" -ge "$min" ] || { echo "Java $min or later is needed; found $major" >&2; exit 1; }
  echo "Java $major found."
}
fetch() { # tool [url-key] -> path of the verified download
  local tool=$1 key=${2:-url} url size sha name dest actual
  url=$(lock_get "$tool" "$key"); [ -n "$url" ] || { echo "[$tool] has no $key for $PLATFORM in tools.lock" >&2; exit 1; }
  size=$(lock_get "$tool" "${key/url/size}"); sha=$(lock_get "$tool" "${key/url/sha256}")
  name=$(basename "$url"); dest="$DL/$name"
  if [ -f "$dest" ] && [ -n "$sha" ] && [ "$sha" != PENDING ] && [ "$(sha256 "$dest")" = "$sha" ]; then
    echo "  $name: already downloaded and verified"; printf '%s' "$dest"; return
  fi
  echo "  downloading $url" >&2
  curl -fsSL --retry 3 -o "$dest.part" "$url"
  actual=$(wc -c < "$dest.part" | tr -d ' ')
  if [ -n "$size" ] && [ "$size" != "$actual" ]; then rm -f "$dest.part"; echo "$name is $actual bytes; tools.lock says $size" >&2; exit 1; fi
  actual=$(sha256 "$dest.part")
  if [ -z "$sha" ] || [ "$sha" = PENDING ]; then rm -f "$dest.part"; echo "$name has no checksum in tools.lock (PENDING): record it with bootstrap.ps1 -RecordPending" >&2; exit 1; fi
  if [ "$actual" != "$sha" ]; then rm -f "$dest.part"; echo "$name: SHA-256 is $actual, tools.lock says $sha. Not installed." >&2; exit 1; fi
  echo "  $name: $(wc -c < "$dest.part" | tr -d ' ') bytes, SHA-256 verified" >&2
  mv -f "$dest.part" "$dest"; printf '%s' "$dest"
}
marker() { cat "$MARK/$1" 2> /dev/null || true; }
installed() { [ -z "$force" ] && [ "$(marker "$1")" = "$2" ] && [ -e "$3" ]; }
stamp() { printf '%s %s' "$(lock_get "$1" version)" "$(lock_get "$1" sha256)"; }
runs() { # exe expected-text args... : the tool runs and says what it should
  local exe=$1 expect=$2; shift 2; local out
  out=$("$exe" "$@" 2>&1) || { echo "$exe $* failed: $out" >&2; exit 1; }
  printf '%s' "$out" | grep -qF -- "$expect" || { echo "$exe $* did not report '$expect': $out" >&2; exit 1; }
  echo "  $(basename "$exe") ok: $(printf '%s' "$out" | head -1)"
}

DITA_HOME="$tools_dir/$(lock_raw dita-ot folder)"; DITA="$DITA_HOME/bin/dita"
DSPDF_HOME="$tools_dir/$(lock_raw designsystempdf folder)"; DSPDF="$DSPDF_HOME/bin/designsystempdf"
PLUGIN_ID=$(lock_raw govuk-plugin id)

# ---- tools -----------------------------------------------------------------------------------

install_dita_ot() {
  local s; s=$(stamp dita-ot); echo; echo "== DITA Open Toolkit $(lock_get dita-ot version)"
  if installed dita-ot "$s" "$DITA"; then echo "  installed at $DITA_HOME"; return; fi
  need_java; local zip; zip=$(fetch dita-ot)
  rm -rf "$DITA_HOME"; unzip -q -o "$zip" -d "$tools_dir"
  [ -x "$DITA" ] || chmod +x "$DITA" "$DITA_HOME/bin/ant" 2> /dev/null || true
  runs "$DITA" "$(lock_get dita-ot version)" --version
  printf '%s' "$s" > "$MARK/dita-ot"
}
install_plugin() {
  local s have; s=$(stamp govuk-plugin); echo; echo "== GOV.UK plugin $PLUGIN_ID $(lock_get govuk-plugin version)"
  [ -x "$DITA" ] || { echo "Install the toolkit first (dita-ot)" >&2; exit 1; }
  have=$(sed -n 's/.*<plugin id="[^"]*" version="\([^"]*\)".*/\1/p' "$DITA_HOME/plugins/$PLUGIN_ID/plugin.xml" 2> /dev/null | head -1 || true)
  if [ -z "$force" ] && [ "$have" = "$(lock_get govuk-plugin version)" ] && [ "$(marker govuk-plugin)" = "$s" ]; then echo "  installed in the toolkit"; return; fi
  local zip; zip=$(fetch govuk-plugin)
  if [ -n "$have" ]; then echo "  removing $PLUGIN_ID $have"; "$DITA" uninstall "$PLUGIN_ID"; fi
  (cd "$DL" && "$DITA" install "$zip")
  "$DITA" transtypes | grep -qx 'govuk' || { echo "the govuk transtype is not listed after installing" >&2; exit 1; }
  echo "  govuk transtype available"
  printf '%s' "$s" > "$MARK/govuk-plugin"
}
install_dspdf() {
  local s; s=$(stamp designsystempdf); echo; echo "== DesignSystemPDF $(lock_get designsystempdf version)"
  if installed designsystempdf "$s" "$DSPDF"; then echo "  installed at $DSPDF_HOME"; return; fi
  need_java; local zip; zip=$(fetch designsystempdf)
  rm -rf "$DSPDF_HOME"; unzip -q -o "$zip" -d "$tools_dir"
  chmod +x "$DSPDF"
  runs "$DSPDF" "DesignSystemPDF $(lock_get designsystempdf version)" --version
  printf '%s' "$s" > "$MARK/designsystempdf"
}
install_pagefind() {
  local s; s=$(stamp pagefind); echo; echo "== Pagefind $(lock_get pagefind version)"
  if installed pagefind "$s" "$tools_dir/pagefind/pagefind"; then echo "  installed"; return; fi
  local tgz; tgz=$(fetch pagefind)
  rm -rf "$tools_dir/pagefind"; mkdir -p "$tools_dir/pagefind"; tar -xzf "$tgz" -C "$tools_dir/pagefind"
  chmod +x "$tools_dir/pagefind/pagefind"
  runs "$tools_dir/pagefind/pagefind" "$(lock_get pagefind version)" --version
  printf '%s' "$s" > "$MARK/pagefind"
}
install_verapdf() {
  local s; s=$(stamp verapdf); echo; echo "== veraPDF $(lock_get verapdf version)"
  if installed verapdf "$s" "$tools_dir/verapdf/verapdf"; then echo "  installed"; return; fi
  need_java; local zip; zip=$(fetch verapdf)
  rm -rf "$DL/verapdf-installer" "$tools_dir/verapdf"; unzip -q -o "$zip" -d "$DL/verapdf-installer"
  java "-DINSTALL_PATH=$tools_dir/verapdf" -jar "$DL/verapdf-installer/$(lock_raw verapdf installer-jar)" "$here/verapdf-auto-install.xml"
  rm -rf "$DL/verapdf-installer"
  chmod +x "$tools_dir/verapdf/verapdf"
  runs "$tools_dir/verapdf/verapdf" "veraPDF $(lock_get verapdf version)" --version
  printf '%s' "$s" > "$MARK/verapdf"
}
install_vnu() {
  local s; s=$(stamp vnu); echo; echo "== Nu HTML Checker $(lock_get vnu version)"
  if installed vnu "$s" "$tools_dir/vnu/vnu.jar"; then echo "  installed"; return; fi
  need_java; local tgz; tgz=$(fetch vnu)
  rm -rf "$DL/vnu-unpack"; mkdir -p "$DL/vnu-unpack" "$tools_dir/vnu"; tar -xzf "$tgz" -C "$DL/vnu-unpack"
  cp -f "$DL/vnu-unpack/$(lock_raw vnu jar-in-archive)" "$tools_dir/vnu/vnu.jar"; rm -rf "$DL/vnu-unpack"
  runs java "$(lock_get vnu version)" -jar "$tools_dir/vnu/vnu.jar" --version
  printf '%s' "$s" > "$MARK/vnu"
}
install_binary() { # tool exe-name version-arg
  local tool=$1 exe=$2 varg=$3 s file; s=$(stamp "$tool"); echo; echo "== $tool $(lock_get "$tool" version)"
  if installed "$tool" "$s" "$tools_dir/$tool/$exe"; then echo "  installed"; return; fi
  file=$(fetch "$tool"); rm -rf "$tools_dir/$tool"; mkdir -p "$tools_dir/$tool"
  case "$file" in *.zip) unzip -q -o "$file" -d "$tools_dir/$tool" ;; *) tar -xzf "$file" -C "$tools_dir/$tool" ;; esac
  chmod +x "$tools_dir/$tool/$exe"
  runs "$tools_dir/$tool/$exe" "$(lock_get "$tool" version)" "$varg"
  printf '%s' "$s" > "$MARK/$tool"
}
install_plugin_tools() {
  local tag base s k rel sha dest actual; tag=$(lock_raw plugin-tools tag); base=$(lock_raw plugin-tools base)
  s="$tag $(lock_keys plugin-tools file. | while read -r k; do lock_raw plugin-tools "$k"; done | sha256sum | cut -c1-16)"
  echo; echo "== Plugin repository checkers at $tag"
  if installed plugin-tools "$s" "$tools_dir/plugin-tools"; then echo "  installed"; return; fi
  while read -r k; do
    rel=${k#file.}; sha=$(lock_raw plugin-tools "$k"); dest="$tools_dir/plugin-tools/$rel"
    mkdir -p "$(dirname "$dest")"; echo "  $rel"
    curl -fsSL --retry 3 -o "$dest.part" "$base$rel"
    actual=$(sha256 "$dest.part")
    [ "$actual" = "$sha" ] || { rm -f "$dest.part"; echo "$rel: SHA-256 is $actual, tools.lock says $sha" >&2; exit 1; }
    mv -f "$dest.part" "$dest"
  done < <(lock_keys plugin-tools file.)
  printf '%s' "$s" > "$MARK/plugin-tools"
}

# ---- run -------------------------------------------------------------------------------------

build_set="dita-ot govuk-plugin designsystempdf pagefind"
check_set="verapdf vnu vale gitleaks plugin-tools"
if [ -n "$only" ]; then wanted=${only//,/ }; elif [ "$mode" = build ]; then wanted=$build_set; else wanted="$build_set $check_set"; fi
for tool in $wanted; do
  case "$tool" in
    dita-ot) install_dita_ot ;;
    govuk-plugin) install_plugin ;;
    designsystempdf) install_dspdf ;;
    pagefind) install_pagefind ;;
    verapdf) install_verapdf ;;
    vnu) install_vnu ;;
    vale) install_binary vale vale --version ;;
    gitleaks) install_binary gitleaks gitleaks version ;;
    plugin-tools) install_plugin_tools ;;
    *) echo "unknown tool: $tool (one of: $build_set $check_set)" >&2; exit 2 ;;
  esac
done
echo; echo "Done. Tools in $tools_dir. Build with: build/scripts/build.sh --project fixture"
