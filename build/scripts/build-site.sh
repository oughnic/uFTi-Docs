#!/usr/bin/env bash
# Builds the whole publishable tree: the bash twin of build-site.ps1, for CI, Linux and macOS.
#
#   build/scripts/build-site.sh [--output DIR] [--keep DIR] [--reuse] [--archive] [--no-check] [--tools-dir DIR]
#
# Reads build/publications.ini (the one place a release is declared; the build fails if it is missing
# or not in the agreed form), builds every manual and Quick Start with build.sh (the toolkit and the
# GOV.UK plugin only, no build message allowed), writes the root and platform pages as DITA 1.3 and
# builds them the same way, and assembles DIR/site:
#
#   site/index.html, not-found.html, staticwebapp.config.json    the root
#   site/<platform>/index.html                                   the platform's versions
#   site/<platform>/<release>/                                   the manual's website and PDF
#   site/<platform>/<release>/start/                             the Quick Start's website and PDF
#   site/<platform>/<release>/version.json
#
# --keep DIR puts back the releases that an earlier run wrote with --archive (DIR holds
# ufti-docs-<platform>-<release>.zip files), so an old release stays online. --reuse uses the
# deliverables already built under DIR. The tree is then checked by check-site.ps1 (PowerShell 7).
#
# Copyright 2026 Oughtibridge Ltd, Apache-2.0.
set -uo pipefail

here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
root=$(cd "$here/../.." && pwd)
output="out"; keep=""; reuse=""; archive=""; nocheck=""; tools_dir=""
while [ $# -gt 0 ]; do
  case "$1" in
    --output) output=$2; shift 2 ;;
    --keep) keep=$2; shift 2 ;;
    --reuse) reuse=1; shift ;;
    --archive) archive=1; shift ;;
    --no-check) nocheck=1; shift ;;
    --tools-dir) tools_dir=$2; shift 2 ;;
    -h|--help) sed -n '2,20p' "$0"; exit 0 ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
done
fail() { echo "::error::$1" >&2; echo "FAIL: $1" >&2; exit 1; }

. "$here/publications.sh"
pub_validate || fail "build/publications.ini is not valid"
case "$output" in /*) out_dir=$output ;; *) out_dir="$root/$output" ;; esac
mkdir -p "$out_dir"; out_dir=$(cd "$out_dir" && pwd)
site_dir="$out_dir/site"; archive_dir="$out_dir/archive"
gen_dir="$root/out/generated/site-root"   # fixed: build/projects/site-root.xml reads its sources from here
base=$(pub_base)
platforms=$(pub_platforms)
tool_args=(); [ -z "$tools_dir" ] || tool_args=(--tools-dir "$tools_dir")

xml() { printf '%s' "$1" | sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' -e 's/"/\&quot;/g' -e "s/'/\&apos;/g"; }
json_get() { sed -n "s/^ *\"$2\": *\"\\(.*\\)\",\\{0,1\\}\$/\\1/p" "$1" | head -1; }
sha256() { if command -v sha256sum > /dev/null; then sha256sum "$@"; else shasum -a 256 "$@"; fi; }

echo; echo "== Publishing tree for $(echo "$platforms" | wc -w | tr -d ' ') platform(s) at $base"
for slug in $platforms; do printf '  %-14s %s\n' "$slug" "$(ini_get "$slug" release)"; done

# ---- 1. The manuals and Quick Starts --------------------------------------------------------------

for slug in $platforms; do
  for d in "$(ini_get "$slug" manual)" "$(ini_get "$slug" quick-start)"; do
    if [ -n "$reuse" ]; then [ -d "$out_dir/$d" ] || fail "--reuse: no build of $d under $out_dir"
    else "$here/build.sh" --project "$d" --output "$out_dir" ${tool_args[@]+"${tool_args[@]}"} || fail "$d did not build cleanly: the tree is not built"; fi
  done
done

# ---- 2. A fresh tree, with the earlier releases put back --------------------------------------------

rm -rf "$site_dir"; mkdir -p "$site_dir"
kept_list="$out_dir/temp/kept.list"; mkdir -p "$out_dir/temp"; : > "$kept_list"   # slug|release|appVersion|manualPdf|quickStartPdf
if [ -n "$keep" ]; then
  [ -d "$keep" ] || fail "--keep: $keep does not exist"
  command -v unzip > /dev/null || fail "--keep needs unzip"
  scratch="$out_dir/temp/kept"; rm -rf "$scratch"; mkdir -p "$scratch"
  for zip in "$keep"/*.zip; do
    [ -f "$zip" ] || continue
    name=$(basename "$zip" .zip); dest="$scratch/$name"; mkdir -p "$dest"
    unzip -q -o "$zip" -d "$dest" || fail "$name.zip cannot be unpacked"
    [ "$(ls "$dest" | wc -l | tr -d ' ')" = 1 ] || fail "$name.zip must hold exactly one <platform>/<release>/ folder"
    slug=$(ls "$dest"); [ "$(ls "$dest/$slug" | wc -l | tr -d ' ')" = 1 ] || fail "$name.zip must hold exactly one <platform>/<release>/ folder"
    rel=$(ls "$dest/$slug"); vf="$dest/$slug/$rel/version.json"
    [ -f "$vf" ] && [ "$(json_get "$vf" platform)" = "$slug" ] && [ "$(json_get "$vf" release)" = "$rel" ] || fail "$name.zip: $slug/$rel/version.json is missing or names another platform or release"
    release_ok "$rel" || fail "$name.zip: '$rel' is not a release label in the agreed form"
    [ -n "$(ini_get "$slug" release)" ] || fail "$name.zip: '$slug' is not in build/publications.ini. Add the platform again, or delete the archive."
    a=$(release_key "$rel"); b=$(release_key "$(ini_get "$slug" release)")
    if [[ $a > $b ]]; then fail "$name.zip: $slug $rel is newer than the release in build/publications.ini ($(ini_get "$slug" release))"; fi
    if [ "$a" = "$b" ]; then echo "  $name.zip: $slug $rel is the release being built, so the new build replaces it"; continue; fi
    [ ! -e "$site_dir/$slug/$rel" ] || fail "$name.zip: $slug $rel is in more than one archive"
    mkdir -p "$site_dir/$slug"; mv "$dest/$slug/$rel" "$site_dir/$slug/$rel"
    echo "$slug|$rel|$(json_get "$site_dir/$slug/$rel/version.json" appVersion)|$(json_get "$site_dir/$slug/$rel/version.json" manualPdf)|$(json_get "$site_dir/$slug/$rel/version.json" quickStartPdf)" >> "$kept_list"
    echo "  kept: $slug $rel (from $name.zip)"
  done
  rm -rf "$scratch"
fi

# ---- 3. The root and the platform pages, as DITA, built the same way -------------------------------

rows_for() { # slug -> release|appVersion|manualPdf|quickStartPdf|current, newest first
  local slug=$1 rel app
  rel=$(ini_get "$slug" release); app=$(ini_get "$slug" app-version)
  {
    echo "$(release_key "$rel")|$rel|$app|ufti-user-manual-$slug-$rel.pdf|start/ufti-quick-start-$slug-$rel.pdf|1"
    awk -F'|' -v s="$slug" '$1 == s { print $2 "|" $3 "|" $4 "|" $5 }' "$kept_list" | while IFS='|' read -r r a m q; do echo "$(release_key "$r")|$r|$a|$m|$q|0"; done
  } | sort -r | cut -d'|' -f2-
}

platform_topic() { # slug
  local slug=$1 title device latest i=0 rel app mpdf spdf cur
  title=$(xml "$(ini_get "$slug" title)"); device=$(xml "$(ini_get "$slug" device)")
  latest=$(xml "$(ini_get "$slug" release)")
  cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE concept PUBLIC "-//OASIS//DTD DITA Concept//EN" "concept.dtd">
<concept id="platform-$slug" xml:lang="en-GB">
  <title>uFTi on $title</title>
  <shortdesc>The Quick Start and the manual for uFTi on $device. The latest version is $latest.</shortdesc>
  <conbody>
    <p>Choose the version of uFTi that you use. The newest version is first. Each version has its own Quick Start and manual, as a website and as a PDF.</p>
EOF
  rows_for "$slug" | while IFS='|' read -r rel app mpdf spdf cur; do
    i=$((i + 1)); rel=$(xml "$rel")
    if [ "$cur" = 1 ]; then t="Version $rel (the latest)"; else t="Version $rel"; fi
    echo "    <section id=\"version-$i\">"
    echo "      <title>$t</title>"
    [ -z "$app" ] || echo "      <p>Checked against the app, version $(xml "$app").</p>"
    echo "      <ul>"
    echo "        <li><xref href=\"$rel/start/\" scope=\"peer\" format=\"html\">Read the Quick Start for version $rel on the website</xref></li>"
    echo "        <li><xref href=\"$rel/$(xml "$spdf")\" scope=\"peer\" format=\"pdf\">Download the Quick Start for version $rel as a PDF</xref></li>"
    echo "        <li><xref href=\"$rel/\" scope=\"peer\" format=\"html\">Read the manual for version $rel on the website</xref></li>"
    echo "        <li><xref href=\"$rel/$(xml "$mpdf")\" scope=\"peer\" format=\"pdf\">Download the manual for version $rel as a PDF</xref></li>"
    echo "      </ul>"
    echo "    </section>"
  done
  echo "  </conbody>"
  echo "</concept>"
}

rm -rf "$gen_dir"; mkdir -p "$gen_dir"
{
  echo '<?xml version="1.0" encoding="UTF-8"?>'
  echo '<!DOCTYPE map PUBLIC "-//OASIS//DTD DITA Map//EN" "map.dtd">'
  echo '<map id="ufti-docs" xml:lang="en-GB">'
  echo '  <title>uFTi documentation</title>'
  for slug in $platforms; do echo "  <topicref href=\"$slug/index.dita\"/>"; done
  echo '  <topicref href="not-found.dita" toc="no"/>'
  echo '</map>'
} > "$gen_dir/ufti-docs.ditamap"
for slug in $platforms; do mkdir -p "$gen_dir/$slug"; platform_topic "$slug" > "$gen_dir/$slug/index.dita"; done
cat > "$gen_dir/not-found.dita" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE concept PUBLIC "-//OASIS//DTD DITA Concept//EN" "concept.dtd">
<concept id="not-found" xml:lang="en-GB">
  <title>Page not found</title>
  <shortdesc>There is no page at this address.</shortdesc>
  <conbody>
    <p>Check the address for mistakes. Or go to the <xref href="$base" scope="peer" format="html">list of devices</xref> and choose again.</p>
  </conbody>
</concept>
EOF
"$here/build.sh" --project site-root --output "$out_dir" ${tool_args[@]+"${tool_args[@]}"} || fail "the root and platform pages did not build cleanly: the tree is not built"

# ---- 4. Assemble ------------------------------------------------------------------------------------

echo; echo "== Assemble the tree"
cp -R "$out_dir/site-root/." "$site_dir/"
# The not-found page is served at the address that was asked for, so a relative link in it (the stylesheet, the
# scripts, the platform pages) would be looked for below that address. Its links are made absolute, from base-url.
BASE="$(printf '%s' "$base" | sed -E 's#^https?://[^/]*##')" perl -pi -e 's{(href|src)="(?!https?://|#|mailto:|/)([^"]*)"}{$1="$ENV{BASE}$2"}g' "$site_dir/not-found.html"
for slug in $platforms; do
  rel=$(ini_get "$slug" release); app=$(ini_get "$slug" app-version)
  ver_dir="$site_dir/$slug/$rel"
  rm -rf "$ver_dir"; mkdir -p "$ver_dir"
  cp -R "$out_dir/$(ini_get "$slug" manual)/." "$ver_dir/"
  [ ! -e "$ver_dir/start" ] || fail "$(ini_get "$slug" manual) has a start folder of its own, where the Quick Start goes"
  mkdir -p "$ver_dir/start"; cp -R "$out_dir/$(ini_get "$slug" quick-start)/." "$ver_dir/start/"
  mpdf="ufti-user-manual-$slug-$rel.pdf"; spdf="start/ufti-quick-start-$slug-$rel.pdf"
  for pdf in "$mpdf" "$spdf"; do [ -f "$ver_dir/$pdf" ] || fail "$slug $rel: the PDF $pdf was not built"; done
  {
    echo "{"
    echo "  \"platform\": \"$slug\","
    echo "  \"release\": \"$rel\","
    [ -z "$app" ] || echo "  \"appVersion\": \"$app\","
    echo "  \"manualPdf\": \"$mpdf\","
    echo "  \"quickStartPdf\": \"$spdf\""
    echo "}"
  } > "$ver_dir/version.json"
  echo "  $slug/$rel/ and $slug/$rel/start/"
done

# ---- 5. The Static Web Apps configuration -----------------------------------------------------------

{
  echo "{"
  echo "  \"\$schema\": \"https://json.schemastore.org/staticwebapp.config.json\","
  echo "  \"routes\": ["
  first=1
  route() { if [ -n "$first" ]; then first=""; else echo ","; fi; printf '%s' "$1"; }
  for slug in $platforms; do
    c=$(ini_get "$slug" release)
    for from in "/$slug/latest"; do route "    { \"route\": \"$from\", \"redirect\": \"/$slug/$c/\", \"statusCode\": 302 }"; done
    for from in "/$slug/latest/start"; do route "    { \"route\": \"$from\", \"redirect\": \"/$slug/$c/start/\", \"statusCode\": 302 }"; done
    route "    { \"route\": \"/$slug/latest/*\", \"redirect\": \"/$slug/$c/\", \"statusCode\": 302 }"
    # an earlier release does not change, so it may be cached for longer than the one being worked on
    rows_for "$slug" | while IFS='|' read -r r a m q cur; do [ "$cur" = 1 ] || echo "$r"; done > "$out_dir/temp/older.list"
    while IFS= read -r r; do route "    { \"route\": \"/$slug/$r/*\", \"headers\": { \"cache-control\": \"public, max-age=86400\" } }"; done < "$out_dir/temp/older.list"
  done
  echo ""
  echo "  ],"
  echo "  \"responseOverrides\": { \"404\": { \"rewrite\": \"/not-found.html\" } },"
  echo "  \"globalHeaders\": {"
  echo "    \"cache-control\": \"public, max-age=300, must-revalidate\","
  echo "    \"x-content-type-options\": \"nosniff\","
  echo "    \"referrer-policy\": \"strict-origin-when-cross-origin\""
  echo "  },"
  echo "  \"mimeTypes\": { \".pdf\": \"application/pdf\" }"
  echo "}"
} > "$site_dir/staticwebapp.config.json"
echo "  staticwebapp.config.json"

# ---- 6. Archives of the current releases, so the next run can keep them -------------------------------

if [ -n "$archive" ]; then
  echo; echo "== Archive each current release"
  command -v zip > /dev/null || fail "--archive needs zip"
  rm -rf "$archive_dir"; mkdir -p "$archive_dir"
  for slug in $platforms; do
    rel=$(ini_get "$slug" release)
    (cd "$site_dir" && zip -qr -X "$archive_dir/ufti-docs-$slug-$rel.zip" "$slug/$rel") || fail "cannot archive $slug $rel"
    echo "  ufti-docs-$slug-$rel.zip"
  done
  (cd "$archive_dir" && sha256 -- *.zip > SHA256SUMS)
fi

# ---- 7. Check the tree, and show it ------------------------------------------------------------------

echo; echo "  $(find "$site_dir" -type f | wc -l | tr -d ' ') file(s), $(du -sk "$site_dir" | cut -f1) KB in $site_dir"
if [ -z "$nocheck" ]; then
  command -v pwsh > /dev/null || fail "the tree check is PowerShell 7 (pwsh); install it or pass --no-check"
  pwsh -NoProfile -File "$here/check-site.ps1" -Output "$out_dir" || exit 1
fi
echo "PASS: the tree is built at $site_dir"
