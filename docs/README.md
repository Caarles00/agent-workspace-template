# docs/

Project documentation in Markdown following Obsidian conventions (wikilinks `[[note]]`,
callouts, property frontmatter) — see the `.agents/skills/obsidian-markdown/` skill for
the exact syntax. Written in the language set in CLAUDE.md (English by default).

This is not end-user documentation nor a public README: it is the project's internal
knowledge base (architecture decisions, runbooks, features in progress...). Open it as
an Obsidian vault if you want to navigate the wikilinks.

## Suggested subfolder convention

- `agents/` — written once by `setup-matt-pocock-skills`: where issues live and how domain docs are laid out; `code-review` reads it
- `adr/` — architecture decision records, where the vendored skills look for them (`improve-codebase-architecture`, `diagnosing-bugs`, `code-review`)
- `features/` — one note per significant feature: what was done and why
- `plans/` — implementation plans, one per feature, named `YYYY-MM-DD-<feature>.md` (see the `writing-plans` skill)
- `runbooks/` — operational procedures (deployment, incidents, recurring tasks)

Specs are the one exception to "everything lives here": they go where `agents/issue-tracker.md` says,
which with local markdown is `.scratch/<feature-slug>/spec.md` at the repo root. That path belongs to
`setup-matt-pocock-skills` and `code-review` searches it, so it stays. Its templates also mention
`/wayfinder` and triage labels, which come from skills this template doesn't vendor: ignore those sections.

Adjust this structure to the project; the only fixed rule is that everything else lives here,
in the configured language, and linked with wikilinks where it makes sense.
