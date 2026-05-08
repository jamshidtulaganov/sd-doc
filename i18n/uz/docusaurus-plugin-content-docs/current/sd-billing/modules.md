---
sidebar_position: 3
title: Modullar
---

# sd-billing modullari

## `api` — kiruvchi integratsiyalar

To'lov shlyuzlari, 1C, SD-app, hamkor tizimlari va admin vositalardan
veb-hooklar va mashinalararo chaqiruvlarni qabul qiladi.

| Submodul | Maqsad |
|----------|--------|
| `Click` | Click shlyuzi prepare/confirm |
| `Payme` | Payme JSON-RPC |
| `Paynet` | Paynet SOAP (`extensions/paynetuz`) |
| `License` | Litsenziyalarni so'rash/yangilash uchun qattiq kodlangan `TOKEN`-himoyalangan endpointlar |
| `Sms` | Kiruvchi SMS veb-hooklari (DLR) |
| `Host` | `sd-main` dan server holati callbacklari |
| `Quest` | Maxsus quest endpointlari |
| `Info` | Ochiq ma'lumot / health |
| `Maintenance` | Tozalovchi / migratsiya utilitalari |

Auth har kontroller uchun farq qiladi:
- `LicenseController::TOKEN` — qattiq kodlangan konstanta.
- `ClickController` — shlyuz sign tekshiruvi (`checkSign`).
- `PaymeController` — Payme HMAC tekshiruvi.
- Bir nechta endpointlar `new UserIdentity("sd","sd")` orqali qattiq
  foydalanuvchi sifatida kiradi (masalan, `actionBuyPackages`,
  `actionExchange`).

API javoblari `application.modules.api.components.*` ostida aniqlangan
`sendSuccessResponse` / `sendFailResponse` yordamchilaridan foydalanadi.

## `dashboard` — ichki admin UI

Operatsion jamoaning asosiy ekrani. Dilerlar, distribyutorlar,
to'lovlar, obunalar, jadvallar, qotib qolgan yozuvlarni tuzatishni ro'yxatlaydi.

## `operation` — domen CRUD

Yozuv trafigining ko'pchiligi sodir bo'ladigan joy. Quyidagilarga ega:

- Paketlar
- Obunalar
- To'lovlar
- Tariflar
- Qora ro'yxat
- Bildirishnomalar

## `partner` — o'z-o'ziga xizmat ko'rsatish portali

Hamkorlar (`ROLE_PARTNER`) o'z dilerlarini va daromadlarini ko'rish uchun
bu yerda kiradi. `PartnerAccessService::checkAccess` tomonidan `partner` va
`directory` modullari + `dashboard/dashboard/index` + `site/*` bilan
cheklangan. (Hozirda bu tekshiruv asosiy kontrollerda **kommentda olib
tashlangan** — xavfsizlik landminalari sahifasiga qarang.)

## `cashbox`

Kassa stollari va oflayn to'lov manbalari. Kassalar o'rtasidagi pul
o'tkazmalari va iste'molni kuzatadi.

## `report`

Hisobot ekranlari — sekinroq agregatlar, ko'pincha PHPExcel eksport.

## `setting`

Ilova sozlamalari + tizim log ko'ruvchisi.

## `notification` — ilova ichidagi

Ilova ichidagi bildirishnomalar (boshqaruv panelidagi qo'ng'iroq belgisi).

## `sms`

SMS shablonlari + yuborish. Provayder:

- **Eskiz** (`notify.eskiz.uz`) UZ uchun
- **Mobizon** KZ uchun

Qattiq kodlangan ma'lumotlar `protected/components/Sms.php`da yashaydi
(xavfsizlik landminasi — alohida sahifaga qarang).

## `bonus`

Bonus / chegirma mantiqi. Choraklik xulosalar.

## `access`

Har-foydalanuvchi ruxsat to'ri: `AccessUser`, `AccessOperation`,
`AccessRelation`. Amallarda bit-flag kirishi bor:

```
DELETE = 8
SHOW   = 4
UPDATE = 2
CREATE = 1
```

`Access::has($operation, $type_access)` — tekshiruv; `Access::check()`
o'tib ketganda `CHttpException(403)` tashlaydi. Adminlar (`ROLE_ADMIN`
yoki `IS_ADMIN`) ruxsat berishga qisqa-tutashadi.

## `directory`

Ma'lumotnomalar / havola ma'lumotlari (shaharlar, davlatlar, valyutalar,
paket turlari va h.k.).

## `dbservice`

DB texnik xizmatlar utilitalar — ommaviy tuzatishlar, ad-hoc ma'lumotlar
migratsiyalari, diagnostika so'rovlari.
