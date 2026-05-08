---
sidebar_position: 7
title: Komponent katalogi (wireframe-darajasidagi)
audience: New frontend / mobile developers
summary: SalesDoctor admin-dagi qayta foydalanish mumkin bo'lgan UI qismlarining wireframe darajasidagi katalogi — har bir qism nima, qayerda paydo bo'ladi va yangisi kerak bo'lganda nimadan nusxa olish kerak.
topics: [components, ui-patterns, table, kpi-tile, breadcrumb, pagination, modal, form-section]
---

# Komponent katalogi (wireframe-darajasidagi)

Bu **wireframe darajasidagi** komponent katalogi. U admin-da ko'radigan har bir qayta foydalanish mumkin bo'lgan UI qismini, uning nima uchun ishlatilishini va mavjud amalga oshirish qayerda yashashini ro'yxatga oladi. Bu **Storybook emas** — vizual dizayn `SD-Web-old.fig` da yashaydi.

Yangi narsa qurganda, bu yerda eng yaqin moslikni toping va uning markup pattern-ini qayta ishlating.

## Joylashuv chrome-i

### Yuqori panel

```
┌──────────────────────────────────────────────────────────────┐
│  ☰  LOGO  | Sales · Касса · GPS · Онлайн-помощь | 🔍 search   │
│                       date-range · 💰 balance · 🔔 · 👤      │
└──────────────────────────────────────────────────────────────┘
```

**Qayerda**: har bir sahifa. **Markup**: `protected/views/layouts/main.php` → `views/partial/topbar.php`.

### Chap rail (sidebar)

```
🗒  Планы
📑  Заявки
📦  Склад
👥  Клиенты
🛵  Агенты
📊  Отчёты
⚙  Настройки
🔍  Аудит
👨‍👩‍👧  Команда
🩺  Диагностика
```

**Qayerda**: har bir sahifa (modal-only view-lardan tashqari). **Rolga asoslangan** — RBAC foydalanuvchi kira olmaydigan elementlarni yashiradi.

### Breadcrumbs

`Dashboard › Orders › List` — 2 chuqurlikdan keyin majburiy.

### Sahifa header-i

```
Page Title                                       [+ New thing]
```

Asosiy harakat yuqori-o'ngda. Ikkilamchi harakatlar `⋮` overflow-da.

## Tabular komponentlar

### Default ma'lumot jadvali

| col | col ↕ | col | … | ⋮ |

- Birinchi ustun = qator raqami yoki checkbox (multi-select)
- Header qatori sticky
- `↕` saralanadiganligini bildiradi
- Pul ustunlari o'ng tomonga tekislanadi
- Status ustuni = rangli pill (pastdagi Status pill ga qarang)
- Oxirgi ustun = qator harakatlari bilan `⋮` (Tahrirlash / Dublikat / O'chirish)
- Footer: sahifalash + sahifa hajmi tanlovchisi + jami soni

**Qayerda**: har bir list ekrani (orders, clients, agents, payments, …). **Kutubxona**: DataTables + `js_plugins/FixedColumns`.

### Guruhlangan / kengaytiriladigan jadval

```
▶ Group A    sum=…    count=…
  ┌─ row …
  └─ row …
▶ Group B
```

**Qayerda**: iyerarxik hisobotlar (per-agent → per-order, per-category → per-product).

### Inline-edit jadval kataki

Katakni ikki marta bosing → u input ga aylanadi → blur yoki Enter AJAX orqali saqlaydi.

**Qayerda**: narx turlari, kategoriyalar, agent sozlamalari.

## Plitka / kart komponentlari

### KPI plitka

```
┌─ Title ───────────────────────────┐
│  1,247                            │
│  Plan: 161        Fact: 3 + 0     │
└───────────────────────────────────┘
```

- Katta raqam
- Ehtiyotkor plan / fact qatori
- Fon rangi = chegara (qizil / kahrabo / yashil)
- Desktop-da qatorga 4 ta, ≤ 1024 px da 2 ta

**Qayerda**: dashboard. **Wireframe**: [page-0](/wireframes/extracted-from-figma/page-0-1512w.png).

### Detal panel kart

```
┌─ Card title ──────────────────────┐
│  Field 1:    value                │
│  Field 2:    value                │
│  …                                │
└───────────────────────────────────┘
```

**Qayerda**: client detal, agent detal, order xulosasi.

## Status pill-lari

| Fon | Ma'no |
|------------|---------|
| Yashil | OK / To'langan / Yetkazilgan / Faol |
| Kahrabo | Kutilmoqda / Tasdiqlash kutilmoqda |
| Qizil | Bekor qilingan / Defekt / Muddati o'tgan |
| Kulrang | Qoralama / Yopiq / Arxivlangan |
| Ko'k | Jarayonda / Yuklangan |

Pill ichidagi matn yorlig'ini har doim qo'shing — rang to'ldiruvchi, hech qachon yagona signal emas (kirish imkoniyati).

## Filtrlar

### Yuqori filter paneli

```
[ Date range ▾ ] [ Status ▾ ] [ Agent ▾ ] [ + More filters ]   [ Apply ]
```

- ≤ 6 ko'rinadigan chip, qolganlari "More filters" ortida yig'iladi.
- Default sana = oxirgi 30 kun.
- Filter holati URL query params-da saqlanadi (havolalar bilan baham ko'rilishi mumkin bo'lsin).

### Filter rail (chap, og'ir hisobotlar uchun)

```
▣  Date
   From [_]
   To   [_]
▣  Status
   ☑ New / ☐ Loaded / ☑ Paid
▣  Agent
   [Search ]
[Apply] [Reset]
```

**Qachon foydalanish kerak**: ≥ 10 filter yoki guruhlash kerak bo'lganda.

## Formalar

### Bo'limli forma

```
┌─ Section title ──────────────────────┐
│  Field   [_______________________]   │
│  Field   [______]   Toggle  ☑        │
└──────────────────────────────────────┘
```

- Desktop-da ikki ustun, tor da bitta ustun.
- Majburiy maydonlar qizil yulduzcha bilan belgilanadi.
- Inline validatsiya har maydonga; cross-field xatolari uchun yuqorida banner.
- Viewport-dan uzunroq formalar uchun sticky footer.
- Asosiy `Save` (o'ng), ikkilamchi `Cancel` (chap); plus ixtiyoriy `Save and add another`.

### Inline tahrirlash

Ikki marta bosish → input → blur / Enter saqlaydi. Narx turlari, kategoriyalar, agent sozlamalari uchun ishlatiladi.

## Modallar

### Tasdiqlash modali

```
┌── Cancel order #O-2026-0123 ────────┐
│                                      │
│  This will release reserved stock    │
│  and mark the order as cancelled.    │
│  This cannot be undone.              │
│                                      │
│           [Cancel]  [Confirm]        │
└──────────────────────────────────────┘
```

- Sarlavha = harakat fe'li + obyekt (`Cancel order #…`).
- Tana ≤ 80 so'z. Oqibatlar haqida aniq bo'ling.
- Asosiy harakat o'ng tomonda; **buzilishli asosiy qizil rangda**.
- Esc yopadi; Enter asosiyni ishga tushiradi, agar textarea ichida bo'lmasa.
- **Modallarni stack qilmang.**

### Modal-ichida tahrirlash

Tezkor tahrirlash uchun (≤ 8 maydon). ≥ 8 maydon uchun uning o'rniga to'liq sahifani oching.

**Kutubxona**: `js_plugins/fancybox2`.

## Xarita komponentlari

### To'la-bleed xarita + o'ng panel

```
┌──────────────────────────────────┬────────────┐
│                                  │  Tabs      │
│           map                    │  filters   │
│                                  │  list      │
└──────────────────────────────────┴────────────┘
```

**Qayerda**: GPS monitoring, marshrut ko'rinishi, geofence tekshirish.
**Wireframes**: [page-2](/wireframes/extracted-from-figma/page-2-2922w.png), [page-13](/wireframes/extracted-from-figma/page-13-2922w.png), [page-25](/wireframes/extracted-from-figma/page-25-2942w.png).
**Kutubxona**: `ng-modules/gps/` ostidagi Angular moduli.

### Sayohat-takrorlash boshqaruvlari

```
[ ◀ ] [ ⏯ ] [ ▶ ]   1× / 2× / 4×
[━━━●━━━━━━━━━]   00:00 / 24:00
```

**Qayerda**: GPS tarixi. **Wireframe**: [page-26](/wireframes/extracted-from-figma/page-26-2918w.png).

## Bildirishnomalar

### Toast

Yuqori-o'ng, 5 s dan keyin avtomatik yo'q bo'ladi. Kutubxona: `js_plugins/noty`.

### In-app qo'ng'iroq

Yuqori paneldagi qo'ng'iroq belgisi → so'nggi bildirishnomalar dropdown-i. Elementlar tegishli obyektga havola qiladi.

### Banner (sahifa darajasida)

Kontent maydonining yuqorisi. Buni quyidagilar uchun ishlating:

- "Litsenziya 3 kunda muddati tugaydi" (ogohlantirish)
- "Oxirgi sinxronizatsiyangiz muvaffaqiyatsiz tugadi" (xato)
- "Yangi release notes mavjud" (info)

## Charts

`js_plugins/jquery-highcharts-10.3.3`. Foydalaning:

- **Line** vaqt ichidagi tendensiyalar uchun.
- **Column** davr bo'yicha taqqoslash uchun.
- **Pie** kam-kamdan — faqat 100 % ga qadar yig'ilgan ≤ 5 bo'lak uchun.
- **Combo** (line + bar) plan vs fact uchun.

## Bosma shablonlar

`protected/views/invoiceTemplate/`. Tenant-ga, **Settings → Templates** ostida sozlangan.

## Mobile (web admin) responsive

Admin **desktop-birinchi** (1280 × 800 minimum). Bundan past:

- Sidebar faqat-icon ga yig'iladi.
- Jadvallar gorizontal ravishda oshib ketadi, sticky birinchi ustun bilan.
- Modallar to'la-ekran bo'ladi.

Web admin uchun tor-telefon layout-i yo'q — telefon foydalanuvchilari maxsus mobil ilovadan foydalanadi.

## Qachon yangi komponent qo'shish kerak

Qo'shmang, faqat:

- Mavjud qismlardan ehtiyojni tuza olmasangiz.
- Bir xil ehtiyoj **3 +** ekranda paydo bo'lsa.
- Dizayn yetakchidan tasdiq olgan bo'lsangiz.

Agar ha bo'lsa, wireframe PNG ni `static/wireframes/` ga qo'shing va shu PR da bu katalogga qatorni qo'shing.
