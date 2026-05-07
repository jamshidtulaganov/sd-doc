---
sidebar_position: 2
title: Ecosystem
---

# The SalesDoctor ecosystem

There are **three sibling projects** that together form the SalesDoctor
platform — they live under `~/projects/salesdoctor/`:

```
sd-cs   ─►   sd-main   ─►   sd-billing
HQ            Dealer CRM       Subscriptions / licensing
```

| Project | Role | Audience |
|---------|------|----------|
| **[`sd-cs`](#sd-cs)** | Head office / "Country Sales 3" | The brand owner consolidating across many dealers |
| **[`sd-main`](#sd-main)** | Dealer CRM | Each dealer's day-to-day operational system |
| **[`sd-billing`](#sd-billing)** | Subscriptions, licensing, payments | The platform vendor managing dealer accounts |

The arrows above describe **direction of dependency / read-flow**, not
data ownership:

- **`sd-cs`** is at HQ. It opens **read** connections into many
  `sd-main` databases to produce consolidated reports.
- **`sd-main`** is the system of record for a dealer's daily operations.
  Each dealer has their own `sd-main` instance, with their own MySQL
  schema (prefix `d0_`).
- **`sd-billing`** is upstream of every `sd-main` and `sd-cs`. It pushes
  licence files, syncs phone directories, pings status, and bills the
  dealer for the subscription. `sd-main` and `sd-cs` only read from
  Billing for licence checks.

See the **Ecosystem** diagram in the
[FigJam board](./architecture/diagrams.md).

```mermaid
flowchart LR
  subgraph HQ["Brand owner / HQ"]
    CS["sd-cs"]
    CSDB[(MySQL cs_*)]
  end
  subgraph DealerA["Dealer A"]
    MA["sd-main"]
    DA[(MySQL sd_dealerA, d0_*)]
  end
  subgraph DealerB["Dealer B"]
    MB["sd-main"]
    DB2[(MySQL sd_dealerB, d0_*)]
  end
  subgraph Vendor["Platform vendor"]
    BL["sd-billing"]
    BLDB[(MySQL d0_* billing schema)]
  end
  CS --> CSDB
  CS -.->|read d0_*| DA
  CS -.->|read d0_*| DB2
  MA --> DA
  MB --> DB2
  BL --> BLDB
  BL -.->|push licences, sync phones, status| MA
  BL -.->|push licences, sync phones, status| MB
  BL -.->|push licences, sync phones, status| CS
```

## sd-cs {#sd-cs}

The **Country Sales 3** application — Yii 1.x, two MySQL connections
(its own `cs_*` schema + a swappable `dealer` connection into each
dealer's `d0_*` DB), focused on consolidated reporting and pivots.

See [sd-cs section](./sd-cs/overview.md).

## sd-main {#sd-main}

The dealer CRM — the bulk of this site is about sd-main. See
[Architecture](./architecture/overview.md), the
[Module reference](./modules/overview.md), and the
[API reference](./api/overview.md).

## sd-billing {#sd-billing}

The platform-vendor's subscription billing system — Yii 1.1.15, MySQL,
Docker, 13 modules covering distributors, dealers, packages,
subscriptions, payments (Click / Payme / Paynet / MBANK / P2P),
settlement, dunning. See [sd-billing section](./sd-billing/overview.md).

## Other folders

`sd-components/` (a Vue + Vuetify UI library) and `manager-ai/` (an
empty AI-assistant scaffold) sit alongside the three core projects.
They aren't peer products — treat them as internal libraries / future
work. See [sd-components notes](./sd-cs/sd-components.md).
