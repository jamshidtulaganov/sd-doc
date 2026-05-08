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

## How to add or update a diagram

The Mermaid in the source docs is canonical. The FigJam master is a regenerable copy. Edit the doc first, lint, then push the FigJam.

### Prerequisites

- Figma MCP with `generate_diagram` and `use_figma` tools available. (At time of writing, the `959fd320-…` server that exposes both is intermittent. If only the read-only Figma MCP is connected, you can author + lint Mermaid in the docs but cannot push to FigJam — defer the FigJam refresh to a later session.)
- Master `fileKey`: `y2kWMuxLwrpdaCGhVwYYYI`.
- The cookbook: [Workflow design standards · Mermaid styling cookbook](../team/workflow-design.md#mermaid-styling-cookbook).

### A. Update an existing diagram

When the source Mermaid changes (e.g. a state transition added, a label tightened):

1. **Edit the Mermaid block** in the source doc. Match the cookbook — measurable predicates, role-named action nodes, white subgraph fills, classDef colours.
2. **Lint locally** to catch render errors before pushing:
   ```bash
   npm run lint:mermaid -- docs/path/to/file.md
   ```
   Or run against the whole repo: `npm run lint:mermaid`.
3. **Find the existing diagram on the master** by name. Run a `use_figma` query:
   ```js
   // skillNames: "figma-use", fileKey: y2kWMuxLwrpdaCGhVwYYYI
   const TARGET_NAME = "Order State Machine"; // exact diagram name
   const sections = figma.root.children[0].children.filter(n => n.type === "SECTION");
   const matches = [];
   for (const s of sections) {
     for (const child of s.children) {
       if (child.name === TARGET_NAME || (child.children || []).some(c => c.name === TARGET_NAME)) {
         matches.push({ sectionId: s.id, sectionName: s.name, nodeId: child.id, nodeName: child.name });
       }
     }
   }
   return { matches };
   ```
4. **Remove the old diagram nodes** from inside that Section (run a follow-up `use_figma` with the IDs returned). Keep the Section itself.
5. **Generate the new Mermaid** into the file:
   ```
   generate_diagram(
     name: "Order State Machine",
     fileKey: "y2kWMuxLwrpdaCGhVwYYYI",
     mermaidSyntax: <verbatim block from the doc, without the ```mermaid fences>,
     userIntent: "Refresh after edit in docs/modules/orders.md"
   )
   ```
6. **Move the new nodes back into the right Section** using the bracket-and-move pattern:
   ```js
   // Snapshot BEFORE generate (run as use_figma):
   const page = figma.root.children[0];
   await figma.setCurrentPageAsync(page);
   return { ids: page.children.map(n => n.id) };
   ```
   ```js
   // After generate, run use_figma with PRE_IDS captured above + TARGET_SECTION_ID:
   const PRE_IDS = ["..."]; // from snapshot
   const TARGET_SECTION_ID = "...";
   const page = figma.root.children[0];
   await figma.setCurrentPageAsync(page);
   const newNodes = page.children.filter(n => !PRE_IDS.includes(n.id));
   const target = await figma.getNodeByIdAsync(TARGET_SECTION_ID);
   for (const n of newNodes) target.appendChild(n);
   return { moved: newNodes.length };
   ```
7. **Commit the doc edit** with a message like `Update <flow> diagram (refreshed in master FigJam)`.

### B. Add a brand-new diagram

When a new feature flow joins the catalog:

1. **Write the Mermaid block** in the right source doc (same module page where the prose lives — keep source-of-truth single-page-per-feature).
2. **Lint** as above.
3. **Decide the target Section** on the master (one of the six listed earlier on this page). If the diagram doesn't fit any existing section, propose a new section in PR review before pushing.
4. **Note the Section's id** by reading `figma.root.children[0].children` once.
5. **Bracket-and-move**: snapshot pre-generate IDs → call `generate_diagram` → diff and move into target Section. Same pattern as step 6 above.
6. **Update this `diagrams.md` page** if the new diagram should appear in the per-section table.
7. **Commit** the source doc + this page in one commit.

### C. Tool unavailable today — what to do anyway

If `generate_diagram` / `use_figma` are not connected:

- Edit the Mermaid in the doc, lint with `npm run lint:mermaid`, commit. The doc lands; FigJam is stale.
- Open a follow-up issue: `Sync <diagram name> to master FigJam`.
- Next time the MCP is back, run the procedure in A or B for each pending diagram. The same Mermaid in the doc is still canonical — no rework needed.
