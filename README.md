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

On Windows, then run `scripts/install.sh --copy` (see [How skills are organized](#how-skills-are-organized)).

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
| `tdd` | Guides the red→green loop: what a good test is, where tests go (seams), anti-patterns (implementation-coupled tests, tautological tests, "horizontal slicing") |
| `requesting-code-review` | Review checklist when closing a feature |
| `security-review` | OWASP Top 10 style security review |
| `codebase-design` / `improve-codebase-architecture` | "Deep modules" vocabulary, spots opportunities to simplify the design |
| `domain-modeling` | Pin down domain terminology (ubiquitous language) |
| `api-design-principles` | REST/GraphQL design principles |
| `frontend-design` | Aesthetic direction when building new UI: typography, palette, layout, avoiding the generic "AI look" |
| `web-design-guidelines` | Frontend accessibility/UX review |
| `obsidian-markdown` | Obsidian syntax for the documentation in `docs/` |

## How skills are organized

- **Canonical source**: `.agents/skills/<skill>/`. This is the folder shared by Codex, Cursor, OpenCode
  and the other harnesses that follow the [skills.sh](https://skills.sh) convention. Edit only here.
- **Per harness**: `.claude/skills/<skill>` is a relative symlink to the canon (Claude Code follows symlinks
  and deduplicates). For another harness that uses its own folder, add another set of symlinks the same way.
- **Script**: `scripts/install.sh` creates any missing symlinks and redoes absolute or broken ones;
  `scripts/install.sh --check` verifies them without changing anything. Run both after `npx skills add`
  (on Windows the CLI creates absolute links) and before committing: if git has `core.symlinks=false`
  a new link is stored as a plain file, and `--check` prints the `git update-index` line that fixes it.
  On Windows without Developer Mode git materializes symlinks as text files; there, use
  `scripts/install.sh --copy`, which copies instead of linking (and assumes you will update the copies by hand).
- **Adding and updating external skills**: `npx skills add <owner>/<repo> --skill <name>` installs into the
  canon, creates the symlinks and records origin and hash in `skills-lock.json`. All included skills
  came in that way, so `npx skills update` brings them up to date and warns if they were edited locally.
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
| [obra/superpowers](https://github.com/obra/superpowers) | `requesting-code-review` |
| [getsentry/skills](https://github.com/getsentry/skills) | `security-review` (includes material from the [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/), CC BY-SA 4.0, see its `LICENSE`) |
| [wshobson/agents](https://github.com/wshobson/agents) | `api-design-principles` |
| [anthropics/skills](https://github.com/anthropics/skills) | `frontend-design` (Apache 2.0, see its `LICENSE.txt`) |
| [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | `web-design-guidelines` |
| [kepano/obsidian-skills](https://github.com/kepano/obsidian-skills) | `obsidian-markdown` |
