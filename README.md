# agent-workspace-template

[![Stars](https://img.shields.io/github/stars/Caarles00/agent-workspace-template?style=flat&color=yellow)](https://github.com/Caarles00/agent-workspace-template/stargazers)
[![License](https://img.shields.io/badge/license-MIT-green?style=flat)](LICENSE)

Stop reconfiguring your agents on every new project. This template ships pre-wired skills,
subagent conventions and security/testing references, agnostic of language, framework and
harness — it works with Claude Code, Cursor, Codex and OpenCode.

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

Then wire the skills — this depends on your harness, not your OS:

- **Codex, OpenCode and the rest of the [skills.sh](https://skills.sh) crowd**: nothing to do, they read
  `.agents/skills/` directly.
- **Claude Code, Cursor**: `sh scripts/install.sh`. On Windows without Developer Mode, read
  [the note below](#windows-without-developer-mode) first.

Then, in order:

1. Fill in [CLAUDE.md](CLAUDE.md) with the real stack (backend, frontend, package manager, code conventions, library quirks) and the documentation language (English by default). The doctrine shared across harnesses (subagents, skills, model tiers) lives in [AGENTS.md](AGENTS.md); CLAUDE.md imports it with `@AGENTS.md`.
2. Run `setup-matt-pocock-skills` once (as a slash command in Claude Code; each harness exposes skills its own way). It asks where issues live for this project — GitHub, GitLab, local markdown or your own workflow — and writes `docs/agents/issue-tracker.md`, which `code-review` reads to find the spec a change was meant to implement. It also appends a short `## Agent skills` pointer block to CLAUDE.md, because that file exists; move it into [AGENTS.md](AGENTS.md) so every harness sees it. The block is informational — the skills read `docs/agents/` directly — so forgetting to move it breaks nothing.
3. Adjust [SECURITY.md](SECURITY.md) and [TESTING.md](TESTING.md) if the stack has its own checklist (e.g. dependency audit tools, a specific test framework).
4. Once the project has recurring task patterns (backend features, frontend views, tests), create agents in `.claude/agents/` following [.claude/agents/README.md](.claude/agents/README.md) and add them to the table in [AGENTS.md](AGENTS.md).
5. Add stack-specific skills if applicable (backend framework, UI/animation library, data provider such as Supabase, etc.) — they are not included because they depend on the project. And remove the ones the project will never use — a backend-only service has no use for `frontend-design` or `web-design-guidelines` — with `npx skills remove <name>` (or `git rm -r` the skill and its link, drop its entry from `skills-lock.json`, and run `sh scripts/install.sh --check`). Each unused skill is one more description in every session's context.

### Adding it to a project that already exists

Git can check out specific paths from another repository straight into your index, so nothing is
copied by hand and nothing of yours is touched:

```bash
git remote add template https://github.com/Caarles00/agent-workspace-template.git
git fetch template master
git checkout template/master -- .agents .claude scripts skills-lock.json \
    AGENTS.md CLAUDE.md SECURITY.md TESTING.md .github/workflows/skills-check.yml
sh scripts/install.sh --check
```

Three files are left out on purpose because your project probably has its own: add
`.claude/settings.local.json` to `.gitignore`, `*.sh text eol=lf` to `.gitattributes`, and take
`docs/README.md` only if you want its Obsidian conventions. If you already have a `CLAUDE.md` or
`AGENTS.md`, drop it from the list and merge by hand. Then continue from *wire the skills* above.

Keeping `template` as a remote is also how you update later: `git fetch template && git checkout
template/master -- .agents/skills/tdd` brings that one skill and nothing else — a path the template
button doesn't have, since it drops the history.

## What `.agents/skills/` includes

All language/framework agnostic:

| Skill | What for |
|---|---|
| `ponytail` | Forces the simplest solution — anti-overengineering |
| `grilling` | Interrogates the plan before building, detects unresolved edge cases |
| `writing-plans` / `executing-plans` | Turns a settled design into a task-by-task plan in `docs/plans/`, then executes it with checkpoints |
| `tdd` | Guides the red→green loop: what a good test is, where tests go (seams), anti-patterns (implementation-coupled tests, tautological tests, "horizontal slicing") |
| `diagnosing-bugs` | A feedback loop that goes red on the bug before any hypothesis; then minimise, rank hypotheses, fix test-first |
| `verification-before-completion` | Gate before saying "done": run the command, read the output, then claim it |
| `code-review` | Two-axis review when closing a feature — the repo's conventions and the originating spec, in parallel subagents |
| `security-review` | OWASP Top 10 style security review |
| `codebase-design` / `improve-codebase-architecture` | "Deep modules" vocabulary, spots opportunities to simplify the design |
| `domain-modeling` | Pin down domain terminology (ubiquitous language) |
| `frontend-design` | Aesthetic direction when building new UI: typography, palette, layout, avoiding the generic "AI look" |
| `web-design-guidelines` | Frontend accessibility/UX review |
| `obsidian-markdown` | Obsidian syntax for the documentation in `docs/` |
| `find-skills` | Searches the [skills.sh](https://skills.sh) ecosystem when the installed set doesn't cover something |
| `setup-matt-pocock-skills` | Run once per project: records where issues live in `docs/agents/`, which `code-review` reads to find the spec |

## What it does NOT include (on purpose)

Concrete agents (`backend-feature`, `frontend-template`, `testing`...) and skills tied to a
stack (backend framework, animation library, cloud provider) — they are recreated or added
per project, because copying them without adapting to the real stack adds nothing.

## How skills are organized

Reference for whoever maintains the skills. You don't need it to use the template.

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
- **Adding and updating external skills**: `npx skills add <owner>/<repo> --skill <name>` installs into the
  canon, creates the symlinks and records origin and hash in `skills-lock.json` (the `find-skills` skill
  covers the search step). All included skills came in that way, so `npx skills update` brings them up to
  date — but it does **not** warn about local edits: it overwrites every edited skill with upstream, deletes
  files upstream doesn't have, and on Windows rewrites the links as absolute. Run it on a branch, then
  `sh scripts/install.sh --check` and `sh scripts/check-rewrites.sh`: the second names each rewrite the
  update undid so you can re-apply it. CI runs both on every pull request, so an update that reverts a
  rewrite cannot merge quietly.
- **Four vendored skills are edited on purpose**: `writing-plans` and `executing-plans` arrive with
  cross-references to sibling skills this template doesn't vendor and a `docs/superpowers/plans/` path
  convention; `find-skills` stops one command short of this repo's install flow; `web-design-guidelines`
  fetches its rules from a URL at every run, which needs WebFetch and follows text nobody here has read.
  Those are rewritten in place — cross-references normalized to the house form
  `call the Skill tool with "<name>"`, the path to `docs/plans/`, the `scripts/install.sh` step added, the
  rules vendored under `references/` and read locally — so the "edited locally" warning is expected for
  exactly those four, not a problem to undo. `scripts/check-rewrites.sh` is the list of those rewrites as
  a check; keep the two in sync. Treat an update as a merge, not an overwrite: read the incoming diff and
  re-apply what the check names. If a skill's upstream version drifts far enough that the rewrite no
  longer fits, drop the skill rather than maintaining a fork of it here.
- **Per-harness metadata inside a skill**: `agents/openai.yaml` is read by Codex; the
  `disable-model-invocation` frontmatter field is read by Claude Code (forces manual invocation). Other
  harnesses ignore what they don't know, so they coexist without issues.

### Windows without Developer Mode

Without Developer Mode git materializes symlinks as text files, so `scripts/install.sh` cannot link.
Run it from Git Bash with `--copy`, which replaces each link on disk with a copy of the skill (and assumes
you will update the copies by hand). Two things keep those copies out of the repo, and you need both:
the `.gitignore` shipped here ignores `.claude/skills/*/` — directories only, so it hides the copied
contents and does nothing to real symlinks — and this line, run once after the copy, makes git stop
seeing the link-turned-directory, which would otherwise be staged as a deleted link:

```bash
git update-index --skip-worktree $(git ls-files .claude/skills .cursor/skills)   # --no-skip-worktree to undo
```

With both in place, `git add -A` and `git commit -a` touch nothing under the skills folders.

That line needs the links to be tracked already, which they are on the `--template` route. After
`rm -rf .git && git init` nothing is tracked yet, so commit the links before copying: `sh scripts/install.sh`,
`git add -A`, apply the `git update-index` lines that `sh scripts/install.sh --check` prints, commit — and
only then `--copy` plus the `--skip-worktree` line above.

Either way `--check` fails, with the command that repairs it, on the two states that break the repo for
everyone else: a copy committed as a directory, and a copy with no link left in the index. CI runs the
same check on every pull request.

## License and third-party content

The repo is [MIT](LICENSE). The skills come from these repos (exact origin and hash in `skills-lock.json`),
each with its own license:

| Origin | Skills |
|---|---|
| [mattpocock/skills](https://github.com/mattpocock/skills) | `tdd`, `grilling`, `codebase-design`, `improve-codebase-architecture`, `domain-modeling`, `diagnosing-bugs`, `code-review`, `setup-matt-pocock-skills` |
| [dietrichgebert/ponytail](https://github.com/dietrichgebert/ponytail) | `ponytail` |
| [obra/superpowers](https://github.com/obra/superpowers) | `verification-before-completion`, `writing-plans`, `executing-plans` |
| [getsentry/skills](https://github.com/getsentry/skills) | `security-review` (includes material from the [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/), CC BY-SA 4.0, see its `LICENSE`) |
| [anthropics/skills](https://github.com/anthropics/skills) | `frontend-design` (Apache 2.0, see its `LICENSE.txt`) |
| [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | `web-design-guidelines` (its rules are vendored from [vercel-labs/web-interface-guidelines](https://github.com/vercel-labs/web-interface-guidelines), MIT, see its `references/LICENSE`) |
| [vercel-labs/skills](https://github.com/vercel-labs/skills) | `find-skills` (a different repo from `vercel-labs/agent-skills` above) |
| [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills) | `obsidian-markdown` |
