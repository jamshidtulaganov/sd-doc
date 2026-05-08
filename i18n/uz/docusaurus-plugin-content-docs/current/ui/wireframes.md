---
sidebar_position: 1
title: Wireframe-lar (joriy UI)
---

# Wireframe-lar — joriy SalesDoctor UI

Bu bo'lim jamoaga qo'shilayotgan **yangi frontend dasturchilari** uchun. U sizning yangi ekranlar quryotgan paytingizda mavjud patternlarga moslashishingiz uchun **bugun ilova qanday ko'rinishini** aks ettiradi.

Bu maxsus ravishda **wireframe / joylashuv** havolasi, chuqur dizayn tizimi emas — vizual stil (ranglar, shriftlar, mikro-o'zaro ta'sirlar) `SD-Web-old.fig` Figma faylida joylashgan.

## Manba

Quyida havola qilingan sahifa skrinshotlari foydalanuvchining `SD-Web-old.fig` Figma faylidan olingan. `static/wireframes/extracted-from-figma/page-NN-WIDTHw.png` ostida **60 ta sahifa darajasidagi wireframe** mavjud.

Agar yangi eksportlar kerak bo'lsa, Figma faylini to'g'ridan-to'g'ri oching:

> `~/projects/salesdoctor/sd-docs/static/wireframes/SD-Web-old.fig`

(yoki shareable URL olish uchun uni figma.com ga yuklang).

## Kanonik joylashuv

SalesDoctor admin-dagi har bir sahifa shu skeletni baham ko'radi.

```
┌──────────────────────────────────────────────────────────────────────┐
│  TOP BAR                                                             │
│  Logo · role tabs (Sales / Касса / GPS / Онлайн-помощь)              │
│      · search · date range · balance · notifications · user         │
├──────┬───────────────────────────────────────────────────────────────┤
│ LEFT │   PAGE                                                        │
│ NAV  │   ┌─ breadcrumbs ────────────────────────────────────────┐    │
│      │   └──────────────────────────────────────────────────────┘    │
│ icon │   ┌─ page title + primary actions ──────────────────────┐    │
│ rail │   └──────────────────────────────────────────────────────┘    │
│      │   ┌─ filters ───────────────────────────────────────────┐    │
│  …   │   └──────────────────────────────────────────────────────┘    │
│      │   ┌─ content (table / form / map / cards) ──────────────┐    │
│      │   └──────────────────────────────────────────────────────┘    │
└──────┴───────────────────────────────────────────────────────────────┘
```

### Yuqori panel

- Chap: logo / brend
- O'rta-chap: rolga asoslangan tab-lar (Sales, Касса, GPS, Онлайн-помощь, …)
- Markaz: global qidiruv "Найти страницы (Ctrl+K)"
- O'ng: sana oralig'i tanlovchi, balans pill, bildirishnomalar, foydalanuvchi menyusi

### Chap navigatsiya rail-i

Yorliqlari bo'lgan vertikal icon-rail:

`Планы · Заявки · Склад · Клиенты · Агенты · Отчеты · Настройки · Аудит 2 · Команда · Диагностика`

Rail **rolga asoslangan filterlanadi** — turli rollar turli elementlarni ko'radi.

### Sahifa maydoni

Kontent maydonida har doim, tartibda:

1. **Breadcrumbs**
2. **Sahifa sarlavhasi** + **asosiy harakat tugmasi** yuqori-o'ngda
3. **Filter paneli** (yuqori) yoki **filter rail-i** (chap, og'ir hisobotlar uchun)
4. **Kontent** — jadval, forma, xarita+sidebar, KPI grid yoki detal panel

## Sahifa patternlari (misollar bilan)

### 1. KPI dashboard plitkalari

Bitta metrik bilan katta rangli bloklar, ostida plan vs fact. Asosiy dashboard va KPI ekranlarida ishlatiladi.

![KPI tiles](/wireframes/extracted-from-figma/page-0-1512w.png)

Quyidagicha qo'llang: desktop-da qatoriga 4 plitka, tor da qatoriga 2 ta. Rang chegaraga asoslangan (qizil = plandan past, yashil = plan / dan yuqori).

### 2. Ro'yxat + filtrlar (default)

Yuqori filter chip-lari → jadval → sahifalash footer-i. Eng keng tarqalgan pattern.

```
┌─────────────────────────────────────────────────────────────┐
│ [date▾] [agent▾] [status▾] [type▾] [+ more filters]   [Add]│
├─────────────────────────────────────────────────────────────┤
│  table                                                       │
└─────────────────────────────────────────────────────────────┘
```

### 3. Forma + xulosa (detal tahrirlash)

Chap = forma bo'limlari; o'ng = "Итоги" (Xulosa) + bog'liq jadval.

![Stock transfer page](/wireframes/extracted-from-figma/page-1-3132w.png)

Yuqorida **stock transfer (Перемещение товара)** sahifasi:
- Chap ustun: forma (Со склада, На склад, ТСД Сканер, Комментарий).
- O'ng ustun: elementlar va jamilarning jonli xulosasi.
- Pastda: tab-lar (Все / Напитки / Шоколад / …) + mahsulot jadvali.

### 4. Xarita + yon panel

Doklangan o'ng panelli to'la-bleed xarita. GPS, monitoring, marshrutni rejalashtirish uchun ishlatiladi.

![GPS monitoring](/wireframes/extracted-from-figma/page-13-2922w.png)

O'ng panel **Мониторинг** va **Маршрут** rejimlari o'rtasida almashinadi.

### 5. Master ro'yxat + detal panel

Sahifalarni o'zgartirmasdan obyektlarni skanerlashni va chuqurlashtirilishni xohlaganda. Ikki ustunli: chap tomonda jadval, o'ng tomonda tanlangan-yozuv tafsilotlari.

### 6. Bitta kontent maydoni ustida tab-lar

Detal sahifalarida uzun formalarni "scroll qilmasdan bo'limlar" ga bo'lish uchun ishlatiladi (masalan, Profile, Plans, Logs).

## Komponent cheat-sheet

| Pattern | Legacy Yii view-larida qayerda | Almashtirish, agar mavjud bo'lsa |
|---------|--------------------------------|---------------------|
| Yuqori panel + sidebar | `protected/views/layouts/main.php` (sd-main) | – |
| Sidebar havolalari | `protected/views/partial/sidebar.php` | – |
| Filter paneli | har kontroller view, jQuery | – |
| DataTable | `protected/views/orders/list.php` va boshqalar + `js_plugins/FixedColumns` | – |
| Modal | `protected/views/modals/*` + `js_plugins/fancybox2` | – |
| KPI plitka | `protected/modules/dashboard/views/...` | – |
| Xarita | `protected/modules/gps3/views/...` + `ng-modules/gps/` | Angular komponenti |
| Charts | `js_plugins/jquery-highcharts-10.3.3` | – |

## Olingan sahifa havolasi

Barcha 60 sahifa `/wireframes/extracted-from-figma/` ostida yashaydi. Ular `page-N-WIDTHw.png` deb nomlanadi. Hammasini skanerlash uchun papkani muharriringizda oching; biz tavsiya qilamiz:

```bash
open sd-docs/static/wireframes/extracted-from-figma/
```

Yangi ekranni dizayn qilayotganda eng yaqin mavjud sahifani tanlang — uning joylashuvi, zichligi va komponent tanlovlariga moslang, agar voz kechish uchun maxsus sabab bo'lmasa.

## O'zingizning eksportlaringizni tashlang

Tegishli Figma frame-ni PNG (2×) sifatida eksport qilib va `static/wireframes/` ga tashlash orqali yangi wireframe-lar qo'shing. Markdown sahifasidan havola qiling:

```markdown
![Outlet detail](/wireframes/outlet-detail.png)
```

Nomlash konvensiyasi: `<area>-<page>.png`, masalan `orders-list.png`, `client-detail.png`, `report-bonus.png`.

## Shuningdek qarang

- [Page layout](./page-layout.md)
- [Filters](./filters.md)
- [Tables](./tables.md)
- [Forms](./forms.md)
- [Modals](./modals.md)
