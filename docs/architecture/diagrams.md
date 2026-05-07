---
sidebar_position: 6
title: Diagrams (FigJam)
---

# Diagrams

The board is split across **six FigJam files**, one per concern. This
gives you focused boards instead of one giant canvas.

| # | Board | URL |
|---|-------|-----|
| 01 | **Ecosystem** — three-project map | https://www.figma.com/board/NIhRaLqT67FQZNKq4cLQtr |
| 02 | **sd-billing** — subscriptions, payments, settlement | https://www.figma.com/board/8gPJ5OFsIjhhaKFn4kRwDH |
| 03 | **sd-cs (HQ)** — multi-DB, cross-dealer reports | https://www.figma.com/board/n7CzNpfgyykdCYYJiuQG7L |
| 04 | **sd-main · System Design** | https://www.figma.com/board/tw0B3eE1bKNbvmmny8TVvx |
| 05 | **sd-main · Feature Flows** | https://www.figma.com/board/MyvyaeEluqvHofH4E2qIoU |
| 06 | **Process Workflows** (QA / PM / Release / Bugs) | https://www.figma.com/board/YvAliP5jI2oqizJeOReYxk |

Plus an **archive** board with the original combined dump:

| Archive | URL |
|---------|-----|
| All-in-one (legacy) | https://www.figma.com/board/KH7PL28JoBs1GOvf6MxkJj |

## What's on each board

### 01 · Ecosystem

- Ecosystem — 3 projects (Vendor / HQ / Dealers)
- Direction of dependency arrow

### 02 · sd-billing

- Architecture (Yii 1.1.15, MySQL, Redis-less, cron-driven)
- Domain ERD (Distributor → Diler → Subscription → Package; Payment;
  Click/Payme/Paynet transactions)
- Subscription lifecycle (buy → renew → expire)
- Click two-phase payment sequence

### 03 · sd-cs (HQ)

- Architecture — multi-DB connection pattern
- Cross-dealer report sequence — connection swap per dealer

### 04 · sd-main · System Design (C4 Container level)

- System Architecture
- Module map
- Core ERD
- Order state machine
- Multi-tenant request flow
- Order lifecycle (full sequence)

### 05 · sd-main · Feature Flows (C4 Component level)

- Create Order (web)
- Create Order (mobile / api3)
- Payment collection & approval
- Visit & GPS geofence
- Warehouse + Stock + Inventory (combined)
- Audit submission
- Online order + Defect/Return (combined)

### 06 · Process Workflows

- QA process (Plan → Design → Execute → Bugs → Sign-off)
- PM lifecycle (Discover → Define → Build → Launch → Learn)
- Release train
- Bug lifecycle (state)

## Why split into multiple files

Big-CRM teams (Salesforce Architects, Zoho) publish architectural
material in **focused boards** — one per audience and one per
abstraction level — rather than a single mega-canvas. The split
follows the **C4 model**: Context (ecosystem) → Container (per project)
→ Component (per feature). Each file is small enough that anyone can
open it, find what they need, and edit without scrolling for hours.

## Embedding PNGs in the docs

Each board can be exported. Drop PNGs into
`static/diagrams/<name>.png` and reference from any markdown:

```markdown
![Ecosystem](/diagrams/ecosystem.png)
```

Suggested filenames are aligned with the board names — see the per-page
"See also" sections for which diagram each module uses.

## Re-generating

These boards were created with the Figma MCP `generate_diagram` tool.
The Mermaid source for every diagram lives inline on the corresponding
doc page (see the module pages, the architecture pages, and the
sd-billing / sd-cs sections). Edit the Mermaid block and re-run
`generate_diagram` against the right `fileKey` to refresh the FigJam
copy.
