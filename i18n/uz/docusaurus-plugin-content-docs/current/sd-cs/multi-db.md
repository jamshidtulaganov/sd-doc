---
sidebar_position: 2
title: Multi-DB ulanish
---

# Multi-DB ulanish

`sd-main` dan farqli (har bir so'rov uchun bitta DB `TenantContext`
orqali), `sd-cs` parallel ravishda **ikkita doimiy DB ulanishini**
saqlaydi:

- `db` — sd-cs ning o'z ma'lumotlar bazasi (prefiks `cs_`).
- `dealer` — **diler**ning sd-main ma'lumotlar bazasi (prefiks `d0_`).

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

## Modellarda ulanishni almashtirish

Diler DB'ga mo'ljallangan ActiveRecord modellari `getDbConnection`'ni
override qiladi:

```php
class DealerOrder extends CActiveRecord {
    public function getDbConnection() {
        return Yii::app()->dealer;
    }
}
```

Lokal `cs_*` sxemasiga qarshi modellar default `db` ulanishidan
foydalanadi.

## Bir nechta dilerlar

Multi-diler hisobot uchun `dealer` ulanishini har iteratsiyada
almashtiring:

```php
foreach (DealerRegistry::all() as $dealer) {
    Yii::app()->setComponent('dealer', new CDbConnection(
        $dealer['dsn'], $dealer['user'], $dealer['pass']
    ));
    // ... dealer'dan o'qish
}
```

Amaliyotda sd-cs buni har bir diler uchun qisqa muddatli
`CDbConnection` obyektlarini quradigan xizmat orqali amalga oshiradi.

## Cheklovlar

- Cross-DB JOIN'lar **ruxsat etilmagan** (ko'p sozlamalarda turli
  hostlar). Buning o'rniga PHP'da agregatsiya qiling.
- sd-cs'dan diler DB'larga yozish'ni oldini olish kerak; agar amaliyot
  aniq admin asbobning bir qismi bo'lmasa, ularni read-only sifatida
  ko'rib chiqing.
