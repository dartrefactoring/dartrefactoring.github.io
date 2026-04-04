#!/usr/bin/env sh
# generate-changelog.sh
#
# Generates docs/_posts/<date>-changelog.md from CHANGELOG.md.
#
# Usage (run from the repo root OR from docs/):
#   docs/scripts/generate-changelog.sh          # from repo root
#   scripts/generate-changelog.sh               # from docs/
#
# The script locates CHANGELOG.md relative to its own directory, so it
# works regardless of the caller's working directory.

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CHANGELOG="$SCRIPT_DIR/../../CHANGELOG.md"
POSTS_DIR="$SCRIPT_DIR/../_posts"

if [ ! -f "$CHANGELOG" ]; then
  echo "ERROR: CHANGELOG.md not found at $CHANGELOG" >&2
  exit 1
fi

# Extract the date of the most recent *released* version (YYYY-MM-DD).
# Falls back to today's date if every version is marked Unreleased.
POST_DATE=$(grep -oE '\] - [0-9]{4}-[0-9]{2}-[0-9]{2}' "$CHANGELOG" \
  | head -1 | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' || true)
POST_DATE="${POST_DATE:-$(date -u +%Y-%m-%d)}"

mkdir -p "$POSTS_DIR"
OUT="$POSTS_DIR/${POST_DATE}-changelog.md"

{
  printf -- '---\n'
  printf 'layout: post\n'
  printf 'title: "Changelog"\n'
  printf 'date: %s 00:00:00 +0000\n' "$POST_DATE"
  printf 'categories: [releases]\n'
  printf 'tags: [changelog]\n'
  printf 'pin: true\n'
  printf -- '---\n\n'
  # Strip the top-level "# Changelog" heading — the post title covers it.
  tail -n +3 "$CHANGELOG"
} > "$OUT"

echo "Generated $OUT"
