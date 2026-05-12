---
sidebar_position: 0
title: QA glossary
audience: QA
---

# QA glossary — the words and numbers you will see

> **Why this exists.** Every QA workflow page leans on a handful of domain-specific words (filial, expeditor, retro-bonus, agents-packet, CIS code, …). They're not optional vocabulary — bug reports and test cases use them constantly. This page is the single source where each one is defined briefly, with a link to the workflow page that uses it in context.
>
> **How to use it.** Search (Ctrl/⌘ F) the term you're confused about. Each entry has a one-sentence plain-English definition, then a "see also" link to where it actually matters for testing.

---

## 1. People and roles

| Term | Plain meaning | See also |
|---|---|---|
| **Role number** | Every user account has a numeric role: **1** admin, **2** manager, **3** operator, **4** field agent, **5** operations, **8** supervisor, **9** key-account, **10** expeditor, **11** merchandiser. | [Team overview](./team/index.md#glossary--terms-and-role-numbers-qa-will-see) |
| **Agent (field agent)** | A salesperson who visits clients and submits orders from a mobile phone. Role 4 internally. | [Role — Agent](./team/role-agent.md) |
| **Agent type** | Stored as `Agent.VAN_SELLING`. **0** regular field agent · **1** van-selling · **2** seller (point-of-sale) · **3** system bot. | [Role — Agent](./team/role-agent.md) |
| **Van-selling agent** | An agent who drives a vehicle full of stock and sells direct from the van; their van is a personal warehouse. | [Role — Agent](./team/role-agent.md) |
| **Seller** | An agent who works from a fixed location (a shop or counter), not a route. | [Role — Agent](./team/role-agent.md) |
| **Supervisor (Supervayzer)** | The web-only manager who oversees a team of agents and watches their KPI. Role 8. | [Role — Supervisor](./team/role-supervisor.md) |
| **Expeditor** | The driver who delivers orders, collects cash, and brings back defective stock. Role 10. | [Role — Expeditor](./team/role-expeditor.md) |
| **Operator** | The office-based clerk who builds orders on the web, edits them, and changes their status. Role 3. | — |
| **Manager** | The office-based approver / overseer. Role 2. | — |
| **Admin** | Top-level web-admin user; sees everything. Role 1. | — |
| **Key-account manager** | A web-admin user scoped to large B2B clients. Role 9. | — |
| **Merchandiser** | A mobile user with a lightweight feature set — usually just visits and audits, no orders. Role 11. | — |

---

## 2. Organisation and scoping

| Term | Plain meaning | See also |
|---|---|---|
| **Dealer** | One customer of the SalesDoctor platform. One dealer = one isolated database. The web admin you log into belongs to exactly one dealer. | — |
| **Filial** | A branch or sub-company under a dealer. Each filial has its own clients, agents, stock and orders. Scoping is enforced everywhere; a user from filial A does not see filial B's data unless they have multi-filial access. | — |
| **Tenant** | A synonym for *dealer* in technical contexts. | — |
| **Trade direction** | A business segment / channel (HoReCa, Pharmacy, Modern Trade, etc.). Orders carry a trade direction, and some rules (auto-bonus, auto-discount, agent's allowed products) match against it. | [Discounts](./orders/discounts.md) |
| **City** | A geographic scoping field on the client and order. Reports often filter by city. | — |
| **Subscription cap** | A licence limit on how many active agents (or van-selling agents, or sellers) a dealer can have. Checked at create-agent time. Free-trial dealers have an effectively unlimited cap. | [Create-edit agent](./team/create-edit-agent.md) |
| **License / licence** | The dealer's paid subscription file. Expires; while expired, the mobile app blocks every user. | — |

---

## 3. The order lifecycle

| Term | Plain meaning | See also |
|---|---|---|
| **Status** | A name for the order's current stage: **New (1)**, **Shipped (2)**, **Delivered (3)**, **Returned (4)**, **Cancelled (5)**. Always use the name in test cases — the number is for logs. | [Status transitions](./orders/status-transitions.md) |
| **Sub-status** | A finer-grained label on top of the main status — e.g. *"awaiting cashier"* on a Delivered order. Sub-status options are configured per dealer and can be empty. | [Status transitions](./orders/status-transitions.md) |
| **Order type** | The kind of order: **1** Sale (the normal case), **2** Recovery / shelf-return, **3** Defect order. | [Orders overview](./orders/index.md) |
| **Close date** | A rolling cut-off date — default 21 days back from today. Orders older than the close date are read-only: status, totals and lines cannot be changed. | [Status transitions](./orders/status-transitions.md) |
| **Re-open** | Moving an order back to **New** from a later status. Allowed from every later status but has cascading side-effects (debt re-calculated, stock restored, history grows). | [Status transitions](./orders/status-transitions.md) |

---

## 4. Money, pricing, bonuses

| Term | Plain meaning | See also |
|---|---|---|
| **Price type** | A named price list (e.g. *"Retail UZS"*, *"Wholesale USD"*). Decides which price each product line uses on the order. | [Discounts](./orders/discounts.md) |
| **Manual price override** | When the operator types a per-unit price directly on a line, instead of using the price-list value. Only allowed if the price type permits it. | [Discounts](./orders/discounts.md) |
| **Per-line discount** | A discount on one specific line. Either a picked rule from the manual-discount list, or a typed per-unit amount. | [Discounts](./orders/discounts.md) |
| **Header discount (auto-discount)** | A discount applied at the order level by an automatic rule — matches against client, agent, trade, threshold value, etc. Recorded as a link from the order to the rule. | [Discounts](./orders/discounts.md) |
| **Bonus order** | A linked, free-of-charge "sister" order that travels alongside a main order. Carries the free products the client gets as a promotion. | [Bonuses](./orders/bonuses.md) |
| **Auto-bonus** | A bonus where the **system** picks the free products from a matching rule. | [Bonuses](./orders/bonuses.md) |
| **Retro-bonus** | A bonus where the **agent** picks the free products themselves at order time on the mobile app. | [Bonuses](./orders/bonuses.md) |
| **Manual bonus edit** | An operator editing the bonus order's contents from the web after the main order is saved. | [Bonuses](./orders/bonuses.md) |
| **Debt** | The amount the client owes for orders not yet paid. Each order adds to it; each payment reduces it. | [Mobile payment](./orders/mobile-payment.md) |
| **Cashbox** | A named till / payment channel (cash, card terminal, bank account). Payments must land in a specific cashbox. Each expeditor has one or more cashboxes assigned. | [Mobile payment](./orders/mobile-payment.md) |
| **TRANS_TYPE** | The kind of ledger row. **1** invoice (created when an order is placed), **3** payment receipt (when cash is collected). QA verifies that both rows exist for every paid order. | [Mobile payment](./orders/mobile-payment.md) |
| **Debt path fork** | For most agents, the system adds the order amount to the client's running balance. For **van-selling / seller** agents — when the dealer's *"debt per order"* setting is on — the system creates a **fresh debt row per order** instead. Test both. | [Status transitions](./orders/status-transitions.md) |

---

## 5. Stock and warehouses

| Term | Plain meaning | See also |
|---|---|---|
| **Warehouse (store)** | A physical place stock is held. A dealer has one or more sale warehouses, plus optional special-purpose warehouses (defect store, return store). | — |
| **Defect store** | A separate warehouse where defective / returned goods are parked. Only used if the expeditor handling the delivery has one configured. **Without it, defects record but no stock moves anywhere.** | [Partial defect](./orders/partial-defect.md) |
| **Stock-check disabled** | A per-warehouse toggle that turns off the *"do you have enough stock?"* check at order time. Use carefully; the check is normally critical. | [Create order — mobile](./orders/create-order-mobile.md) |
| **Van warehouse** | The personal warehouse of a van-selling agent. Stock leaves it the moment the agent sells from the van. | [Role — Agent](./team/role-agent.md) |

---

## 6. Visits, routes, GPS

| Term | Plain meaning | See also |
|---|---|---|
| **Visit** | A record that an agent went to a client. Includes check-in time, check-out time, GPS, and what happened during the visit. | [Role — Agent](./team/role-agent.md) |
| **Route (visiting)** | The list of clients an agent is supposed to visit on a given weekday. | [Role — Agent](./team/role-agent.md) |
| **DAY** | 1–7 = Monday–Sunday. Used everywhere a weekday is stored. | — |
| **WEEK_TYPE** | A field on each route entry. **0** every week · **1** odd weeks only · **2** even weeks only · **3** once per month (the *WEEK_POSITION*-th weekday of the month). | — |
| **WEEK_POSITION** | When WEEK_TYPE = 3, which occurrence of the weekday in the month: **1** = 1st, **5** = last. | — |
| **Follow sequence** | A toggle in the agents-packet that forces the agent to visit clients in the saved SORT order instead of picking freely. | [agents-packet](./team/agents-packet.md) |
| **Geofence radius** | The acceptable distance between the GPS point at check-in and the client's saved coordinates. The system stores GPS on every visit; whether it *enforces* the radius depends on dealer config. | [Role — Agent](./team/role-agent.md) |
| **Out of zone** | A visit whose check-in GPS is farther than the geofence radius from the client. Flagged for review. | [Role — Agent](./team/role-agent.md) |
| **AKB** (active client base) | The set of clients who actually bought something in the period. Drives sales-share reports. | — |
| **OKB** | The full population of clients visited in the period, regardless of whether they bought. AKB ÷ OKB = the conversion percentage. | — |

---

## 7. Mobile app configuration

| Term | Plain meaning | See also |
|---|---|---|
| **sd-agents app** | The mobile app the field agent uses. | [Role — Agent](./team/role-agent.md) |
| **Driver app** | The mobile app the expeditor uses. Same codebase, different build. | [Role — Expeditor](./team/role-expeditor.md) |
| **agents-packet (AgentPaket)** | The bundle of configuration pushed from the web admin to the sd-agents mobile app. Internal model name: `AgentPaket`. Carries the SETTINGS JSON blob (route rules, GPS, discounts, …) plus per-agent product / price restrictions. | [agents-packet](./team/agents-packet.md) |
| **expeditor-packet (ExpeditorPaket)** | The same idea for the driver app. Smaller surface — covers delivery rules, payment, defect-photo requirements, etc. | [expeditor-packet](./team/expeditor-packet.md) |
| **Company config file** | The per-dealer defaults file on the server's filesystem: `/upload/company_config.txt` (agents) or `/upload/company_expeditor_config.txt` (expeditors). | [agents-packet](./team/agents-packet.md) |
| **SETTINGS blob** | The JSON column on AgentPaket / ExpeditorPaket holding every toggle for the mobile app. Up to 100 KB. | [agents-packet](./team/agents-packet.md) |
| **Read-modify-write hazard** | Two admins editing different keys of the same agent's packet at the same time can silently clobber each other because saves are full-blob replaces, not field-level upserts. **A QA test plan must check for this explicitly.** | [agents-packet](./team/agents-packet.md#conflict-landmine--the-read-modify-write-hazard) |
| **Sync** | The act of the mobile app re-fetching its config and data from the server. Happens on login and on the agent's manual *"sync"* tap. There is no automatic push from the server. | [agents-packet](./team/agents-packet.md) |
| **PRODUCT_ID restriction** | The comma-separated list of products one agent may sell. Edited via the Product distribution screen. Stored separately from the SETTINGS blob. | [Product distribution](./team/product-distribution.md) |

---

## 8. Defects, returns, exchanges

| Term | Plain meaning | See also |
|---|---|---|
| **Partial defect** | The client took most of the order but some lines were broken / expired. The operator records defective quantities per line; the order stays in Delivered. | [Partial defect](./orders/partial-defect.md) |
| **Whole-order return** | The client refused the *whole* delivery; every line is marked defective and the order moves to status Returned. Goods go back to the order's warehouse. | [Whole-order return](./orders/whole-return.md) |
| **Defect**, the entity | Per-line defect declaration on a delivered order. Distinct from the *audit* module's *facing* / *audit-result* (those record merchandising surveys, not delivery defects). | [Partial defect](./orders/partial-defect.md) |
| **Reject** | A whole-order rejection at delivery, recorded inline on the order. Distinct from per-line defect. | [Whole-order return](./orders/whole-return.md) |
| **Exchange (stock)** | The system's audit row recording stock moving between warehouses — e.g. defective items moving from the order's warehouse to the defect store. | [Partial defect](./orders/partial-defect.md) |

---

## 9. CIS / regulated goods (XTrace)

| Term | Plain meaning | See also |
|---|---|---|
| **CIS code** | A unique mark printed on regulated goods (tobacco, alcohol, water, dairy…) that the state's tracking system records. | [CIS code check](./orders/cis-code-check.md) |
| **XTrace** | The internal name for the state tracking system. Also known by trade names like *Aslbelgisi*. The system calls XTrace asynchronously to verify CIS codes on each order. | [CIS code check](./orders/cis-code-check.md) |
| **GTIN** | The product code printed alongside the CIS code. The system checks that the GTIN on the code matches the product on the order line. | [CIS code check](./orders/cis-code-check.md) |
| **CIS status** | The result of the XTrace check on the order's codes: **Waiting for check** · **Checked — OK** · **Checked — codes invalid** · **Checked — quantity mismatch**. | [CIS code check](./orders/cis-code-check.md) |

---

## 10. KPI

| Term | Plain meaning | See also |
|---|---|---|
| **KpiTaskTemplate** | A definition of one thing the company measures (e.g. *"Sales sum"*, *"AKB"*, *"Number of visits"*). Carries a name, type, and seven bonus-tier thresholds with percentages. | [KPI setup and views](./team/kpi-setup-and-views.md) |
| **Kpi (a row)** | One person's KPI for one month. Carries `TEAM_TYPE` (agent / supervisor / expeditor), `TEAM` (the person's id), `FIX_SALARY`. | [KPI setup and views](./team/kpi-setup-and-views.md) |
| **KpiTask** | Child of `Kpi` — the target value for one template (e.g. *"Agent X must do 50,000,000 UZS in sales this month"*). | [KPI setup and views](./team/kpi-setup-and-views.md) |
| **FIX_SALARY** | The fixed monthly salary base, separate from any bonus. Stored on the `Kpi` row. | [KPI setup and views](./team/kpi-setup-and-views.md) |
| **Bonus tier (MARK1..7)** | Seven threshold values on a template that define the payout curve. Hitting MARK3 might pay 75%; MARK5 might pay 100%; MARK7 might pay 120%. | [KPI setup and views](./team/kpi-setup-and-views.md) |
| **All-zero deletion** | If the admin clears every target value for an agent on a month, the system **deletes** the agent's Kpi + KpiTask rows for that month. Easy to do by accident; verify it's intentional. | [KPI setup and views](./team/kpi-setup-and-views.md) |
| **KPI v1 vs v2** | Two versions of the KPI plumbing exist. **v2 is current** (`KpiNewController`); v1 is legacy. Test plans should target v2 unless chasing a v1-only regression. | [KPI setup and views](./team/kpi-setup-and-views.md) |

---

## 11. Notifications, integrations, audit trail

| Term | Plain meaning | See also |
|---|---|---|
| **Telegram alert** | Order events (creation, status change) are announced to a dealer-configured Telegram channel. Fire-and-forget; failures don't roll back the order. | [Create order — web](./orders/create-order-web.md) |
| **SDIntegration** | The internal name of the deferred export call that forwards orders to external systems. Runs after the response is already returned to the user. | — |
| **Faktura.uz / Didox / 1C** | External invoicing / accounting integrations. Each has its own export controller and credentials. | — |
| **Order history** | The audit trail on each order — one row per field change, by user, with before/after values and timestamp. | [Order list & history](./orders/order-list-and-history.md) |
| **GUID** | A unique ID the mobile app generates per order before submitting it. Used by the api4 channel to reject duplicate submissions if the agent taps Submit twice. | [Create order — mobile](./orders/create-order-mobile.md) |
| **SyncLog** | The api3-channel equivalent of the GUID — a per-device, 20-second window during which a re-submit is treated as the same order. Older than the GUID approach; less reliable. | [Create order — mobile](./orders/create-order-mobile.md) |
| **AfterResponse** | The internal mechanism that defers slow side-effects (Telegram, integrations) until after the user's HTTP response. Failures there are silent. | — |

---

## 12. UI labels — Russian to English

The web admin is in Russian by default. The same word appears here as the Russian UI label and the English term used in this guide.

| Russian label | English equivalent | Where used |
|---|---|---|
| Команда | Team module | The whole field-staff management area. |
| Агенты | Agents | List of field agents. |
| Супервайзеры | Supervisors | List of supervisors. |
| Экспедиторы | Expeditors | List of drivers. |
| Торговая команда | Sales team | Grouping page (supervisor + their agents). |
| Распределение товаров | Product distribution | Bulk-edit which agents can sell which products. |
| Задачи | Tasks | Ad-hoc tasks for agents (new feature). |
| KPI установка | KPI setup | Setting per-person targets. |
| Заявки | Orders | The orders list. |
| Касса | Cashbox / Till | Payment channel. |
| Финансы | Finance | Debt and payment screens. |
| Склад | Stock | Warehouse and balances. |
| Клиенты | Clients | Outlets and customers. |
| Планы | Plans | Monthly sales targets. |
| Аудит | Audit | Visit audits, facing, photos. |
| Настройки | Settings | Admin and access management. |
| Отчёты | Reports | Operational reports. |

---

## How to keep this glossary useful

When you write a new test plan and the terminology trips you up:

1. **Search this page first.** If the term is here, copy the definition into the test case.
2. **If it's not here**, write the test plan with your best understanding and **leave a note**. The doc owner will add the term to this glossary on the next pass.
3. **If a definition is wrong or out of date**, edit it directly — this is a living document.

The aim is *one place* to land for every term — never two competing definitions in separate pages.
