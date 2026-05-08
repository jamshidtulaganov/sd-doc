# SD-DOC Module Workflows Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Augment the existing `sd-main` Docusaurus pages in `sd-docs` with a `## Workflows` section per module, containing 2–4 mermaid diagrams that answer real developer questions. Phase 1 covers the 10 highest-value modules.

**Architecture:** Add a global `diagram-conventions.md` doc to `sd-docs/docs/architecture/` (PR #0). Then for each priority module, append a `## Workflows` section to `sd-docs/docs/modules/<module>.md` with: entry-points table, one `erDiagram` for the entities slot, 2–4 workflow diagrams (`sequenceDiagram` / `flowchart` / `stateDiagram-v2`), cross-module touchpoints, and a gotchas list. Each module ships in its own PR. Mermaid is rendered by `@docusaurus/theme-mermaid` (already enabled) and validated by the existing `npm run lint:mermaid` script.

**Tech Stack:** Docusaurus 3 with `@docusaurus/theme-mermaid` ^3.10.1, `@mermaid-js/mermaid-cli` (via `npm run lint:mermaid`), markdown.

**Spec:** [`superpowers/specs/2026-05-08-sd-doc-module-workflows-design.md`](../specs/2026-05-08-sd-doc-module-workflows-design.md) (in this `sd-docs` repo, alongside this plan).

**Repos in play:**
- Code being documented: `sd-main` (sibling repo at `/Users/jamshid/projects/salesdoctor/sd-main/`, `protected/modules/<name>/`)
- Where docs are written: `sd-docs` (this repo)
- Internal planning docs (this plan, the spec): `sd-docs/superpowers/`, outside the published `docs/` Docusaurus content root.

---

## File Structure

**Created:**
- `sd-docs/docs/architecture/diagram-conventions.md` — single source of truth for diagram style, actor names, and anti-patterns. Cited by every module PR review.

**Modified per module (Phase 1, in this order):**
1. `sd-docs/docs/modules/audit-adt.md` (audit only — adt is out of scope)
2. `sd-docs/docs/modules/gps.md`
3. `sd-docs/docs/modules/agents.md`
4. `sd-docs/docs/modules/clients.md`
5. `sd-docs/docs/modules/integration.md`
6. `sd-docs/docs/modules/orders.md`
7. `sd-docs/docs/modules/warehouse.md`
8. `sd-docs/docs/modules/inventory.md`
9. `sd-docs/docs/modules/finans.md`
10. `sd-docs/docs/modules/settings-access-staff.md` (settings only)

**Modified once (PR #0):**
- `sd-docs/sidebars.js` — register the new conventions doc under `System Architecture`.

**Constraint:** never modify the frontmatter or pre-existing sections of any module file. Only append a `## Workflows` section.

---

## Task 1: PR #0 — Diagram conventions doc and sidebar registration

**Files:**
- Create: `sd-docs/docs/architecture/diagram-conventions.md`
- Modify: `sd-docs/sidebars.js` (System Architecture group, add one entry)

### Step 1.1: Create a fresh branch in sd-docs

- [ ] Run:

```bash
cd /Users/jamshid/projects/salesdoctor/sd-docs
git checkout -b docs/diagram-conventions
git status
```

Expected: `On branch docs/diagram-conventions`, clean working tree.

### Step 1.2: Verify mermaid is already wired up

- [ ] Run:

```bash
grep -n "mermaid\|theme-mermaid" /Users/jamshid/projects/salesdoctor/sd-docs/docusaurus.config.js
grep "@docusaurus/theme-mermaid\|mermaid-cli" /Users/jamshid/projects/salesdoctor/sd-docs/package.json
ls /Users/jamshid/projects/salesdoctor/sd-docs/scripts/lint-mermaid.sh
```

Expected: confirms `markdown: { mermaid: true }`, `themes: ['@docusaurus/theme-mermaid']`, `@docusaurus/theme-mermaid` in deps, and the lint script exists. **If any are missing, stop and add them — that part of PR #0 was assumed done in the spec.**

### Step 1.3: Create `docs/architecture/diagram-conventions.md`

- [ ] Create the file with this exact content:

````markdown
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
| `<Module>Controller`, `<Module>Service` | Internal layers — use the **real** PHP class name (`OrdersController`, `GpsService`) |
| `DB` | MySQL. Put the table name in the arrow label (`INSERT gps_track`) |
| `Cron` | A scheduled job (`protected/components/jobs/<Job>`) |
| `External:<vendor>` | Third parties — `External:Didox`, `External:1c-eSale`, `External:Faktura-uz`, `External:Wialon` |

## Style rules

1. **One diagram answers one question.** If a diagram does not fit on a
   standard laptop screen, split it.
2. **Every arrow has a label.** Unlabelled arrows are useless to readers.
   Label with the operation, not just `→`.
3. **Reference real code identifiers** in node names: `GpsController::actionPing`,
   `OrdersService::confirm`, `protected/components/jobs/GeofenceJob`.
   Never use generic words like "process" or "validate" without the actual
   method name.
4. **Stable workflow numbering.** Sections are titled `### Workflow 1.2 — <name>`.
   Other pages cross-link to them with stable anchors:
   `[Workflow 1.2](./<module>.md#workflow-12--<slug>)`.
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
````

### Step 1.4: Register the new doc in the sidebar

- [ ] Open `sd-docs/sidebars.js`. Find the `System Architecture` items list (around line 32–58, ends with `'devops/scaling'`). After the `'security/sd-main-landmines'` line, insert:

```javascript
            'architecture/diagram-conventions',
```

The relevant chunk after edit (verify):

```javascript
            'security/auth-and-roles',
            'security/rbac',
            'security/sessions',
            'security/data-isolation',
            'security/sd-main-landmines',
            'architecture/diagram-conventions',
            'devops/deployment',
```

If the surrounding lines do not match, do **not** force the insert — open the file, read it fully, and place the new entry inside the System Architecture `items` array at the bottom of the architecture/security/devops cluster.

### Step 1.5: Run the build and the lint

- [ ] Run:

```bash
cd /Users/jamshid/projects/salesdoctor/sd-docs
npm run build
```

Expected: builds without errors. The new conventions doc appears in the build output (`Extracted ... docs`).

- [ ] Run:

```bash
npm run lint:mermaid
```

Expected: `OK    N file(s) linted clean.` The conventions doc itself contains no live mermaid blocks, but other docs may — they should still pass.

### Step 1.6: Commit

- [ ] Run:

```bash
cd /Users/jamshid/projects/salesdoctor/sd-docs
git add docs/architecture/diagram-conventions.md sidebars.js
git status
git commit -m "docs(sd-main): add diagram conventions doc"
```

Expected: one commit, two files.

### Step 1.7: Push and open PR

- [ ] Run:

```bash
git push -u origin docs/diagram-conventions
gh pr create --title "docs(sd-main): add diagram conventions" --body "$(cat <<'EOF'
## Summary
- Adds the global mermaid diagram conventions doc that every sd-main module workflow PR will cite.
- Registers it in the System Architecture sidebar group.

## Why
First of 11 PRs implementing the SD-DOC module workflows plan. This PR locks in the style guide so module PRs can be reviewed against a stable rubric. See spec at `superpowers/specs/2026-05-08-sd-doc-module-workflows-design.md` (in this repo, outside the published Docusaurus content).

## Test plan
- [x] `npm run build` passes
- [x] `npm run lint:mermaid` passes
- [x] New doc renders at `/docs/architecture/diagram-conventions` and shows up in the sidebar
EOF
)"
```

Expected: PR URL printed.

---

## Task 2: PR #1 — Audit module pilot

The pilot. This is the canonical example for Tasks 3–11. Read it once, then duplicate the shape for every subsequent module.

**Files:**
- Modify (append `## Workflows` section): `sd-docs/docs/modules/audit-adt.md`

**Precondition:** **PR #0 (Task 1) must be merged into `sd-docs` master before this task starts.** Step 2.4's subagent prompt cites `docs/architecture/diagram-conventions.md` as the style guide, and that file only exists once Task 1 ships. Verify with `git log --oneline master | head -5` and look for `add diagram conventions doc`.

**Scope clarification:** The existing file documents both `audit` and `adt`. Phase 1 covers `audit` only (per spec §6). The new workflows section is for the audit module's controllers; do not touch any pre-existing prose about `adt`.

### Step 2.1: Create the module branch in sd-docs

- [ ] Run:

```bash
cd /Users/jamshid/projects/salesdoctor/sd-docs
git checkout master
git pull --ff-only
git checkout -b docs/sd-main-workflows-audit
```

Expected: clean branch off master.

### Step 2.2: Inventory the audit module via a sonnet Explore subagent

Dispatch a sonnet `Explore` subagent with the prompt below. **Do not skip this step and write from memory.** The inventory is the source of truth for everything in the next steps.

- [ ] Dispatch with this exact prompt (substitute `<module>=audit`):

```
Inventory protected/modules/audit in /Users/jamshid/projects/salesdoctor/sd-main. Report:
1. All controllers and their action methods, with file:line for each public action
2. All models referenced (key fields and relationships)
3. Background jobs in protected/components/jobs/ that touch these models (file path)
4. API endpoints in api/, api3/, api4/ that read/write these models (route + file:line)
5. Cross-module dependencies (which other modules' models are read/written here)
6. Any DB tables created or written by this module (table names with the model that owns them)

Return as markdown. Under 400 words. Do not propose diagrams or write workflows — only inventory.
```

Save the subagent output to a scratch file outside the repo:

```bash
mkdir -p /tmp/sd-doc-pilot && cat > /tmp/sd-doc-pilot/audit-inventory.md
# (paste subagent output, save with Ctrl-D)
```

- [ ] Verify by spot-checking one cited file:line — pick any controller from section 1 and confirm the method exists.

### Step 2.3: Select 2 workflows for the audit pilot

- [ ] Read the inventory. Choose **exactly 2** workflows for the pilot (`audit` is small — 2 is right; later modules pick 2–4).

  Selection rule: each workflow must answer a distinct dev question. Write the question down before drafting.

  Likely candidates given the controller list (`AuditController`, `AuditorController`, `AuditsController`, `DashboardController`, `FacingController`, `PhotoReportController`, `PollController`, `PollResultController`, `PriceController`, `SettingsController`, `SkuController`, `StorecheckController`):
  - **Workflow 1.1** — Storecheck visit lifecycle (`StorecheckController` + `Storecheck` model). Dev question: "What happens from when an auditor opens a storecheck task to when the result lands in DB?" Diagram type: `sequenceDiagram`.
  - **Workflow 1.2** — Photo-report ingestion and review (`PhotoReportController`). Dev question: "How does a photo report move from upload → review → approval/rejection?" Diagram type: `stateDiagram-v2`.

  These are starting suggestions — adjust based on what the inventory actually shows. Record the final two workflows + diagram types in `/tmp/sd-doc-pilot/audit-decisions.md` before drafting.

### Step 2.4: Draft the `## Workflows` section via a sonnet writing subagent

- [ ] Dispatch a sonnet subagent (general-purpose) with this prompt. Inline the inventory and the decisions:

```
You are drafting the `## Workflows` section for the existing file
`/Users/jamshid/projects/salesdoctor/sd-docs/docs/modules/audit-adt.md`.

Constraints:
- Append only. Do not modify or remove any existing content.
- Cover the `audit` module only. The `adt` module is out of scope.
- Follow the page template and mermaid conventions in
  `/Users/jamshid/projects/salesdoctor/sd-docs/docs/architecture/diagram-conventions.md`
  exactly.
- Every code identifier you reference must exist. Verify by reading the
  actual PHP file before naming a method, model, or job.
- Use standard actor names (`Mobile`, `Web`, `api3`, `<Module>Controller`,
  `<Module>Service`, `DB`, `Cron`, `External:<vendor>`).
- No source-file hyperlinks. Inline code only (`AuditController::actionIndex`).

Inputs:

INVENTORY:
<paste contents of /tmp/sd-doc-pilot/audit-inventory.md>

DECISIONS:
<paste contents of /tmp/sd-doc-pilot/audit-decisions.md>

Required structure (sections, in this order):
1. ### Entry points  — table of every public web/mobile/cron entry into the audit module
2. ### Domain entities — one `erDiagram` covering only the 3–6 models that appear in the two workflows below
3. ### Workflow 1.1 — <name>  — short prose, then one mermaid block of the chosen type
4. ### Workflow 1.2 — <name>  — short prose, then one mermaid block of the chosen type
5. ### Cross-module touchpoints — bullet list (Reads / Writes / APIs)
6. ### Gotchas — bullet list, or one bullet "none known"

Output the complete `## Workflows` section as a single fenced markdown
block, ready for me to append to the existing file. Nothing else.
```

- [ ] Save the subagent output to `/tmp/sd-doc-pilot/audit-workflows.md`.

### Step 2.5: Append the section to the module page

- [ ] Read the current end of the existing file:

```bash
tail -30 /Users/jamshid/projects/salesdoctor/sd-docs/docs/modules/audit-adt.md
```

- [ ] Open `audit-adt.md` in an editor and paste the contents of `/tmp/sd-doc-pilot/audit-workflows.md` at the end of the file as a new top-level section (starting with `## Workflows`). Ensure there is exactly one blank line between the previous content and the new section. **Do not** use shell append (`>>`) — it risks corrupting the file if there is no trailing newline. If using a Claude Code agent, use the Edit tool with the last existing line as `old_string` anchor.

### Step 2.6: Polish — verify every reference

- [ ] For every controller method, model, job, and API route mentioned in the new section, run:

```bash
grep -rn "<identifier>" /Users/jamshid/projects/salesdoctor/sd-main/protected/modules/audit/
```

Anything that does not return a match is a fabricated reference — fix or remove before continuing.

- [ ] Read the prose with adversarial eyes. Cut any sentence that:
  - Restates the diagram in words
  - Uses the words "leverage", "robust", "comprehensive", or other AI filler
  - Describes what an arrow already shows

### Step 2.7: Lint mermaid and build

- [ ] Run:

```bash
cd /Users/jamshid/projects/salesdoctor/sd-docs
npm run lint:mermaid -- docs/modules/audit-adt.md
```

Expected: `OK    1 file(s) linted clean.`

If parser errors: read the error, fix the offending block, re-run. The most common errors are: unclosed quotes in node labels, special chars (`(`, `)`) inside labels without quoting, and missing `participant` declarations in sequence diagrams.

- [ ] Run:

```bash
npm run build
```

Expected: build succeeds.

### Step 2.8: Visually verify

- [ ] Run:

```bash
cd /Users/jamshid/projects/salesdoctor/sd-docs
npm run start
```

Open `http://localhost:3000/docs/modules/audit-adt` in a browser. Confirm:
- The `## Workflows` section appears at the bottom (existing content above it is unchanged).
- The `erDiagram` and both workflow diagrams render visually (not just as text).
- Page navigation still works (the sidebar entry points to the same page).

Stop the dev server when done (`Ctrl-C`).

### Step 2.9: Commit

- [ ] Run:

```bash
cd /Users/jamshid/projects/salesdoctor/sd-docs
git add docs/modules/audit-adt.md
git status
git commit -m "docs(sd-main): add workflows to audit module"
```

Expected: one commit, one file changed (only `audit-adt.md`).

### Step 2.10: Push and open PR

- [ ] Run:

```bash
git push -u origin docs/sd-main-workflows-audit
gh pr create --title "docs(sd-main): add workflows to audit" --body "$(cat <<'EOF'
## Summary
- Pilot of the per-module `## Workflows` section. Adds entry-points table, `erDiagram`, two workflow diagrams, cross-module touchpoints, and gotchas to the audit module page.
- Validates the template that Tasks 3–10 will replicate for the remaining 9 priority modules.

## Acceptance criteria (from spec §9)
- [x] 2 workflows, each answering a distinct dev question
- [x] Every diagram references real code identifiers, verified to exist
- [x] Entry points table covers every public controller action of `audit`
- [x] `erDiagram` covers 3–6 entities actually appearing in the workflows
- [x] Cross-module touchpoints lists every other module mentioned
- [x] Gotchas section has at least one item (or "none known" stated explicitly)
- [x] All mermaid blocks pass `npm run lint:mermaid`
- [x] `npm run build` succeeds
- [x] Adheres to `docs/architecture/diagram-conventions.md`

## Test plan
- [x] Mermaid lint clean for the modified file
- [x] Local build succeeds
- [x] Manual visual check at `http://localhost:3000/docs/modules/audit-adt`
EOF
)"
```

Expected: PR URL printed. Wait for review before starting Task 3.

---

## Tasks 3–11: Remaining 9 priority modules

Each follows Task 2 verbatim. The only changes are the module name, the file modified, and the workflow count.

**Substitution table:**

| Task | Module | File modified | Branch | Workflow count |
|---|---|---|---|---|
| 3 | `gps3` | `sd-docs/docs/modules/gps.md` | `docs/sd-main-workflows-gps3` | 3–4 |
| 4 | `agents` | `sd-docs/docs/modules/agents.md` | `docs/sd-main-workflows-agents` | 3–4 |
| 5 | `clients` | `sd-docs/docs/modules/clients.md` | `docs/sd-main-workflows-clients` | 2–3 |
| 6 | `integration` | `sd-docs/docs/modules/integration.md` | `docs/sd-main-workflows-integration` | 3–4 |
| 7 | `orders` | `sd-docs/docs/modules/orders.md` | `docs/sd-main-workflows-orders` | 4 |
| 8 | `warehouse` | `sd-docs/docs/modules/warehouse.md` | `docs/sd-main-workflows-warehouse` | 3 |
| 9 | `inventory` | `sd-docs/docs/modules/inventory.md` | `docs/sd-main-workflows-inventory` | 2 |
| 10 | `finans` | `sd-docs/docs/modules/finans.md` | `docs/sd-main-workflows-finans` | 3 |
| 11 | `settings` | `sd-docs/docs/modules/settings-access-staff.md` | `docs/sd-main-workflows-settings` | 2–3 |

**Per-task substitution rules:**

1. The existing file may cover more than the Phase-1 module (e.g., `gps.md` covers all three GPS generations; `settings-access-staff.md` covers settings + access + staff). Document the **Phase-1 module only**. Do not touch other module content in the file. State this explicitly in the PR description.
2. Workflow count drives subagent prompt: in Step 2.3, ask for the substitution-table number for that module (e.g., "Choose exactly 4 workflows" for `orders`).
3. After Task 7 (`orders`), revisit `gps3` and `agents` PRs — the larger `orders` workflows often surface cross-module references that retroactively need links from `gps3` (visit/GPS) and `agents` (route/plan). Add follow-up commits if so.

**Steps 2.1 through 2.10 apply identically with `<module>=<task module>`.** Re-read Task 2 each time — do not work from memory. The cross-module touchpoints section especially benefits from a fresh read once previous modules have shipped.

### Task-completion gate

After each module PR merges, before starting the next:

- [ ] Confirm CI passed on merge.
- [ ] Skim the merged page on the deployed site to catch rendering issues that local build missed.
- [ ] If anything in the conventions doc needs sharpening based on what you learned, open a small follow-up PR against `docs/architecture/diagram-conventions.md` *before* starting the next module — never let drift accumulate across multiple modules.

---

## Self-review checklist (run before declaring Phase 1 done)

- [ ] All 11 PRs (PR #0 + 10 modules) merged into `sd-docs` main.
- [ ] `npm run lint:mermaid` is part of CI in `sd-docs` (verify in `.github/workflows/`).
- [ ] `docs/architecture/diagram-conventions.md` is the cited reference in every module's `## Workflows` review thread (or no reviewer needed it because the work matched the doc on first read — that is the goal).
- [ ] The 10 module pages collectively answer "how does X work" for any of the priority modules from one page each, without opening Figma.
- [ ] No module PR exceeds 4 workflows. If one did, it was split or flagged.
- [ ] Phase 2 module list (12 modules in spec §6) is captured as a follow-up issue in `sd-docs` so the work is not lost.

---

## Out of scope (do NOT do in this plan)

- Client-facing FigJam diagrams.
- Workflow sections for `sd-cs`, `sd-billing`, `manager-ai` doc sections.
- ru/uz translations of new workflow content.
- Source-file hyperlinks from prose to `sd-main`.
- Per-actor color theming in mermaid.
- API-module workflow sections (`api`, `api2`, `api3`, `api4`).
- Workflow sections for the 12 excluded modules in spec §6.
