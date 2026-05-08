---
sidebar_position: 4
title: ng-modules (Angular)
---

# ng-modules

Yii sahifalariga embed qilingan mustaqil Angular feature modullari. Hozirda ikkitasi faol:

| Modul | Maqsadi |
|--------|---------|
| `ng-modules/gps/` | `gps3` moduli uchun jonli xarita + kuzatuv UI |
| `ng-modules/neakb/` | Maxsus audit (НЕ-АКБ) UI |

## Joylashuv

```
ng-modules/<feature>/
├── package.json
├── angular.json
├── src/
└── dist/      ← static fayl sifatida xizmat qiladigan build qilingan bundle
```

## Build qilish

```bash
cd ng-modules/gps
npm install
npm run build
```

`dist/` papkasi maxsus ravishda commit qilinadi (production-da Node yo'q). Har bir o'zgartirishdan keyin build-ni qayta ishga tushiring.

## Yii view-da embed qilish

```php
<sd-gps-map data-tenant="<?= h($tenant) ?>"></sd-gps-map>
<?php Yii::app()->clientScript
    ->registerScriptFile('/ng-modules/gps/dist/main.js'); ?>
<?php Yii::app()->clientScript
    ->registerCssFile('/ng-modules/gps/dist/styles.css'); ?>
```

## PHP bilan aloqa

Angular bundle api3 / api4 endpointlarini fetch orqali chaqiradi. Yii view runtime kontekstini `data-*` atributlari orqali uzatadi; Angular bootstrap ularni `(host element).getAttribute('data-...')` bilan o'qiydi.
