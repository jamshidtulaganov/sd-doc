---
sidebar_position: 1
title: Reports module — QA guide
audience: QA
---

# Reports module — QA test guide

> **Who this is for.** QA writing test cases for the **Web → Отчёты** section of sd-main without reading the source code. Every page in this guide is written in business language, anchored in workflow diagrams, and ends with a starter checklist of test scenarios.
>
> **Who this is *not* for.** Developers wanting to trace SQL or model code — go to the developer guide for the matching controller and view files.

---

## What the Reports module does, in one paragraph

The Reports module turns the data captured by Orders, Visits, Payments and Stock into **answers**. Most reports are *not* lists of raw rows — they are aggregations: sums per agent, per client, per product, per day. Every report has the same shape: a **filter bar** at the top (date range plus a long list of drop-downs), a **table or pivot** in the body, and sometimes an **Excel export** button. Almost every QA bug in this module is one of three things: (a) a filter does not narrow the data it claims to, (b) a supervisor sees data that belongs to another team, or (c) a wide date range times out the page.

There are **35+ distinct reports** under Отчёты. Most are read-only and follow the same patterns; only a handful drive day-to-day decisions for the dealer. This guide focuses QA effort on those.

---

## What the headline business questions are and which report answers them

| Question the user is trying to answer | Open this report | QA priority |
|---|---|---|
| "How much did each **agent** sell this month — and what is their unconfirmed cash and debt?" | [Заказы по агентам](./report-agent.md) | **H** |
| "How much did each **client** buy — by month, by category, who are my top customers?" | [Продажи по клиентам](./report-customer.md) | **H** |
| "How many units / how much money did each **product (SKU)** generate — by category, by agent?" | [Продажи по товарам / по SKU](./report-volume-sku.md) | **H** |
| "How is each **expeditor** doing — how much did they deliver, how much defect, how much debt did they leave behind?" | [Delivery & expeditor reports](./report-expeditor.md) | **H** |
| "Did the agent **visit** the clients on their route — and did the visit result in an order? AKB / OKB / strike rate." | [По визитам 2.0](./report-visit.md) | **H** |

---

## The full list of reports under Отчёты

The dealer's menu may hide some of these depending on configuration. The QA-priority column tells you where to spend time.

| URL path | Plain-English name | What it answers | QA priority |
|---|---|---|---|
| `/report/agent` | Заказы по агентам | Sales per agent + agent debt and cash | **H** |
| `/report/agent/salary` *(and variants `/salary2`, `/salary3`)* | Зарплата агента | Bonus / commission calc for the agent | M |
| `/report/agent/agentVisits` | Визиты агента (старый) | Visit counts per agent | L |
| `/report/agent/visit` | По визитам — старая страница | Visit + AKB/OKB by agent | M |
| `/report/agent/agentBonus` | Бонусы агентов | Bonus payouts per agent | L |
| `/report/agent/prodGroup` | Агент × товарная группа | Agent sales grouped by product group | M |
| `/report/agent/sales` | Продажи агента (детально) | Per-agent detailed sales | M |
| `/report/customer` | Продажи по клиентам — пивот | Pivot: AKB/OKB, by category, by city, by top customer | **H** |
| `/report/customer/clientList` | Продажи по клиентам — список | Flat client-by-client list, supports Excel | **H** |
| `/report/customer/clientListAkb` | АКБ-список | Just the AKB part of the above | M |
| `/report/customer/monthly` | Месячная динамика по клиенту | Same clients, broken by month | M |
| `/report/customer/getAkb` | АКБ-функция | API endpoint, used by other reports | L |
| `/report/customer/getOkb` | ОКБ-функция | API endpoint, used by other reports | L |
| `/report/customer/minimum` | Минимальный заказ | Clients below a sales threshold | M |
| `/report/volumeReport` | Продажи по товарам | Pivot per product category × product | **H** |
| `/report/volumeReport/version2` | Продажи по SKU | Distribution per SKU per client — strike rate | **H** |
| `/report/volumeReport/vue` | Vue-версия товарной аналитики | Modern UI, same data | M |
| `/report/expeditor` | Развоз по экспедиторам | Volume to deliver per expeditor | M |
| `/report/expeditorReport` | Отчёт экспедитора | Per-expeditor full pivot, multi-page | **H** |
| `/report/expeditorDebt` | Долги по экспедиторам | Outstanding debt per expeditor | **H** |
| `/report/expeditorDefect` | Брак по экспедиторам | Defects and returns attributed to expeditor | **H** |
| `/report/expeditorDailyReport` | Развоз на день | One-day load plan and reconciliation | M |
| `/report/reportVisit` | По визитам 2.0 | Daily visit grid by agent × day of month | **H** |
| `/report/reportVisit/auditor` | По визитам — аудиторы | Same, but for merchandisers, not agents | L |
| `/report/report` | Маршрут / результативность | Per-client outcome: visited, ordered, refused | **H** |
| `/report/visit` | Подробности визита | Per-visit drill-down | M |
| `/report/visitingHistory` | История визитов клиента | Per-client visit timeline | M |
| `/report/photoReport` | Фото-отчёты | Photos taken during visits | M |
| `/report/parentPhotoReport` | Фото-отчёты родителя | Grouped photos | L |
| `/report/createImageReport` *(obsolete)* | — | Skip | L |
| `/report/discountDetail` | Скидки — детали | Per-line discount audit | M |
| `/report/productPriceMarkup` | Наценка по товарам | Margin per product | M |
| `/report/realBonus` | Реальные бонусы | Actual paid bonuses | M |
| `/report/bonusReport` | Сводка бонусов | Bonus summary | M |
| `/report/bonusAccumulation` | Накопление бонусов | Bonus accumulation per client | L |
| `/report/saleDetail` *(and `/saleDetailNew`)* | Детально по продажам | Line-level sales | M |
| `/report/ordersReport` | Сводка заказов | Order count summary | M |
| `/report/defect` | Брак сводно | Defect totals | M |
| `/report/reject` | Отказы | Rejection / refusal report | M |
| `/report/tasks` *(and `/tasksReport`)* | Задачи | Agent task completion | L |
| `/report/analyze` | Аналитика | Multi-dimension drill | L |
| `/report/rfm` | RFM-сегментация | RFM analysis of clients | L |
| `/report/feedbackReport` | Обратная связь | Feedback per client | L |
| `/report/workingTime` | Рабочее время агента | Agent time on-route | L |
| `/report/price` | Прайс-листы | Current price list | L |
| `/report/telegram` | Сводка для Telegram | Pre-formatted text for chat | L |
| `/report/reportBuilder` | Конструктор отчётов | Custom report builder | L |
| `/report/rlpReport` | RLP-отчёт | Loyalty-program totals | L |
| `/report/planExpeditor` | План экспедитора | Expeditor plan vs fact | M |
| `/report/vanselDailyReport` | Van-selling — день | Van-selling agent daily | M |
| `/report/export` | Универсальный экспорт | Generic Excel export endpoint | L |

---

## What every reports test should record

For each scenario from these pages, the test case should capture:

1. **Pre-conditions** — which dealer / filial, which role, what date range, what data must exist (orders, visits, payments, defects).
2. **Filter combination** — every drop-down value used.
3. **Expected result** — the totals row, the row count, the visible values for a known client/agent/SKU.
4. **Expected scoping** — which agents / clients / cities the role should see (Supervisor scoping is the most-tested rule).
5. **Performance** — first paint time, total time-to-table, and whether Excel export completed.
6. **Edge** — empty result, period crossed close date, two currencies in scope, an inactive client present in source orders.

---

## Glossary — the words you will see on every report screen

These show up on almost every report screen. The full cross-module glossary is at [QA glossary](../glossary.md).

| Term | What it means in plain language |
|---|---|
| **Date filter — by what date?** | Reports let the user choose **by order date / by load date / by delivery date**. The three give different numbers for the same period because an order created late in March may load early April. Always record which one you used. |
| **Status filter — default 2 + 3** | Almost every report defaults to *Shipped + Delivered* — i.e. real sales. New, Cancelled and Returned are excluded unless the user opts in. The "Заказы по агентам" page is the only one where this is explicit on screen. |
| **AKB** | *Active client base* — distinct clients that placed at least one order in the period. |
| **OKB** | *Total client base* — distinct clients that were visited (in scope) in the period, ordered or not. |
| **Strike rate** | OKB ÷ AKB, expressed as a percentage. "How many of the visited clients actually bought." |
| **Supervisor scoping** | When a supervisor opens a report, the system silently restricts the report to **their** agents. Other supervisors' agents are invisible. The user cannot turn this off. |
| **Partner scoping** | When a partner (role 7) opens a report, the system silently restricts to their product categories. |
| **Pivot view** | A table where columns are dimensions (e.g. category) and rows are entities (e.g. client). Most report pages have one pivot per tab. |
| **Excel export** | A `.xls` download generated server-side from the same data. Some reports support it, some don't — see each page. |
| **Currency mixing** | The report sums amounts across orders in different currencies. By default the numbers are **summed without conversion** — so a USD order and a UZS order will produce a meaningless total. Most reports show a per-currency breakdown when more than one currency is in scope. |

---

## For developers

The matching developer reference is `docs/modules/report.md` — that file lists every controller, view file and SQL helper.
