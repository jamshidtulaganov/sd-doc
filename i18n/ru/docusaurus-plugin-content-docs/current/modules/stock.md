---
sidebar_position: 7
title: stock
audience: Backend engineers, QA, PM
summary: Операции на уровне количества — возвраты, обмены, списания, закупки. Дополняет warehouse (который хранит документы).
topics: [stock, return, exchange, writeoff, purchase, reservation]
---

# Модуль `stock`

Операции на уровне количества поверх складского слоя: возвраты,
обмены между магазинами, списания, закупки. Дополняет
[`warehouse`](./warehouse.md) (который хранит заголовки документов).

## Ключевые возможности

| Возможность | Что делает | Роль(и) владельца |
|---------|--------------|---------------|
| Добавить возврат | Запись возврата на склад из дефекта / отказа | 1 / 9 / склад |
| Купить / закупка | Входящая закупка от поставщика | 1 / 9 |
| Обмен между магазинами | Перемещение остатков между розничными магазинами | 1 / 9 |
| Списание | Постоянное удаление (повреждение, кража) | 1 |
| Финансовый отчёт | Стоимость остатков, старение, неликвиды | 1 / 9 |
| Отчёт по магазинам | Состояние остатков по каждому магазину | 1 / 9 |
| Атомарная операция резервирования | `Stock::reserveForOrder()` выполняется в транзакции | system |

## Папка

```
protected/modules/stock/
├── controllers/
│   ├── AddReturnController.php
│   ├── BuyController.php
│   ├── ExchangeStoresController.php
│   ├── ExcretionController.php
│   ├── FinancialReportController.php
│   └── …
└── views/
```

## Сервисы остатков

Общий `StockService` (в `protected/components/`) — это **единственная
точка**, которая мутирует строки `stock`. Избегайте самописного SQL — там
прячутся ошибки конкурентного доступа.

## Резервирования

Когда заказ переходит в `Reserved`, `Stock::reserveForOrder()`
**атомарно** в одной транзакции уменьшает счётчик `available`
и увеличивает счётчик `reserved`.

## Ключевой поток функционала — дефект и возврат

См. **Feature · Online order + Defect/Return** в
[FigJam · sd-main · Feature Flows](https://www.figma.com/board/MyvyaeEluqvHofH4E2qIoU).

```mermaid
flowchart LR
  D(["Delivery"]) --> CHK{"All lines accepted (no defect)?"}
  CHK -->|yes| OK["STATUS=Delivered"]
  CHK -->|no| DEF["Defect rows"]
  DEF --> RTS["Return-to-stock job"]
  RTS --> RPT["Defect KPI"]
classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
classDef approval fill:#fef3c7,stroke:#92400e,color:#000
classDef success  fill:#dcfce7,stroke:#166534,color:#000
classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
classDef external fill:#f3f4f6,stroke:#374151,color:#000
classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000
class D,DEF,RTS,RPT action
class OK success
```

## Права доступа

| Действие | Роли |
|--------|-------|
| Возврат / списание | 1 / 9 |
| Закупка | 1 / 9 |
| Обмен между магазинами | 1 / 9 |
