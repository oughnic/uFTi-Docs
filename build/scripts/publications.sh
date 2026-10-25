#!/usr/bin/env bash
# Reads build/publications.ini for the bash build scripts: the bash twin of the publication functions
# in UftiBuild.psm1 (Read-UftiPublications, Get-UftiPublishedDeliverable and friends). Source it; it
# runs nothing. Works with the bash on macOS (3.2): no associative arrays.
#
# Copyright 2026 Oughtibridge Ltd, Apache-2.0.

export LC_ALL=C
PUB_ROOT=${PUB_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}
PUB_FILE="$PUB_ROOT/build/publications.ini"
PUB_RELEASE_RE='^((Alpha|Beta|RC)-[1-9][0-9]*|[0-9]+\.[0-9]+(\.[0-9]+)?)$'
PUB_SLUG_RE='^[a-z0-9]+(-[a-z0-9]+)*$'
PUB_BASE_RE='^https://[a-z0-9.-]+(:[0-9]+)?/([A-Za-z0-9._~-]+/)*$'

release_ok() { [[ $1 =~ $PUB_RELEASE_RE ]]; }

release_key() { # Alpha-1 < Alpha-2 < Beta-1 < RC-1 < 1.0 < 1.0.1 < 1.1; compare keys as strings
  local l=$1 rank
  if [[ $l =~ ^(Alpha|Beta|RC)-([0-9]+)$ ]]; then
    case ${BASH_REMATCH[1]} in Alpha) rank=1 ;; Beta) rank=2 ;; RC) rank=3 ;; esac
    printf '%d.%06d.%06d.%06d' "$rank" "$((10#${BASH_REMATCH[2]}))" 0 0
  elif [[ $l =~ ^([0-9]+)\.([0-9]+)(\.([0-9]+))?$ ]]; then
    printf '4.%06d.%06d.%06d' "$((10#${BASH_REMATCH[1]}))" "$((10#${BASH_REMATCH[2]}))" "$((10#${BASH_REMATCH[4]:-0}))"
  else
    return 1
  fi
}

ini_sections() { awk '{ sub(/\r$/, "") } /^[ \t]*\[/ { s = $0; gsub(/^[ \t]*\[|\][ \t]*$/, "", s); print s }' "$PUB_FILE"; }
ini_keys() { # section -> its keys, one a line
  awk -v s="$1" '{ sub(/\r$/, "") } /^[ \t]*#/ { next }
    /^[ \t]*\[/ { t = $0; gsub(/^[ \t]*\[|\][ \t]*$/, "", t); f = (t == s); next }
    f { i = index($0, "="); if (i > 0) { k = substr($0, 1, i - 1); gsub(/^[ \t]+|[ \t]+$/, "", k); print k } }' "$PUB_FILE"
}
ini_get() { # section key -> the value, or nothing
  awk -v s="$1" -v key="$2" '{ sub(/\r$/, "") } /^[ \t]*#/ { next }
    /^[ \t]*\[/ { t = $0; gsub(/^[ \t]*\[|\][ \t]*$/, "", t); f = (t == s); next }
    f { i = index($0, "="); if (i > 0) { k = substr($0, 1, i - 1); gsub(/^[ \t]+|[ \t]+$/, "", k);
        if (k == key) { v = substr($0, i + 1); gsub(/^[ \t]+|[ \t]+$/, "", v); print v; exit } } }' "$PUB_FILE"
}
pub_platforms() { ini_sections | grep -vx 'site'; }

pub_validate() { # prints every problem; returns 1 if there is one
  local n=0 slug k v rel base keyed recorded map manifest app
  bad() { [ "$n" -gt 0 ] || echo "build/publications.ini:" >&2; echo "  - $1" >&2; n=$((n + 1)); }
  if [ ! -f "$PUB_FILE" ]; then echo "build/publications.ini does not exist" >&2; return 1; fi
  for k in $(ini_sections | sort | uniq -d); do bad "section [$k] appears more than once"; done
  base=$(ini_get site base-url)
  if [ -z "$base" ]; then bad "[site] base-url is missing"
  elif ! [[ $base =~ $PUB_BASE_RE ]]; then bad "[site] base-url '$base' must be an https address that ends with a slash"; fi
  keyed=0
  for slug in $(pub_platforms); do
    keyed=$((keyed + 1))
    [[ $slug =~ $PUB_SLUG_RE ]] || bad "[$slug] the section name is the platform's folder: lower case letters, digits and single hyphens only"
    case $slug in govuk | theme | pagefind | latest | start | logs | temp | reports) bad "[$slug] '$slug' is a name the site uses for something else" ;; esac
    for k in title device release manual quick-start; do [ -n "$(ini_get "$slug" "$k")" ] || bad "[$slug] $k is missing"; done
    for k in $(ini_keys "$slug"); do case $k in title | device | release | app-version | manual | quick-start) ;; *) bad "[$slug] unknown key '$k'" ;; esac; done
    rel=$(ini_get "$slug" release)
    if [ -n "$rel" ] && ! release_ok "$rel"; then bad "[$slug] release '$rel' is not in the agreed form (Alpha-N, Beta-N, RC-N, or a number such as 1.0 or 1.2.3)"; fi
    for k in manual quick-start; do
      v=$(ini_get "$slug" "$k")
      if [ -n "$v" ] && [ ! -f "$PUB_ROOT/build/projects/$v.xml" ]; then bad "[$slug] $k '$v' has no file build/projects/$v.xml"; fi
    done
    app=$(ini_get "$slug" app-version)
    map="$PUB_ROOT/content/platforms/$slug/keys/images.ditamap"
    manifest="$PUB_ROOT/content/platforms/$slug/images/manifest.json"
    recorded=""
    [ -f "$map" ] && recorded=$(grep -o '<vrm version="[^"]*"' "$map" | sed 's/.*version="//; s/"$//')
    if [ -f "$manifest" ]; then recorded="$recorded
$(awk '/"app"[ \t]*:/ { f = 1 } f && /"version"/ { sub(/.*"version"[ \t]*:[ \t]*"/, ""); sub(/".*/, ""); print; exit }' "$manifest")"; fi
    recorded=$(printf '%s\n' "$recorded" | grep -v '^$')
    if [ -n "$recorded" ] && [ -z "$app" ]; then bad "[$slug] the pictures record app version '$(printf '%s\n' "$recorded" | head -1)', so app-version must say so"; fi
    if [ -n "$app" ]; then
      while IFS= read -r v; do [ -z "$v" ] || [ "$v" = "$app" ] || bad "[$slug] app-version '$app' differs from '$v' recorded with the pictures: they change together"; done <<EOF
$recorded
EOF
    fi
  done
  [ "$keyed" -gt 0 ] || bad "no platform is declared"
  [ "$n" -eq 0 ]
}

pub_base() { ini_get site base-url; }

pub_footer() { # kind (root|manual|quick-start) slug release -> the footer link pairs
  local kind=$1 slug=$2 rel=$3 base shared own
  base=$(pub_base)
  shared=$(sed -n 's/.*name="govuk\.footer\.links"[[:space:]]*value="\([^"]*\)".*/\1/p' "$PUB_ROOT/build/projects/common.xml" | tr ';' '\n' | grep -v '^Choose your device|' | paste -sd ';' -)
  own="Choose your device|$base"
  if [ "$kind" = manual ]; then own="$own;Version $rel: other versions|$base$slug/;Quick Start|$base$slug/$rel/start/"
  elif [ "$kind" = quick-start ]; then own="$own;Version $rel: other versions|$base$slug/;Full manual|$base$slug/$rel/"; fi
  printf '%s;%s' "$own" "$shared"
}

# pub_resolve PROJECT: sets PUB_KIND, PUB_SLUG, PUB_RELEASE, PUB_SITE_URL, PUB_PDF_NAME and PUB_FOOTER
# for a published project, and returns 1 for any other (a fixture).
pub_resolve() {
  local project=$1 slug base
  PUB_KIND=""; PUB_SLUG=""; PUB_RELEASE=""; PUB_SITE_URL=""; PUB_PDF_NAME=""; PUB_FOOTER=""
  base=$(pub_base)
  if [ "$project" = site-root ]; then
    PUB_KIND=root; PUB_SITE_URL=$base; PUB_FOOTER=$(pub_footer root "" ""); return 0
  fi
  for slug in $(pub_platforms); do
    PUB_RELEASE=$(ini_get "$slug" release)
    if [ "$project" = "$(ini_get "$slug" manual)" ]; then
      PUB_KIND=manual; PUB_SLUG=$slug; PUB_SITE_URL="$base$slug/$PUB_RELEASE/"; PUB_PDF_NAME="ufti-user-manual-$slug-$PUB_RELEASE"
      PUB_FOOTER=$(pub_footer manual "$slug" "$PUB_RELEASE"); return 0
    fi
    if [ "$project" = "$(ini_get "$slug" quick-start)" ]; then
      PUB_KIND=quick-start; PUB_SLUG=$slug; PUB_SITE_URL="$base$slug/$PUB_RELEASE/start/"; PUB_PDF_NAME="ufti-quick-start-$slug-$PUB_RELEASE"
      PUB_FOOTER=$(pub_footer quick-start "$slug" "$PUB_RELEASE"); return 0
    fi
  done
  PUB_RELEASE=""
  return 1
}
