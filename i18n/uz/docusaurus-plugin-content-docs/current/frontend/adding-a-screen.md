---
sidebar_position: 4
title: Ekran qo'shish
audience: Frontend engineers shipping their first end-to-end change
summary: Yangi server tomonida render qilingan ekranni qo'shish uchun aniq retsept — kontroller harakati, view fayli, sahifaga xos JS/CSS, sidebar yozuvi, i18n kalitlari. Buni har qanday yangi sahifa uchun ro'yxat sifatida keltiring.
topics: [frontend, recipes, first-pr]
---

# Ekran qo'shish

Bu eng keng tarqalgan frontend o'zgarishi uchun retsept: yangi server tomonida render qilingan sahifa (yoki mavjud sahifaga yangi harakat). Uni birinchi PR uchun yuqoridan pastgacha bajaring.

Bu sahifa siz allaqachon [Boshlash](./getting-started.md) ni bajargansiz va [Conventions](./conventions.md) ni o'qigansiz deb taxmin qiladi.

Mazmunli interaktiv vidjetlar uchun (jonli xarita, drag-drop kanban), uning o'rniga Angular oroli qo'shing — qarang [ng-modules](./ng-modules.md) va [Frontend overview](./overview.md#qachon-angular-oroli-qoshish-kerak).

## Avval qaror qiling

Kod yozishdan oldin shu savollarga javob bering. Har bir tanlov siz boradigan yo'lni belgilab beradi.

| Savol | Default javob |
|----------|----------------|
| Yuqori darajada yoki modulda? | Agar ekran feature sohasiga (orders, warehouse va boshqalar) tegishli bo'lsa, uni `protected/modules/<name>/` ga qo'ying. Agar bu haqiqatan ham cross-cutting bo'lsa, yuqori darajada. |
| Yangi kontroller yoki yangi harakat? | Iloji boricha mavjud kontrollerda yangi harakat. Yangi kontroller faqat URL haqiqatan ham yangi resurs bo'lganda. |
| Layout? | `main.php` (default — yuqori panel + sidebar). Juda keng jadvallar uchun `column1.php` dan foydalaning. Qarang [Yii views · Layoutlar](./yii-views.md#layoutlar). |
| Qaysi rollarga ko'rinadi? | Auth ierarxiyasidan (RBAC) rolga moslashing. Sidebar yozuvlari rolga asoslangan. Qarang [Security · RBAC](../security/rbac.md). |
| Yangi i18n kalitlari? | Ha — qarang [6-qadam](#6-i18n-kalitlarini-qoshish). |

## Retsept

### 1. Kontroller harakatini qo'shish (yoki qayta foydalanish)

Yuqori darajadagi ekran uchun kontroller `protected/controllers/` da yashaydi. Modul ekrani uchun u `protected/modules/<name>/controllers/` da yashaydi.

```php
// protected/modules/orders/controllers/OrderController.php
public function actionSummary()
{
    $rows = OrderService::summaryFor(Yii::app()->tenantContext);
    $this->render('summary', ['rows' => $rows]);
}
```

Konvensiyalar ([loyiha Conventions](../project/conventions.md)):

- **Yupqa kontrollerlar**. Biznes mantig'i kontrollerda emas, `OrderService` yoki shunga o'xshash narsada yashaydi.
- **DB yozuvlari inline emas**. Agar harakat holatni o'zgartirsa, ish navbatga qo'ying (`BaseJob`) — qarang [Jobs and scheduling](../architecture/jobs-and-scheduling.md).
- **Tenant scoping ni hurmat qiling**. `BaseFilial` dan meros olgan modellar uni avtomatik ravishda qo'llaydi; raw SQL tenant predikatini o'z ichiga olishi kerak.

### 2. View faylini yaratish

```
protected/modules/orders/views/order/summary.php
```

Papka kontroller nomi (kichik harf, `Controller` qo'shimchasisiz); fayl harakat (kichik harf).

Minimal view:

```php
<?php
/** @var array $rows */
$this->breadcrumbs = [
    Yii::t('orders', 'Orders') => ['/orders/order/list'],
    Yii::t('orders', 'Summary'),
];
?>

<h1><?= Yii::t('orders', 'Order summary') ?></h1>

<table class="table table-striped" id="orders-summary">
    <thead>
        <tr>
            <th><?= Yii::t('orders', 'Date') ?></th>
            <th><?= Yii::t('orders', 'Total') ?></th>
        </tr>
    </thead>
    <tbody>
        <?php foreach ($rows as $row): ?>
            <tr>
                <td><?= H::date($row['CREATE_AT']) ?></td>
                <td><?= Formatter::money($row['TOTAL']) ?></td>
            </tr>
        <?php endforeach; ?>
    </tbody>
</table>

<?php
Yii::app()->clientScript
    ->registerScriptFile('/js/orders-summary.js?v=' . VERSION);
?>
```

Eslatmalar:

- `$this->breadcrumbs` 2 chuqurlikdan keyin majburiy ([UI · Page layout](../ui/page-layout.md)).
- `H` va `Formatter` standart view yordamchilari ([Yii views · Yordamchilar](./yii-views.md#yordamchilar)).
- Har bir literal qatorni `Yii::t('<category>', '...')` ga o'rab oling ([Conventions · View-larda i18n](./conventions.md#view-larda-i18n)).
- `<?= VERSION ?>` so'rovi release-da cache-busting uchun — qarang [Boshlash · Frontend kodi aslida qayerdan keladi](./getting-started.md#frontend-kodi-aslida-qayerdan-keladi).

### 3. Sahifaga xos JS qo'shing

Agar sahifa shared snippet-lar qoplay olmaydigan JS ga muhtoj bo'lsa, uni `js/` ostiga tashlang:

```
js/orders-summary.js
```

[Conventions · `js/` dagi JS fayllari](./conventions.md#js-dagi-js-fayllari) ga ko'ra:

- Kichik harf, sahifaga xos nom.
- `$(function(){ ... });` da initsializatsiyani o'rab oling — jQuery 1.10 — minimum; inline skriptlarda `let` yo'q, arrow funktsiyalar yo'q (legacy fleet bo'ylab brauzer qo'llab-quvvatlashi shafqatsiz).
- `js_plugins/` dan bog'liq bo'lgan har qanday plaginni (Chosen, fancybox2 va boshqalar) sahifaga xos faylingizdan *oldin* view da ro'yxatdan o'tkazib havola qiling.

### 4. Sahifaga xos CSS qo'shing (faqat zarur bo'lsa)

```
css/orders-summary.css
```

View dan ro'yxatdan o'tkazing:

```php
Yii::app()->clientScript
    ->registerCssFile('/css/orders-summary.css?v=' . VERSION);
```

Faqat ikkita padding qiymatini o'rnatish uchun yangi fayl qo'shmang — avval mavjud utility klasslarini kengaytiring.

### 5. URL va menyuni ulash

#### URL

Modul ichidagi URL-lar uchun, Yii ning default routing-i `/<module>/<controller>/<action>` ni hal qiladi. Agar sizga go'zalroq route kerak bo'lsa, `protected/config/main_static.php` ning `urlManager.rules` ga qoida qo'shing ([Project structure · Nima qayerda yashaydi](../project/structure.md#what-lives-where) ga ko'ra).

#### Sidebar yozuvi

Sidebar elementlari `protected/views/partial/sidebar.php` da yashaydi ([Yii views · Papka](./yii-views.md#papka) ga ko'ra).

Mos rol tekshiruvi bilan himoyalangan element qo'shing:

```php
<?php if (Yii::app()->user->checkAccess('order_read')): ?>
    <li>
        <a href="<?= $this->createUrl('/orders/order/summary') ?>">
            <?= Yii::t('orders', 'Summary') ?>
        </a>
    </li>
<?php endif; ?>
```

(Aniq rol nomlarini [Security · RBAC](../security/rbac.md) dan tasdiqlang — yangi ruxsat kalitini ixtiro qilmang.)

### 6. i18n kalitlarini qo'shish

Ekran jo'natadigan har bir faol locale uchun kataloglarni oching:

```
protected/messages/ru/orders.php
protected/messages/en/orders.php
protected/messages/uz/orders.php
```

Har biri `return ['Source string' => 'Translation', ...]` massivi. View-da ishlatgan kalitlarni qo'shing.

Agar manba tili RU bo'lsa (aksariyat mavjud kataloglar shunday), `ru` faylingiz qatorni o'ziga xaritalashi mumkin — bu yaxshi.

[Conventions · View-larda i18n](./conventions.md#view-larda-i18n) ga ko'ra, RU-birinchi feature uchun faqat `ru` da jo'natishingiz mumkin, ammo bir xil release ichida EN + UZ ni rejalashtiring.

### 7. Brauzerda smoke-test

[Boshlash · Smoke-test ro'yxati](./getting-started.md#smoke-test-royxati-birinchi-sessiya) ga ko'ra:

- [ ] DevTools → Network → Disable cache.
- [ ] Yangi URL ni hard-refresh qiling. Sahifa render qilinishini, `/js/orders-summary.js` da 404 yo'qligini, `/css/...` da 404 yo'qligini tasdiqlang.
- [ ] Har bir interaktiv elementni bosing — jadval saralash, harakat menyusi, har qanday modal.
- [ ] Tilni RU → EN → UZ ga almashtiring — har bir ko'rinadigan qator o'zgarishini tasdiqlang (manba tiliga fallthrough yo'q).
- [ ] `protected/runtime/application.log` ni kuzating — sizning harakatingiz tomonidan chiqarilgan ogohlantirishlar yoki xatoliklar yo'qligini tasdiqlang.
- [ ] Admin bo'lmagan rol sifatida sinab ko'ring — sidebar elementi faqat rol tekshiruvi o'tganda ko'rinishini va to'g'ridan-to'g'ri URL hit-i 403 ni olishini tasdiqlang.

## Nusxa olish uchun ishlaydigan misol

Filtrli oddiy ro'yxat ekrani uchun, orders list view-i kanonik misol. [UI · Component katalogi](../ui/component-catalog.md) ga ko'ra, `protected/views/orders/list.php` default jadval + filter pattern-ini misol qilib ko'rsatadi. O'zingiznikini yozishdan oldin uni o'qib chiqing.

## PR uchun ro'yxat

Push qilishdan oldin:

- [ ] Kontroller harakati yupqa; mantiq xizmatda.
- [ ] View da breadcrumb-lar (chuqurlik > 2 bo'lsa) va asosiy harakat tugmasi (qo'llaniladigan bo'lsa) [UI · Page layout](../ui/page-layout.md) ga ko'ra mavjud.
- [ ] Barcha ko'rinadigan qatorlar `Yii::t()` ga o'ralgan.
- [ ] i18n kalitlari `ru`, `en`, `uz` kataloglarida mavjud.
- [ ] Sahifaga xos JS `js/<area>.js` ostida `?v=` cache-bust bilan.
- [ ] Sidebar yozuvi rolga himoyalangan.
- [ ] DevTools da console xatolari yo'q (legacy asosiy chizig'idan yuqori).
- [ ] Smoke testdan `application.log` da yangi yozuvlar yo'q.
- [ ] Branch nomi `feat/<short-desc>`, bitta mantiqiy o'zgarish ([Conventions · Git](../project/conventions.md#git-conventions) ga ko'ra).

## Ochiq savollar / TODO

- **Global `VERSION` konstantasini tasdiqlash** — `?v=` da ishlatiladigan belgi bu nomdan farq qilishi mumkin. Mavjud view-ning `registerScriptFile` chaqirig'ini tekshiring va pattern-ni nusxa oling.
- **Permission key nomlash** — yuqoridagi `order_read` illyustrativ. PR ga nusxa olishdan oldin haqiqiy kalitlar [Security · RBAC](../security/rbac.md) da yashashini tasdiqlang.
- **`sidebar.php` aniq yo'l** — [Yii views](./yii-views.md) dan `protected/views/partial/sidebar.php` sifatida tasdiqlangan, ammo faylda ishlatiladigan rol himoyasi yordamchisi ba'zi forklarda `Yii::app()->user->checkAccess(...)` dan farq qilishi mumkin; atrofdagi kodga moslang.
