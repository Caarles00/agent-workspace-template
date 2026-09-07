#!/usr/bin/env sh
# Wires each skill in .agents/skills/ into the folders of the harnesses present in the project.
#   (no flag)  relative symlink per skill; absolute, broken or wrong links are redone
#   --copy     copies instead of linking (Windows without symlink support)
#   --check    verifies links without touching anything; exit 1 on any problem
# Idempotent: leaves alone whatever is already correct.
set -eu

cd "$(dirname "$0")/.."
# On Git Bash, ln -s silently copies unless told to create real Windows symlinks (needs Developer Mode)
export MSYS=winsymlinks:nativestrict
MODE=link
case "${1:-}" in
  --copy) MODE=copy ;;
  --check) MODE=check ;;
esac

# harness:skills-folder. Add one line per harness that uses its own folder.
TARGETS="
.claude:.claude/skills
.cursor:.cursor/skills
"

FAILS=0
fail() { echo "FAIL  $1: $2"; FAILS=$((FAILS + 1)); }

for skill in .agents/skills/*/; do
  name=$(basename "$skill")
  for target in $TARGETS; do
    harness=${target%%:*}
    dir=${target#*:}
    [ -d "$harness" ] || continue
    dest="$dir/$name"
    depth=$(printf '%s' "$dir" | tr -cd '/' | wc -c)
    up=$(printf '../%.0s' $(seq 0 "$depth"))
    want="${up}.agents/skills/$name"

    case "$MODE" in
      check)
        if [ -L "$dest" ]; then
          have=$(readlink "$dest")
          if [ "$have" != "$want" ]; then
            fail "$dest" "bad target '$have' (absolute?), want '$want'"
          elif [ ! -e "$dest" ]; then
            fail "$dest" "broken link"
          fi
        elif [ -d "$dest" ]; then
          : # copied skill (--copy); nothing to verify
        elif [ -f "$dest" ]; then
          # git materializes symlinks as plain text when core.symlinks=false
          [ "$(cat "$dest")" = "$want" ] || fail "$dest" "plain file with unexpected content"
        else
          fail "$dest" "missing"
        fi
        if [ ! -d "$dest" ]; then
          mode=$(git ls-files -s -- "$dest" 2>/dev/null | cut -d' ' -f1)
          if [ -n "$mode" ] && [ "$mode" != 120000 ]; then
            fail "$dest" "tracked as mode $mode, not a symlink; fix with: git update-index --add --cacheinfo 120000,\$(git hash-object -w $dest),$dest"
          fi
        fi
        ;;
      link)
        mkdir -p "$dir"
        if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$want" ] && [ -e "$dest" ]; then continue; fi
        # git materializes symlinks as plain text when core.symlinks=false; that is the tracked state, keep it
        if [ -f "$dest" ] && [ ! -L "$dest" ] && [ "$(cat "$dest")" = "$want" ]; then continue; fi
        if [ -e "$dest" ] || [ -L "$dest" ]; then action=relink; else action=link; fi
        rm -rf "$dest"
        if ln -s "$want" "$dest" 2>/dev/null && [ -L "$dest" ]; then
          echo "$action  $dest"
        else
          # No symlink permission (Windows): write the text form git uses for symlinks when
          # core.symlinks=false, so the repo stays consistent. Claude Code won't follow it locally.
          rm -rf "$dest"
          printf '%s' "$want" > "$dest"
          echo "$action  $dest  (as text: symlinks unavailable here; use --copy to have the skill locally)"
        fi
        ;;
      copy)
        mkdir -p "$dir"
        if [ -d "$dest" ] && [ ! -L "$dest" ]; then continue; fi
        rm -rf "$dest"
        cp -R ".agents/skills/$name" "$dest"
        echo "copy  $dest"
        ;;
    esac
  done
done

if [ "$MODE" = check ]; then
  if [ "$(git config core.symlinks 2>/dev/null || true)" = false ]; then
    echo "NOTE  core.symlinks=false: git stores new links as plain files; register them with the update-index line above"
  fi
  if [ "$FAILS" -eq 0 ]; then
    echo "OK    all links verified"
  else
    echo "$FAILS problem(s)"
    exit 1
  fi
fi
