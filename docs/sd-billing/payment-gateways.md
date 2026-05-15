---
sidebar_position: 4
title: Payment gateways
---

# Payment gateways

sd-billing accepts money from five online + several offline channels.
Every successful inbound payment ultimately writes a `Payment` row of
the right `TYPE`, increments `Diler.BALANS`, and triggers
`Diler::deleteLicense()` / `Diler::refresh()` to settle outstanding
subscriptions.

## Online

| Gateway | `Payment.TYPE` | Controller | Notes |
|---------|----------------|------------|-------|
| **Click** | `TYPE_CLICKONLINE` | `api/click` | Two-phase prepare/confirm with HMAC signature (`ClickTransaction::checkSign`) |
| **Payme** | `TYPE_PAYMEONLINE` | `api/payme` | JSON-RPC; HMAC auth header verified in `PaymeHelper` |
| **Paynet** | `TYPE_PAYNETONLINE` | `api/paynet` | SOAP via `extensions/paynetuz/`; creds template in `_constants.php` |
| **MBANK** (KG) | `mbank` | gateway-specific | Stub-level today — re-confirm with maintainer |
| **P2P** | `p2p` | manual entry | Operator confirms incoming bank transfer |

## Offline

| Source | `Payment.TYPE` | Captured by |
|--------|----------------|-------------|
| Cash | `cash` | `cashbox` module |
| Cashless / wire | `cashless` | `cashbox` |
| License redemption | `license` | `Diler::refresh()` consuming credits |
| Distribute / settlement | `distribute` | `cron settlement` (see [Cron](./cron-and-settlement.md)) |
| Service fee | `service` | manual |

## Canonical `Payment.TYPE` enum

The full enum is defined as class constants on the `Payment` model
(`protected/models/Payment.php` in sd-billing). String labels above
map to integer codes; new code MUST use the constants, not the bare
integers or strings:

| Constant | String label | Direction |
|----------|--------------|-----------|
| `Payment::TYPE_CASH` | `cash` | inbound (offline) |
| `Payment::TYPE_CASHLESS` | `cashless` | inbound (offline) |
| `Payment::TYPE_P2P` | `p2p` | inbound (offline) |
| `Payment::TYPE_LICENSE` | `license` | outbound (consumed) |
| `Payment::TYPE_DISTRIBUTE` | `distribute` | settlement |
| `Payment::TYPE_SERVICE` | `service` | manual fee |
| `Payment::TYPE_PAYMEONLINE` | `payme` | inbound (gateway) |
| `Payment::TYPE_CLICKONLINE` | `click` | inbound (gateway) |
| `Payment::TYPE_PAYNETONLINE` | `paynet` | inbound (gateway) |
| `Payment::TYPE_MBANK` | `mbank` | inbound (gateway, KG) |

The numeric integer values are intentionally not reproduced here so
this doc can't drift from the model — read the constant declarations
in `Payment.php` for the authoritative numbers.

## Click flow (canonical)

```mermaid
sequenceDiagram
  participant U as User
  participant C as Click
  participant API as api/click
  participant DB as MySQL
  participant D as Diler
  U->>C: pay
  C->>API: prepare (sign)
  API->>API: ClickTransaction::checkSign
  API->>DB: insert ClickTransaction (state=prepared)
  Note over API: Duplicate prepare/confirm requests return the same response (idempotent)
  API-->>C: 200
  C->>API: confirm (sign)
  API->>DB: ClickTransaction state=confirmed
  API->>DB: insert Payment TYPE=clickonline
  API->>D: Diler.BALANS += summa (DB trigger)
  API->>D: deleteLicense() + refresh()
  API-->>C: 200
```

## Payme flow

```mermaid
sequenceDiagram
  participant Pa as Payme
  participant API as api/payme
  participant DB as MySQL
  Pa->>API: CheckPerformTransaction
  API->>DB: validate dealer + amount
  API-->>Pa: result
  Pa->>API: CreateTransaction
  API->>DB: PaymeTransaction (created)
  Pa->>API: PerformTransaction
  API->>DB: PaymeTransaction (performed) + Payment TYPE=payme
  API-->>Pa: result
```

## Paynet flow

SOAP-based. `PaynetController::actionIndex` (in
`protected/modules/api/controllers/PaynetController.php`) sets the
`text/xml` content type, authenticates as the fixed `paynet` user via
`UserIdentity`, then hands the request off to a `SoapServer` bound to
`paynetuz\services\PaynetService` (the `paynetuz` extension supplies
the WSDL at `PAYNET_WSDL_URL`). The service maps each SOAP call into a
`PaynetTransaction` and, on success, a `Payment` row of
`TYPE_PAYNETONLINE`.

```mermaid
sequenceDiagram
  participant PN as Paynet gateway
  participant API as api/paynet (actionIndex)
  participant SVC as PaynetService<br/>(paynetuz extension)
  participant DB as MySQL
  participant D as Diler

  PN->>API: SOAP POST (XML)
  API->>API: UserIdentity("paynet","paynet")<br/>authenticate
  API->>SVC: SoapServer dispatch
  SVC->>DB: insert/update PaynetTransaction
  SVC->>DB: insert Payment TYPE=paynetonline
  SVC->>D: BALANS += summa (trigger)
  SVC->>D: Diler::deleteLicense() + refresh()
  SVC-->>API: SOAP result
  API-->>PN: 200 text/xml
```

## Idempotency

Each gateway's transaction table is the idempotency key. Receiving the
same `prepare` (Click) or `CreateTransaction` (Payme) twice returns the
same response without inserting another `Payment`.

## Failure modes

| Scenario | Behaviour |
|----------|-----------|
| Bad sign | 4xx, `Payment` not created |
| Dealer inactive | 4xx, transaction stays in `prepared` |
| Duplicate id | Same response as first call |
| Network error mid-`PerformTransaction` | Gateway retries; idempotency holds |

## Logging

`Logger::writeLog2($data, $is_req, $path)` writes per-day per-action
JSON files under `log/<controller>/<YYYY-MM-DD>/`. **Sanitise inputs
before logging** — never log card details or full payment payloads.

## Manual payment entry

Cashiers / operators add payments through the dashboard `operation`
module. Uses `Payment::create([...])` directly — same DB triggers fire.

## Distributor payment create/update

`DistrPaymentController::actionCreateAjax` / `actionUpdateAjax`
(`protected/modules/dashboard/controllers/DistrPaymentController.php`)
records a payment against a `Distributor`. The controller enforces
`Access::check('operation.distr.payment', CREATE|UPDATE)`, verifies the
posted `CURRENCY_ID` matches `Distributor.CURRENCY_ID`, and binds the
first cashbox owned by the current user when only one is available.

```mermaid
flowchart LR
  S(["Operator submits<br/>DistrPayment form"]) --> A["actionCreateAjax /<br/>actionUpdateAjax"]
  A --> AC{"Access::check<br/>operation.distr.payment"}
  AC -- "deny" --> R1(["403"])
  AC -- "allow" --> CB{"User has cashbox?"}
  CB -- "none" --> R2(["error: no cashbox"])
  CB -- "ok" --> CUR{"Distr.CURRENCY_ID<br/>== posted CURRENCY_ID?"}
  CUR -- "no" --> R3(["error: валюта неверно"])
  CUR -- "yes" --> SAVE["DistrPayment->save()<br/>(CASHBOX_ID auto-set)"]
  SAVE --> OK(["success"])

  class S,A,SAVE action
  class AC,CB,CUR approval
  class R1,R2,R3 reject
  class OK success
  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
```

## Manual payment entry (dashboard variant)

`dashboard/PaymentController::actionCreateAjax` / `actionUpdateAjax`
(`protected/modules/dashboard/controllers/PaymentController.php`) is
the dealer-facing equivalent of the `operation` payment screen. After
saving, the controller calls `$diler->deleteLicense()` so the dealer's
`sd-main` re-pulls its licence with the new balance.

```mermaid
flowchart LR
  S(["Operator submits<br/>Dealer payment"]) --> A["actionCreateAjax /<br/>actionUpdateAjax"]
  A --> AC{"Access::check<br/>operation.dealer.payment"}
  AC -- "deny" --> R1(["403"])
  AC -- "allow" --> CB{"User has cashbox?"}
  CB -- "none" --> R2(["error: no cashbox"])
  CB -- "ok" --> CUR{"Diler.CURRENCY_ID<br/>== posted CURRENCY_ID?"}
  CUR -- "no" --> R3(["error: валюта неверно"])
  CUR -- "yes" --> SAVE["Payment->save()<br/>(CASHBOX_ID auto-set)"]
  SAVE --> DL["Diler::deleteLicense()<br/>→ NotifyCron license_delete"]
  DL --> OK(["success"])

  class S,A,SAVE,DL action
  class AC,CB,CUR approval
  class R1,R2,R3 reject
  class OK success
  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
```

## Write-server (push licence file)

`FixController::actionWriteServer` /
`actionCheckStatusServer`
(`protected/modules/dashboard/controllers/FixController.php`) walks
non-archive `Diler` rows in pages of 10 and posts to each dealer's
`{DOMAIN}/api/billing/checkBranch` to refresh the local `Server` row
(`db_server`, `web_server`, `web_branch`). The status pass then flips
each `Server.status` to `OPENED` or `DELETED` depending on the dealer
state, which gates whether sd-main accepts new licence files.

```mermaid
sequenceDiagram
  participant Adm as Admin
  participant FX as FixController
  participant DLR as Diler (paged 10)
  participant SD as sd-main /api/billing/checkBranch
  participant SRV as Server row

  Adm->>FX: GET writeServer?offset&limit
  loop each Diler in page
    FX->>SD: POST /api/billing/checkBranch
    SD-->>FX: {db_server, web_branch}
    FX->>SRV: save(db_server, web_server, web_branch)
  end
  Adm->>FX: GET checkStatusServer
  FX->>SRV: status = OPENED (or DELETED)<br/>per dealer.isDeleted()
```
