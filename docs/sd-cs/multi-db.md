---
sidebar_position: 2
title: Multi-DB connection
---

# Multi-DB connection

Unlike `sd-main` (one DB per request via `TenantContext`), `sd-cs` keeps
**two persistent DB connections** in parallel:

- `db` — sd-cs's own database (prefix `cs_`).
- `dealer` — the **dealer's** sd-main database (prefix `d0_`).

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

## Switching connection in models

ActiveRecord models targeted at the dealer DB override `getDbConnection`:

```php
class DealerOrder extends CActiveRecord {
    public function getDbConnection() {
        return Yii::app()->dealer;
    }
}
```

Models against the local `cs_*` schema use the default `db` connection.

## Multiple dealers

For a multi-dealer report, swap the `dealer` connection per iteration:

```php
foreach (DealerRegistry::all() as $dealer) {
    Yii::app()->setComponent('dealer', new CDbConnection(
        $dealer['dsn'], $dealer['user'], $dealer['pass']
    ));
    // ... read from dealer
}
```

In practice, sd-cs does this through a service that constructs
short-lived `CDbConnection` objects per dealer.

## Caveats

- Cross-DB JOINs are **not allowed** (different hosts in many setups).
  Aggregate in PHP instead.
- Writes to dealer DBs from sd-cs should be avoided; treat them
  read-only unless the operation is explicitly part of an admin tool.
