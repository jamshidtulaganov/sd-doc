---
sidebar_position: 1
title: QA — jarayon va bilim bazasi
audience: QA jamoasi
summary: SalesDoctor (sd-cs · sd-main · sd-billing) uchun test rejalari, bug hisobotlari, jiddiylik ta'riflari, regression issiq nuqtalari va reliz tasdig'i.
topics: [qa, testing, regression, bug-report, sign-off]
---

# QA — jarayon va bilim bazasi

Ushbu sahifa **QA jamoa a'zolari** uchun. U test jarayoni,
shablonlarni va har bir relizda qayta sinashingiz kerak bo'lgan
SalesDoctor ga xos regression sohalarini qamrab oladi.

Mos FigJam bordlari [Workflow · QA process](https://www.figma.com/board/YvAliP5jI2oqizJeOReYxk)
va Workflow · Bug lifecycle (xuddi shu fayl).

## Bosqichlar

1. **Reja** — PRD ni o'qing, xususiyatlarni xavf bo'yicha tartiblang,
   qabul qilish mezonlarini aniqlang.
2. **Dizayn** — test holatlarini yozing (ijobiy, salbiy, chetga),
   test ma'lumotlarini to'plang, avtomatlashtirish nomzodlarini
   aniqlang.
3. **Bajarish** — smoke → funktsional → regression → E2E (mobil + web +
   api3 + api4) → unumdorlik.
4. **Buglar** — takrorlash → fayl qo'yish → triage → tuzatish →
   tekshirish → yopish.
5. **Tasdiq** — UAT, reliz eslatmalari, go / no-go.

## Test rejasi shabloni

```md
# Test plan: <feature>

## Scope
- Included: ...
- Excluded: ...

## Risk assessment
| Risk | Likelihood | Impact | Mitigation |

## Environments
- Dev: ...
- Staging: ...
- Prod: ...

## Approach
- Manual: ...
- Automation: ...

## Entry / exit criteria
## Test cases
| ID | Title | Steps | Expected | Priority |

## Schedule & owners
```

## Bug hisoboti shabloni

```md
# <one-line summary>
- Severity: S1 / S2 / S3 / S4
- Priority: P0 / P1 / P2 / P3
- Environment: prod / staging / dev
- Build / version: <git sha>
- Tenant: <subdomain>
- Role: <Agent / Admin / ...>

## Steps to reproduce
1. ...
2. ...

## Actual
## Expected
## Evidence
- Screenshots
- HAR / logs

## Reproducibility
- 5/5 — always
- 3/5 — intermittent
```

## Jiddiylik ta'riflari

| Sev | Ta'rif |
|-----|--------|
| S1 | Production o'chgan yoki ma'lumot buzilgan |
| S2 | Asosiy xususiyat ishlamaydi, vaqtinchalik yechim yo'q |
| S3 | Asosiy xususiyat pasaygan, vaqtinchalik yechim mavjud |
| S4 | Kichik / kosmetik |

## SalesDoctor ga xos regression issiq nuqtalari

Bular regressiyalar yashirinadigan yuqori qiymatli sohalar. Har bir
relizda uchta loyiha bo'ylab ularni qayta sinang.

### sd-main

| Soha | Nimani tekshirish | Nima uchun muhim |
|------|-------------------|------------------|
| Buyurtma status o'tishlari | Har bir STATUS / SUB_STATUS sakrashi (`Draft → New → Reserved → Loaded → Delivered → Paid → Closed`, shuningdek `Cancelled` / `Defect` / `Returned`) | Qotib qolgan buyurtmalar pul yo'q degani |
| Multi-tenant izolyatsiyasi | Subdomen almashtirish hech qachon ma'lumot oqmaydi — A tenantida login, B tenantida so'rov → kirish rad etilgan | Muvofiqlik, shartnoma |
| Kesh invalidatsiyasi | Narx / kategoriyani tahrirlash → keyingi o'qish ≤ 10 daqiqa ichida yangi qiymatni ko'rsatadi | Mijozlar noto'g'ri narxlar haqida qo'ng'iroq qiladi |
| Mobil offline → sync | Telefonni tashrif o'rtasida offline qiling, buyurtmalarni oling, ulanishni qayta tiklang | Haydovchilar o'lik zonalarida |
| 1C / Didox / Faktura.uz round-trip | Buyurtma jo'nating, u to'g'ri INN + VAT bilan 1C da paydo bo'lishini tekshiring | Muvofiqlik / diler buxgalteriyasi |
| GPS geofence | Radius ichida va tashqarisida tashrif | KPI aniqligi |
| Bonus order linkage | Bonus buyurtma `BONUS_ORDER_ID` orqali qaytib ulanadi | Settlement yaxlitligi |

### sd-cs

| Soha | Nimani tekshirish |
|------|-------------------|
| Dilerlar bo'ylab hisobot mosligi | Diler bo'yicha qatorlar yig'indisi == HQ aggregati ± 0 |
| Diler sxema drift | Turli sd-main versiyalaridagi dilerlarga qarshi hisobotni ishga tushiring |
| Faqat o'qish ijrosi | sd-cs `d0_*` jadvalida UPDATE qila olmaydi (qasddan buzilgan so'rov bilan sinab ko'ring) |
| Tenant bo'yicha kesh | A diler uchun keshni yangilash B ga ta'sir qilmaydi |

### sd-billing

| Soha | Nimani tekshirish |
|------|-------------------|
| Click prepare/confirm | Bir xil trans id bilan confirm ni qayta yuboring — bir xil javob, ikki marta to'lov yo'q |
| Payme idempotentligi | `CreateTransaction` qayta urinilgan — ikki nusxa Payment qatori yo'q |
| Settlement | Distributor + diler juftligi oy uchun nolga teng |
| Litsenziya muddati → eslatma | Muddati minus 7/3/1 kun → Telegram + SMS yuborildi |
| Obunani yangilash | Yangi `Payment` qator `Diler.refresh()` ni darhol ishga tushiradi |
| Notify-cron drain | `d0_notify_cron` navbati bir daqiqada bo'shaydi |

## Bajarildi = bu tekshiruvlar o'tadi

- [ ] Barcha P0 / P1 holatlari bajarilgan
- [ ] Ochiq S1 / S2 buglar yo'q
- [ ] Regression suite yashil
- [ ] Unumdorlik bazasi oxirgi relizdan ±10 % ichida
- [ ] EN / RU / UZ da reliz eslatmalari ishlab chiqilgan

## Foydali ichki havolalar

- [Modullar umumiy ko'rinishi](../modules/overview.md) — nimani sinashni
  topish uchun
- [API ma'lumotnomasi](../api/overview.md) — endpoint darajasidagi
  test holatlari uchun
- [sd-billing xavfsizlik tuzoqlari](../sd-billing/security-landmines.md) —
  faol xavflar
- [sd-cs ↔ sd-main integratsiya](../sd-cs/sd-main-integration.md) —
  cross-DB stsenariylari
