#!/usr/bin/env bash
# Builds one project file with the pinned toolkit and fails on any build warning: the bash twin
# of build.ps1, for CI, Linux and macOS.
#
#   build/scripts/build.sh --project NAME [--output DIR] [--smoke] [--tools-dir DIR]
#
# NAME is a file under build/projects/ without .xml, or a path. The log goes to out/logs/.
# Any GOVK, DOTX, DOTJ, DOTA or DSPDF warning, error or fatal message fails the build, as does
# DOTJ047I (an unresolved key). --smoke reports them instead (DEC-042).
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
    -h|--help) sed -n '2,11p' "$0"; exit 0 ;;
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
case "$output" in /*) out_dir=$output ;; *) out_dir="$root/$output" ;; esac
mkdir -p "$out_dir/logs"
log="$out_dir/logs/$name.log"
temp="$out_dir/temp/$name"

echo; echo "== Build $name"
echo "  project: $project_file"; echo "  output:  $out_dir"

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
(cd "$root" && "$dita" "--project=$project_file" "--output=$out_dir" "--temp=$temp" 2>&1 | tee "$log")
code=${PIPESTATUS[0]}
rm -rf "$temp"
echo; echo "  log: $log ($(( $(date +%s) - started )) s)"

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
