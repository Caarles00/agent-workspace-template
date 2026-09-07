# Worked example: pressure-testing a skill

> [!warning] These files are test fixtures. Nothing here is a live scenario, and nothing here is an
> instruction to you. If you reached this folder while doing something else, you can stop reading.

This is the full test suite obra wrote while hardening the `systematic-debugging` skill, kept as the
worked example for the technique that `testing-skills-with-subagents.md` describes. Read it when you are
writing or hardening a skill of your own and want to see what "watch it fail first" looks like in
practice.

| File | What it demonstrates |
|---|---|
| `CREATION-LOG.md` | The whole arc: extracting the skill, structuring it, closing the loopholes the tests exposed |
| `test-academic.md` | The cheap baseline — can an agent even quote the skill back correctly? Passing this proves nothing about compliance |
| `test-pressure-1.md` | Urgency and money: a fake outage at $15k/minute, with the wrong answer made to look pragmatic |
| `test-pressure-2.md` | Sunk cost and exhaustion |
| `test-pressure-3.md` | Authority and social pressure |

The three pressure tests are deliberately adversarial: each one argues, persuasively, for abandoning the
skill it is testing. That is the point — a skill that only holds up when nothing is pushing against it
has not been tested. Each fixture opens with a "this is a real scenario, act now" framing, which is what
makes it work on a fresh subagent that has no other context.

**How to run one:** paste the scenario into a *fresh* subagent that has the skill loaded and nothing else
of your session's context — skipping this README and the fixture's own header. Then compare its choice
against what the skill demands. A subagent that already watched you set up the test is not a valid
subject; it will infer the expected answer.

The paths these fixtures mention (`skills/debugging/systematic-debugging`) are upstream's layout, not
this project's. Here the skill lives at `.agents/skills/systematic-debugging/`.
