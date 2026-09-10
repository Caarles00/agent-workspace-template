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
- Keep the established pattern when closing a feature: verify first — that one you do yourself, it's commands and their output, not a subagent — then a code review, plus a security review when the change touches sensitive surface (see "Skills for specific moments" below). Relaying a subagent's "all green" as if you had checked it is exactly the failure `verification-before-completion` exists to stop.
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
- When you first need to understand the root cause of a bug — that's `diagnosing-bugs` below; come back to ponytail once a fix is actually on the table, because the fix still has to be the laziest one that works

Levels: `lite` (suggests an alternative), `full` (default), `ultra` (YAGNI extremist). Each harness exposes the skill its own way (slash command, mention by name...); the level is given when invoking it.

### `grilling` — interrogates the user before building

Invoke it when you notice any of these signals:

**Do invoke:**
- You are about to start a new feature, a new endpoint, or any significant business logic change
- The plan has unresolved edge cases, or the design assumes something that hasn't been confirmed
- The user uses a "grill" trigger phrase or asks you to challenge the approach

**Don't invoke:**
- Trivial one-line bugfixes, CSS/style changes, documentation updates or unit tests without new logic

When the frontier empties and the user confirms the design, don't start typing: if the work spans more than a couple of files, the next step is `writing-plans` below. Grilling settles the decisions; the plan is where they stop living in your context window.

### `writing-plans` + `executing-plans` — from a settled design to a task list

Once the design is agreed, write it down before touching code with the `writing-plans` skill: it turns the decisions into bite-sized tasks with the real interfaces spelled out — no "TBD", no "add validation" — saved to `docs/plans/YYYY-MM-DD-<feature>.md`. Pick it up later, in another session or with a subagent, using the `executing-plans` skill, which re-reads the plan critically before running it and stops at the checkpoints instead of improvising past them.

**Do invoke:**
- The work spans several files or several sessions, and you would otherwise be holding the whole sequence in your head
- The user hands you a spec, a ticket, or the output of a `grilling` session and expects code out the other end
- You are about to delegate implementation to a subagent and need it to work from something other than your session history
- There is already a plan in `docs/plans/` covering what you were asked to do — read it and execute it, don't restart from scratch

**Don't invoke:**
- The design still has open questions — `grilling` first; a plan written on top of unsettled decisions just makes them look decided
- Single-file changes, bugfixes, or anything you can finish in one pass — the plan would cost more than the work
- As a substitute for asking: a plan that guesses at an unconfirmed requirement is a confident wrong answer with checkboxes

Plans are project documentation like any other: `docs/plans/`, in the language set in CLAUDE.md, Obsidian conventions (see the `obsidian-markdown` skill).

### `diagnosing-bugs` — when something breaks and you don't yet know why

Invoke it when you notice any of these signals:

**Do invoke:**
- A test fails, an endpoint 500s, or the behavior doesn't match what the code plainly says it should do
- You are about to propose a fix and you cannot state the root cause in one sentence
- You are under time pressure and a quick fix looks obvious — that is exactly when guessing is most tempting, and a tight loop is faster than thrashing
- You are reading code to build a theory before you have a command that goes red on this bug
- Your first fix didn't work and you are already reaching for a second one
- The bug shows up only sometimes, only for one user, or only in one environment
- You catch yourself adding a `try/except`, a null check or a retry whose real job is to make a symptom disappear

**Don't invoke:**
- The cause is already proven — a typo, a wrong import, a stack trace that names the file and the line
- Nothing is broken and you are chasing a design improvement instead: that's `codebase-design` / `improve-codebase-architecture`

The skill's first phase is the whole skill: a tight feedback loop that goes red on *this* bug, before any hypothesis. The fix then lands test-first, as [TESTING.md](TESTING.md) requires, so the minimised repro stays as the regression test. One rule the skill doesn't state, so it lives here: if the third fix in a row fails, stop. That isn't a failed hypothesis, it's a wrong design — take it to `codebase-design` / `improve-codebase-architecture` before attempting a fourth.

### `verification-before-completion` — before saying "done"

Invoke it when you notice any of these signals:

**Do invoke:**
- You are about to write "done", "fixed", "working" or "tests pass" in a message to the user
- You are about to commit, open a PR, or hand the work back to whoever delegated it to you
- A subagent reported success and you are about to relay that report as if it were a fact you checked
- The last time you ran the suite was before your most recent edit
- You are reaching for "should", "probably" or "seems to" to describe your own change

**Don't invoke:**
- There is nothing to verify yet — you are still mid-edit, or still exploring

This is the gate *before* the reviews below, not a cheaper version of them: it proves your own claims with fresh command output, while `code-review` puts someone else's eyes on the work. And unlike the reviews, it has no size threshold — a one-line CSS change still gets the command run and the output read before you call it done.

### `code-review` + `security-review` — the second pair of eyes when completing a feature

When you finish implementing a new feature, a new endpoint, or any significant business logic change, launch a **code review** with the `code-review` skill before calling the task done. It reviews on two axes in two parallel subagents — the project's documented conventions, and the spec or issue the change was meant to implement — and reports them separately so one can't mask the other. It finds the spec through the issue tracker (`docs/agents/issue-tracker.md`, written once by `setup-matt-pocock-skills`) or through a file under `docs/` named after the feature — so the plan `writing-plans` saved to `docs/plans/` is the spec the review reads. Name it after the branch or feature and there is nothing else to produce.

Add a **security review** with the `security-review` skill (OWASP Top 10, injection, auth, XSS, etc.) only when the change touches the sensitive surface listed in [SECURITY.md](SECURITY.md): auth/sessions/permissions, payments, user-uploaded files, calls to external services with user data, or any new endpoint or entry point. When both apply, launch them **in parallel** as two scoped agents.

**Don't invoke** (neither of them) for: trivial one-line bugfixes, CSS/style changes, documentation updates or unit tests without new logic. Those are exceptions to the *reviews* only — `verification-before-completion` above still applies, and has no exceptions.

### `find-skills` — when the toolkit itself is the gap

This one acts on `.agents/skills/`, not on the project's code.

**Do invoke:**
- You are about to improvise an entire methodology — a testing approach, a migration procedure, a design language — that someone has almost certainly already packaged: `find-skills` searches the [skills.sh](https://skills.sh) ecosystem before you write it from scratch
- The user asks "is there a skill for X?", or wants a capability the installed set plainly doesn't cover

**Don't invoke:**
- A single project rule or a stack quirk — that goes in [CLAUDE.md](CLAUDE.md), not into a new skill
- To install something on your own initiative: `find-skills` proposes, the user approves, and the install is `npx skills add` **followed by** `sh scripts/install.sh` — skipping the second command leaves the per-harness links broken (see [How skills are organized](README.md#how-skills-are-organized))

---

## Subagent model tiers

> Explore with the fast tier, build with the standard one, review what matters with the high reasoning one.

| Tier | Use for |
|---|---|
| Fast | Finding and reading code, grep, factual questions about the codebase |
| Standard (default) | Writing code, implementing features, fixing bugs, templates and CSS |
| High reasoning | Architecture/design review, complex refactors, critical security or performance decisions, PR review |

Tiers are generic; the mapping to each provider's models lives in the harness config (e.g. CLAUDE.md for Claude Code).
