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
- Keep the established pattern: when closing a feature, code review + security review in parallel (2 scoped agents; see "Skills for specific moments" below).
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

When you finish implementing a new feature, a new endpoint, or any significant business logic change, launch these two agents **in parallel** before calling the task done:

1. **Code review** — use the `requesting-code-review` skill to verify the work meets the requirements and the project's conventions.
2. **Security review** — use the `security-review` skill to detect vulnerabilities (OWASP Top 10, injection, auth, XSS, etc.).

**Don't invoke** (neither of them) for: trivial one-line bugfixes, CSS/style changes, documentation updates or unit tests without new logic.

---

# Subagents — Model selection

When launching subagents, pick the tier according to the task. Tiers are generic; the mapping to each
provider's concrete models goes in the harness configuration file (e.g. CLAUDE.md for Claude Code).

## Fast tier — quick, low-cost tasks

- Finding files, reading code, grep, repo exploration
- Answering factual questions about the code
- Single-step tasks with no complex decisions
- Exploration agents by default

## Standard tier — everyday work

This is the default tier, no need to specify it.

- Writing and editing new code
- Implementing features, fixing bugs
- Generating translations, templates, CSS
- General-purpose agents by default

## High reasoning tier — critical decisions

- Reviewing architecture or system design
- Complex refactors with many dependencies
- Critical security or performance decisions
- Independent second opinion before merge
- Planning or PR review agents

## Golden rule

> Explore with the fast tier, build with the standard one, review what matters with the high reasoning one.
