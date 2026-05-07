---
sidebar_position: 4
title: ng-modules (Angular)
---

# ng-modules

Stand-alone Angular feature modules embedded in Yii pages. Two are
currently active:

| Module | Purpose |
|--------|---------|
| `ng-modules/gps/` | Live map + tracking UI for the `gps3` module |
| `ng-modules/neakb/` | Specialised audit (НЕ-АКБ) UI |

## Layout

```
ng-modules/<feature>/
├── package.json
├── angular.json
├── src/
└── dist/      ← built bundle, served as a static file
```

## Building

```bash
cd ng-modules/gps
npm install
npm run build
```

The `dist/` folder is deliberately checked in (no Node in production).
Re-run the build after every change.

## Embedding in a Yii view

```php
<sd-gps-map data-tenant="<?= h($tenant) ?>"></sd-gps-map>
<?php Yii::app()->clientScript
    ->registerScriptFile('/ng-modules/gps/dist/main.js'); ?>
<?php Yii::app()->clientScript
    ->registerCssFile('/ng-modules/gps/dist/styles.css'); ?>
```

## Communication with PHP

The Angular bundle calls api3 / api4 endpoints over fetch. The Yii view
passes runtime context via `data-*` attributes; the Angular bootstrap
reads them with `(host element).getAttribute('data-...')`.
