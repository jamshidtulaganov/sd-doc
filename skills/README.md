# Skills (for Claude / agent use only)

These are **agent skill bundles** — instructions that Claude (or any
agent host) loads when it works on this repo. They are **not**
team-member guides; for those, see the **Team** section in the docs.

| Skill | Used when |
|-------|-----------|
| [`sd-docs-author`](./sd-docs-author/SKILL.md) | Writing or updating any page in `sd-docs/` |
| [`diagram-author`](./diagram-author/SKILL.md) | Generating / refreshing FigJam diagrams |
| [`claude-ai-assist`](./claude-ai-assist/SKILL.md) | The full human ↔ AI collaboration loop |

## Knowledge base for human team members

QA, Product, and new developers do **not** need to read the skills.
They use the docs site directly:

- **QA** — see `/docs/team/qa` for test plans, bug templates, severity,
  and SalesDoctor-specific regression hot spots.
- **Product** — see `/docs/team/pm` for PRD templates, RICE
  prioritisation, release notes, and per-project PM context.
- **New developer onboarding** — see `/docs/team/onboarding` for the
  Day 1 / Week 1 / Month 1 plan, the recommended reading order, and a
  list of starter tickets.

The docs site is also fed into the team's RAG / vector database, so
the same content is reachable via in-app search and chat assistants.

## How to load a skill

If you're using **Claude Code** locally, point your skills config at
this folder (or copy the bundles into `~/.claude/skills/`).

In Cowork mode or another agent host, ask:

> "Use the `sd-docs-author` skill from `/sd-docs/skills/` to write the
> page for module X."

The agent reads the corresponding `SKILL.md` and follows the rules.
