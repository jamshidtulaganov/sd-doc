---
sidebar_position: 8
title: Diagram conventions
audience: Backend engineers, QA, PM
summary: How to author and review the mermaid workflow diagrams that appear in every sd-main module page.
topics: [docs, mermaid, conventions, style-guide]
---

# Diagram conventions

Every `sd-main` module page in this site has a `## Workflows` section with
two to four mermaid diagrams. This document is the single source of truth
for how those diagrams are written and reviewed. Reviewers cite this doc
for style nits instead of relitigating per PR.

## When to use which diagram type

| Type | Use for | Example question answered |
|---|---|---|
| `sequenceDiagram` | Request flows over time | "How does a GPS sample travel from mobile to DB?" |
| `flowchart TD` | Branching business rules | "What happens if discount exceeds the agent's limit?" |
| `stateDiagram-v2` | Entity lifecycle | "What statuses can an Order be in?" |
| `erDiagram` | Entity relationships (one per module, in the Domain entities slot) | "How are Agent, AgentPlan, AgentPaket, Car related?" |

Pick by the question being answered, not by personal preference. If you
cannot phrase the question in one sentence, the diagram is the wrong type
or the wrong scope.

## Standard actor names

Use these exact names so diagrams across modules are comparable.

| Name | Means |
|---|---|
| `Mobile` | The agent mobile app, talking to `api3` |
| `Web` | A browser, talking to a web controller |
| `api`, `api2`, `api3`, `api4` | The respective API entry-point modules |
| `<Module>Controller`, `<Module>Service` | Internal layers — use the **real** PHP class name (e.g., `OrdersController`, or a service class like `OrderService` if your module has one) |
| `DB` | MySQL. Put the table name in the arrow label (`INSERT gps_track`) |
| `Cron` | A scheduled job (`protected/components/jobs/<Job>`) |
| `External:<vendor>` | Third parties — `External:Didox`, `External:1c-eSale`, `External:Faktura-uz`, `External:Wialon` |

## Style rules

1. **One diagram answers one question.** If a diagram does not fit on a
   standard laptop screen, split it.
2. **Every arrow has a label.** Unlabelled arrows are useless to readers.
   Label with the operation, not just `→`.
3. **Reference real code identifiers** in node names: `GpsController::actionOffline`,
   `OrdersController::actionView`, `protected/components/jobs/SendNotificationJob`.
   Never use generic words like "process" or "validate" without the actual
   method name.
4. **Stable workflow numbering.** Sections are titled `### Workflow 1.2 — <name>`.
   Other pages cross-link to them with stable anchors:
   `[Workflow 1.2](./<module>.md#workflow-12-<slug>)`.
5. **No source-file hyperlinks in v1.** Use inline code with the real
   identifier; there is no stable public source URL for `sd-main`.
6. **No color theming.** Default Docusaurus mermaid theme
   (`light: 'neutral'`, `dark: 'dark'`). Do not add `%%{init}%%` blocks.

## Anti-patterns rejected in review

- **God diagrams.** A single diagram trying to show the whole module.
  Split it by question. Two clean diagrams beat one cluttered one.
- **Generic labels.** `save data`, `process`, `validate input`,
  `do the thing`. Replace with the actual function, table, or event.
- **Structure-only diagrams.** A workflow diagram that only shows
  entity relationships without motion (time, decision, state change)
  is the wrong type — move it to the `erDiagram` slot or delete it.
- **Off-screen sprawl.** If a node sits below the laptop fold on standard
  width, the diagram is too wide. Split or restructure.
- **Mixed actor styles.** Half the diagram says `MobileApp`, the other
  half says `Mobile`. Pick the standard name from the table above.

## Page template

Every module page that appears in the
[Workflows sidebar](../modules/overview.md) appends this section:

```markdown
## Workflows

### Entry points
| Trigger | Controller / Action / Job | Notes |
|---|---|---|
| <web/mobile/cron/queue> | `<Class>::<method>` | <one-line context> |

### Domain entities
<one mermaid `erDiagram` covering the 3–6 models that appear in the
workflows below — not every model in the module>

### Workflow 1.1 — <business name>
<1–2 sentence what/why>
<one mermaid diagram, type chosen from the table above>

### Workflow 1.2 — <next>
…

### Cross-module touchpoints
- Reads: `<module>.<Model>` (<purpose>)
- Writes: `<module>.<Model>` (<purpose>)
- APIs: `<api1/2/3/4>/<route>`

### Gotchas
- <known landmines, deprecated paths, common mistakes — or "none known">
```

**Workflow count per module:** 2 to 4. More than 4 means the module is
overloaded — split conceptually or flag for review.

## How to validate before pushing

```bash
cd sd-docs
npm run lint:mermaid                          # all blocks site-wide
npm run lint:mermaid -- docs/modules/<file>   # one file (faster)
npm run build                                 # full Docusaurus build
```

The lint script invokes `@mermaid-js/mermaid-cli` and fails on parser
errors. CI runs the same check before merge.
