---
sidebar_position: 6
title: Diagrams (FigJam)
---

# Diagrams

All canonical SalesDoctor architecture and workflow diagrams live in **one consolidated FigJam master**, organised by domain into top-level Sections. Open the master once and scroll between sections — every diagram is on the same canvas.

## The master board

**[Open the master FigJam](https://www.figma.com/board/y2kWMuxLwrpdaCGhVwYYYI)**

| # | Section | What's inside |
|---|---------|---------------|
| 1 | **System Design** | Ecosystem · sd-main System Architecture · sd-billing Architecture · sd-cs Architecture (multi-DB) · sd-main Core ERD · sd-billing Domain ERD |
| 2 | **Inter-project integration & feature catalog** | Inter-project integration map (sd-cs ↔ sd-main ↔ sd-billing endpoints) · Key feature catalog by project |
| 3 | **sd-billing workflows** | Subscription Lifecycle · Click two-phase payment · Payme JSON-RPC payment · Settlement cron · Notify cron · sd-billing integration sequence |
| 4 | **sd-cs workflows** | sd-cs Onboarding Flow |
| 5 | **sd-main Order flows** | Order State Machine · Order Create (api3) · Payment Collection & Approval · Online Order · Client Approval |
| 6 | **sd-main Field & ops flows** | Visit & GPS Geofence · Warehouse Goods Receipt · Inventory Stocktake · Defect & Return · Audit Submission |

25 diagrams total. A separate placeholder for future Process Workflows (QA / PM / Release / Bug lifecycle) is left out of the master until those processes are formally documented in the codebase.

## Why one board

Big-CRM teams (Salesforce Architects, Zoho) used to publish architectural material across multiple focused boards — one per audience, one per abstraction level — but in practice readers lose track of which board to open. A single master with named Sections matches the C4 model (Context → Container → Component) while keeping everything one click away. The Sections give the same visual division pages would; FigJam Plugin API doesn't expose programmatic page creation today, so Sections are the right tool.

## Source of truth — Mermaid in the docs

The Mermaid source for every diagram lives **inline on the corresponding doc page**. Edit the Mermaid block, lint locally, then re-run `generate_diagram` against the master `fileKey` to refresh the FigJam copy.

| Section diagram | Mermaid source |
|-----------------|----------------|
| Ecosystem | [`docs/ecosystem.md`](../ecosystem.md) |
| Inter-project integration map | [`docs/ecosystem.md`](../ecosystem.md) |
| Key feature catalog by project | [`docs/ecosystem.md`](../ecosystem.md) |
| sd-main System Architecture | [`docs/architecture/overview.md`](./overview.md) |
| sd-billing Architecture | [`docs/sd-billing/overview.md`](../sd-billing/overview.md) |
| sd-cs Architecture (multi-DB) | [`docs/sd-cs/overview.md`](../sd-cs/overview.md) |
| sd-main Core ERD | [`docs/data/erd.md`](../data/erd.md) |
| sd-billing Domain ERD | [`docs/sd-billing/domain-model.md`](../sd-billing/domain-model.md) |
| Subscription Lifecycle | [`docs/sd-billing/subscription-flow.md`](../sd-billing/subscription-flow.md) |
| Click / Payme payment sequences | [`docs/sd-billing/payment-gateways.md`](../sd-billing/payment-gateways.md) |
| Settlement & Notify cron | [`docs/sd-billing/cron-and-settlement.md`](../sd-billing/cron-and-settlement.md) |
| sd-billing integration sequence | [`docs/sd-billing/integration.md`](../sd-billing/integration.md) |
| sd-cs Onboarding | [`docs/sd-cs/sd-main-integration.md`](../sd-cs/sd-main-integration.md) |
| Order State Machine + Order Create | [`docs/modules/orders.md`](../modules/orders.md) |
| Payment Collection & Approval | [`docs/modules/payment.md`](../modules/payment.md) |
| Online Order | [`docs/modules/onlineOrder.md`](../modules/onlineOrder.md) |
| Client Approval | [`docs/modules/clients.md`](../modules/clients.md) |
| Visit & GPS Geofence | [`docs/modules/agents.md`](../modules/agents.md) |
| Warehouse Goods Receipt | [`docs/modules/warehouse.md`](../modules/warehouse.md) |
| Inventory Stocktake | [`docs/modules/inventory.md`](../modules/inventory.md) |
| Defect & Return | [`docs/modules/stock.md`](../modules/stock.md) |
| Audit Submission | [`docs/modules/audit-adt.md`](../modules/audit-adt.md) |

The styling cookbook (colour taxonomy, shape vocabulary, swimlane recipe, white subgraph rule) lives at [Workflow design standards · Mermaid styling cookbook](../team/workflow-design.md#mermaid-styling-cookbook). Lint Mermaid blocks locally with `npm run lint:mermaid` before pushing.

## Legacy boards (deprecated — redirect only)

The 6 previous boards are wiped and each carries a sticky pointing here. Don't edit them; the canonical content is the master above.

| Legacy board | Sticky redirect | Status |
|--------------|-----------------|--------|
| Ecosystem | https://www.figma.com/board/NIhRaLqT67FQZNKq4cLQtr | Wiped |
| sd-billing | https://www.figma.com/board/8gPJ5OFsIjhhaKFn4kRwDH | Wiped |
| sd-cs (HQ) | https://www.figma.com/board/n7CzNpfgyykdCYYJiuQG7L | Wiped |
| sd-main · System Design | https://www.figma.com/board/tw0B3eE1bKNbvmmny8TVvx | Wiped |
| sd-main · Feature Flows | https://www.figma.com/board/MyvyaeEluqvHofH4E2qIoU | Wiped |
| Process Workflows | https://www.figma.com/board/YvAliP5jI2oqizJeOReYxk | Empty (no source authored yet) |
| All-in-one (very old archive) | https://www.figma.com/board/KH7PL28JoBs1GOvf6MxkJj | Pre-consolidation; do not edit |

## Embedding PNGs in the docs

Each diagram in the master can be exported individually. Drop PNGs into `static/diagrams/<name>.png` and reference from any markdown:

```markdown
![Ecosystem](/diagrams/ecosystem.png)
```

## Re-generating

Edit the Mermaid block in the matching source doc. To refresh the FigJam copy:

1. Locate the diagram on the master board (note its current Section).
2. Use `use_figma` to find and remove the existing diagram nodes.
3. Use `generate_diagram` with `fileKey: y2kWMuxLwrpdaCGhVwYYYI` and the new Mermaid.
4. Use `use_figma` to move the just-generated nodes back into the same Section.

The bracket-and-move pattern (snapshot top-level node IDs before generate; diff after) is documented in the resumption agent prompt history. Single-diagram regenerations are quick.
