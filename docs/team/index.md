---
sidebar_position: 0
title: Team knowledge base
slug: /team
audience: All team members (QA, PM, new engineers)
summary: Entry point to team-facing pages — onboarding, QA process, and Product Management process. The same content is fed into the team's RAG / vector database.
topics: [team, knowledge-base, onboarding, qa, pm]
---

# Team knowledge base

This section is for **human team members**. The pages here are the
canonical "knowledge base" — they're also fed into the team's RAG /
vector database, so the same content is reachable via in-app search
and chat assistants.

| Page | For | What you'll find |
|------|-----|------------------|
| [New developer onboarding](./onboarding.md) | New engineers | Day 1 / Week 1 / Month 1 plan, reading order, starter tickets |
| [QA — process & knowledge base](./qa.md) | QA team | Test plans, bug templates, severity, regression hot-spots |
| [Product Management — process & knowledge base](./pm.md) | Product team | PRD templates, RICE, release notes, project context |

## How this section is used

- **Onboarding** — managers point new hires here on day 1.
- **Test cases** — QA writes tests against the regression hot-spots
  and the per-module key features documented under
  [Modules](../modules/overview.md).
- **New features** — Product writes PRDs that reference the relevant
  module + feature flow, then engineering implements against the
  established patterns.
- **RAG / search** — the team's vector DB ingests these pages so
  users can ask "how does payment approval work" and get the right
  passage.

## Documentation = knowledge base = onboarding

A well-written page should serve all three audiences. When you write
a new page, ask:

1. Will this make sense to a **new engineer** with no platform
   context? (Add a Summary paragraph if not.)
2. Will a **QA engineer** find the regression risks? (Add a "Failure
   modes" or "Hot-spots" section if relevant.)
3. Will a **PM** know the feature's impact on roles, mobile, and
   compliance? (Use the per-module Key Features table.)
4. Will the **vector DB** chunk it cleanly? (Self-contained sections,
   absolute references — no "see above".)
