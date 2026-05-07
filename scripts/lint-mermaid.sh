#!/usr/bin/env bash
# Lint every Mermaid block in docs/**/*.md by rendering it with mmdc.
# Exits non-zero on the first malformed block.
#
# Requires: npx (Node 18+). The first run downloads @mermaid-js/mermaid-cli
# into npx's cache. Subsequent runs are fast.
#
# Usage: npm run lint:mermaid
#        scripts/lint-mermaid.sh           # equivalent
#        scripts/lint-mermaid.sh path/to/file.md   # single file
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

if [ $# -gt 0 ]; then
  files=("$@")
else
  mapfile -t files < <(grep -rl '```mermaid' "$ROOT/docs")
fi

failed=0
for f in "${files[@]}"; do
  # mmdc writes per-block .svg files when given a markdown input;
  # we don't care about the output, only the exit status / stderr.
  if ! npx -y -p @mermaid-js/mermaid-cli mmdc \
      -i "$f" -o "$TMP/out.svg" --quiet 2> "$TMP/err"; then
    echo "FAIL  $f"
    sed 's/^/      /' "$TMP/err"
    failed=1
  fi
done

if [ "$failed" -ne 0 ]; then
  echo
  echo "Mermaid lint failed. See errors above." >&2
  exit 1
fi
echo "OK    $(printf '%s\n' "${files[@]}" | wc -l | tr -d ' ') file(s) linted clean."
