#!/usr/bin/env bash
# One SHA-256 for the built output of one or more deliverables: the hash of every file's path and
# its own hash, in a fixed order, every Pagefind index left out (its bytes differ between runs on
# identical pages, DEC-053). Identical output gives the same value, so CI can tell that a manual's
# output is unchanged and an earlier pass of the accessibility checks still stands (DEC-206).
#
#   build/scripts/output-hash.sh [--output out] <deliverable> [<deliverable> ...]
#
# Prints the hash alone. Works with the bash on macOS (3.2).
#
# Copyright 2026 Oughtibridge Ltd, Apache-2.0.
set -euo pipefail
export LC_ALL=C

out=out
if [ "${1:-}" = "--output" ]; then out=${2:?--output needs a folder}; shift 2; fi
[ "$#" -gt 0 ] || { echo "usage: output-hash.sh [--output out] <deliverable> ..." >&2; exit 2; }

if command -v sha256sum > /dev/null 2>&1; then hashcmd="sha256sum"; else hashcmd="shasum -a 256"; fi

cd "$out"
for d in "$@"; do
  [ -d "$d" ] || { echo "no output at $out/$d" >&2; exit 1; }
done
# each file as "<hash>  <path>", paths relative to the output folder, sorted, then hashed again
for d in "$@"; do
  find "$d" -type d -name pagefind -prune -o -type f -print0
done | sort -z | xargs -0 -n 50 $hashcmd | $hashcmd | cut -d" " -f1
