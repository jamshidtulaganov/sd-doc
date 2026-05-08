---
sidebar_position: 1
title: Introduction
slug: /intro
audience: New developers, all team members
summary: SalesDoctor / Novus Distribution is a multi-tenant Distribution CRM platform. Three projects — sd-cs (HQ), sd-main (dealer CRM), sd-billing (subscriptions). This site is the developer documentation, also fed into the team's RAG / vector DB knowledge base.
topics: [overview, introduction, distribution, crm, multi-tenant]
---

# Introduction

**SalesDoctor** (internal name **Novus Distribution**, codebase folder
`sd-main`) is a multi-tenant **Distribution CRM** platform focused on
field sales, van-selling, merchandising and route accounting.

This documentation is for **developers** who build, deploy and operate the
system. End-user documentation is maintained separately and is not part of this site.

## What the system does

| Domain | Capabilities |
|--------|--------------|
| Sales | Order capture (web + mobile), pricing, discounts, bonuses, defects, returns |
| Field force | Routes, visits, GPS tracking, KPI for agents and supervisors |
| Merchandising | Audits, facing, polls, photo reports |
| Catalog | Products, categories, SKUs, brands, price types |
| Inventory | Multi-warehouse stock, transfers, inventories, lots, tara/packaging |
| Finance | Receivables, payments, cashbox, P&L per agent and per filial |
| Reporting | 80+ reports, dashboards, Excel export |
| Integrations | 1C, Didox EDI, Faktura.uz, Smartup, Telegram, FCM, SMS |
| Online | Online store, B2B portal, Telegram bot, scheduled reports |

## Audience map

- **You're a backend developer** — start at [Architecture overview](./architecture/overview.md)
  then [Project structure](./project/structure.md).
- **You're a frontend / mobile developer** — start at
  [Frontend overview](./frontend/overview.md) and the
  [API reference](./api/overview.md).
- **You're a DevOps / SRE** — go to [Deployment](./devops/deployment.md).
- **You're integrating an external system** — see
  [Integrations](./integrations/overview.md) and the
  [REST API reference](./api/overview.md).

## Conventions in this doc

- Code paths are relative to the repository root (the `sd-main` folder).
- `protected/` is the Yii application root.
- Module names are written `lowerCamel` matching their folder, e.g. `orders`,
  `onlineOrder`.
- Roles are referenced by their numeric ID *and* descriptive name, e.g.
  `4 / Agent`.
- All command-line examples assume **macOS / Linux** with `bash`. On Windows
  use WSL2.
