# Project-specific agents

This folder starts empty on purpose: custom subagents depend on each project's stack
(a backend-feature agent for FastAPI is not the same in Rails), so they are recreated
each time instead of copied.

## When to create one

Only when a type of task repeats often enough to justify a dedicated system prompt —
typically: implementing backend features, creating/editing frontend views, and writing
tests. If the project is small or the pattern doesn't repeat, none is needed.

## Template

Each agent is a `.claude/agents/<name>.md` file with frontmatter:

```markdown
---
name: short-name
description: One sentence — when this agent is launched and what it produces.
tools: [Read, Write, Edit, Bash, Grep, Glob]   # trim to the minimum needed
model: sonnet   # standard tier; tier mapping in CLAUDE.md, criteria in AGENTS.md
---

Agent instructions: project conventions, patterns to follow,
what to check before finishing (tests, lint, etc.)
```

## Examples to recreate depending on the stack

- **Backend**: implement endpoints/routes and data models following the conventions
  of the project's ORM/framework.
- **Frontend**: create or modify views/components following the project's UI pattern
  (SSR+HTMX, SPA, etc.).
- **Testing**: write tests for new code, with the project's test framework.

Update the table in `AGENTS.md` as soon as you create the first one.
