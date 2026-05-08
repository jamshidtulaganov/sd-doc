---
sidebar_position: 14
title: onlineOrder
audience: Backend engineers, QA, PM, B2B customers
summary: B2B онлайн-магазин + канал заказа через Telegram-бот — клиенты размещают заказы напрямую без визита агента.
topics: [online-order, b2b, telegram, webapp, self-service, online-payment]
---

# Модуль `onlineOrder`

B2B онлайн-магазин + канал заказа через Telegram-бот. Клиенты (или
их операторы) размещают заказы без визита агента.

## Ключевые возможности

| Возможность | Что делает | Роль(и) владельца |
|---------|--------------|---------------|
| Просмотр публичного каталога | Клиент просматривает товары с фильтрами по категории / бренду / наличию | конечный клиент |
| Корзина + размещение заказа | Клиент отправляет через api4 | конечный клиент |
| Редирект на онлайн-оплату | Передача в Click / Payme / Paynet для оплаты | конечный клиент |
| Поток оплаты позже | Для клиентов с кредитом; проходит через стандартный пайплайн заказа | конечный клиент |
| История заказов | Клиент видит прошлые заказы + статусы + скачиваемые счета | конечный клиент |
| Контактная форма | Связь с командой операторов через портал | конечный клиент |
| Отчёты | Отчёты по собственному потреблению клиента | конечный клиент |
| Запланированные отчёты | Периодические дайджесты отчётов на email | конечный клиент |
| Telegram-бот | `/start`, `/catalog`, `/order`, `/orders`, `/help` | конечный клиент |
| Telegram WebApp | Встроенный SPA внутри Telegram для полного оформления заказа | конечный клиент |

## Контроллеры

| Контроллер | Назначение |
|------------|---------|
| `CatalogController` | Просмотр публичного каталога |
| `ContactController` | Контактная форма / сообщения |
| `OrderController` | Размещение заказа и история |
| `PaymentController` | Редирект на онлайн-оплату |
| `ReportController` | Собственные отчёты клиента |
| `ScheduledReportController` | Периодические отчёты на email |
| `TelegramController` | Webhook Telegram-бота |
| `WebAppController` | Хост Telegram WebApp |

## Аутентификация

Онлайн-пользователи аутентифицируются по той же таблице `User`, но
с другой `ROLE`. Сессии по-прежнему проходят через Redis db0 с
префиксом `HTTP_HOST`.

## Ключевой поток функционала — онлайн-заказ

См. **Feature · Online order + Defect/Return** в
[FigJam · sd-main · Feature Flows](https://www.figma.com/board/MyvyaeEluqvHofH4E2qIoU).

```mermaid
flowchart LR
  C(["Customer login api4"]) --> CAT["Catalog"]
  CAT --> CRT["Cart"]
  CRT --> SUB["POST /api4/order/create"]
  SUB --> ORD["Order STATUS=New"]
  ORD --> PAY{"Pay now?"}
  PAY -->|yes| RDR[("Redirect to provider")]
  RDR --> CB["Callback verify"]
  CB --> AP(["Mark paid"])

  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000

  class C,CAT,CRT,SUB,ORD,PAY,CB action
  class RDR external
  class AP success
```
