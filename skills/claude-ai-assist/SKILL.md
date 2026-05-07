---
name: claude-ai-assist
description: Use whenever the user wants Claude (or another AI assistant) to help with SalesDoctor work — code, docs, diagrams, QA, PM artefacts. Defines the collaboration loop, prompt patterns, MCP usage, and verification steps. Trigger on phrases like "use Claude", "AI workflow", "how should I prompt", or whenever planning a multi-step AI-assisted task.
---

# Skill — Claude AI assist

Board diagram: **Workflow — Claude AI Assist** in FigJam:
`https://www.figma.com/board/KH7PL28JoBs1GOvf6MxkJj`.

## Loop

```
Goal → Clarify → Plan → Explore → Execute → Verify → Output
```

1. **Clarify** with `AskUserQuestion` before kicking off non-trivial work
   (audience, format, depth, locale, output location).
2. **Plan** with `TaskCreate` — break work into 4–8 visible tasks the user
   can follow. Mark `in_progress` BEFORE work, `completed` after.
3. **Explore** the codebase / files first; don't hallucinate structure.
4. **Execute** in batches — multiple independent tool calls in one message
   when possible (parallelism > sequence).
5. **Verify** — read diffs, run builds / linters, check links.
6. **Output** — give the user `computer://` links to final files in their
   selected folder.

## When to use which MCP

| Task | Tool |
|------|------|
| Generate diagrams (architecture, ERD, flows) | Figma MCP `generate_diagram` |
| Edit existing FigJam file | Figma MCP `use_figma` with `fileKey` |
| Get screenshots / frames | Figma MCP `get_design_context` / `get_screenshot` |
| Write files in user's folder | `Write` / `Edit` (after `request_cowork_directory`) |
| Run shell commands | `mcp__workspace__bash` |
| Web research | `WebSearch` / `WebFetch` |
| Long-running parallel jobs | `TaskCreate` + multiple sub-agents via `Agent` |

## Prompt patterns that work for SalesDoctor

- **"Write the developer page for module X"** → use `sd-docs-author` skill.
- **"Generate diagram of order lifecycle"** → `generate_diagram` with
  `sequenceDiagram`, drop into the canonical FigJam (`fileKey`).
- **"Audit modules for obsolete code"** → grep `*.obsolete`, summarise per
  module.
- **"Translate this page into RU/UZ"** → keep frontmatter + slug, translate
  body only.

## Anti-patterns

- ❌ Asking Claude to do private/financial actions (move money, change
  access controls) — Claude refuses by policy. Do those by hand.
- ❌ Long single mega-prompts. Break work into tasks.
- ❌ Trusting un-verified summaries — read the diff before commit.
- ❌ Embedding secrets in prompts. Use environment files instead.

## Verification checklist

- Files Claude wrote are in the user's folder, not the sandbox.
- `computer://` links provided for every artefact.
- Build / lint passes (`npm run build` for sd-docs).
- Mermaid blocks render (no parser errors).
- All FigJam links use `fileKey=KH7PL28JoBs1GOvf6MxkJj`.

## Useful one-liners

```bash
# Find every obsolete file:
find protected -name "*.obsolete"

# Count modules:
ls protected/modules | wc -l

# Translation skeleton for a page:
mkdir -p i18n/ru/docusaurus-plugin-content-docs/current/<path>
cp docs/<path>/<page>.md i18n/ru/docusaurus-plugin-content-docs/current/<path>/<page>.md
```
