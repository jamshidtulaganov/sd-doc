---
name: frontend-onboarding-author
description: Use when writing or updating developer documentation for the SalesDoctor frontend — onboarding, conventions, recipes, page-layout / wireframe references. Scope is strictly wireframe and page-structure level (the "frame"); never expose detailed component designs, visual tokens, or design-system specs the team hasn't agreed on. Triggers include "frontend onboarding", "frontend conventions", "adding a screen", "page layout", "wireframes", "UI structure", any request to write a developer doc that touches the UI layer.
---

# Skill — Frontend onboarding docs author

This skill is the **rules of engagement** for writing developer-facing
documentation about the SalesDoctor frontend. It is more constrained
than the general [`sd-docs-author`](../sd-docs-author/SKILL.md) skill:
the constraint is the whole point.

Use this skill on top of `sd-docs-author` when the page is in
`docs/frontend/` or `docs/ui/`, or when the audience is "a new
frontend developer".

## The two scope rules (non-negotiable)

### Rule 1 — Frame, not design

Document the **frame** (layout, page structure, wireframe) — never
the **design** (visual styling, branded look, polished components).

| ✅ In scope | ❌ Out of scope |
|------------|----------------|
| ASCII page-layout diagrams | Hex codes, brand colours |
| Wireframe screenshots from `static/wireframes/extracted-from-figma/` | Polished mockups from a non-public Figma |
| "Where the breadcrumbs go" | "What the breadcrumb font weight is" |
| "A list page has filters above the table" | "Filter chips have 8 px corner radius" |
| Component **placement** within a layout | Component **anatomy** (named visual parts) |
| State of the page (list / form / modal) | Visual state matrix (default/hover/focus/disabled/loading) |
| Role-driven sidebar entries | Sidebar icon library |
| Yii view path that renders the layout | A bespoke design-system token table |

If you find yourself reaching for a hex code, a font scale, a spacing
scale, an accessibility WCAG number, or a Storybook-style component
anatomy diagram — stop. That's design, not frame. Either:

- Mark it as **"Open questions / TODO"** and move on, or
- Replace it with a layout-level statement (e.g. "primary action
  button is top-right of the page header" — placement, not styling).

### Rule 2 — No detailed components

The team does **not** want a component-level design system exposed
in these docs (whether because the system is incomplete, proprietary,
or not yet agreed). Do not write:

- Per-component pages with anatomy + props + states + a11y + do/don't.
- Token foundations (colors / typography / spacing / iconography).
- Component inventory tables that imply a curated library exists.

Replace component pages with **page-layout patterns**:

- Instead of "Button component" → write "Primary action placement
  in a list page".
- Instead of "Modal component" → write "When to put an action in a
  modal vs a full page".
- Instead of "Filter chip component" → write "Filter bar layout"
  + "Side filter rail layout" — patterns, not chips.

## Audience and tone

- **Audience**: a senior frontend dev with general web experience,
  no prior Yii / no Russian. Going from clone to first PR in one week.
- **Tone**: terse, declarative, second person. Imperatives over
  passive voice ("Put the file under `js/<area>.js`", not "Files
  should be placed under `js/<area>.js`").
- **No marketing**. No "delightful" / "intuitive" / "robust".
- **No empty headings**. If a section has nothing to say yet, omit
  it; don't write "TBD".

## Grounding and citation

This is how the Phase-A pages were written and is the standard going
forward.

1. **Every fact cites a file**. If you write "models live under
   `protected/models/`", the page must link to or reference
   [Project structure](../../docs/project/structure.md). If you can't
   cite a file, you can't write the claim.
2. **Don't invent**. If a convention isn't already documented or
   visible in the codebase, do not put it in the docs. List it
   under "Open questions / TODO" so a teammate confirms before
   the doc becomes authoritative.
3. **Never say "best practice"** without a project-internal source.
   Generic web wisdom belongs on MDN, not here.
4. **Mirror existing language**. If `protected/views/orders/list.php`
   is called "the list view" elsewhere, call it that — don't invent
   "index page" / "table view" / "browse screen".
5. **Cite line numbers** when a claim is non-obvious or fragile
   (`docs/frontend/overview.md:13`).

## Page structure

Every developer doc in `docs/frontend/` and `docs/ui/` follows the
same skeleton:

```md
---
sidebar_position: <N>
title: <human title>
audience: <who this is for>
summary: <one sentence>
topics: [tag1, tag2]
---

# <title>

<one paragraph: what this page is, who reads it, what it isn't>

## <Sections — see "section playbook" below>

## Open questions / TODO

<unresolved items, marked with the team-member to ask>
```

### Section playbook by page type

| Page type | Required sections (in this order) |
|-----------|----------------------------------|
| Onboarding-style ("Getting started", "Adding a screen") | Prerequisites · Recipe steps · Smoke-test checklist · Where to go next · Open questions |
| Conventions / reference ("Conventions", "Yii views") | Where things live (table) · Naming · When to use what · What you must not touch · Open questions |
| Page-layout / wireframe ("Page layout", "Tables", "Forms") | What this layout is (one line) · ASCII layout · Rules · When to use a different layout · Open questions |
| Module reference (existing template — see `sd-docs-author`) | Folder · Key entities · Controllers · API · See also |

## Wireframe handling

- Embed images from `static/wireframes/extracted-from-figma/` only —
  never reference a path under `static/wireframes/` that the file
  manifest doesn't include. Broken-image references are worse than
  no image (they were one of the original audit findings).
- Caption every embedded wireframe with: **role · action · which
  Yii view renders it**.
- Group wireframes by module, not by component type.
- Note staleness explicitly: the source file is `SD-Web-old.fig` —
  product UI may have drifted. When in doubt, defer to the running
  app and mark the wireframe page with a "last verified" date.

## ASCII layouts

Pure ASCII is the default for frame diagrams (cheap, version-able,
diffs cleanly). Conventions:

- Box-drawing characters: `┌ ─ ┐ │ └ ┘ ├ ┤ ┬ ┴ ┼`.
- Wrap in a fenced code block (no language tag).
- Annotate with placeholder content (`[Search ]`, `Total: 1 234`,
  `▣ Status`, `[Apply]`) — readers should be able to imagine the
  populated screen.
- Width: ≤ 80 columns. Mobile / narrow renderings stretch.

## What NOT to write (reference list)

If a teammate asks for any of the below, redirect — these belong
to a future, separately-decided design system:

- Color tokens, palette pages, contrast guidelines.
- Typography scales, font specimens.
- Spacing scales, grid system specs.
- Iconography library or sprite documentation.
- Per-component anatomy + state matrix + accessibility checklists.
- Storybook-style live previews.
- Storybook / MDX live components.
- Animation / motion specs.

The line: if it would be in a Figma file, it's design. If it would
be in a code-tour for a new dev, it's frame.

## i18n flow

(Same as the parent [`sd-docs-author`](../sd-docs-author/SKILL.md)
skill.) Locales are `en` (default for these dev docs), `ru`, `uz`.
Frontend onboarding docs may ship EN-only first; mirror to RU/UZ
when the content is stable. Mark untranslated pages with a
`<!-- TODO: translate -->` comment at the top of the locale file.

## Verification before "done"

Run this checklist before marking a page complete:

1. **Frontmatter parses** — no stray `---`, all required fields.
2. **All relative links resolve** — the target `.md` exists. Run
   the dev server and confirm zero "Markdown link couldn't be
   resolved" warnings for the new page.
3. **No design leaks** — grep your draft for hex codes, `px`
   measurements, font names, `WCAG`, `aria-*` (unless quoting an
   existing role-gating example), Storybook references. If any
   appear, justify with a file citation or remove.
4. **No invented conventions** — every "do this / don't do that"
   has a citation to an existing doc, code path, or is in
   "Open questions".
5. **Smoke-test the docs site** — `npm run start`, navigate to the
   new page, confirm it renders, sidebar entry exists, and the
   page works in mobile-narrow rendering.
6. **Sidebar entry** — added to `sidebars.js` under the right
   category.
7. **No emojis** in body text. ✅ / ❌ tolerated in short rule
   tables only.

## Templates

### Onboarding-style page

```md
---
sidebar_position: <n>
title: <verb> <noun>
audience: <e.g. "Frontend engineers shipping their first end-to-end change">
summary: <one sentence>
topics: [frontend, recipes]
---

# <title>

<one-paragraph framing — what / who / what this isn't>

## Decide first

| Question | Default answer |
|----------|----------------|

## The recipe

### 1. <step>
### 2. <step>
…

## Checklist for the PR

- [ ] …

## Open questions / TODO

- **<title>** — <what's unconfirmed, who to ask>
```

### Page-layout / wireframe page

```md
---
sidebar_position: <n>
title: <layout name>
audience: Frontend engineers
summary: <one sentence>
topics: [ui, layout]
---

# <title>

<one paragraph: when you'd reach for this layout>

## Layout

```
<ASCII diagram>
```

## Rules

- <placement / behaviour rule>
- <placement / behaviour rule>

## When not to use this

- <case → alternative layout>

## Open questions / TODO

- …
```

### Conventions / reference page

```md
---
sidebar_position: <n>
title: <area> conventions
audience: Frontend engineers
summary: <one sentence>
topics: [frontend, conventions]
---

# <title>

<one-paragraph framing>

## Where things live

| If you're adding… | Put it under… |
|--------|---------|

## Naming

…

## When to use what

…

## What you must not touch

| Path | Why |

## Open questions / TODO

- …
```

## Anti-patterns (don't do these)

- **The empty design system** — a page that lists "Button / Input /
  Card / Modal" but has nothing concrete to say about each. Either
  document each placement-level rule or delete the page.
- **The TBD wall** — a page where every section is "TODO". Better
  to omit the page until you can write at least one section
  authoritatively.
- **The component museum** — exhaustive prop tables for every
  reusable widget. We don't have a curated library, and pretending
  we do creates an obligation we can't meet.
- **Visual aspiration** — describing what we *want* the design to be.
  Document the frame as it exists; aspiration is a separate document
  in a different folder.
- **Cross-cite without confirming** — copying a path or convention
  from another doc that itself wasn't grounded. Re-verify in the
  source codebase or mark TODO.

## See also

- [`sd-docs-author`](../sd-docs-author/SKILL.md) — the parent skill
  with general formatting / i18n / cross-link rules. Always read
  alongside.
- [`diagram-author`](../diagram-author/SKILL.md) — for any FigJam
  diagram referenced from these pages.
- [Team · onboarding](../../docs/team/onboarding.md) — the audience
  these docs serve.
