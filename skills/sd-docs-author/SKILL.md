---
name: sd-docs-author
description: Use whenever the user asks to write, update, or extend documentation for the SalesDoctor / Novus Distribution CRM. Triggers include "developer docs", "client docs", "module reference", "API reference", "ADR", or any request to add a page to /sd-docs/. Produces Docusaurus-ready Markdown across EN/RU/UZ locales.
---

# Skill — SalesDoctor docs author

Use this skill when writing or updating documentation in the `sd-docs/`
project.

## Output rules

1. **Always Markdown with frontmatter**:
   ```md
   ---
   sidebar_position: <N>
   title: <human title>
   ---
   ```
2. **No emojis** unless the user asks. Use ✅ / ❌ for short rule lists only.
3. **Keep paragraphs short** (≤ 4 sentences) and break long lists into
   tables.
4. **Mermaid is allowed** — it renders in Docusaurus. Wrap with
   ` ```mermaid ` fences.
5. **Cross-link extensively**:
   - Developer ↔ Client docs use absolute paths starting with `/docs/` or
     `/client/`.
   - Within the same instance, use relative `./` paths.
6. **Code blocks** have language tags (`php`, `bash`, `sql`, `nginx`,
   `yaml`, `dockerfile`, `json`).
7. **Tables** for any pairwise data.

## i18n flow

1. Write the canonical EN page under `docs/` or `client-docs/`.
2. Mirror the file path under
   `i18n/<locale>/docusaurus-plugin-content-docs/current/`
   (or `…-client/current/` for the client instance).
3. Translate the body, keep the **same frontmatter `slug` / id**.
4. Translate the sidebar labels in
   `i18n/<locale>/docusaurus-plugin-content-docs/current.json` (or
   `code.json`).

## Page templates

### Module reference

```md
---
sidebar_position: <n>
title: <module>
---

# `<module>` module
<one-line purpose>

## Folder
…

## Key entities
| Entity | Model | Notes |

## Controllers
| Controller | Purpose |

## API
| Endpoint | Purpose |

## See also
- ...
```

### API endpoint

```md
## `<METHOD> /path`
<purpose>

### Request
- Headers
- Body

### Response
- 200
- 4xx errors

### Example
```

### ADR

```md
# ADR <NNNN> — <title>
- Status: Accepted | Proposed | Deprecated
- Date: YYYY-MM-DD
- Deciders: ...

## Context
## Decision
## Consequences
```

## Diagrams

Canonical FigJam: `https://www.figma.com/board/KH7PL28JoBs1GOvf6MxkJj`.
Either:
- Reference exported PNG at `/diagrams/<name>.png`, or
- Inline Mermaid (preferred for small ones).

## Verification before "done"

1. Front-matter parses (no stray `---`).
2. All relative links resolve (the target `.md` exists).
3. Sidebar entry exists in `sidebars.js` or `sidebarsClient.js`.
4. RU and UZ counterparts exist (even if body is `<!-- TODO -->`).
