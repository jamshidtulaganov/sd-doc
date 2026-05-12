---
sidebar_position: 2
title: Page-to-module map
audience: QA
---

# Page-to-module map — every navigation entry and where the code lives

> **Why this exists.** sd-main has 40+ modules but the navigation has only ~10 left-menu sections and 6 top-nav entries. Each navigation entry spans **multiple** code modules. QA test plans constantly need to know *"if I click X, which module's controller is the action?"* — this is the answer key.
>
> **Source.** Generated from `protected/components/SideMenu2.php` and `protected/components/TopMenu2.php` in sd-main. Re-verify whenever those files change.

---

## Left sidebar — 10 sections, 80+ pages

### 🩺 Диагностика (Doctor) — only when `/upload/doctor.txt` exists with `"OK"`

| Russian label | URL | RBAC | Has QA guide? |
|---|---|---|---|
| Outlet T | `/doctor/forecast` | `operation.doctor.outlet` | ❌ |
| Установка плана Outlet T | `/doctor/outletPlan` | `operation.doctor.outletPlan` | ❌ |
| План по агентам | `/doctor/doctor2` | `operation.doctor.total` | ❌ |
| Установка плана по агентам | `/doctor/volume` | `operation.doctor.volumePlan` | ❌ |
| Strike Rate | `/doctor/doctor2/strikeRate` | `operation.doctor.strikeRate` | ❌ |
| План по SKU / АКБ / Strike (setup + view) | various `/doctor/*` | `operation.doctor.*` | ❌ |

All under the `doctor` module.

### 📋 Планы (Planning)

| Label | URL | Module | RBAC |
|---|---|---|---|
| Результаты | `/planning/monthly2` | planning | `operation.planning.results` |
| Outlet targeting | `/planning/outlet` | planning | `operation.planning.outlet` |
| Установка планов | `/planning` | planning | `operation.planning.setup` |
| План по товарам (set + view) | `/stock/planProduct/*` | **stock** | `operation.planning.byproduct*` |

### 📦 Заявки (Orders) — covered by QA guide

| Label | URL | Module |
|---|---|---|
| Заявки | `/orders/list` | orders ✅ |
| Заявки (версия 1) | `/orders/orders` | orders ✅ |
| Создать заказ | `/orders/view/createOrder` | orders ✅ |
| Создать заказ (версия 1) | `/orders/createOrder` | orders ✅ |
| Создать возврат с полки | `/orders/recoveryOrder/create` | orders |
| Отказы | `/orders/rejects` | orders |
| Создать обмен | `/orders/recoveryOrder/createReplace` | orders |
| Онлайн заявки | `/onlineOrder/order` | onlineOrder |
| Заявки на карте | `/orders/view/onMap` | orders |
| Импорт статусов / Импорт заказов / Импорт возвратов | `/orders/orders/editStatus`, `/orders/importOrder*` | orders |
| Заявки (Van Selling), Возврат (Van Selling) | `/vs/order`, `/vs/view/return` | vs |
| История заказов (количество) | `/report/ordersReport` | report |

### 🏬 Склад (Stock) — covered by QA guide

Spans `warehouse`, `stock`, `store`, plus filial-conditional entries from `orders/supplier`.

Key URLs by responsibility:
- **Stores CRUD**: `/warehouse/list` — `warehouse` module ✅
- **Balances view**: `/stock/stock/detail` — `stock` module ✅
- **Receipts**: `/warehouse/view/listPurchase`, draft list at `/warehouse/view/purchaseDraft` — `warehouse` ✅
- **Adjustments**: `/warehouse/view/listAdjustment` — `warehouse` ✅
- **Transfers**: `/warehouse/view/exchangeList` — `warehouse` ✅
- **Excretion / write-offs**: `/stock/excretion` — `stock` ❌
- **Reports** (pivots, daily remainder, lot, profit): `/stock/*` — `stock` ❌
- **Inter-filial movement & supplier receipt** (only when `!FilialComponent::isOnlyFilial()`): `/orders/supplier/receipt`, `/stock/purchase/refund?movement=1`, `/warehouse/view/filialMovement` — orders + stock + warehouse
- **Догруз экспедиторам** (when params enable it): `/orders/expeditorLoadNeo` — orders

### 🏷️ Маркировка (Marking) — *only Uzbekistan, roles 3/5/20*

| Label | URL | Module |
|---|---|---|
| Приёмка (Acceptance) | `/markirovka/view/incomingInvoices` | markirovka |
| Реализация (Sale) | `/markirovka/view/outgoingInvoices` | markirovka |

QA guide: ❌ to be written.

### 👥 Клиенты (Clients) — partially covered by QA guide

| Label | URL | Module | Has QA? |
|---|---|---|---|
| Клиенты *(or Торговые точки in contragent mode)* | `/clients/client` | clients | ✅ |
| Контрагенты *(only contragent mode)* | `/clients/contragent` | clients | ❌ |
| Клиенты на карте | `/gps2` | gps2 | ❌ |
| Визиты агентов | `/clients/agentRoute` | clients | ❌ |
| Клиенты на карте (new) | `/clients/view/clientMap` | clients | ❌ |
| Оборудования | `/inventory/list` | inventory | ❌ |
| Остатки в торговых точках | `/clients/stock` | clients | ❌ |
| Объединение клиентов | `/clients/client/duplicate` | clients | ✅ |
| Контакты | `/onlineOrder/contact` | onlineOrder | ❌ |
| Отчеты по тарам | `/clients/taradoc` | clients | ❌ |
| iDokon POS | `/integration/view/idokon` | integration | ❌ |
| СМС рассылка *(UZ only)* | `/sms/view/list` | sms | ❌ |

### 👨‍💼 Команда (Team) — covered by QA guide

| Label | URL | Module |
|---|---|---|
| Агенты | `/staff/view/agent` | staff ✅ |
| Супервайзеры | `/staff/view/supervisor` | staff ✅ |
| Экспедиторы | `/staff/view/expeditor` | staff ✅ |
| Торговая команда | `/team/auditor` | team |
| KPI агентов / setup | `/dashboard/kpi`, `/agents/kpiNew` | dashboard + agents ✅ |
| KPI супервайзеров / setup | `/dashboard/kpi?superviser=y`, `/agents/kpiNew/superviser` | dashboard + agents ✅ |
| KPI экспедиторов / setup | `/dashboard/kpiExpeditor/*` | dashboard ✅ |
| Дневной KPI *(when params enable)* | `/dashboard/kpi/daily` | dashboard |
| Распределение товаров | `/agents/limit` | agents ✅ |
| Задачи | `/agents/taskNew` | agents ✅ |

### 🔍 Аудит (Audit) — v1, hidden when v2 enabled

| Label | URL | Module |
|---|---|---|
| Дневной отчет | `/audit/dashboard/daily` | audit |
| Проверки | `/audit/audits` | audit |
| Доля полки | `/audit/facing` | audit |
| Присутствие | `/audit/sku` | audit |
| Анализ цен | `/audit/price` | audit |
| Мерчандайзинг / Опрос | `/audit/pollResult` | audit |
| Сторчек | `/audit/storecheck` | audit |
| Настройки / Рейтинг | `/audit/settings`, `/audit/photoReport` | audit |

QA guide: ❌.

### 🔍 Аудит 2 — newer, replaces v1

| Label | URL | Module |
|---|---|---|
| Дневной отчет | `/adt/dashboard` | adt |
| Ритейл аудит | `/adt/adtAudit/fullReport` | adt |
| Контроль мерчендайзеров | `/adt/mixReport/index` | adt |
| Отчет по дневному посещению | `/report/reportVisit/auditor` | report |
| Клиенты (audit-scoped) | `/adt/client` | adt |
| Настройки | `/adt/settings` | adt |
| Отчёты | `/adt/reports` | adt |
| Рейтинг фото-отчётов | `/audit/photoReport` | audit (shared) |
| Отчет по визиту мерчандайзеров | `/adt/visitReport` | adt |

QA guide: ❌.

### ⚙️ Настройки (Settings) — single entry → ~20 sub-pages

`/settings/diler` is the landing. The settings module owns 50+ controllers. Highest-QA-value sub-pages:

- `/settings/diler` — dealer global config (NDS, currency, ESF operator)
- `/settings/cashbox` — cashbox CRUD (overlap: also at `/clients/finans/cashbox`)
- `/settings/currency`, `/settings/priceType`, `/settings/channel`, `/settings/clientCategory`, `/settings/clientType`
- `/settings/bonus`, `/settings/skidkaManual` — bonus / discount rules
- `/settings/royalty` — royalty rules
- `/settings/access` or `/settings/user` — RBAC + users
- `/settings/closed` — period close

---

## Top navbar — 6 sections

### 📊 Супервайзер / Продажи / Финансы — single-page dashboards

| Label | URL | Module |
|---|---|---|
| Супервайзер | `/dashboard/supervayzer` | dashboard |
| Продажи | `/dashboard/sales` | dashboard |
| Финансы | `/dashboard/finans` | dashboard |

### 📈 Отчёты (Reports) — `report` module, 35+ sub-pages

Highest-QA-value:
- Заказы по агентам — `/report/agent`
- Продажи по клиентам (1/2/3) — `/report/customer/*`
- Продажи по товарам / По Sku 2.0 — `/report/volumeReport`, `version2`
- Отгрузки / Долги / Возвраты по экспедиторам — `/report/expeditor*`, `/report/expeditorDebt`
- По бонусам / Накопительный бонус — `/report/bonusReport`, `bonusAccumulation`
- По визитам (1.0 + 2.0) — `/report/agent/visit`, `/report/report`
- RFM, Конструктор отчётов — `/report/rfm`, `/report/reportBuilder`
- Универсальные отчёты — `/report/saleDetail`, `/report/discountDetail`

### 💰 Касса (Cashbox) — three sub-groups

**Расчеты с клиентами** (Customer settlements) — module `clients/finans` and `dashboard`:
- Оплаты клиентов — `/clients/finans` ✅
- Акт сверки с клиентом — `/clients/finans/revise2`
- Обороты по всем клиентам — `/clients/finans/report`
- Долги по агентам и экспедиторам — `/dashboard/dolg`
- Начальные балансы — `/clients/finans/initialBalans`
- Отчет по поступлениям — `/dashboard/kassaIncome`
- Балансы клиентов — `/clients/transactions`
- Долги по заказам — `/clients/computation`
- Отчет по кассе — `/clients/transactionPivot`
- Задолженность клиентов (по отгрузке) — `/clients/view/clientDebtByShipment`

**Расчеты с поставщиками** (Supplier settlements) — module `clients/shipper*`:
- Поставщики — `/clients/shipper`
- Оплаты поставщикам — `/clients/shipperFinans`
- Обороты по всем поставщикам — `/clients/shipperFinans/report`
- Акт сверки c поставщиком — `/clients/shipperFinans/revise`
- Начальные балансы поставщиков — `/clients/shipperFinans/initialBalans`

**Прочие** (Other) — module `finans` and `payment`:
- Расходы — `/finans/consumption`
- Остатки денежных средств — `/clients/finans/cashboxBalans` ✅
- Движения денежных средств — `/finans/consumption/report`
- Кассы — `/clients/finans/cashbox`
- Статьи и Фонды — `/finans/consumption/category`
- Прочие приходы в кассу — `/finans/consumption/credit`
- Подтверждение оплаты — `/payment/approval`
- Подтверждение оплаты доставщиков / агентов (версия 1) — `/clients/finans/deliver*`
- P&L (conditional) — `/finans/pnl`
- Перевод денежных средств между филиалами — `/finans/paymentTransfer`

### 🛰️ GPS — `gps` and `gps2` modules

| Label | URL | Module |
|---|---|---|
| GPS 1 | `/gps/monitoring` | gps |
| GPS 2 | `/gps2/monitoring` | gps2 |

QA guide: ❌.

---

## Quick "which module owns this URL?" lookup

| URL prefix | Server module |
|---|---|
| `/clients/...` (most paths) | clients |
| `/clients/finans/...`, `/clients/transactions`, `/clients/computation` | clients (finans sub-area) |
| `/clients/shipper*` | clients (supplier-ledger sub-area) |
| `/finans/...` | finans (separate from `/clients/finans`!) |
| `/orders/...` | orders |
| `/onlineOrder/...` | onlineOrder |
| `/vs/...` | vs (van-selling) |
| `/staff/...` | staff (CRUD for agent / supervisor / expeditor) |
| `/agents/...` | agents (KPI, limits, taskNew) |
| `/team/...` | team |
| `/dashboard/...` | dashboard (KPI views, summary, kassaIncome) |
| `/warehouse/...` | warehouse |
| `/stock/...` | stock |
| `/store/...` | store |
| `/inventory/...` | inventory (fixed assets, *not* stock) |
| `/markirovka/...` | markirovka |
| `/audit/...` | audit (v1) |
| `/adt/...` | adt (audit v2) |
| `/report/...` | report |
| `/payment/...` | payment |
| `/settings/...` | settings |
| `/integration/...` | integration |
| `/gps/...` | gps |
| `/gps2/...` | gps2 |
| `/planning/...` | planning |
| `/doctor/...` | doctor |
| `/sms/...` | sms |

## When this map drifts

The two files `SideMenu2.php` and `TopMenu2.php` are the source of truth. If you find a page in the UI that isn't on this map, read those two files first — they have conditional logic (multi-filial, contragent mode, UZ-only, free-trial gates) that hides items from some users.
