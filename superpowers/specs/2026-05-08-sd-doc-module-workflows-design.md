# SD-DOC: Developer-Facing Module Workflows (Phase 1)

**Date:** 2026-05-08
**Owner:** Jamshid
**Status:** Approved design, ready for implementation plan
**Repo touched:** `sd-docs` (this repo — Docusaurus site)
**Source-of-truth code repo:** `sd-main` (sibling at `/Users/jamshid/projects/salesdoctor/sd-main/` — the code being documented)
**This spec lives in:** `sd-docs/superpowers/specs/`, outside the published `docs/` Docusaurus content root so it does not appear on the deployed site.

---

## 1. Goal

Add developer-facing **workflow diagrams** to the existing `sd-docs` Docusaurus
site so engineers, QA, and PMs can answer questions like:

- "How does GPS work end-to-end?"
- "How does agent-paket flow through orders?"
- "What is the audit module and what does it track?"
- "Which integrations exist and how do they connect?"

Today the `sd-main` section of `sd-docs` has descriptive module pages
(`docs/modules/<name>.md`) with feature tables and entity lists, but **no
workflow diagrams**. They link out to FigJam in places, which means visual
flows live outside version control and drift from code.

This Phase 1 closes that gap for the **10 highest-value modules** with
inline mermaid diagrams. A later Phase 2 covers the long tail. A separate
client-facing track (FigJam, business-question framing) is out of scope here
and will be planned independently.

## 2. Audience and tone

- **Audience:** backend engineers, QA, PM. Not end users.
- **Tone:** technical and direct. Reference real controller methods, model
  classes, file paths, table names. No simplified business language.

## 3. Output and location

- **Format:** Mermaid in markdown, embedded directly in module pages.
- **Location:** augment existing `sd-docs/docs/modules/<name>.md` files.
  Do not create parallel files. Do not change the sidebar.
- **Scope:** only the **sd-main** section of `sd-docs`. Sibling sections
  (`sd-cs`, `sd-billing`, `manager-ai`) are out of scope.
- **Renderer:** Docusaurus mermaid theme (`@docusaurus/theme-mermaid`).
  Already enabled in `sd-docs/docusaurus.config.js`
  (`markdown: { mermaid: true }`, `themes: ['@docusaurus/theme-mermaid']`,
  theme `{ light: 'neutral', dark: 'dark' }`). No setup needed.
- **Lint:** `sd-docs/scripts/lint-mermaid.sh` (`npm run lint:mermaid`)
  already exists. It renders every ` ```mermaid ` block via
  `@mermaid-js/mermaid-cli` and fails on parser errors. Used as the
  automated quality gate in Steps 4 and 5 of the authoring loop, and as
  a CI check.

## 4. Per-module page template

Append the following section to each priority module page. Existing content
(frontmatter, intro, features table, folder layout, entities) stays as-is.

```markdown
## Workflows

### Entry points
| Trigger | Controller / Action / Job | Notes |
|---|---|---|
| <web/mobile/cron/queue> | `<Class>::<method>` | <one-line context> |

### Domain entities
<one mermaid `erDiagram` showing 3-6 core models in workflows below>

### Workflow 1.1 — <business name>
<1-2 sentence what/why>
<one mermaid diagram — type chosen per Section 5>

### Workflow 1.2 — <next>
...

### Cross-module touchpoints
- Reads: <module>.<Model> (<purpose>)
- Writes: <module>.<Model> (<purpose>)
- APIs: <api1/2/3/4>/<route>

### Gotchas
- <known landmines, deprecated paths, common mistakes>
```

**Workflow count per module:** 2-4. More than 4 indicates the module is
conceptually overloaded — split or flag.

## 5. Mermaid diagram conventions

Four diagram types cover all flows. Pick by the question being answered.

| Type | Use for | Example question |
|---|---|---|
| `sequenceDiagram` | Request flows over time | "How does data move from mobile to DB?" |
| `flowchart TD` | Branching business rules | "What happens if the discount exceeds limit?" |
| `stateDiagram-v2` | Entity lifecycle | "What statuses can an Order be in?" |
| `erDiagram` | Entity relationships (one per module, in Domain entities slot) | "How are these models related?" |

**Standard actor names** (used identically across all modules so diagrams
are comparable):

- `Mobile` — agent mobile app via api3
- `Web` — browser via web controllers
- `api3`, `api4`, `api2`, `api` — public API entry points
- `<Module>Controller`, `<Module>Service` — internal layers (real class names)
- `DB` — MySQL, with table name in arrow labels (`INSERT gps_track`)
- `Cron` — scheduled job (`protected/components/jobs/<Job>`)
- `External:<vendor>` — third parties (`External:Didox`, `External:1c-eSale`)

**Style rules:**

- One diagram answers one question. Doesn't fit on a laptop screen → split.
- Every arrow has a label (the operation, not just "→").
- Reference real code identifiers in node names (`GpsController::actionPing`,
  not "the GPS endpoint").
- Workflow numbering is stable: `### Workflow 1.2 — <name>`. Cross-references
  use `[Workflow 1.2](#workflow-12--<slug>)`.
- Code mentioned in prose appears as inline code with the real identifier
  (`GpsController::actionPing`, `protected/components/jobs/GeofenceJob`). No
  hyperlinks to source files in v1 — sd-docs and sd-main are separate repos
  and there is no stable public source URL. Phase 2 can revisit.
- No color theming in v1. Default Docusaurus mermaid theme.

**Anti-patterns rejected in review:**

- "God diagrams" attempting to show the whole module — must be split per question.
- Generic labels (`save data`, `process`, `validate`) — must reference the
  actual function, table, or event.
- Diagrams that restate the entity table without showing motion (time,
  decision, or state change).
- Off-screen sprawl on standard laptop width.

**Single source of truth:** all of the above is captured in
`sd-docs/docs/architecture/diagram-conventions.md` (created in PR #0).
Module PRs link to it; reviewers cite it for nits instead of relitigating
style per-PR.

## 6. Phase 1 module list (priority order)

10 modules ordered by attack sequence — start small to validate the
template, then tackle the modules explicitly named by stakeholder, then
the largest, ending with cross-cutting modules whose diagrams reference
others.

| # | Module | Rationale | Est. workflows |
|---|---|---|---|
| 1 | `audit` | Pilot — small, well-bounded, validates template | 2 |
| 2 | `gps3` | Stakeholder priority; real-time + ingest patterns | 3-4 |
| 3 | `agents` | Includes agent-paket, routes, KPIs; entity-rich pattern | 3-4 |
| 4 | `clients` | Tightly coupled with agents; sets cross-module reference style | 2-3 |
| 5 | `integration` | Stakeholder priority; sets external-systems pattern | 3-4 |
| 6 | `orders` | Largest; do once template is fluent | 4 |
| 7 | `warehouse` | Stock movements, returns, replacements | 3 |
| 8 | `inventory` | Inventarizatsiya | 2 |
| 9 | `finans` | Akt-sverka, payments, cash transfer | 3 |
| 10 | `settings` | Cross-cutting (KPI, bulk, prices) — last | 2-3 |

Total modules in `protected/modules/`: 38. Phase 1 covers 10 of them.
The remaining 28 are categorised as follows.

**Phase 2 candidates** (12) — non-trivial flows worth documenting later:
`access`, `dashboard`, `report`, `sms`, `staff`, `stock`, `store`,
`onlineOrder`, `sync`, `payment`, `pay`, `markirovka`.

**API modules** (4) — `api`, `api2`, `api3`, `api4`. Already covered by the
existing `docs/api/*` pages (`api-v1`, `api-v2`, `api-v3-mobile`,
`api-v4-online`). A workflow section per API module is **out of scope** for
this Phase 1; individual endpoints are referenced from module workflows
where relevant.

**Excluded entirely** (12) — legacy, thin, or replaced: `gps`, `gps2`,
`adt`, `aidesign`, `neakb`, `partners`, `planning`, `rating`, `team`, `vs`,
`doctor`, `manager`.

## 7. PR strategy

- **PR #0 — Setup** (lands first, blocks all module PRs)
  - Mermaid renderer + lint already wired up in sd-docs (verified). No
    config or dependency changes needed.
  - Create `sd-docs/docs/architecture/diagram-conventions.md` from Section 5.
  - Register the new doc in `sd-docs/sidebars.js` under `System Architecture`.
  - Run `npm run build` and `npm run lint:mermaid` to confirm the new doc
    builds and any sample mermaid in it passes.
  - Commit: `docs(sd-main): add diagram conventions doc`.

- **PR #1..#10 — One PR per module**, in the order in Section 6.
  - ~150-300 line diff each.
  - Title pattern: `docs(sd-main): add workflows to <module>`.
  - Each PR ships independently — no batch merges. Lets reviewers catch
    template drift early.

## 8. Authoring loop per module

Repeatable 5-step process per module. Most steps delegated to sonnet
subagents per project memory (reserve opus for strategic review). Roughly
~90 minutes per module of human time.

**Step 1 — Inventory** (sonnet Explore subagent, ~10 min, parallelizable
across modules)

Dispatch with this prompt template:

> Inventory `protected/modules/<module>` in this sd-main repo. Report:
> 1. All controllers and their action methods (file:line)
> 2. All models referenced (key fields)
> 3. Background jobs in `protected/components/jobs/` that touch these models
> 4. API endpoints in `api/`, `api3/`, `api4/` that read/write these models
> 5. Cross-module dependencies (which other modules' models are read/written here)
> Return as markdown. Under 400 words.

**Step 2 — Workflow selection** (human, ~5 min)

Read inventory. Pick 2-4 flows worth answering. Choose diagram type per
flow per Section 5.

**Step 3 — Drafting** (sonnet writing subagent, ~20 min)

Dispatch with the inventory output, selected workflow names, chosen diagram
types, and the page template (Section 4) + conventions (Section 5). Instruct
the subagent to verify every method reference by reading the actual file.
Output: complete `## Workflows` markdown section.

**Step 4 — Polish** (human, ~15 min)

- Verify every controller/method exists at the cited path.
- Tighten prose; cut AI filler.
- Add cross-module links to sibling module pages.
- Run `npm run lint:mermaid -- docs/modules/<name>.md` to confirm every
  block parses cleanly. Faster than mermaid.live, and the same check CI
  enforces.

**Step 5 — Local verification + PR** (~10 min)

- `npm run build` in `sd-docs/` (full site build).
- `npm run lint:mermaid` (all mermaid blocks site-wide).
- View page locally, confirm rendered diagrams look right.
- Commit + push: one commit per module.

## 9. Acceptance criteria (per module page)

A module PR is reviewable only if all of the following hold:

- [ ] 2-4 workflows, each answering a distinct dev question
- [ ] Every diagram references real code identifiers, verified to exist at
      the cited file:line
- [ ] Entry points table covers every public controller action of the module
- [ ] `erDiagram` covers the 3-6 entities actually appearing in workflows
      (not all module entities)
- [ ] Cross-module touchpoints section lists every other module mentioned
      in any diagram
- [ ] Gotchas section has at least one item, or explicitly states "none known"
- [ ] All mermaid blocks pass `npm run lint:mermaid` (and the full
      `npm run build` succeeds)
- [ ] Adheres to `docs/architecture/diagram-conventions.md`

## 10. Effort and timeline

- PR #0 (setup): ~1 hour
- PR #1..#10 (modules): ~90 min each → ~15 hours
- **Total:** ~16 hours of focused work

Realistic calendars:

- Compressed: 3-4 working days
- Spread: 2 weeks at 1-2 modules/day

## 11. Out of scope

- Client-facing FigJam diagrams (separate later phase, business-question framing)
- `sd-cs`, `sd-billing`, `manager-ai` sections of `sd-docs`
- Translating any docs to ru/uz (i18n stays English-only for v1)
- Per-actor color theming in mermaid
- Workflow diagrams for the 28 non-Phase-1 modules listed in Section 6
- Hyperlinks from prose to source files (decided in Section 5)

## 12. Risks and mitigations

| Risk | Mitigation |
|---|---|
| Mermaid renderer drift or theme regression | Already enabled and version-pinned (`^3.10.1`); CI runs `lint:mermaid` so any regression fails the build before merge |
| AI-drafted diagrams cite methods that don't exist | Step 4 polish requires human verification against code |
| Template drift across module PRs | Reviewers cite `diagram-conventions.md`; one-PR-per-module catches drift early |
| `orders` module too large for the template | Tackled at position 6, after template proven on 5 simpler modules; can split into two pages if needed |
| Gotchas section empty / superficial | "None known" explicitly required if empty; reviewers prompt for at least one |

## 13. Success metric

Phase 1 is done when:

1. PR #0 merged.
2. All 10 module pages have a `## Workflows` section meeting Section 9 criteria.
3. `docs/architecture/diagram-conventions.md` is the cited source for any
   mermaid styling question.
4. A new dev can answer "how does X work?" for any of the 10 modules from
   their `sd-docs` page alone, without opening Figma or asking a teammate.
