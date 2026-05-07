---
sidebar_position: 2
title: Yii views
---

# Yii views

## Folder

```
protected/views/
├── layouts/      Top-level layouts (main.php, column1.php, ...)
├── modals/       Reusable modal partials
├── partial/      Shared partials (header, sidebar, breadcrumbs)
├── invoiceTemplate/
├── site/         Login, error, dashboard
└── vue/          Isolated Vue islands
```

Each module has its own `views/<controller>/<action>.php` mirroring its
controllers.

## Layouts

Most pages use `main.php` which renders:

- Top bar (logo, locale switcher, user menu)
- Left sidebar (per-role)
- Content area
- Footer

For wide tables, switch to `column1.php` which removes the sidebar.

## Helpers

- `H` (`protected/components/H.php`) — small HTML helpers.
- `Formatter` (`protected/components/Formatter.php`) — currency, dates.
- `Compress` — output gzip helpers.
- `BootPager`, `MyHtml` — pagination & form widgets.

## i18n in views

```php
<?= Yii::t('orders', 'Create order') ?>
```

Catalogues live in `protected/messages/<locale>/<category>.php`. Active
locales: `ru` (default), `en`, `uz`, `tr`, `fa`.
