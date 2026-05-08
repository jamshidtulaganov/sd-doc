---
sidebar_position: 3
title: Lokal o'rnatish
---

# Lokal o'rnatish

## Old shartlar

- Docker Desktop (yoki Docker Engine + Compose)
- ~4 GB bo'sh RAM
- Git
- Test qilmoqchi bo'lgan dev subdomeni uchun lokal hosts yozuvi

## Ishga tushirish

```bash
git clone git@github.com:salesdoctor/sd-main.git
cd sd-main

# 1. Copy the sample local config (gitignored)
cp protected/config/main_sample.php protected/config/main_local.php

# 2. Build & start
docker compose up -d --build

# 3. Tail the logs
docker compose logs -f web
```

Stack quyidagilarni ochib beradi:

| Xizmat | URL |
|---------|-----|
| Web ilova | http://localhost:8080 |
| phpMyAdmin | http://localhost:8081 (root / root) |
| MySQL | `127.0.0.1:3306` (`jamshid` / `secret`) |
| Redis | `127.0.0.1:6379` |

## Ma'lumotlar bazasini seed qilish

Bugungi kunda to'liq avtomatlashtirilgan seed skripti yo'q. Ish jarayoni:

```bash
# Pull a sanitised dump from the team file share, then:
docker compose exec db mysql -uroot -proot sd_main < dump.sql
```

Agar dump ingiz bo'lmasa, jamoadoshingizdan so'rang yoki staging
muhitining read-only ko'zgusini ishlating.

## Test login

Yangi seed dagi standart hisob ma'lumotlari:

| Rol | Login | Parol |
|------|-------|----------|
| Super Admin | `admin` | `admin` |
| Agent | `agent1` | `123456` |

Ulardan tashqi har qanday muhit uchun ularni darhol o'zgartiring.

## Hot reload?

Yii kompilyatsiya qilmaydi, shuning uchun PHP fayllarni tahrirlash keyingi
so'rovda yangilanadi. JS/CSS o'zgarishlari brauzer yangilashi orqali
qabul qilinadi. Hot module replacement **yo'q** — bu server-rendered
ilova.

## Keng tarqalgan tuzoqlar

- **`runtime/` va `assets/` ga ruxsatlar** — `www-data` yoza olishini
  ta'minlang. Dockerfile ularni chown qiladi, lekin host bind mount uni
  buzishi mumkin.
- **PHP ogohlantirishlari log larni to'ldirmoqda** — ko'plab fayllar PHP
  7.3 davriga oid va PHP 8 ostida deprecation chiqaradi. Nima qilayotganingizni
  bilmasangiz, 7.3 da qoling.
- **`assets/` diskni to'ldiryapti** — vaqti-vaqti bilan
  `rm -rf assets/<hash>` qilib eskirgan chop etilgan bundlelarni tozalang.
