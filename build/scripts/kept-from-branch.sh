#!/usr/bin/env bash
# Puts the releases already published back into the next build (build and quality, section 7; DEC-143, DEC-144).
#
#   build/scripts/kept-from-branch.sh <branch> <dir>
#
# The published tree lives on a branch (default "publish"): <platform>/<release>/ for every release
# ever published. This script reads that branch and writes one archive for each release into <dir>,
# named ufti-docs-<platform>-<release>.zip and holding exactly one <platform>/<release>/ folder, which is
# what build-site.sh --keep expects. If the branch does not exist yet, <dir> stays empty. Run it in a
# clone with a remote named origin, before the build.
set -euo pipefail

branch=${1:?usage: kept-from-branch.sh <branch> <dir>}
dest=${2:?usage: kept-from-branch.sh <branch> <dir>}
command -v zip > /dev/null || { echo "kept-from-branch.sh needs zip" >&2; exit 1; }
mkdir -p "$dest"; dest=$(cd "$dest" && pwd)

if ! git ls-remote --exit-code --heads origin "$branch" > /dev/null 2>&1; then
  echo "There is no '$branch' branch yet, so no earlier release is kept."
  exit 0
fi
git fetch --quiet --depth 1 origin "refs/heads/$branch:refs/remotes/origin/$branch"
work=$(mktemp -d); trap 'git worktree remove --force "$work/tree" > /dev/null 2>&1 || true; rm -rf "$work"' EXIT
git worktree add --quiet --detach "$work/tree" "refs/remotes/origin/$branch"

count=0
for vf in "$work"/tree/*/*/version.json; do
  [ -f "$vf" ] || continue
  rel_dir=$(dirname "$vf"); rel=$(basename "$rel_dir"); slug=$(basename "$(dirname "$rel_dir")")
  (cd "$work/tree" && zip --quiet --recurse-paths --symlinks "$dest/ufti-docs-$slug-$rel.zip" "$slug/$rel")
  echo "  from '$branch': $slug $rel"
  count=$((count + 1))
done
echo "$count earlier release(s) read from '$branch'."
