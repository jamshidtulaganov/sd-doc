---
sidebar_position: 1
title: Frontend overview
---

# Frontend overview

SalesDoctor is **server-rendered** PHP. The frontend is a mix of:

| Layer | Tech | Where |
|-------|------|-------|
| Page shell | Yii views (PHP) | `protected/views/`, module views |
| Page logic (small) | jQuery + 3rd-party plugins | `js/`, `js_plugins/` |
| Modern islands | Angular | `ng-modules/` |
| A few experiments | Vue | `protected/views/vue/` |
| Charts | Highcharts (10.3.3) | `js_plugins/jquery-highcharts-10.3.3` |
| Tables | DataTables | inline + `dataTables.material.min.css` |
| Modals | fancybox | `js_plugins/fancybox*` |
| Pickers | chosen, jquery-ui | `js_plugins/chosen`, `js/jquery-ui.js` |

## Page lifecycle

1. Browser → Nginx → `index.php`.
2. Yii routes to controller action.
3. Controller renders a view from `protected/views/<controller>/<action>.php`.
4. View uses `Yii::app()->clientScript->registerPackage('jquery')` etc. to
   pull JS / CSS.
5. The HTML response is sent as a complete page — no SPA shell.

## Asset publishing

Yii's `CAssetManager` copies any "asset bundle" referenced by views into
`assets/<hash>/`. Hashes change when files change. The folder grows over
time — periodically clean it.

## When to add an Angular island

For substantial interactive UI (maps, drag-drop kanbans, complex forms),
add an Angular module under `ng-modules/` with its own build pipeline.
The PHP view embeds `<sd-feature></sd-feature>` and includes the bundled
JS via `<script src="/ng-modules/feature/main.js">`.

Don't add new SPA layers casually — every island raises maintenance
costs.

## See also

- [Yii views](./yii-views.md)
- [JS plugins](./js-plugins.md)
- [ng-modules](./ng-modules.md)
- [Asset pipeline](./assets-pipeline.md)
