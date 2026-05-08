---
sidebar_position: 4
title: ng-modules (Angular)
---

# ng-modules

Самостоятельные Angular feature-модули, встроенные в Yii-страницы. Сейчас
активны два:

| Модуль | Назначение |
|--------|------------|
| `ng-modules/gps/` | Live-карта + UI трекинга для модуля `gps3` |
| `ng-modules/neakb/` | Специализированный UI аудита (НЕ-АКБ) |

## Структура

```
ng-modules/<feature>/
├── package.json
├── angular.json
├── src/
└── dist/      ← собранный бандл, отдаётся как статика
```

## Сборка

```bash
cd ng-modules/gps
npm install
npm run build
```

Папка `dist/` намеренно закоммичена (в продакшне нет Node). Пересобирайте после
каждого изменения.

## Встраивание в Yii view

```php
<sd-gps-map data-tenant="<?= h($tenant) ?>"></sd-gps-map>
<?php Yii::app()->clientScript
    ->registerScriptFile('/ng-modules/gps/dist/main.js'); ?>
<?php Yii::app()->clientScript
    ->registerCssFile('/ng-modules/gps/dist/styles.css'); ?>
```

## Связь с PHP

Angular-бандл вызывает эндпоинты api3 / api4 через fetch. Yii-view передаёт
runtime-контекст через `data-*`-атрибуты; Angular-бутстрап читает их через
`(host element).getAttribute('data-...')`.
