@AGENTS.md

# ALWAYS KEEP THIS IN MIND

> Base template. Fill in each section when starting a new project and delete this notice.

## General
- Check whether there are skills available before implementing something
- Review generated code for possible errors before calling it done
- Project documentation lives in `docs/` and follows Obsidian and Markdown conventions (see the `obsidian-markdown` skill)
- **Documentation language**: English _(set this when starting the project; agents write all `docs/` content in this language)_

## Project stack
- **Backend**: _(framework, language, ORM/DB, queue/cache if applicable)_
- **Frontend**: _(framework or SSR+HTMX/vanilla, with or without build step)_
- **Local services**: _(how DB/Redis/etc. are started locally — Docker Compose, native services...)_
- **Package manager**: _(uv, npm/pnpm, cargo... — state the canonical command for adding dependencies)_

## Code conventions
- _(ORM/language style: e.g. SQLAlchemy 2.x with `Mapped`+`mapped_column`, not the legacy style)_
- _(how circular imports or type dependencies are resolved)_
- Never write comments that explain WHAT the code does; only write comments when the WHY is not obvious

## Known quirks of installed libraries
- _(note here linter/type-checker false positives or non-obvious behaviors of the project's dependencies, as you discover them)_

## Frontend
- All frontend must be responsive
- _(interactivity preference: HTMX, SPA framework, vanilla JS... and when to use each)_
- Always preserve template syntax and existing logic when modifying templates

## Claude Code specific

The general doctrine (when to launch subagents, when to invoke each skill, model tiers) lives in
[AGENTS.md](AGENTS.md) and is imported above with `@AGENTS.md`. Only what doesn't apply to other harnesses goes here:

- **Tier to model mapping**: fast → `haiku`, standard → `sonnet` (default), high reasoning → `opus`.
- Skills can also be invoked as slash commands (`/ponytail lite|full|ultra`, `/grilling`, `/writing-plans`, `/tdd`...).
- Project-specific subagents go in `.claude/agents/` (see [.claude/agents/README.md](.claude/agents/README.md)).
