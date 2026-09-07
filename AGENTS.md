# Project agents

## Specialized agents

_Empty until the project has its own agents — see [.claude/agents/README.md](.claude/agents/README.md)
for the template. Fill in this table as soon as you create the first one._

| Agent | When | Model | File |
|-------|------|-------|------|
| — | — | — | — |

---

## When to launch a subagent

- Launch a subagent only if it brings **real parallelism**, **broad search** (you want the conclusion, not the file dump) or **context isolation**. To read an already-known fact or make a trivial edit, do it directly.
- **Massive fan-out (workflows / dozens of agents) only on explicit request.** Don't trigger it on your own initiative.
- Keep the established pattern: when closing a feature, a code review, plus a security review when the change touches sensitive surface (see "Skills for specific moments" below).
- Prune custom agents you don't use: each definition takes up context even when not launched.

---

## Skills for specific moments

### `ponytail` — forces the simplest solution that works

Invoke it when you notice any of these signals:

**Do invoke:**
- You are about to create a new file for something that could go in an existing one
- You wonder "do I need a `service` for this?" before having two use cases that share it
- You are going to add a new dependency — does the stdlib or something already installed cover it?
- You are creating a class or helper for something that happens only once
- Someone asks to "add caching" without a benchmark that justifies it
- You are refactoring without anyone having asked for it

**Don't invoke:**
- Security, auth or payment logic — ponytail doesn't simplify this
- When you first need to understand the root cause of a bug

Levels: `lite` (suggests an alternative), `full` (default), `ultra` (YAGNI extremist). Each harness exposes the skill its own way (slash command, mention by name...); the level is given when invoking it.

### `grilling` — interrogates the user before building

Invoke it when you notice any of these signals:

**Do invoke:**
- You are about to start a new feature, a new endpoint, or any significant business logic change
- The plan has unresolved edge cases, or the design assumes something that hasn't been confirmed
- The user uses a "grill" trigger phrase or asks you to challenge the approach

**Don't invoke:**
- Trivial one-line bugfixes, CSS/style changes, documentation updates or unit tests without new logic

### `requesting-code-review` + `security-review` — when completing a feature

When you finish implementing a new feature, a new endpoint, or any significant business logic change, launch a **code review** with the `requesting-code-review` skill before calling the task done: it verifies the work meets the requirements and the project's conventions.

Add a **security review** with the `security-review` skill (OWASP Top 10, injection, auth, XSS, etc.) only when the change touches the sensitive surface listed in [SECURITY.md](SECURITY.md): auth/sessions/permissions, payments, user-uploaded files, calls to external services with user data, or any new endpoint or entry point. When both apply, launch them **in parallel** as two scoped agents.

**Don't invoke** (neither of them) for: trivial one-line bugfixes, CSS/style changes, documentation updates or unit tests without new logic.

---

## Subagent model tiers

> Explore with the fast tier, build with the standard one, review what matters with the high reasoning one.

| Tier | Use for |
|---|---|
| Fast | Finding and reading code, grep, factual questions about the codebase |
| Standard (default) | Writing code, implementing features, fixing bugs, templates and CSS |
| High reasoning | Architecture/design review, complex refactors, critical security or performance decisions, PR review |

Tiers are generic; the mapping to each provider's models lives in the harness config (e.g. CLAUDE.md for Claude Code).
