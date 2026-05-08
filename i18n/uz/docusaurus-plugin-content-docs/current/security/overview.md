---
sidebar_position: 1
title: Xavfsizlik umumiy ko'rinishi
---

# Xavfsizlik umumiy ko'rinishi

| Soha | Yondashuv |
|------|-----------|
| Autentifikatsiya | DB da saqlangan ma'lumotlar, MD5 (legacy) — izohlarga qarang |
| Sessiyalar | Redis db0, `HTTP_HOST` keyPrefix |
| Avtorizatsiya | `DbAuthManager` `authitem` ustida + keshlangan |
| Tenant izolyatsiyasi | Subdomen → DB; kesh tenant + filial bo'yicha prefikslangan |
| Transport | Nginx da TLS |
| Saqlangan ma'lumot | MySQL + fayl tizimi; backuplar shifrlangan |
| Maxfiy ma'lumotlar | `main_local.php` (commit qilinmaydi); 1C / Didox / Faktura.uz hisobga olish ma'lumotlari tenant sozlamalarida |
| Audit | `IntegrationLog`, `OrderStatusHistory`, `audit_*` jadvallar |
| Rate limiting | IP / foydalanuvchi bo'yicha login throttling |

## Ma'lum zaif tomonlar (e'tiborli bo'ling)

- **MD5 parollar** — tarixiy; vaqt o'tishi bilan bcrypt ga o'tkazilishi kerak.
  `LoginController` o'tish davrida ikkalasini ham qo'llab-quvvatlaydi.
- **Yii 1 CSRF** — sukut bo'yicha yoqilgan, lekin bir nechta legacy POST
  endpointlar uni chetlab o'tadi. Yangilarini qo'shishdan oldin tekshiring.
- **PHP 7.3** — upstream xavfsizlik qo'llab-quvvatlanishidan tashqarida.
  WAF va tez-tez OS darajasidagi yangilanishlar bilan qoplang.

## Zaiflik haqida xabar berish

`security@salesdoc.io` ga tavsif va takrorlash bilan email yuboring.
Iltimos, xavfsizlik xatolari uchun ommaviy GitHub issue ochmang.

## Sahifalar

- [Auth va rollar](./auth-and-roles.md)
- [RBAC](./rbac.md)
- [Sessiyalar](./sessions.md)
- [Ma'lumotlar izolyatsiyasi](./data-isolation.md)
