# docs/

Project documentation in Markdown following Obsidian conventions (wikilinks `[[note]]`,
callouts, property frontmatter) — see the `.agents/skills/obsidian-markdown/` skill for
the exact syntax. Written in the language set in CLAUDE.md (English by default).

This is not end-user documentation nor a public README: it is the project's internal
knowledge base (architecture decisions, runbooks, features in progress...). Open it as
an Obsidian vault if you want to navigate the wikilinks.

## Suggested subfolder convention

- `architecture/` — design decisions, ADRs
- `features/` — one note per significant feature: what was done and why
- `plans/` — implementation plans, one per feature, named `YYYY-MM-DD-<feature>.md` (see the `writing-plans` skill)
- `runbooks/` — operational procedures (deployment, incidents, recurring tasks)

Adjust this structure to the project; the only fixed rule is that everything lives here,
in the configured language, and linked with wikilinks where it makes sense.
