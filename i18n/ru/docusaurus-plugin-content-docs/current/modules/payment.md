---
sidebar_position: 10
title: payment / pay
audience: Backend engineers, QA, PM, Cashier
summary: Два связанных модуля — pay (низкоуровневая регистрация платежей) и payment (воркфлоу утверждения кассиром поверх него).
topics: [payment, approval, cashier, cash, non-cash]
---

# Модули `payment` и `pay`

Два связанных модуля:

- **`pay`** — низкоуровневая регистрация платежей (записи против заказов).
- **`payment`** — воркфлоу утверждения поверх `pay`.

## Ключевые возможности

| Возможность | Что делает | Роль(и) владельца |
|---------|--------------|---------------|
| Регистрация платежа | Создание строки `Payment`, привязанной к заказу | Агент / Оператор |
| Утверждение платежа | Кассир подтверждает реальность платежа | Кассир |
| Отклонение платежа | Кассир отклоняет с указанием причины | Кассир |
| Применение к долгу | При утверждении применяется к долгу клиента + кассе | system |
| Переназначение на другой заказ | Оператор может перенаправить ошибочный платёж | 1 / 6 |
| Уведомление | Агент + клиент уведомляются об исходе | system |

## Поток утверждения

См. **Feature · Payment Collection & Approval** в
[FigJam · sd-main · Feature Flows](https://www.figma.com/board/MyvyaeEluqvHofH4E2qIoU).

```mermaid
flowchart LR
  A["Agent collects cash"] --> B["Pay record created"]
  B --> C{"Approval needed?"}
  C -- yes --> D["Cashier reviews"]
  D --> E["Approved / Rejected"]
  C -- no --> F["Auto-applied"]
  E --> F
classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
classDef approval fill:#fef3c7,stroke:#92400e,color:#000
classDef success  fill:#dcfce7,stroke:#166534,color:#000
classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
classDef external fill:#f3f4f6,stroke:#374151,color:#000
classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
class A,B,F action
class D approval
class E success
```

`payment/ApprovalController` — экран проверки кассиром.

## Аудит воркфлоу

См. [Стандарты дизайна воркфлоу](../team/workflow-design.md) — этот
поток оценён по 12 принципам дизайна. Открытые задачи: добавить
порог автоутверждения, фиксировать причину отклонения, добавить таймер SLA.

## Права доступа

| Действие | Роли |
|--------|-------|
| Создание | 4 / 5 / 6 |
| Утверждение / отклонение | 6 (кассир) / 1 / 2 |
| Переназначение | 1 / 6 |
