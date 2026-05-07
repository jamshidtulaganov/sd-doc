---
sidebar_position: 5
title: Assets pipeline
---

:::warning Stub
This page is a placeholder. The content is incomplete — verify against source before relying on it. See [the audit's stub-backfill list](#) for status.
:::

# Assets pipeline (or lack thereof)

There is **no build pipeline**. CSS and JS are served as plain files.

## Mental model

- New JS / CSS → put under `js/` or `css/`.
- Reference from a view via `clientScript`.
- Yii copies anything it considers an "asset bundle" into
  `assets/<hash>/` at runtime; that's the URL it injects.
- Cache busting is via the hashed asset folder name.

## Minification

Optional. Most files are served unminified. If you want to minify, run
your tool of choice locally and commit both `<file>.js` and
`<file>.min.js`, then reference the minified one in production builds.

## Versioning

The repo doesn't use a frontend version manifest. To force a hard
refresh, append `?v=<release-tag>` in the view:

```php
Yii::app()->clientScript->registerScriptFile('/js/orders.js?v=' . VERSION);
```
