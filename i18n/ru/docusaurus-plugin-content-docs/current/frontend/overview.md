---
sidebar_position: 1
title: Обзор фронтенда
---

# Обзор фронтенда

SalesDoctor — **серверный рендеринг** на PHP. Фронтенд — это микс из:

| Слой | Технология | Где |
|------|------------|-----|
| Каркас страницы | Yii views (PHP) | `protected/views/`, views модулей |
| Логика страницы (небольшая) | jQuery + сторонние плагины | `js/`, `js_plugins/` |
| Современные «острова» | Angular | `ng-modules/` |
| Несколько экспериментов | Vue | `protected/views/vue/` |
| Графики | Highcharts (10.3.3) | `js_plugins/jquery-highcharts-10.3.3` |
| Таблицы | DataTables | inline + `dataTables.material.min.css` |
| Модалки | fancybox | `js_plugins/fancybox*` |
| Пикеры | chosen, jquery-ui | `js_plugins/chosen`, `js/jquery-ui.js` |

## Жизненный цикл страницы

1. Браузер → Nginx → `index.php`.
2. Yii маршрутизирует к экшену контроллера.
3. Контроллер рендерит view из `protected/views/<controller>/<action>.php`.
4. View использует `Yii::app()->clientScript->registerPackage('jquery')` и т.п.,
   чтобы подтянуть JS / CSS.
5. HTML-ответ отправляется как полная страница — никакого SPA-каркаса.

## Публикация ассетов

Yii-овский `CAssetManager` копирует любой «asset bundle», на который ссылаются
views, в `assets/<hash>/`. Хеши меняются при изменении файлов. Папка растёт со
временем — периодически чистите её.

## Когда добавлять Angular-«остров»

Для существенного интерактивного UI (карты, drag-drop канбаны, сложные формы),
добавьте Angular-модуль под `ng-modules/` со своим build-пайплайном.
PHP-view встраивает `<sd-feature></sd-feature>` и подключает собранный JS через
`<script src="/ng-modules/feature/main.js">`.

Не добавляйте новые SPA-слои бездумно — каждый «остров» увеличивает стоимость
поддержки.

## См. также

- [Yii views](./yii-views.md)
- [JS-плагины](./js-plugins.md)
- [ng-modules](./ng-modules.md)
- [Пайплайн ассетов](./assets-pipeline.md)
