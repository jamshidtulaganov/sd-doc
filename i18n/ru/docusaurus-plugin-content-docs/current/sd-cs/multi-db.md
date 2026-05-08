---
sidebar_position: 2
title: Multi-DB connection
---

# Multi-DB connection

В отличие от `sd-main` (одна БД на запрос через `TenantContext`), `sd-cs` держит
**два постоянных DB-подключения** параллельно:

- `db` — собственная база sd-cs (префикс `cs_`).
- `dealer` — БД sd-main **дилера** (префикс `d0_`).

`db_sample.php`:

```php
return [
    'db' => [
        'connectionString' => 'mysql:host=localhost1;dbname=<country>',
        'tablePrefix' => 'cs_',
    ],
    'dealer' => [
        'class' => 'CDbConnection',
        'connectionString' => 'mysql:host=localhost2;dbname=<dealer>',
        'tablePrefix' => 'd0_',
    ],
];
```

## Переключение подключения в моделях

Модели ActiveRecord, нацеленные на dealer-DB, переопределяют `getDbConnection`:

```php
class DealerOrder extends CActiveRecord {
    public function getDbConnection() {
        return Yii::app()->dealer;
    }
}
```

Модели против локальной схемы `cs_*` используют дефолтное подключение `db`.

## Несколько дилеров

Для multi-dealer отчёта меняйте подключение `dealer` на каждой итерации:

```php
foreach (DealerRegistry::all() as $dealer) {
    Yii::app()->setComponent('dealer', new CDbConnection(
        $dealer['dsn'], $dealer['user'], $dealer['pass']
    ));
    // ... read from dealer
}
```

На практике sd-cs делает это через сервис, конструирующий
short-lived объекты `CDbConnection` на каждого дилера.

## Caveats

- Кросс-БД JOIN **не разрешены** (разные хосты во многих установках).
  Агрегируйте в PHP вместо этого.
- Записей в дилерские БД из sd-cs следует избегать; относитесь к ним
  read-only, если только операция явно не часть admin-инструмента.
