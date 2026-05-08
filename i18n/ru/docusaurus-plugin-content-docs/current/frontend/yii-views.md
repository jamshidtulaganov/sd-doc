---
sidebar_position: 2
title: Yii views
---

# Yii views

## Папка

```
protected/views/
├── layouts/      Топ-уровневые layouts (main.php, column1.php, ...)
├── modals/       Переиспользуемые модальные partial'ы
├── partial/      Общие partial'ы (header, sidebar, breadcrumbs)
├── invoiceTemplate/
├── site/         Логин, ошибки, дашборд
└── vue/          Изолированные Vue-«острова»
```

У каждого модуля есть своя папка `views/<controller>/<action>.php`, повторяющая
его контроллеры.

## Layouts

Большинство страниц используют `main.php`, который рендерит:

- Топ-бар (логотип, переключатель локали, меню пользователя)
- Левый сайдбар (по ролям)
- Контентную область
- Футер

Для широких таблиц переключайтесь на `column1.php`, который убирает сайдбар.

## Хелперы

- `H` (`protected/components/H.php`) — небольшие HTML-хелперы.
- `Formatter` (`protected/components/Formatter.php`) — валюта, даты.
- `Compress` — output-хелперы gzip.
- `BootPager`, `MyHtml` — пагинация и виджеты форм.

## i18n во views

```php
<?= Yii::t('orders', 'Create order') ?>
```

Каталоги живут в `protected/messages/<locale>/<category>.php`. Активные локали:
`ru` (по умолчанию), `en`, `uz`, `tr`, `fa`.
