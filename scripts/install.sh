#!/usr/bin/env sh
# Links (or copies with --copy) each skill in .agents/skills/ into the folders of the harnesses
# present in the project. Idempotent: leaves alone whatever is already correct.
set -eu

cd "$(dirname "$0")/.."
MODE=link
[ "${1:-}" = "--copy" ] && MODE=copy

# harness:skills-folder. Add one line per harness that uses its own folder.
TARGETS="
.claude:.claude/skills
.cursor:.cursor/skills
"

for skill in .agents/skills/*/; do
  name=$(basename "$skill")
  echo "$TARGETS" | while IFS=: read -r harness dir; do
    [ -n "$harness" ] && [ -d "$harness" ] || continue
    mkdir -p "$dir"
    dest="$dir/$name"
    depth=$(printf '%s' "$dir" | tr -cd '/' | wc -c)
    up=$(printf '../%.0s' $(seq 0 "$depth"))
    if [ "$MODE" = link ]; then
      [ -L "$dest" ] && [ -e "$dest" ] && continue
      rm -rf "$dest"
      ln -s "${up}.agents/skills/$name" "$dest"
      echo "link  $dest"
    else
      [ -d "$dest" ] && [ ! -L "$dest" ] && continue
      rm -rf "$dest"
      cp -R ".agents/skills/$name" "$dest"
      echo "copy  $dest"
    fi
  done
done
