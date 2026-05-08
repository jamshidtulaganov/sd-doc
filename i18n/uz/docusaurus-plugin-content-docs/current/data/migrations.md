---
sidebar_position: 5
title: Migratsiyalar
---

# Migratsiyalar

Yii 1 o'zining migration vositasini taqdim etadi: `yiic migrate`.

## Yangi migratsiya yaratish

```bash
docker compose exec web php protected/yiic migrate create add_priority_to_orders
```

Bu `protected/migrations/m<YYMMDD_HHMMSS>_add_priority_to_orders.php` ni yaratadi.

## Qo'llash

```bash
# Kutilayotganlarni qo'llash
docker compose exec web php protected/yiic migrate up

# Oxirgisini qaytarish
docker compose exec web php protected/yiic migrate down
```

## Multi-tenant muammo

`yiic migrate` `main.php` dan **default** DB ga qarshi ishlaydi. Barcha tenantlarni migrate qilish uchun, takrorlang:

```bash
for db in $(mysql -uroot -proot -Nsre 'SHOW DATABASES LIKE "sd\\_%"'); do
  docker compose exec -e DB_NAME=$db web php protected/yiic migrate up
done
```

(yoki har takrorlashda `connectionString` ni almashtiruvchi wrapper script ishlating).

## Konvensiyalar

- Bir migratsiya = bitta mantiqiy o'zgarish.
- Hatto `return false;` bo'lsa ham, qaytarib bo'lmaydigan operatsiyalar uchun har doim `down()` ni taqdim eting.
- Migratsiya ichidan ilova kodiga havola qilmang — ularni iloji boricha sof SQL/DDL holida saqlang.
