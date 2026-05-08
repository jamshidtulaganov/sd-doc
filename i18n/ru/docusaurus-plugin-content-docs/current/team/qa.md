---
sidebar_position: 1
title: QA — процесс и база знаний
audience: QA team
summary: Тест-планы, баг-репорты, определения severity, регрессионные горячие точки и sign-off релизов для SalesDoctor (sd-cs · sd-main · sd-billing).
topics: [qa, testing, regression, bug-report, sign-off]
---

# QA — процесс и база знаний

Эта страница для **членов QA-команды**. Покрывает процесс тестирования,
шаблоны и SalesDoctor-специфичные регрессионные области, которые нужно
перетестировать на каждом релизе.

Соответствующие FigJam-доски —
[Workflow · QA process](https://www.figma.com/board/YvAliP5jI2oqizJeOReYxk)
и Workflow · Bug lifecycle (тот же файл).

## Фазы

1. **Plan** — читаем PRD, ранжируем фичи по риску, определяем критерии
   приёмки.
2. **Design** — пишем тест-кейсы (positive, negative, edge), собираем
   тестовые данные, выявляем кандидатов на автоматизацию.
3. **Execute** — smoke → functional → regression → E2E (mobile + web +
   api3 + api4) → performance.
4. **Bugs** — воспроизводим → фиксируем → триаж → фикс → верификация → close.
5. **Sign-off** — UAT, release notes, go / no-go.

## Шаблон тест-плана

```md
# Test plan: <feature>

## Scope
- Included: ...
- Excluded: ...

## Risk assessment
| Risk | Likelihood | Impact | Mitigation |

## Environments
- Dev: ...
- Staging: ...
- Prod: ...

## Approach
- Manual: ...
- Automation: ...

## Entry / exit criteria
## Test cases
| ID | Title | Steps | Expected | Priority |

## Schedule & owners
```

## Шаблон баг-репорта

```md
# <one-line summary>
- Severity: S1 / S2 / S3 / S4
- Priority: P0 / P1 / P2 / P3
- Environment: prod / staging / dev
- Build / version: <git sha>
- Tenant: <subdomain>
- Role: <Agent / Admin / ...>

## Steps to reproduce
1. ...
2. ...

## Actual
## Expected
## Evidence
- Screenshots
- HAR / logs

## Reproducibility
- 5/5 — always
- 3/5 — intermittent
```

## Определения severity

| Sev | Определение |
|-----|------------|
| S1 | Production лежит или повреждение данных |
| S2 | Major-фича непригодна, нет workaround |
| S3 | Major-фича деградирована, есть workaround |
| S4 | Minor / косметика |

## Регрессионные горячие точки SalesDoctor

Это области с высокой ценностью, где прячутся регрессии. Перетестируйте
их на каждом релизе во всех трёх проектах.

### sd-main

| Область | Что проверять | Почему важно |
|------|----------------|----------------|
| Order status transitions | Каждый прыжок STATUS / SUB_STATUS (`Draft → New → Reserved → Loaded → Delivered → Paid → Closed`, плюс `Cancelled` / `Defect` / `Returned`) | Застрявшие заказы — это потерянные деньги |
| Изоляция тенантов | Переключение поддомена никогда не утечёт данные — логин на тенанте A, запрос на тенанте B → access denied | Compliance, контрактные обязательства |
| Инвалидация кеша | Изменили цену / категорию → следующее чтение показывает новое значение в течение ≤ 10 мин | Клиенты звонят про неправильные цены |
| Mobile offline → sync | Перевести телефон в offline посреди визита, делать заказы, восстановить связь | Драйверы в "мёртвых зонах" |
| 1C / Didox / Faktura.uz round-trip | Сабмит заказа, проверка появления в 1C с правильным INN + НДС | Compliance / dealer accounting |
| GPS геофенс | Визит на грани радиуса изнутри vs снаружи | Точность KPI |
| Bonus order linkage | Бонусный заказ ссылается обратно через `BONUS_ORDER_ID` | Целостность settlement |

### sd-cs

| Область | Что проверять |
|------|----------------|
| Cross-dealer консистентность отчётов | Сумма per-dealer строк == HQ aggregate ± 0 |
| Дрейф схемы дилеров | Запустить отчёт против дилеров на разных версиях sd-main |
| Read-only enforcement | sd-cs не может UPDATE на таблице `d0_*` (тестировать намеренно сломанным запросом) |
| Per-tenant кеш | Бамп кеша для дилера A не влияет на B |

### sd-billing

| Область | Что проверять |
|------|----------------|
| Click prepare/confirm | Повторный confirm с тем же trans id — тот же ответ, без двойной зарядки |
| Payme идемпотентность | `CreateTransaction` повторён — без дублирующейся строки Payment |
| Settlement | Distributor + dealer пара суммируется в ноль за месяц |
| Licence expiry → reminder | Истечение минус 7/3/1 дней → отправлены Telegram + SMS |
| Subscription refresh | Новая строка `Payment` триггерит `Diler.refresh()` немедленно |
| Notify-cron drain | Очередь `d0_notify_cron` опустошается в течение минуты |

## Done = эти проверки пройдены

- [ ] Все P0 / P1 кейсы выполнены
- [ ] Нет открытых S1 / S2 багов
- [ ] Регрессионный набор зелёный
- [ ] Performance baseline в пределах ±10 % от прошлого релиза
- [ ] Release notes составлены на EN / RU / UZ

## Полезные внутренние ссылки

- [Modules overview](../modules/overview.md) — чтобы найти, что тестировать
- [API reference](../api/overview.md) — для endpoint-уровня тест-кейсов
- [sd-billing security landmines](../sd-billing/security-landmines.md) —
  активные риски
- [sd-cs ↔ sd-main integration](../sd-cs/sd-main-integration.md) —
  cross-DB сценарии
