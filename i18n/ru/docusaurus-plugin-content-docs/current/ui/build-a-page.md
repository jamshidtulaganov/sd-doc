---
sidebar_position: 8
title: Постройте новую страницу (cookbook)
audience: New frontend developers
summary: Пошаговый cookbook для постройки новой admin-страницы в sd-main — от выбора паттерна вайрфрейма до прокладки контроллера, view, JS и i18n-строк.
topics: [cookbook, build-page, frontend, yii-view, jquery, ajax, recipe]
---

# Постройте новую страницу (cookbook)

Это рецепт, по которому новый фронтенд-разработчик идёт на своём
**первом тикете**. Он проходит «постройка list-страницы для X»
end-to-end. Адаптируйте для форм, карт, дашбордов сменой layout-паттерна.

## Предусловия

- Локально запущен sd-main ([Локальная настройка](../project/local-setup.md)).
- Вы можете залогиниться и кликать по интерфейсу.
- Вы прочитали [Каталог вайрфреймов](./wireframes.md) и
  [Каталог компонентов](./component-catalog.md).

## Рецепт — list-страница

### Шаг 1 — выберите паттерн раскладки

Откройте [Каталог вайрфреймов](./wireframes.md) и выберите один из шести
паттернов. Для list-страницы дефолт — **Паттерн B (List + filters)**.
Запомните номер вайрфрейма-PNG — будете соответствовать его layout'у.

### Шаг 2 — определите URL

Yii-роуты авто-резолвятся в `<controller>/<action>` (см.
`urlManager` в `protected/config/main_static.php`). Для нового списка
«thingies» в модуле orders:

```
/orders/thingyList/index   →   OrdersModule → ThingyListController::actionIndex
```

### Шаг 3 — создайте контроллер

```bash
touch protected/modules/orders/controllers/ThingyListController.php
```

```php
<?php
class ThingyListController extends Controller
{
    public function filters() { return ['accessControl']; }

    public function accessRules() {
        return [
            ['allow', 'roles' => ['1','2','9']],
            ['deny',  'users' => ['*']],
        ];
    }

    public function actionIndex() {
        H::access('operation.orders.thingyList.view'); // RBAC
        $this->pageTitle = Yii::t('orders', 'Thingies');
        $this->render('index');
    }

    public function actionGetData() {
        // AJAX endpoint that returns rows for the table.
        $from = $_GET['from'] ?? date('Y-m-01');
        $to   = $_GET['to']   ?? date('Y-m-d');
        // …validate, query, return JSON
        $this->success([
            'rows' => Thingy::model()->findAllByAttributes(...),
            'total' => 1234,
        ]);
    }
}
```

### Шаг 4 — создайте view

```
protected/modules/orders/views/thingyList/index.php
```

```php
<?php $this->breadcrumbs = [Yii::t('orders', 'Thingies')]; ?>

<div class="page-header">
  <h1><?= Yii::t('orders', 'Thingies') ?></h1>
  <a class="btn btn-primary pull-right" href="<?= $this->createUrl('create') ?>">
    + <?= Yii::t('orders', 'New thingy') ?>
  </a>
</div>

<div class="filter-bar">
  <input type="date" id="from" value="<?= date('Y-m-01') ?>">
  <input type="date" id="to"   value="<?= date('Y-m-d') ?>">
  <select id="status">
    <option value="">— <?= Yii::t('app', 'All') ?> —</option>
    <option value="new">New</option>
    <option value="paid">Paid</option>
  </select>
  <button id="apply" class="btn btn-default"><?= Yii::t('app', 'Apply') ?></button>
</div>

<table id="thingy-table" class="display"></table>

<?php
Yii::app()->clientScript->registerScriptFile('/js/thingy-list.js');
Yii::app()->clientScript->registerCssFile('/css/thingy-list.css');
?>
```

### Шаг 5 — напишите JS

```
js/thingy-list.js
```

```js
$(function () {
  const table = $('#thingy-table').DataTable({
    serverSide: true,
    ajax: {
      url: '/orders/thingyList/getData',
      data: function (d) {
        d.from   = $('#from').val();
        d.to     = $('#to').val();
        d.status = $('#status').val();
      },
    },
    columns: [
      { title: '#',       data: 'id' },
      { title: 'Name',    data: 'name' },
      { title: 'Status',  data: 'status', render: renderStatusPill },
      { title: '',        data: null,    render: renderRowActions },
    ],
    pageLength: 25,
  });

  $('#apply').on('click', () => table.ajax.reload());
});

function renderStatusPill(s) {
  return `<span class="pill pill-${s}">${s}</span>`;
}
function renderRowActions(_, _t, row) {
  return `
    <div class="row-actions">
      <a href="/orders/thingy/edit/${row.id}">Edit</a>
      <a href="#" class="js-delete" data-id="${row.id}">Delete</a>
    </div>`;
}
```

### Шаг 6 — добавьте i18n-строки

```
protected/messages/ru/orders.php
protected/messages/en/orders.php
protected/messages/uz/orders.php
```

```php
return [
    'Thingies'   => 'Thingies',     // ru: "Штуки", uz: "Narsalar"
    'New thingy' => 'New thingy',
    // …
];
```

### Шаг 7 — добавьте в сайдбар

Откройте `protected/views/partial/sidebar.php` и добавьте:

```php
<?php if (Yii::app()->user->checkAccess('operation.orders.thingyList.view')): ?>
  <a href="<?= Yii::app()->createUrl('orders/thingyList/index') ?>">
    <?= Yii::t('orders', 'Thingies') ?>
  </a>
<?php endif; ?>
```

### Шаг 8 — RBAC permission

Добавьте строку в `authitem` (через UI модуля `access` или миграцию):

```sql
INSERT INTO authitem (name, type, description) VALUES
  ('operation.orders.thingyList.view', 0, 'View Thingies list');
INSERT INTO authitemchild (parent, child) VALUES
  ('1', 'operation.orders.thingyList.view'),
  ('2', 'operation.orders.thingyList.view'),
  ('9', 'operation.orders.thingyList.view');
```

Сбросьте auth-кеш:

```php
Yii::app()->tenantContext->scoped()->delete('authitem');
```

### Шаг 9 — протестируйте страницу

- Залогиньтесь под ролью `1` — страница работает.
- Залогиньтесь под ролью `4` — страница возвращает 403.
- Отфильтруйте по дате — таблица перезагружается через AJAX.
- Кликните действие строки — открывается confirm-модалка, confirm →
  строка удаляется.

### Шаг 10 — напишите тест

Если вы добавили логику в `ThingyListController` сверх
display/AJAX — добавьте unit-тест под `tests/unit/orders/`. См.
[Тестирование](../quality/testing.md).

### Шаг 11 — откройте PR

Описание PR должно включать:

- Номер вайрфрейма, на который вы соответствовали
- Скриншот новой страницы
- Почему это не существующий паттерн (если вы добавили новый)
- Ссылку на RBAC-миграцию

## Вариант — form / detail-страница (Паттерн C)

Замените view из шага 4 на секционную форму:

```php
<form method="post" action="<?= $this->createUrl('save') ?>">
  <fieldset class="section">
    <legend><?= Yii::t('orders', 'General') ?></legend>
    <label>Name <input name="Thingy[NAME]"></label>
    <label>Code <input name="Thingy[CODE]"></label>
  </fieldset>

  <fieldset class="section">
    <legend><?= Yii::t('orders', 'Pricing') ?></legend>
    <label>Price <input name="Thingy[PRICE]" type="number"></label>
  </fieldset>

  <div class="form-actions sticky-footer">
    <a class="btn" href="<?= $this->createUrl('index') ?>"><?= Yii::t('app', 'Cancel') ?></a>
    <button type="submit" class="btn btn-primary"><?= Yii::t('app', 'Save') ?></button>
  </div>
</form>
```

## Вариант — map-страница (Паттерн D)

Не пишите свежую карту. Переиспользуйте Angular-модуль под
`ng-modules/gps/`, встроив:

```php
<sd-gps-map data-tenant="<?= h($tenant) ?>"></sd-gps-map>
<?php Yii::app()->clientScript->registerScriptFile('/ng-modules/gps/dist/main.js'); ?>
<?php Yii::app()->clientScript->registerCssFile('/ng-modules/gps/dist/styles.css'); ?>
```

Передайте runtime-контекст через `data-*`-атрибуты; Angular-бутстрап их
читает.

## Don'ts

- ❌ Не запускайте новый SPA. Встраивайте Angular-«остров» только при
  наличии одобрения.
- ❌ Не загружайте полную таблицу в DOM client-side — server-side
  пагинация обязательна для тенантов с > 10k строк.
- ❌ Не пишите English-only строки. Добавляйте во все четыре каталога
  (ru / en / uz / tr).
- ❌ Не обходите RBAC проверкой роли во view.

## См. также

- [Каталог вайрфреймов](./wireframes.md)
- [Каталог компонентов](./component-catalog.md)
- [Yii views](../frontend/yii-views.md)
- [JS-плагины](../frontend/js-plugins.md)
- [Паттерны jQuery / AJAX](../frontend/jquery-patterns.md)
