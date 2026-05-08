---
sidebar_position: 8
title: Lokal sozlash
---

# sd-billing lokal sozlash

```bash
git clone <repo> sd-billing
cd sd-billing

docker compose up -d                  # mysql :3308 da, web :3000 da

# Boshlang'ich sxema
docker compose exec web php protected/yiic.php migrate

# Ixtiyoriy: demo ma'lumotlarni yuklash (kichik / o'rta / katta)
# Mavjud bo'lsa doc/MOCK_SEED.md ga qarang
# docker compose exec web php docker/seed_mock_data.php

# Loglarni kuzatish
docker compose logs -f web

# Cron ishini ad-hoc ishga tushirish
docker compose exec web php cron.php notify
```

## Mount eslatmasi

Repo `web` konteyneriga `/var/www`da bind-mount qilingan. Host
tahrirlari darhol PHPda jonli.

## DB ulanishi

`MYSQL_HOST`, `MYSQL_PORT`, `MYSQL_DATABASE`, `MYSQL_USER`,
`MYSQL_PASSWORD` (`protected/config/db.php`) dan o'qiladi. Standartlar
docker-do'st (`mysql:3306`).

`protected/config/db.php` va `_db.php` ikkalasi gitignore qilingan. Agar
sizga lokal override kerak bo'lsa, `_db.php` → `db.php`ga nusxa ko'chiring.

## Composer

`composer.lock` mavjud, lekin `composer.json` **yo'q** — bog'liqlik
holati takrorlanmaydi. `doc/TESTING_PLAN.md` ning 0-bosqichi
`composer.json`ni qayta tiklaydi, shunda test infratuzilmasi o'rnatiladigan
bo'ladi.

Shu vaqtgacha vendor commit qilingan `vendors/` papka orqali bog'lab qo'yilgan.

## Migratsiyalar

```bash
cd protected && ./yiic migrate create <name>
./yiic migrate                                  # qo'llash
./yiic migrate down                             # oxirgisini orqaga qaytarish
```

Kuzatuv jadvali: `tbl_migration`. Fayl nomlash:
`mYYMMDD_HHMMSS_<snake>.php`. Har doim `safeUp` / `safeDown` ni amalga
oshiring — ular tranzaksiya ichida ishlaydi, shuning uchun siz xavfsiz
qayta ishga tushira olasiz.

## Sinov logini

Standart seed ma'lumotlari (bir martalik bo'lmagan envlar uchun darhol
almashtiring):

| Rol | Login | Parol |
|-----|-------|-------|
| Super-admin | `admin` | `admin` |
| Manager | `manager` | `123456` |

(Agar dampingiz farq qilsa, to'g'ri ma'lumotlar uchun jamoadan so'rang.)
