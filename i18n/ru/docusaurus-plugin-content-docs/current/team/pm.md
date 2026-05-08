---
sidebar_position: 2
title: Product Management — процесс и база знаний
audience: Product team
summary: Шаблоны PRD, приоритизация RICE, release notes (EN/RU/UZ) и SalesDoctor-специфичный контекст PM. Помогает PM очерчивать новые фичи и оценивать влияние на три проекта.
topics: [pm, prd, rice, release-notes, prioritisation]
---

# Product Management — процесс и база знаний

Эта страница для **Product Manager**. Покрывает PM-жизненный цикл,
шаблоны и SalesDoctor-специфичные факторы, которые нужно учитывать при
проектировании или приоритизации фич.

Соответствующие FigJam-диаграммы —
[Workflow · PM](https://www.figma.com/board/YvAliP5jI2oqizJeOReYxk)
и Workflow · Release train (тот же файл).

## Цикл фаз

1. **Discover** — интервью, тикеты поддержки, обратная связь продаж,
   аналитика → opportunity-дерево.
2. **Define** — проблема, гипотеза, метрика, PRD, wireframes (Figma),
   tech-спайк, RICE.
3. **Deliver** — backlog, sprint, build, QA, UAT.
4. **Launch** — feature flag, release notes, обучение поддержки, мониторинг.
5. **Learn** — outcome vs гипотеза, итерация / убийство / масштабирование.

## Шаблон PRD / one-pager

```md
# PRD — <feature>

## Problem
What's broken / missing today, for whom.

## Hypothesis
If we ship X, we expect Y, measured by Z within N weeks.

## Goals & non-goals
- In scope
- Out of scope

## Success metrics
- Primary KPI
- Guard-rail metrics

## User stories
- As a <role>, I want <goal>, so that <benefit>.

## Solution sketch
- Wireframes link
- Key flows

## Edge cases & risks
## Rollout
- Target tenants
- Feature flag name
- Stages: 5 % → 25 % → 100 %
- Rollback plan

## Timeline & owners
```

## Скоринг RICE

| Поле | Значение |
|-------|---------|
| Reach | # тенантов / агентов, затронутых за квартал |
| Impact | 0.25 / 0.5 / 1 / 2 / 3 |
| Confidence | 50 % / 80 % / 100 % |
| Effort | человеко-недели |
| Score | (R × I × C) / E |

## Release notes (multi-lingual)

Переводите на **EN / RU / UZ** для каждого релиза. Шаблон:

```md
## v<sem>.<minor> — <date>

### New
- ...

### Improved
- ...

### Fixed
- ...

### Breaking
- ...

### Migration
- DB: yes / no, see `m<id>_<name>.php`
- Config: ...
```

## SalesDoctor-специфичный PM-контекст

Каждый PRD должен ответить на вопросы ниже до подписания.

### Какие проекты затрагиваются?

| Проект | Когда привлекать |
|---------|------------------|
| **sd-main** | По умолчанию — большинство фич затрагивает sd-main |
| **sd-cs** | Если фича требует консолидированной HQ-отчётности (cross-dealer) |
| **sd-billing** | Если фича влияет на subscription, лицензию или платёжный flow |

Если фича затрагивает **два** проекта, идентифицируйте контрактную
поверхность (API-эндпоинт, колонку БД, integration log) и проектируйте
её как внешнюю интеграцию.

### Какие роли затронуты?

Роли, которые важны почти для каждой фичи:

`Agent` (4) · `Operator` (5) · `Cashier` (6) · `Supervisor` (8) ·
`Manager` (9) · `Admin Filial` (2) · `Super Admin` (1) · `Expeditor`
(10) · `Partner` (7).

Фича не "отгружена", пока затронутые роли не знают, что она существует, и
затронутые экраны не задокументированы в
[секции wireframes](../ui/wireframes.md).

### Мобильный компаньон?

Для sd-main **мобильный опыт (api3) часто bottleneck для adoption**. Ни
одна фича не "отгружена", пока мобильный компаньон не задокументирован
(или явно out of scope).

### Compliance-интеграции?

В Узбекистане **интеграции 1C, Didox и Faktura.uz — deal-breakers**.
Если фича меняет данные заказа, планируйте integration-impact как
P0-зависимость.

### Multi-tenancy по умолчанию

Feature flag-и должны по умолчанию быть **OFF** и opt-in пер тенант.
Тенанты с кастомным контрактом могут раскатить раньше; дефолтные тенанты
получают фичу только после верификации.

### Языки

UI-строки в `ru / en / uz / tr` (и частичный `fa`). Не отгружайте фичу
с английскими строками only.

## Полезные внутренние ссылки

- [Modules overview](../modules/overview.md) — чтобы очертить, что
  затронуто
- [Ecosystem](../ecosystem.md) — карта 3-проекта
- [API reference](../api/overview.md) — для дизайна endpoint-поверхности
- [Wireframes](../ui/wireframes.md) — текущие UI-паттерны
- [sd-billing security landmines](../sd-billing/security-landmines.md) —
  PM-видимые debt-пункты
