---
sidebar_position: 3
title: JS plugins
---

:::warning Stub
This page is a placeholder. The content is incomplete — verify against source before relying on it. See [the audit's stub-backfill list](#) for status.
:::

# JS plugins

`js_plugins/` holds vendored 3rd-party JS. Add new plugins here only when
absolutely necessary — every addition becomes a permanent dependency
because there is no build pipeline.

## Currently used

| Folder | Purpose |
|--------|---------|
| `bootstrap/` | Bootstrap 3 (legacy) |
| `chosen/` | Searchable selects |
| `fancybox/`, `fancybox2/` | Modals + lightbox |
| `FixedColumns/` | DataTables fixed columns |
| `ajaxform/` | Ajax form submission |
| `ajaxcrud_behavior.js` | Yii ajaxcrud helper |
| `jquery-highcharts-10.3.3/` | Charts |
| `jquery.spin.js`, `spin.min.js` | Loading spinner |
| `json2/` | JSON polyfill (legacy) |
| `la-color-picker/` | Color picker |
| `noty/` | Toast notifications |
| `export/` | Excel / CSV export helpers |

## Adding a plugin

1. Drop the unminified source under `js_plugins/<name>/`.
2. Reference it from a view via `clientScript`:
   ```php
   Yii::app()->clientScript
     ->registerScriptFile('/js_plugins/<name>/<name>.js');
   ```
3. Document its purpose in this file.

## Removal candidates

- `bootstrap/` — replace with utility CSS over time.
- `json2/` — modern browsers don't need it.
- `fancybox/` (v1) — keep only `fancybox2`.
