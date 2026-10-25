#!/usr/bin/env bash
# Builds one project file with the pinned toolkit and fails on any build warning: the bash twin
# of build.ps1, for CI, Linux and macOS.
#
#   build/scripts/build.sh --project NAME [--output DIR] [--smoke] [--tools-dir DIR]
#
# NAME is a file under build/projects/ without .xml, or a path. The log goes to out/logs/.
# Any GOVK, DOTX, DOTJ, DOTA or DSPDF warning, error or fatal message fails the build, as does
# DOTJ047I (an unresolved key). --smoke reports them instead (DEC-042). A manual or Quick Start in
# build/publications.ini is built with the site address, PDF name and footer links its release gives.
#
# Copyright 2026 Oughtibridge Ltd, Apache-2.0.
set -uo pipefail

here=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
root=$(cd "$here/../.." && pwd)
tools_dir="${UFTI_TOOLS:-$root/.tools}"
project=""; output="out"; smoke=""
while [ $# -gt 0 ]; do
  case "$1" in
    --project) project=$2; shift 2 ;;
    --output) output=$2; shift 2 ;;
    --smoke) smoke=1; shift ;;
    --tools-dir) tools_dir=$2; shift 2 ;;
    -h|--help) sed -n '2,12p' "$0"; exit 0 ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
done
[ -n "$project" ] || { echo "usage: build.sh --project NAME [--output DIR] [--smoke]" >&2; exit 2; }

lock="$root/build/tools.lock"
folder() { awk -v s="[$1]" '$0 == s { f = 1; next } /^\[/ { f = 0 } f && index($0, "folder = ") == 1 { print substr($0, 10); exit }' "$lock"; }
dita_home="$tools_dir/$(folder dita-ot)"
dita="$dita_home/bin/dita"
[ -x "$dita" ] || { echo "The toolkit is not at $dita_home. Run build/scripts/bootstrap.sh first." >&2; exit 1; }
for d in "$dita_home/bin" "$tools_dir/$(folder designsystempdf)/bin" "$tools_dir/pagefind" "$tools_dir/verapdf"; do
  [ -d "$d" ] && PATH="$d:$PATH"
done
export PATH

if [ -f "$project" ]; then project_file=$(cd "$(dirname "$project")" && pwd)/$(basename "$project"); else project_file="$root/build/projects/$project.xml"; fi
[ -f "$project_file" ] || { echo "No project file: $project_file" >&2; exit 1; }
name=$(basename "$project_file" .xml)

# A published deliverable takes its address, PDF name and footer links from the release declared in
# build/publications.ini (build and quality, section 7); the build fails if that file is wrong.
. "$here/publications.sh"
pub_validate || { echo "::error::build/publications.ini is not valid"; exit 1; }
release_args=()
if pub_resolve "$name"; then
  release_args=("--govuk.site.url=$PUB_SITE_URL" "--govuk.footer.links=$PUB_FOOTER")
  [ -z "$PUB_PDF_NAME" ] || release_args+=("--govuk.pdf.name=$PUB_PDF_NAME")
fi
case "$output" in /*) out_dir=$output ;; *) out_dir="$root/$output" ;; esac
mkdir -p "$out_dir/logs"
log="$out_dir/logs/$name.log"
temp="$out_dir/temp/$name"

echo; echo "== Build $name"
echo "  project: $project_file"; echo "  output:  $out_dir"
[ -z "$PUB_KIND" ] || echo "  release: ${PUB_RELEASE:-(the site root)}, site address $PUB_SITE_URL"

# The toolkit writes into the output folder without clearing it, and Pagefind leaves old index
# fragments behind, so each deliverable's folder is removed first: a build is from nothing.
outputs_of() { # project file -> the output hrefs of its deliverables and of the files it includes
  local f=$1 inc
  grep -oE '<output href="[^"]+"' "$f" | sed 's/.*href="//; s/"$//'
  grep -oE '<include href="[^"]+"' "$f" | sed 's/.*href="//; s/"$//' | while read -r inc; do outputs_of "$(dirname "$f")/$inc"; done
}
outputs_of "$project_file" | sort -u | while read -r href; do
  target=$(cd "$out_dir" 2> /dev/null && mkdir -p "$href" && cd "$href" && pwd)
  case "$target" in "$out_dir"/*) rm -rf "$target"; echo "  cleared: $target" ;; esac
done
started=$(date +%s)
# --verbose, because the toolkit logs an unresolved key (DOTJ047I) at its information level, which
# the default level never prints. The full log goes to the file; the console shows the messages.
(cd "$root" && "$dita" "--project=$project_file" "--output=$out_dir" "--temp=$temp" --verbose ${release_args[@]+"${release_args[@]}"} > "$log" 2>&1)
code=$?
rm -rf "$temp"
grep -E '\[(GOVK|DOTX|DOTJ|DOTA|DSPDF)[0-9]{3}[WEF]\]|\[DOTJ047I\]|^\s*(govuk:|Warning|Error|BUILD|Exception)' "$log" | sed 's/^/  /' || true
echo; echo "  log: $log ($(( $(date +%s) - started )) s, $(wc -l < "$log" | tr -d ' ') lines)"

# The gated messages: warnings, errors, fatal messages, DOTJ047I, and the toolkit's own failures.
gated=$(grep -E '\[(GOVK|DOTX|DOTJ|DOTA|DSPDF)[0-9]{3}[WEF]\]|\[DOTJ047I\]|^\s*(BUILD FAILED|Error:|\[ERROR\]|Exception in thread)' "$log" || true)
count=$(printf '%s' "$gated" | grep -c . || true)
[ "$code" -eq 0 ] || { echo "::error::dita exited with $code building $name"; exit "$code"; }
if [ "$count" -eq 0 ]; then echo "PASS: $name built with no warnings."; exit 0; fi
summary=$(printf '%s\n' "$gated" | grep -oE '\[(GOVK|DOTX|DOTJ|DOTA|DSPDF)[0-9]{3}[WEFI]\]' | sort | uniq -c | awk '{printf "%s x%s ", $2, $1}')
if [ -n "$smoke" ]; then
  echo "::notice::Smoke build $name: $count message(s) reported, not gated: $summary"
  printf '%s\n' "$gated" | sort -u | sed 's/^/    /'
  exit 0
fi
echo "::error::$name: $count build message(s) fail the build: $summary"
printf '%s\n' "$gated" | sort -u | sed 's/^/    /'
exit 1
