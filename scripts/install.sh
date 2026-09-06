#!/usr/bin/env sh
# Enlaza (o copia con --copy) cada skill de .agents/skills/ en las carpetas de los harnesses
# presentes en el proyecto. Idempotente: no toca lo que ya está bien.
set -eu

cd "$(dirname "$0")/.."
MODE=link
[ "${1:-}" = "--copy" ] && MODE=copy

# harness:carpeta-de-skills. Añade una línea por harness que use carpeta propia.
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
