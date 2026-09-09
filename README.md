# agent-workspace-template

[![Stars](https://img.shields.io/github/stars/Caarles00/agent-workspace-template?style=flat&color=yellow)](https://github.com/Caarles00/agent-workspace-template/stargazers)
[![License](https://img.shields.io/badge/license-MIT-green?style=flat)](LICENSE)

Base template for starting a new project with coding agents already configured: generic
skills, agent/subagent conventions, and reference documents on good practices (security,
testing), all agnostic of language, framework and harness (Claude Code, Codex, Cursor,
OpenCode...).

## Usage

The simplest way is GitHub's **Use this template** button (or its CLI equivalent), which
creates a new repo without carrying over the template's history:

```bash
gh repo create project-name --template Caarles00/agent-workspace-template --private --clone
```

If you prefer to clone by hand:

```bash
git clone https://github.com/Caarles00/agent-workspace-template.git project-name
cd project-name
rm -rf .git && git init   # drop the template's history
```

Then wire the skills, which depends on your harness rather than your OS:

- **Codex, OpenCode and the rest of the [skills.sh](https://skills.sh) crowd**: nothing to do, they read
  `.agents/skills/` directly.
- **Claude Code, Cursor**: `sh scripts/install.sh`. On Windows run it from Git Bash and with `--copy`
  instead, because without Developer Mode git materializes the symlinks as plain text files (see
  [How skills are organized](#how-skills-are-organized)).

Then, in order:

1. Fill in [CLAUDE.md](CLAUDE.md) with the real stack (backend, frontend, package manager, code conventions, library quirks) and the documentation language (English by default). The doctrine shared across harnesses (subagents, skills, model tiers) lives in [AGENTS.md](AGENTS.md); CLAUDE.md imports it with `@AGENTS.md`.
2. Adjust [SECURITY.md](SECURITY.md) and [TESTING.md](TESTING.md) if the stack has its own checklist (e.g. dependency audit tools, a specific test framework).
3. Once the project has recurring task patterns (backend features, frontend views, tests), create agents in `.claude/agents/` following [.claude/agents/README.md](.claude/agents/README.md) and add them to the table in [AGENTS.md](AGENTS.md).
4. Add stack-specific skills if applicable (backend framework, UI/animation library, data provider such as Supabase, etc.) — they are not included because they depend on the project.

## What `.agents/skills/` includes

All language/framework agnostic:

| Skill | What for |
|---|---|
| `ponytail` | Forces the simplest solution — anti-overengineering |
| `grilling` | Interrogates the plan before building, detects unresolved edge cases |
| `writing-plans` / `executing-plans` | Turns a settled design into a task-by-task plan in `docs/plans/`, then executes it with checkpoints |
| `tdd` | Guides the red→green loop: what a good test is, where tests go (seams), anti-patterns (implementation-coupled tests, tautological tests, "horizontal slicing") |
| `systematic-debugging` | Four phases to the root cause before any fix — no patching symptoms |
| `verification-before-completion` | Gate before saying "done": run the command, read the output, then claim it |
| `requesting-code-review` | Review checklist when closing a feature |
| `security-review` | OWASP Top 10 style security review |
| `codebase-design` / `improve-codebase-architecture` | "Deep modules" vocabulary, spots opportunities to simplify the design |
| `domain-modeling` | Pin down domain terminology (ubiquitous language) |
| `api-design-principles` | REST/GraphQL design principles |
| `frontend-design` | Aesthetic direction when building new UI: typography, palette, layout, avoiding the generic "AI look" |
| `web-design-guidelines` | Frontend accessibility/UX review |
| `obsidian-markdown` | Obsidian syntax for the documentation in `docs/` |
| `find-skills` | Searches the [skills.sh](https://skills.sh) ecosystem when the installed set doesn't cover something |
| `writing-skills` | Writes and edits skills the way `tdd` writes code: watch it fail first, then document |

## How skills are organized

- **Canonical source**: `.agents/skills/<skill>/`. This is the folder shared by Codex, Cursor, OpenCode
  and the other harnesses that follow the [skills.sh](https://skills.sh) convention. Edit only here — under
  `--copy` an edit made in a per-harness folder is lost on the next run, which `rm -rf`s the destination first.
- **Per harness**: a harness that reads its own folder instead of the canon gets one relative symlink per
  skill (Claude Code follows symlinks and deduplicates). `scripts/install.sh` already wires `.claude/skills`
  and `.cursor/skills`, and skips whichever of those folders the project doesn't have; for another harness,
  add a line to the script's `TARGETS`. Harnesses that follow the skills.sh convention read `.agents/skills/`
  directly and need nothing.
- **Script**: `scripts/install.sh` creates any missing symlinks and redoes absolute or broken ones;
  `scripts/install.sh --check` verifies them without changing anything. Run both after `npx skills add`
  (on Windows the CLI creates absolute links) and before committing: if git has `core.symlinks=false`
  a new link is stored as a plain file, and `--check` prints the `git update-index` line that fixes it.
  CI runs `--check` on every pull request too, because in a mixed team the person adding a skill often
  doesn't use the harness whose link they just broke and has no reason to notice.
  On Windows without Developer Mode git materializes symlinks as text files; there, use
  `scripts/install.sh --copy`, which copies instead of linking (and assumes you will update the copies by hand).
  Those copies sit on paths git tracks as symlinks, so it reports them as deleted from then on: tell git to
  ignore the difference, or a stray `git add -A` will drop the links and break the repo for everyone on
  Mac/Linux. `--copy` users should run it once, right after the copy:

  ```bash
  git update-index --skip-worktree $(git ls-files .claude/skills .cursor/skills)   # --no-skip-worktree to undo
  ```

  That line only bites when the links are already tracked, which is the `--template` route. After
  `rm -rf .git && git init` nothing is tracked yet, so it is a silent no-op and the copies simply become
  your project's own content — fine, unless the team is mixed Windows/Unix, where the canon stops
  propagating to whoever gets the copies.
- **Adding and updating external skills**: `npx skills add <owner>/<repo> --skill <name>` installs into the
  canon, creates the symlinks and records origin and hash in `skills-lock.json` (the `find-skills` skill
  covers the search step). All included skills came in that way, so `npx skills update` brings them up to
  date and warns if they were edited locally.
- **Some vendored skills are edited on purpose**: several arrive with cross-references to skills this
  template doesn't vendor, or with path conventions that don't match this repo's `docs/`. Those are
  rewritten in place — cross-references normalized to the house form `call the Skill tool with "<name>"`,
  upstream's `docs/superpowers/plans/` rewritten to `docs/plans/` — so the "edited locally" warning is
  expected for them, not a problem to undo. Treat an update as a merge, not an overwrite: read the
  incoming diff and re-apply the rewrites. If a skill's upstream version drifts far enough that the
  rewrite no longer fits, drop the skill rather than maintaining a fork of it here.
- **Per-harness metadata inside a skill**: `agents/openai.yaml` is read by Codex; the
  `disable-model-invocation` frontmatter field is read by Claude Code (forces manual invocation). Other
  harnesses ignore what they don't know, so they coexist without issues.

## What it does NOT include (on purpose)

Concrete agents (`backend-feature`, `frontend-template`, `testing`...) and skills tied to a
stack (backend framework, animation library, cloud provider) — they are recreated or added
per project, because copying them without adapting to the real stack adds nothing.

## License and third-party content

The repo is [MIT](LICENSE). The skills come from these repos (exact origin and hash in `skills-lock.json`),
each with its own license:

| Origin | Skills |
|---|---|
| [mattpocock/skills](https://github.com/mattpocock/skills) | `tdd`, `grilling`, `codebase-design`, `improve-codebase-architecture`, `domain-modeling` |
| [dietrichgebert/ponytail](https://github.com/dietrichgebert/ponytail) | `ponytail` |
| [obra/superpowers](https://github.com/obra/superpowers) | `requesting-code-review`, `systematic-debugging`, `verification-before-completion`, `writing-plans`, `executing-plans`, `writing-skills` |
| [getsentry/skills](https://github.com/getsentry/skills) | `security-review` (includes material from the [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/), CC BY-SA 4.0, see its `LICENSE`) |
| [wshobson/agents](https://github.com/wshobson/agents) | `api-design-principles` |
| [anthropics/skills](https://github.com/anthropics/skills) | `frontend-design` (Apache 2.0, see its `LICENSE.txt`) |
| [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | `web-design-guidelines` |
| [vercel-labs/skills](https://github.com/vercel-labs/skills) | `find-skills` (a different repo from `vercel-labs/agent-skills` above) |
| [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills) | `obsidian-markdown` |
