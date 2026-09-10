#!/usr/bin/env sh
# Fails if any deliberate local edit to a vendored skill has been undone — which is what
# `npx skills update` does, silently, to every edited skill (it also deletes files upstream lacks).
# Mirrors the "edited on purpose" bullet in README.md: keep the two in sync.
#   sh scripts/check-rewrites.sh     exit 1 on any problem, naming what to re-apply
set -eu
cd "$(dirname "$0")/.."

FAILS=0
fail() { echo "FAIL  $1"; FAILS=$((FAILS + 1)); }

# Upstream artifacts every rewrite removed; a hit means a skill came back in its upstream form.
for pat in 'superpowers:' 'docs/superpowers' '\.\./using-superpowers'; do
  hits=$(grep -rl -- "$pat" .agents/skills 2>/dev/null || true)
  [ -z "$hits" ] || fail "'$pat' is back in: $(echo "$hits" | tr '\n' ' ')"
done

f=.agents/skills/writing-plans/SKILL.md
grep -q 'docs/plans/' "$f" || fail "$f: plans no longer go to docs/plans/"

f=.agents/skills/find-skills/SKILL.md
grep -q 'scripts/install.sh' "$f" || fail "$f: the scripts/install.sh step after npx skills add is gone"
! grep -q -- '-g -y' "$f" || fail "$f: upstream's global install (-g -y) is back"

f=.agents/skills/web-design-guidelines/SKILL.md
! grep -q 'WebFetch' "$f" || fail "$f: fetches its rules from a URL again instead of references/guidelines.md"
for r in guidelines.md LICENSE; do
  [ -f ".agents/skills/web-design-guidelines/references/$r" ] || fail "web-design-guidelines/references/$r is missing"
done

if [ "$FAILS" -eq 0 ]; then
  echo "OK    all rewrites in place"
else
  echo "$FAILS problem(s): a skill was reverted, most likely by npx skills update; re-apply the rewrite (README, 'edited on purpose')"
  exit 1
fi
