#!/usr/bin/env bash
# Pushes the finished tree to the publish branch, so the output of this repository is a pushed asset an
# Azure Static Web App can deploy from (build and quality, section 7; DEC-144).
#
#   build/scripts/publish-tree.sh <tree> <branch> [source-ref]
#
# <tree> is out/site, as build-site.sh leaves it (it already holds the earlier releases, put back with
# --keep). On the branch it goes into a site/ folder, beside a short README.md that says what the branch
# is and nothing else (no sources); Azure uses `site` as its app location. The branch is replaced by
# exactly that, in one new commit, so a release that is not in the tree is not on the branch: never run
# this on a tree built without the earlier releases. The commit names the source commit and the releases
# it holds. Nothing is pushed when the result is what the branch already holds.
# Run it in a clone with a remote named origin and a token that can push (contents: write).
set -euo pipefail

tree=${1:?usage: publish-tree.sh <tree> <branch> [source-ref]}
branch=${2:?usage: publish-tree.sh <tree> <branch> [source-ref]}
ref=${3:-${GITHUB_REF_NAME:-$(git rev-parse --abbrev-ref HEAD)}}
[ -f "$tree/index.html" ] && [ -f "$tree/staticwebapp.config.json" ] || { echo "$tree is not a built tree (no index.html or staticwebapp.config.json)" >&2; exit 1; }
tree=$(cd "$tree" && pwd)
src=$(git rev-parse HEAD)

releases=$(for vf in "$tree"/*/*/version.json; do [ -f "$vf" ] || continue; d=$(dirname "$vf"); echo "$(basename "$(dirname "$d")") $(basename "$d")"; done)
[ -n "$releases" ] || { echo "the tree holds no <platform>/<release>/version.json" >&2; exit 1; }

work=$(mktemp -d); trap 'git worktree remove --force "$work/tree" > /dev/null 2>&1 || true; rm -rf "$work"' EXIT
existed=no
if git ls-remote --exit-code --heads origin "$branch" > /dev/null 2>&1; then
  existed=yes
  git fetch --quiet --depth 1 origin "refs/heads/$branch:refs/remotes/origin/$branch"
  git worktree add --quiet --detach "$work/tree" "refs/remotes/origin/$branch"
else
  git worktree add --quiet --detach "$work/tree" HEAD
  (cd "$work/tree" && git checkout --quiet --orphan "$branch" && git rm -rf --quiet . )
fi

cd "$work/tree"
find . -mindepth 1 -maxdepth 1 ! -name .git -exec rm -rf {} +
mkdir site
cp -a "$tree"/. site/
cat > README.md <<'MD'
# Published documentation

This branch holds the built uFTi documentation, nothing else. It is written by the Site workflow of the
source repository (the `publish` job), never by hand, and each publication replaces it.

- `site/` is the tree: a root page, one folder for each platform, and below each platform one folder for
  each uFTi app release, with the manual and the Quick Start as a website and a PDF.
- To serve it, use `site` as the app location (Azure Static Web Apps) with no build step.
- The sources are on the `dev` branch of the same repository.
MD
git add -A
if [ "$existed" = yes ] && git diff --cached --quiet; then
  echo "The '$branch' branch already holds this tree. Nothing to push."
  exit 0
fi
msg="Publish the documentation tree built from ${src:0:7} ($ref)

Releases in this tree:
$(echo "$releases" | sed 's/^/- /')"
git -c user.name="${GIT_AUTHOR_NAME:-github-actions[bot]}" -c user.email="${GIT_AUTHOR_EMAIL:-41898282+github-actions[bot]@users.noreply.github.com}" commit --quiet -m "$msg"
git push --quiet origin "HEAD:refs/heads/$branch"
echo "Pushed $(git rev-parse --short HEAD) to '$branch' ($(find . -path ./.git -prune -o -type f -print | wc -l | tr -d ' ') files)."
