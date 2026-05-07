# Wireframes

This folder is the home for **page-layout references**. Three kinds of
content live here:

## 1. `extracted-from-figma/` — 60 page screenshots from `SD-Web-old.fig`

Auto-extracted from the user's Figma file. They're the actual current
SalesDoctor admin pages (in Russian). Use them as the canonical
reference for how the existing app looks today.

Filenames follow `page-N-WIDTHw.png` (`N` is the index, `WIDTH` is
pixel width).

## 2. `SD-Web-old.fig` — the source design file

The original Figma design file. Open it in:

- **Figma desktop** — File → Open Local Files → pick this file.
- **Figma web** — drag the file onto figma.com.

Once on figma.com, share the link with the team and we can use the
Figma MCP tools to pull individual frames as named PNGs / metadata.

## 3. Top-level PNGs (you drop these)

Add your own wireframes as `<area>-<page>.png` and reference them from
markdown:

```markdown
![Outlet detail](/wireframes/outlet-detail.png)
```

Suggested filenames the wireframes pages already reference:

| File | Description |
|------|-------------|
| `page-layout.png` | Whole-page skeleton: top bar + sidebar + content |
| `filters-top.png` | Filter chips above a table |
| `filters-side.png` | Filter rail to the left of a table |
| `table-default.png` | Default data table |
| `table-grouped.png` | Grouped / expandable rows |
| `form-create.png` | Create / edit form with sections |
| `form-inline.png` | Inline edit pattern |
| `modal-confirm.png` | Confirmation modal |
| `modal-edit.png` | Edit-in-modal pattern |
| `list-detail.png` | Master list + detail panel |
| `dashboard.png` | Dashboard with KPIs + charts |
| `mobile-agent-home.png` | Mobile agent home |
| `mobile-agent-order.png` | Mobile order creation |
