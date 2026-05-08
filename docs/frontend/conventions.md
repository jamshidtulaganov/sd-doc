---
sidebar_position: 3
title: Frontend conventions
audience: Frontend engineers
summary: File layout, naming, when to use jQuery vs an Angular island vs a Vue page, i18n in views, what not to touch. Frontend complement to the project-wide Conventions page.
topics: [frontend, conventions, style]
---

# Frontend conventions

This page covers conventions specific to the frontend layer. For
PHP / DB / Git conventions, see
[project Conventions](../project/conventions.md). For the *anatomy*
of the stack, see [Frontend overview](./overview.md).

## Where things live

| If you're adding… | Put it under… |
|--------|---------|
| A page-specific JS file | `js/<area>.js` (first-party) |
| A 3rd-party library | `js_plugins/<name>/` |
| A page-specific stylesheet | `css/<area>.css` |
| A view partial reused across pages | `protected/views/partial/` |
| A reusable modal partial | `protected/views/modals/` |
| An interactive island (Angular) | `ng-modules/<feature>/` |
| A Vue experiment | `protected/views/vue/` (sparingly) |

`js/` already contains ~120 first-party files (per
[Project structure](../project/structure.md)) and `js_plugins/` is
the vendored 3rd-party home (Bootstrap 3, Chosen, fancybox,
jQuery UI, Highcharts, DataTables FixedColumns, noty — see
[JS plugins](./js-plugins.md)).

## When to use what

The frontend is intentionally a mix. The decision rule, in order:

1. **Plain Yii view + jQuery snippet** — the default. Use this for
   list pages, forms, modals, and anything that fits the existing
   page lifecycle (see [Frontend overview](./overview.md#page-lifecycle)).
2. **Yii view + first-party `js/<area>.js`** — when the page-level
   JS would clutter the view, lift it to a file under `js/` and
   register via `clientScript->registerScriptFile`.
3. **An existing `js_plugins/` library** — for a known need:
   chart → Highcharts, search-select → Chosen, table → DataTables,
   modal → fancybox2, toast → noty.
4. **A new `js_plugins/` library** — only when no existing plugin
   covers the need *and* no team consensus exists to write it
   in-house. Each addition is permanent (see
   [JS plugins · Adding a plugin](./js-plugins.md#adding-a-plugin)).
5. **An Angular island under `ng-modules/`** — only for substantial
   interactive UI (live map, drag-drop kanban, complex multi-step
   form). Each island has its own build, its own routing, its own
   maintenance cost. Consult before adding a new one
   ([Frontend overview](./overview.md#when-to-add-an-angular-island)).
6. **A Vue page** — don't add new ones. The few existing experiments
   in `protected/views/vue/` are kept; new SPAs go in `ng-modules/`
   if they have to exist at all.

If you're unsure which level fits, pick the lower one. Going from a
jQuery snippet to an Angular island is rarely cheaper than the
reverse.

## Naming

### JS files in `js/`

- **Page-specific** — name after the controller/area: `orders.js`,
  `clients.js`, `invoice.js`. Keep it lowercase.
- **Reusable utilities** — name after the concern: `date-utils.js`,
  `money.js`. Avoid `helpers.js` / `common.js` — every legacy
  codebase has one and nobody knows what's in it.
- **A new folder under `js/`** — only when a feature ships ≥ 3
  files. Otherwise keep flat.

### JS files in `js_plugins/`

- **One folder per library** — `<name>/` matches the upstream name
  (`chosen/`, `fancybox2/`, `jquery-highcharts-10.3.3/`).
- **Pin the version in the folder name** when the plugin is likely
  to ever be upgraded next to the old one (the Highcharts folder
  is the precedent).

### CSS files

- **Page-specific** — `css/<area>.css`, mirroring the JS naming.
- **Site-wide** — kept minimal; most styling rides on Bootstrap 3
  classes today.

### Yii views

Per [Conventions](../project/conventions.md):

- **Folder per controller** — `views/<controller>/`.
- **One file per action** — `views/<controller>/<action>.php`,
  lowercase.
- **Reusable partials** — `views/partial/<name>.php`, included via
  `$this->renderPartial('partial.<name>', [...])`.

## i18n in views

Wrap every visible string:

```php
<?= Yii::t('orders', 'Create order') ?>
```

- **Category** is the first arg (`'orders'`, `'common'`, …). Match
  the module / area you're in — don't pile everything into
  `'common'`.
- **Source string** is the second arg. Keep the source language
  consistent within a category (the existing catalogues mix RU and
  EN sources; when adding, follow the surrounding file).
- Catalogues live in `protected/messages/<locale>/<category>.php`.
  Active locales: **`ru` (default)**, `en`, `uz`, `tr`, `fa` (per
  [Tech stack](../architecture/tech-stack.md)).
- Adding a new key in `ru` only is acceptable for an RU-first feature,
  but plan for EN + UZ within the same release. The
  [onboarding starter ticket](../team/onboarding.md#week-1)
  list includes "fill missing translations" tasks for this reason.

## Calling APIs from the frontend

Per [Pitfalls in your first month](../team/onboarding.md#pitfalls-to-avoid-in-your-first-month):

- **Do not** add new endpoints to `api` (v1) or `api2`.
- **Mobile** flows → `api3` ([API v3 — mobile](../api/api-v3-mobile.md)).
- **Online / web** flows → `api4` ([API v4 — online](../api/api-v4-online.md)).

For Angular islands, see [ng-modules · Communication with PHP](./ng-modules.md#communication-with-php)
— context (tenant, user, etc.) flows from the Yii view to the
Angular bundle via `data-*` attributes on the host element.

## What you must not touch

| Path | Why |
|------|-----|
| `framework/` | Vendored Yii 1.x. Patch only as a last resort and only via the team's process. |
| `assets/<hash>/` | Auto-generated. Edits get overwritten and the directory can be deleted at any time. |
| `*.obsolete` | Removed code kept around for archaeology. |
| `index2.php`, `a.php` | Legacy entrypoints / one-off scripts. |
| `vendors/`, `protected/extensions/` | Pinned vendored libs. |

## Removal candidates (don't extend, plan to retire)

From [JS plugins · Removal candidates](./js-plugins.md#removal-candidates):

- **`bootstrap/`** — replace with utility CSS over time.
- **`json2/`** — modern browsers don't need it.
- **`fancybox/` (v1)** — keep only `fancybox2`.

If you're touching one of these, prefer the modern replacement
unless the change scope is genuinely a bug-fix-in-place.

## Open questions / TODO

- **`js/` graveyard** — is there a definitive list of which `js/*.js`
  files are referenced by some controller's
  `registerScriptFile` versus abandoned? Until this list exists,
  treat unfamiliar `js/` files as suspect and `grep` for references
  before assuming they're live.
- **Iconography source** — Bootstrap 3 glyphs? a custom sprite?
  both? See [JS plugins](./js-plugins.md#currently-used) for clues.
- **Site-wide globals** exposed by existing JS (e.g. `Distr`, others)
  — should be enumerated here once confirmed.
