---
sidebar_position: 3
title: New developer onboarding
audience: New backend / frontend / mobile / DevOps engineers
summary: First-day, first-week and first-month plan to get productive on the SalesDoctor platform (sd-cs · sd-main · sd-billing). Reading order, environment setup, starter tickets, who to ask.
topics: [onboarding, first-day, first-week, ramp-up]
---

# New developer onboarding

Welcome. This page is the path from "first day" to "shipping your
first PR" on the SalesDoctor platform. The plan assumes you're a
backend / frontend / mobile / DevOps engineer with general web
experience and no prior exposure to Yii 1.x.

The platform has **three sibling projects** — see the
[Ecosystem page](../ecosystem.md) for the big picture before you
dive in.

## Day 1

Goal: have the docs + code on your laptop and one local environment
running.

- [ ] Get **GitHub access** to `sd-main`, `sd-cs`, `sd-billing`,
      `sd-docs`, `sd-components`.
- [ ] Get **VPN / network access** to the dev MySQL replicas.
- [ ] Clone the four repos under `~/projects/salesdoctor/`.
- [ ] Install **Docker Desktop** (≥ 4 GB RAM allocated) and **Node 18+**.
- [ ] Run the docs site locally:
      ```bash
      cd sd-docs && npm install && npm run start
      ```
- [ ] Read these pages in order:
      1. [Introduction](../intro.md)
      2. [Ecosystem](../ecosystem.md)
      3. [Architecture overview](../architecture/overview.md)
      4. [Tech stack](../architecture/tech-stack.md)
- [ ] **Frontend track only** — also read:
      [Frontend overview](../frontend/overview.md) →
      [Getting started (frontend)](../frontend/getting-started.md).

## Week 1

Goal: be able to run the system, read its data, and trace one full
request.

**Must read** (everyone, in order):

- [ ] [Introduction](../intro.md)
- [ ] [Ecosystem](../ecosystem.md)
- [ ] [Architecture overview](../architecture/overview.md)
- [ ] [Local setup](../project/local-setup.md) — bring up sd-main
      locally and smoke-test login.
- [ ] [Project structure](../project/structure.md)
- [ ] [Conventions](../project/conventions.md)
- [ ] [Modules overview](../modules/overview.md)

**Read as needed for your first ticket** (don't pre-read; pull these
in when the ticket touches them):

- Architecture deep-dives:
  [Multi-tenancy](../architecture/multi-tenancy.md),
  [Caching](../architecture/caching.md),
  [Background jobs](../architecture/jobs-and-scheduling.md).
- sd-billing local setup:
  [sd-billing local setup](../sd-billing/local-setup.md).
- Frontend track:
  [Frontend conventions](../frontend/conventions.md),
  [Adding a screen](../frontend/adding-a-screen.md),
  [Yii views](../frontend/yii-views.md),
  [JS plugins](../frontend/js-plugins.md),
  [ng-modules](../frontend/ng-modules.md),
  [Asset pipeline](../frontend/assets-pipeline.md).
- UI patterns:
  [Page layout](../ui/page-layout.md),
  [tables](../ui/tables.md),
  [filters](../ui/filters.md),
  [forms](../ui/forms.md),
  [modals](../ui/modals.md).

**Then:**

- [ ] Pick one user-visible flow and trace it end-to-end:
      Suggested flow: *agent submits a mobile order*.
      - Mobile request: [API v3 — `POST /api3/order/create`](../api/api-v3-mobile.md)
      - Controller handler in `protected/modules/api3/controllers/OrderController.php`
      - Validation + insert in `OrderService` / `Order` model
      - Stock reservation queue job
      - Status transition to `Reserved`
      - Read the [Order lifecycle](../architecture/diagrams.md) sequence
- [ ] Open one **starter ticket** (your manager will assign one).
      Recommended starters:

      *Backend-flavoured:*
      - Add a translation row in `protected/messages/uz/...`.
      - Convert a `Distr::getFilter()` caller to `QueryBuilder`.
      - Write a unit test for an existing service method.

      *Frontend-flavoured:*
      - Add a new column to an existing list view (e.g. an `Agent`
        column on the orders table) — touches a Yii view, the
        DataTables config, and i18n keys in
        `protected/messages/<locale>/orders.php`. Use
        [Adding a screen](../frontend/adding-a-screen.md) as the
        checklist.
      - Convert one inline `style="..."` in a view to a named CSS
        class.
      - Add a missing `aria-label` to one row-actions `⋮` menu and
        document it in [UI · Tables](../ui/tables.md).
      - Add one missing `Yii::t()` call where a literal RU string
        slipped through a view; add the corresponding `en` and
        `uz` keys.
- [ ] Submit your first PR. Follow
      [Coding standards](../quality/coding-standards.md) and
      [Contribution](../quality/contribution.md).

## Month 1

Goal: ship a customer-visible change and understand a second project.

- [ ] Ship a small feature (≤ 1-week scope) end-to-end including
      tests, docs update, release-notes entry.
- [ ] Read **one of**:
      - [sd-cs overview](../sd-cs/overview.md) +
        [sd-cs ↔ sd-main integration](../sd-cs/sd-main-integration.md)
        if you'll work on HQ reporting.
      - [sd-billing overview](../sd-billing/overview.md) +
        [Subscription flow](../sd-billing/subscription-flow.md) if
        you'll work on subscriptions / payments.
- [ ] Walk through 5 real production tickets in your project tracker
      and predict the diagnosis before reading the resolution.
- [ ] Pair with someone from QA on a regression test cycle (see
      [Team · QA](./qa.md)) — gives you the failure-mode
      catalogue.

## How we work

| Topic | Where to read |
|-------|---------------|
| Branching, PRs | [Coding standards](../quality/coding-standards.md), [Contribution](../quality/contribution.md) |
| Release process | [Release process](../quality/release-process.md) |
| Tests | [Testing](../quality/testing.md) |
| ADRs | [ADR index](../adr/index.md) |
| Diagrams | [Diagrams (FigJam)](../architecture/diagrams.md) |

## Who to ask

| Topic | Channel |
|-------|---------|
| Repo access / VPN | `#it-helpdesk` |
| sd-main domain questions | `#sd-main-eng` |
| sd-cs / HQ reporting | `#sd-cs-eng` |
| Billing & payments | `#sd-billing-eng` |
| QA process | `#qa` |
| Anything else | your tech lead |

## Pitfalls to avoid in your first month

- ❌ Touching `framework/` (vendored Yii 1.x). Don't.
- ❌ Adding `declare(strict_types=1)` to legacy files.
- ❌ Hard-coding a tenant DB name.
- ❌ Calling `Yii::app()->cache` directly — use `ScopedCache`.
- ❌ Adding new endpoints to `api` or `api2`. Use `api3` (mobile) or
  `api4` (online).
- ❌ Renaming columns on legacy tables. Existing call-sites depend on
  `UPPER_SNAKE_CASE`.

## Reference: useful one-liners

```bash
# Find every obsolete file in sd-main:
find protected -name "*.obsolete"

# Count modules:
ls protected/modules | wc -l

# Translation skeleton for a new RU page:
mkdir -p i18n/ru/docusaurus-plugin-content-docs/current/<path>
cp docs/<path>/<page>.md i18n/ru/docusaurus-plugin-content-docs/current/<path>/<page>.md

# Tail sd-main runtime log:
docker compose exec web tail -f protected/runtime/application.log
```

## Welcome aboard

Your first PR doesn't need to be impressive — it needs to demonstrate
you can land a change end-to-end. Focus on the loop, not the size.
Ask early, ask often.
