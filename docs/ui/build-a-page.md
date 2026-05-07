---
sidebar_position: 8
title: Build a new page (cookbook)
audience: New frontend developers
summary: Step-by-step cookbook for building a new admin page in sd-main — from picking a wireframe pattern to wiring up the controller, view, JS and i18n strings.
topics: [cookbook, build-page, frontend, yii-view, jquery, ajax, recipe]
---

# Build a new page (cookbook)

This is the recipe a new frontend dev follows on their **first
ticket**. It walks through "build a list page for X" end-to-end.
Adapt for forms, maps, dashboards by swapping the layout pattern.

## Prerequisites

- Local sd-main running ([Local setup](../project/local-setup.md)).
- You can sign in and click around.
- You've read [Wireframes catalog](./wireframes.md) and
  [Component catalog](./component-catalog.md).

## Recipe — list page

### Step 1 — pick a layout pattern

Open [Wireframes catalog](./wireframes.md) and choose one of the six
patterns. For a list page, **Pattern B (List + filters)** is the
default. Note the wireframe PNG number — you'll match its layout.

### Step 2 — decide the URL

Yii routes auto-resolve `<controller>/<action>` (see
`urlManager` in `protected/config/main_static.php`). For a new
"thingies" listing in the orders module:

```
/orders/thingyList/index   →   OrdersModule → ThingyListController::actionIndex
```

### Step 3 — create the controller

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

### Step 4 — create the view

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

### Step 5 — write the JS

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

### Step 6 — add i18n strings

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

### Step 7 — add to the sidebar

Open `protected/views/partial/sidebar.php` and add:

```php
<?php if (Yii::app()->user->checkAccess('operation.orders.thingyList.view')): ?>
  <a href="<?= Yii::app()->createUrl('orders/thingyList/index') ?>">
    <?= Yii::t('orders', 'Thingies') ?>
  </a>
<?php endif; ?>
```

### Step 8 — RBAC permission

Add a row to `authitem` (via the `access` module UI or a migration):

```sql
INSERT INTO authitem (name, type, description) VALUES
  ('operation.orders.thingyList.view', 0, 'View Thingies list');
INSERT INTO authitemchild (parent, child) VALUES
  ('1', 'operation.orders.thingyList.view'),
  ('2', 'operation.orders.thingyList.view'),
  ('9', 'operation.orders.thingyList.view');
```

Bump the auth cache:

```php
Yii::app()->tenantContext->scoped()->delete('authitem');
```

### Step 9 — test the page

- Sign in as role `1` — page works.
- Sign in as role `4` — page returns 403.
- Filter by date — table reloads via AJAX.
- Click a row action — confirm modal opens, confirm → row deletes.

### Step 10 — write a test

If you've added logic in `ThingyListController` beyond
display/AJAX, add a unit test under `tests/unit/orders/`. See
[Testing](../quality/testing.md).

### Step 11 — open the PR

PR description should include:

- Wireframe number you matched
- Screenshot of the new page
- Why this isn't an existing pattern (if you added a new one)
- Link to the RBAC migration

## Variant — form / detail page (Pattern C)

Replace step 4's view with a sectioned form:

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

## Variant — map page (Pattern D)

Don't write a fresh map. Reuse the Angular module under
`ng-modules/gps/` by embedding:

```php
<sd-gps-map data-tenant="<?= h($tenant) ?>"></sd-gps-map>
<?php Yii::app()->clientScript->registerScriptFile('/ng-modules/gps/dist/main.js'); ?>
<?php Yii::app()->clientScript->registerCssFile('/ng-modules/gps/dist/styles.css'); ?>
```

Pass runtime context via `data-*` attributes; the Angular bootstrap
reads them.

## Don'ts

- ❌ Don't start a new SPA. Embed an Angular island only if you have
  approval.
- ❌ Don't load a full table into the DOM client-side — server-side
  pagination is non-negotiable for tenants > 10k rows.
- ❌ Don't write English-only strings. Add to all four catalogs (ru /
  en / uz / tr).
- ❌ Don't bypass RBAC by checking the role in the view.

## See also

- [Wireframes catalog](./wireframes.md)
- [Component catalog](./component-catalog.md)
- [Yii views](../frontend/yii-views.md)
- [JS plugins](../frontend/js-plugins.md)
- [jQuery / AJAX patterns](../frontend/jquery-patterns.md)
