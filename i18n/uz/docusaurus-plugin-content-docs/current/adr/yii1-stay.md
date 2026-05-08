---
sidebar_position: 2
title: ADR-0001 — Yii 1.x da qolish
---

# ADR 0001 — Hozircha Yii 1.x da qoling

- Status: **Accepted**
- Date: 2024-09-12
- Deciders: Engineering leads

## Kontekst

Ilova 12+ yillik Yii 1.x kod bazasi bo'lib, `CActiveRecord`, magic
getter lar va bir qator vendor qilingan kengaytmalardan keng
foydalaniladi. PHP 7.3 ning hayoti tugagan. Yii 1.x rasmiy ravishda
qo'llab-quvvatlanmaydi, lekin community fork (`yii1/yii1-php8`) PHP 8
tuzatishlarini jo'natadi.

Biz quyidagilarni ko'rib chiqdik:

1. **Yii 1.x + PHP 7.3 da qoling** (status quo).
2. Community fork orqali **Yii 1.x + PHP 8.2**.
3. **Yii 2 / Yii 3 ga migratsiya.**
4. **Laravel ga migratsiya.**
5. **Strangler fig: bo'lakcha yangi freymvorka qayta yozish.**

## Qaror

Ko'rinadigan kelajak uchun **Yii 1.x** da qoling. Community fork bizning
test matritsamizdan o'tgandan so'ng flag ortida PHP 8.2 yangilanishini
rejalashtiring.

## Oqibatlar

- Qisqa muddatda nol qayta yozish narxi.
- Jamoadagi mavjud ko'nikmalar 1:1 uzatiladi.
- Fork yangilanishi kelmaguncha EOL PHP ni ishlashda davom ettirishimiz
  kerak.
- Yii 2 / Laravel ni kutgan yangi xodimlarni jalb qilish oson emas.
- Ba'zi zamonaviy xususiyatlar (typed properties, attributes) mavjud emas.

## Yumshatishlar

- Ilova oldida WAF.
- Agressiv konteyner yamoqlash davri.
- Yangi xususiyatlar strangler chegarasida joylashishi kerak, shunda biz
  keyingi major uchun freymvork tanlovini qayta ko'rib chiqishimiz
  mumkin.
