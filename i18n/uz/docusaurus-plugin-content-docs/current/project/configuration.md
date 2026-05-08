---
sidebar_position: 5
title: Konfiguratsiya
---

# Konfiguratsiya

Yii ning konfiguratsiyasi — boot vaqtida yig'iladigan **bitta PHP massiv**.
SalesDoctor uni yuqoridan pastga birlashtiriladigan uchta qatlamga
ajratadi:

```
main_static.php   ← Shared base (modules, components, urlManager, …)
main.php          ← Tenant defaults (DB credentials, params)
main_local.php    ← Per-host overrides (gitignored)
```

`index.php` `main.php` ni yuklaydi, u o'z navbatida `main_static.php` ni
`require` qiladi va nihoyat `main_local.php` ni birlashtiradi.

## Asosiy bo'limlar

### Ma'lumotlar bazasi

```php
'db' => [
    'connectionString' => 'mysql:host=db;dbname=sd_main',
    'username' => 'jamshid',
    'password' => 'secret',
    'tablePrefix' => 'd0_',
    'emulatePrepare' => true,
    'charset' => 'utf8',
],
```

`dbname` — bu *standart* DB. Haqiqiy har bir tenant uchun DB so'rov
boshlangandan keyin `TenantContext` tomonidan tanlanadi.

### Redis (3 mantiqiy DB)

```php
'redis_session' => [ 'class' => 'CRedisCache', 'database' => 0, 'keyPrefix' => $_SERVER['HTTP_HOST'].':' ],
'queueRedis'    => [ 'class' => 'RedisConnection', 'database' => 1 ],
'redis_app'     => [ 'class' => 'CRedisCache', 'database' => 2 ],
```

### Auth

```php
'authManager' => [
    'class' => 'application.components.DbAuthManager',
    'connectionID' => 'db',
    'itemTable' => 'authitem',
    'cachingDuration' => 600,
    'tenantContextID' => 'tenantContext',
],
```

### Modullar

Yassi `modules` massivi har bir xususiyat modulini yoqadi.
`protected/modules/` ostida yangi modul papkasini qo'shing va uning nomini
shu yerga qo'shing.

### Lokal

```php
'onBeginRequest' => function ($event) {
    // resolves lang from ?lang=, cookie, or default 'ru'
    // Allowed: ru, en, uz, tr
}
```

## Paramslar

Boolean lar va xususiyat flag lari `params` da yashaydi:

```php
'params' => [
    'enableNewCreateOrder2' => true,
    'enableOrderList2'      => true,
    'enableMarkupPerProduct'=> true,
    'enableImportOrders'    => true,
    'allowDisablingStockCheck' => true,
    'numberFormat' => 2,
    // …
]
```

`Yii::app()->params['enableNewCreateOrder2']` bilan o'qing.

## Muhitga xos overrideslar

`main_local.php` quyidagilar uchun to'g'ri joy:

- Boshqa `db.host` / hisob ma'lumotlari
- Redis ni masofaviy klasterga yo'naltirish
- Gii ni yoqish (`'gii' => [...]`)
- Production da ba'zi modullarni o'chirish

```php
return [
    'components' => [
        'db' => [ 'connectionString' => 'mysql:host=10.0.0.5;dbname=sd_main' ],
    ],
    'modules' => [
        'gii' => false,
    ],
];
```
