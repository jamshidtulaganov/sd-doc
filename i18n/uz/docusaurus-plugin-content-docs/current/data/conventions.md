---
sidebar_position: 4
title: Ma'lumotlar konvensiyalari
---

# Ma'lumotlar konvensiyalari

## Identifikatorlar

- **Yangi jadvallar** `ID INT AUTO_INCREMENT` ishlatadi.
- **Eski jadvallar** sintetik qator (ko'pincha `<filial>_<seq>` yoki UUID-ga o'xshash format) ni o'z ichiga olgan `<ENTITY>_ID VARCHAR(32)` ishlatadi.
- **Tashqi ID-lar** `XML_ID` ustunida yashaydi. 1C, Didox, Faktura.uz bilan round-trip qilish uchun ishlatiladi.

## Casing

Bosh harf (`ORDER_ID`, `CLIENT_ID`) — legacy default; uni allaqachon ishlatayotgan jadvallarda saqlang. Yangi jadvallar snake_case kichik harfdan foydalanishi mumkin, lekin izchil bo'lsin.

## Soft delete

Deyarli hamma joyda `ACTIVE = 'Y' | 'N'`. Hard `DELETE` admin vositalari uchun saqlangan.

## Vaqt belgilari

- `CREATE_AT`, `UPDATE_AT` — `DATETIME`.
- `TIMESTAMP_X` — umumiy oxirgi-o'zgartirilgan belgi, sync delta-lari uchun ishlatiladi.

## Belgilar to'plami

Default belgilar to'plami — `utf8` (3-bayt). Ba'zi yangi jadvallar `utf8mb4` ishlatadi. Emoji-xavfsiz matn ustunlari uchun `CREATE TABLE` da aniq bo'ling.
