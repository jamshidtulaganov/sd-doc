---
sidebar_position: 5
title: Конфигурация
---

# Конфигурация

Конфиг Yii — это **один PHP-массив**, собираемый при старте. SalesDoctor
делит его на три слоя, которые мерджатся сверху вниз:

```
main_static.php   ← Shared base (modules, components, urlManager, …)
main.php          ← Tenant defaults (DB credentials, params)
main_local.php    ← Per-host overrides (gitignored)
```

`index.php` загружает `main.php`, который в свою очередь `require`-ит
`main_static.php` и в конце мерджит `main_local.php`.

## Ключевые секции

### База данных

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

`dbname` — это *дефолтная* БД. Реальная per-tenant БД выбирается
`TenantContext` после начала запроса.

### Redis (3 логические БД)

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

### Модули

Плоский массив `modules` включает каждый feature-модуль. Добавьте
новую папку модуля под `protected/modules/` и добавьте её имя сюда.

### Локаль

```php
'onBeginRequest' => function ($event) {
    // resolves lang from ?lang=, cookie, or default 'ru'
    // Allowed: ru, en, uz, tr
}
```

## Params

Булевы и feature-флаги живут в `params`:

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

Читайте через `Yii::app()->params['enableNewCreateOrder2']`.

## Окружение-специфичные оверрайды

`main_local.php` — правильное место для:

- Других `db.host` / credentials
- Указания Redis на удалённый кластер
- Включения Gii (`'gii' => [...]`)
- Отключения определённых модулей в продакшене

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
