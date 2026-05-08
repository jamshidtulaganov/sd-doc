---
sidebar_position: 3
title: JS-плагины
---

# JS-плагины

`js_plugins/` хранит вендорный сторонний JS. Добавляйте сюда новые плагины
только когда это действительно необходимо — каждый новый становится постоянной
зависимостью, потому что нет build-пайплайна.

## Сейчас используется

| Папка | Назначение |
|-------|------------|
| `bootstrap/` | Bootstrap 3 (legacy) |
| `chosen/` | Поиск-селекты |
| `fancybox/`, `fancybox2/` | Модалки + лайтбокс |
| `FixedColumns/` | Фиксированные колонки DataTables |
| `ajaxform/` | Ajax-сабмит форм |
| `ajaxcrud_behavior.js` | Yii-хелпер ajaxcrud |
| `jquery-highcharts-10.3.3/` | Графики |
| `jquery.spin.js`, `spin.min.js` | Спиннер загрузки |
| `json2/` | JSON-полифилл (legacy) |
| `la-color-picker/` | Color picker |
| `noty/` | Toast-уведомления |
| `export/` | Хелперы экспорта в Excel / CSV |

## Добавление плагина

1. Положите неминифицированный исходник под `js_plugins/<name>/`.
2. Сошлитесь на него из view через `clientScript`:
   ```php
   Yii::app()->clientScript
     ->registerScriptFile('/js_plugins/<name>/<name>.js');
   ```
3. Опишите его назначение в этом файле.

## Кандидаты на удаление

- `bootstrap/` — со временем заменить на utility-CSS.
- `json2/` — современным браузерам не нужен.
- `fancybox/` (v1) — оставить только `fancybox2`.
