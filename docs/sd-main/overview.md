---
sidebar_position: 1
title: sd-main · Dealer CRM
slug: /sd-main
audience: All sd-main developers, PM, QA
summary: Landing page for the sd-main project — the dealer CRM (Yii 1.x PHP, multi-tenant, mobile + web + B2B online). Sub-trees cover System Architecture, Workflows (modules + APIs + integrations + frontend + UI), and Data Schemes.
topics: [sd-main, dealer-crm, yii, distribution]
---

# sd-main — Dealer CRM

**sd-main** (internal name *Novus Distribution*) is the per-dealer CRM at the heart of the SalesDoctor platform. Each dealer runs their own `sd-main` instance against their own MySQL schema (`d0_` prefix). It captures orders, runs the field force, manages stock and warehouses, books payments, integrates with 1C / Didox / Faktura.uz, and exposes the mobile + B2B online channels.

The sub-trees below split sd-main's docs three ways. Pick the one that matches what you're trying to do.

## Three sub-trees

| Sub-tree | What's inside | Start here when… |
|----------|---------------|------------------|
| **[System Architecture](../architecture/overview.md)** | Tech stack, multi-tenancy, caching, jobs & scheduling, project layout, security, deployment | You're onboarding, debugging cross-cutting behaviour, or operating the platform |
| **[Workflows](../modules/overview.md)** | Every module + API surface + integrations + frontend + UI patterns | You're building or changing a feature |
| **[Data Schemes](../data/overview.md)** | ERD, core entities, schema conventions, migrations | You're touching the database or writing a report |

## At a glance

| Property | Value |
|----------|-------|
| Stack | PHP 7.3 · Yii 1.x · Nginx + php-fpm · MySQL 8 · Redis 7 |
| Tenancy | DB-per-customer, subdomain-routed via `TenantContext` |
| Mobile | api3 surface (Bearer-token auth) for the agent app |
| B2B online | api4 surface (token + Telegram-signed init) |
| Modules | 40+ Yii modules under `protected/modules/` |
| Diagrams | Inline Mermaid in source docs; canonical FigJam at the [diagram gallery](../diagrams/index.md) |

## How sd-main relates to the other two projects

- **`sd-billing`** is upstream — it pushes licence files and phone-directory updates to every sd-main, and bills dealers for the platform. See [Inter-project integration map](../ecosystem.md#inter-project-integration-map).
- **`sd-cs`** is downstream — it opens read-only connections into every sd-main's DB to produce HQ-level consolidated reports. See [sd-cs ↔ sd-main integration](../sd-cs/sd-main-integration.md).

The cross-project surface is small and one-directional: sd-main exposes a tight set of `api/billing` and `api/license` endpoints; everything else is scoped to a single dealer.
