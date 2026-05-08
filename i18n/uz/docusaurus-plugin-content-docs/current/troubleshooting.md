---
sidebar_position: 99
title: Muammolarni bartaraf etish
---

# Muammolarni bartaraf etish

## "Cannot resolve tenant" / bo'sh sahifa

**Sababi**: `HTTP_HOST` mavjud tenantga mos kelmaydi.

- Nginx `server_name` va `fastcgi_param HTTP_HOST $host;` ni tekshiring.
- Tenantning registryda mavjudligini tasdiqlang.
- Hal qilish nosozligi uchun `protected/runtime/application.log` ni
  tekshiring.

## 500 — `Class 'X' not found`

**Sababi**: `main_static.php` da yetishmayotgan `import` direktivasi yoki
autoload o'tkazib yuborildi.

- `import` ga `application.modules.<module>.models.*` ni qo'shing.
- Agar bu xizmat bo'lsa, fayl `protected/components/` ostida ekanligini
  ta'minlang.

## "Срок лицензии программы истёк"

**Sababi**: tenantning litsenziyasi muddati tugagan (`hasSystemActive`
false qaytaradi).

- Super-admin UI orqali ushbu tenant uchun litsenziya yozuvini yangilang.
- Litsenziya jadvalidagi sana / system-id juftliklarini tekshiring.

## Mobil login bajarilmaydi (api3)

- `deviceToken` bo'sh emasligini tasdiqlang.
- Parol hash formatini tasdiqlang — eski foydalanuvchilar hali ham MD5
  bo'lishi mumkin (birinchi loginda shaffof).
- Foydalanuvchining `ACTIVE = 'Y'` va system 4 uchun litsenziya faolligini
  tekshiring.

## Excel eksport OOM

- Eksport ehtimol hammasini PHPExcel obyektlariga yuklaydi.
- > 10k qator uchun `XLSXWriter` orqali oqimga yoki bo'lakli CSV ga
  o'tkazing.

## Navbat bo'shatilmayapti

- Ishchilar quladi. Supervisor ni tekshiring.
- `LLEN sd_queue:default` monoton ko'tarilmasligi kerak.
- Birinchi elementni tekshiring: `LRANGE sd_queue:default 0 0` — keng
  tarqalgan sabab — har bir qayta urinishda istisno tashlaydigan poison
  pill.

## Redis db2 o'sib bormoqda

- Yangi kod yo'li TTLsiz yozadi. Yaqinda o'zgargan fayllarda `set(.*null`
  yoki yalang'och `set(` chaqiruvlarini qidiring.
- Aybdorlarni topish uchun `MEMORY USAGE <prefix>:*`.

## "Cannot redeclare class"

- Ikkita fayl bir xil klassni belgilaydi. Yaqinda nomi o'zgartirilganlarga
  qarang; eski fayl nomi hali ham `*.obsolete` sifatida mavjud bo'lishi
  mumkin, lekin Composer / Yii ikkalasini ham yuklayapti.
