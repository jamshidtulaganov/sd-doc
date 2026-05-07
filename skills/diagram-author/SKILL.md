---
name: diagram-author
description: Use when the user asks for a workflow / architecture / ERD / sequence / state diagram for SalesDoctor. Always emits the diagram into the canonical FigJam board, never a separate file.
---

# Skill — Diagram author

## The one rule

The canonical FigJam board is:

```
fileKey   = KH7PL28JoBs1GOvf6MxkJj
url       = https://www.figma.com/board/KH7PL28JoBs1GOvf6MxkJj
```

**Always** pass `fileKey=KH7PL28JoBs1GOvf6MxkJj` to
`generate_diagram`. Never create a new board.

## Diagram type cheat sheet

| User intent | Mermaid type |
|-------------|---------------|
| System architecture, modules, deployments | `flowchart` (LR or TB) |
| Process / workflow with phases | `flowchart` with `subgraph` per phase |
| Step-by-step actor interaction | `sequenceDiagram` |
| Object lifecycle | `stateDiagram-v2` |
| Schema / entities | `erDiagram` |
| Project plan with dates | `gantt` |

## Existing diagrams (don't recreate, edit)

| Name | Concern |
|------|---------|
| SalesDoctor — System Architecture | tier diagram |
| SalesDoctor — Module Map | Yii modules grouping |
| SalesDoctor — Core ERD | data model |
| SalesDoctor — Order Lifecycle | sequence |
| SalesDoctor — Order State Machine | order STATUS |
| SalesDoctor — Roles & Permissions | RBAC |
| SalesDoctor — Deployment Topology | infra |
| SalesDoctor — Agent Visit Flow | mobile flow |
| SalesDoctor — Multi-tenant Request Flow | tenant resolution |
| Workflow — QA Process | QA loop |
| Workflow — Bug Lifecycle (state) | bug states |
| Workflow — Product Management | PM loop |
| Workflow — Release Train | release process |
| Workflow — Claude AI Assist | AI usage |

## Rules for new diagrams

1. **Keep < 25 nodes** unless the user specifically asks for detail.
2. **Quote labels** with spaces: `["Label with spaces"]`.
3. **Group by phase** with `subgraph` — gives the diagram clear pacing.
4. **Avoid emojis** in the diagram itself.
5. **No `\n`** inside labels — use multiple nodes if you need line breaks.
6. **Don't use the word `end`** as a class name (Mermaid keyword).
7. **Sequence diagrams: no notes** (the FigJam exporter doesn't render
   them well).
8. **Gantt: no colour styling**.

## Mermaid templates

### Process flow with phases

```
flowchart LR
  subgraph Phase1["1 — Discover"]
    A1[...]
    A2[...]
  end
  subgraph Phase2["2 — Define"]
    B1[...]
  end
  A1 --> A2 --> B1
```

### Sequence

```
sequenceDiagram
  participant U as User
  participant A as App
  participant D as DB
  U->>A: action
  A->>D: query
  D-->>A: rows
  A-->>U: response
```

### State machine

```
stateDiagram-v2
  [*] --> S1
  S1 --> S2 : event
  S2 --> [*]
```

## After generating

1. The tool returns an `imageUrl` and `claimFileUrl`. The image is the
   raster preview — link the **claim/edit URL** in docs.
2. Tell the user the diagram is in the canonical board with its name so
   they can find it.
3. Optionally instruct them to export PNG and drop into
   `static/diagrams/`.
