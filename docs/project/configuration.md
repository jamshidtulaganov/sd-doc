---
sidebar_position: 5
title: Configuration
---

# Configuration

Yii's config is **a single PHP array** assembled at boot. SalesDoctor splits
it into three layers that merge top-down:

```
main_static.php   ← Shared base (modules, components, urlManager, …)
main.php          ← Tenant defaults (DB credentials, params)
main_local.php    ← Per-host overrides (gitignored)
```

`index.php` loads `main.php`, which in turn `require`s `main_static.php` and
finally merges `main_local.php`.

## Key sections

### Database

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

`dbname` is the *default* DB. The real per-tenant DB is selected by
`TenantContext` after the request begins.

### Redis (3 logical DBs)

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

### Modules

The flat `modules` array enables every feature module. Add a new module
folder under `protected/modules/` and add its name here.

### Locale

```php
'onBeginRequest' => function ($event) {
    // resolves lang from ?lang=, cookie, or default 'ru'
    // Allowed: ru, en, uz, tr
}
```

## Params

Booleans and feature flags live in `params`:

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

Read with `Yii::app()->params['enableNewCreateOrder2']`.

## Environment-specific overrides

`main_local.php` is the right place for:

- Different `db.host` / credentials
- Pointing Redis at a remote cluster
- Enabling Gii (`'gii' => [...]`)
- Disabling certain modules in production

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
