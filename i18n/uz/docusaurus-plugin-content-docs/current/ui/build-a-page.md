---
sidebar_position: 8
title: Yangi sahifa qurish (cookbook)
audience: New frontend developers
summary: sd-main da yangi admin sahifasini qurish uchun bosqichma-bosqich cookbook — wireframe pattern tanlashdan kontroller, view, JS va i18n qatorlarini ulashgacha.
topics: [cookbook, build-page, frontend, yii-view, jquery, ajax, recipe]
---

# Yangi sahifa qurish (cookbook)

Bu yangi frontend dev o'zining **birinchi tiketida** ergashadigan retsept. U "X uchun list sahifasini qurish" ni boshidan oxirigacha bosib o'tadi. Layout pattern-ini almashtirib formalar, xaritalar, dashbord-larga moslashtiring.

## Dastlabki shartlar

- Mahalliy sd-main ishlamoqda ([Local setup](../project/local-setup.md)).
- Siz tizimga kirib, atrofni bosishingiz mumkin.
- Siz [Wireframe-lar katalogi](./wireframes.md) va [Komponent katalogi](./component-catalog.md) ni o'qib chiqdingiz.

## Retsept — list sahifasi

### Step 1 — layout pattern-ini tanlang

[Wireframe-lar katalogi](./wireframes.md) ni oching va olti pattern-dan birini tanlang. List sahifasi uchun, **Pattern B (List + filters)** — default. Wireframe PNG raqamini qayd qiling — uning layout-iga moslashasiz.

### Step 2 — URL-ni hal qiling

Yii routes `<controller>/<action>` ni avtomatik hal qiladi (`protected/config/main_static.php` dagi `urlManager` ga qarang). Orders modulida yangi "thingies" listing uchun:

```
/orders/thingyList/index   →   OrdersModule → ThingyListController::actionIndex
```

### Step 3 — kontrollerni yarating

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
        // Jadval uchun qatorlarni qaytaradigan AJAX endpoint.
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

### Step 4 — view-ni yarating

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

### Step 5 — JS-ni yozing

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

### Step 6 — i18n qatorlarini qo'shing

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

### Step 7 — sidebar ga qo'shing

`protected/views/partial/sidebar.php` ni oching va qo'shing:

```php
<?php if (Yii::app()->user->checkAccess('operation.orders.thingyList.view')): ?>
  <a href="<?= Yii::app()->createUrl('orders/thingyList/index') ?>">
    <?= Yii::t('orders', 'Thingies') ?>
  </a>
<?php endif; ?>
```

### Step 8 — RBAC ruxsati

`authitem` ga qator qo'shing (`access` modul UI orqali yoki migration orqali):

```sql
INSERT INTO authitem (name, type, description) VALUES
  ('operation.orders.thingyList.view', 0, 'View Thingies list');
INSERT INTO authitemchild (parent, child) VALUES
  ('1', 'operation.orders.thingyList.view'),
  ('2', 'operation.orders.thingyList.view'),
  ('9', 'operation.orders.thingyList.view');
```

Auth cache-ni yangilang:

```php
Yii::app()->tenantContext->scoped()->delete('authitem');
```

### Step 9 — sahifani sinab ko'ring

- `1` rol sifatida tizimga kiring — sahifa ishlaydi.
- `4` rol sifatida tizimga kiring — sahifa 403 qaytaradi.
- Sana bo'yicha filtrlash — jadval AJAX orqali qayta yuklanadi.
- Qator harakatini bosing — confirm modal ochiladi, tasdiqlang → qator o'chiriladi.

### Step 10 — test yozing

Agar siz `ThingyListController` ga ko'rsatish/AJAX dan tashqari mantiq qo'shgan bo'lsangiz, `tests/unit/orders/` ostida unit testni qo'shing. Qarang [Testing](../quality/testing.md).

### Step 11 — PR ni oching

PR tavsifi quyidagilarni o'z ichiga olishi kerak:

- Siz mos kelgan wireframe raqami
- Yangi sahifaning skrinshoti
- Bu nima uchun mavjud pattern emas (yangisini qo'shgan bo'lsangiz)
- RBAC migration-ga havola

## Variant — forma / detal sahifasi (Pattern C)

Step 4-ning view-ini bo'limli forma bilan almashtiring:

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

## Variant — xarita sahifasi (Pattern D)

Yangi xarita yozmang. `ng-modules/gps/` ostidagi Angular modulini embed qilish orqali qayta foydalaning:

```php
<sd-gps-map data-tenant="<?= h($tenant) ?>"></sd-gps-map>
<?php Yii::app()->clientScript->registerScriptFile('/ng-modules/gps/dist/main.js'); ?>
<?php Yii::app()->clientScript->registerCssFile('/ng-modules/gps/dist/styles.css'); ?>
```

Runtime kontekstini `data-*` atributlari orqali uzating; Angular bootstrap ularni o'qiydi.

## Qilmasligingiz kerak bo'lgan narsalar

- Yangi SPA boshlamang. Tasdiqlangan bo'lsangizgina Angular orolini embed qiling.
- DOM ga klient tomonida to'liq jadvalni yuklamang — server tomonidagi sahifalash > 10k qatorli tenantlar uchun muzokara qilib bo'lmaydigan.
- Faqat ingliz tilidagi qatorlarni yozmang. To'rt katalog (ru / en / uz / tr) ga qo'shing.
- View-da rolni tekshirib RBAC-ni chetlab o'tmang.

## Shuningdek qarang

- [Wireframes katalogi](./wireframes.md)
- [Komponent katalogi](./component-catalog.md)
- [Yii views](../frontend/yii-views.md)
- [JS plagins](../frontend/js-plugins.md)
- [jQuery / AJAX patternlari](../frontend/jquery-patterns.md)
