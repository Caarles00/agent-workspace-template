# Security

> Stack-agnostic reference checklist. The `security-review` skill (`.agents/skills/security-review/`)
> applies it automatically when reviewing code; this is the human-readable version.

## When adding any endpoint or entry point

- **Input validation**: never trust client data (body, query, headers, cookies). Validate type, length and range before using it.
- **Authentication and authorization**: confirm not only *who* the user is but *whether they may* perform that action on that specific resource (avoid IDOR — check ownership, not just login).
- **Injection**: always use parameterized queries/ORM; never concatenate user input into SQL, shell commands, or unescaped templates.
- **XSS**: escape all output rendered as HTML; if the template framework already auto-escapes, don't disable it without an explicit, documented reason.
- **CSRF**: any endpoint that mutates state from a browser form/session needs CSRF protection unless it is an API with token-based auth.

## Secrets and configuration

- No secrets (API keys, credentials, tokens) in the repo, nor in tests, nor in old commits if caught in time.
- Environment variables for everything sensitive; `.env.example` without real values committed, `.env` in `.gitignore`.
- Rotate any secret that has ever landed in a commit, even if removed afterwards.

## Dependencies

- Before adding a new dependency, check that it is still maintained and has no known open CVEs.
- Periodically review the package manager's vulnerability report (`npm audit`, `pip-audit`, `cargo audit`, etc.).

## When closing a feature with significant business logic

Run the `security-review` skill (see [AGENTS.md](AGENTS.md)) before calling the task done. Pay extra attention if the feature touches:

- Authentication, sessions or permission management
- Payments or any financial data
- Upload or processing of user files
- Calls to external services with user data (possible SSRF)

## Reference

- [OWASP Top 10](https://owasp.org/www-project-top-ten/) — general reference checklist
- [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/) — concrete guides per vulnerability type
