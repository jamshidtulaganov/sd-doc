---
sidebar_position: 17
title: report
---

# `report` module

The single largest module (80+ reports). Each report is its own controller
returning HTML + Excel.

## Controllers (selected)

`AgentController`, `AnalyzeController`, `BonusController`,
`BonusAccumulationController`, plus dozens more for sales, debt, returns,
defects, audits, GPS, KPI, etc.

## Authoring a report

1. Create a controller under `protected/modules/report/controllers/`.
2. Subclass `BaseReport` (`protected/components/BaseReport.php`).
3. Define `dataProvider()`, `columns()`, and `excel()` overrides.
4. Add a sidebar entry in the report nav config.

## Key feature flow — Report run

See **Feature — Report Run & Excel Export** in the
[FigJam board](../architecture/diagrams.md).

```mermaid
flowchart LR
  U[Open report] --> F[Set filters]
  F --> CHK{Cache hit?}
  CHK -->|yes| R[Render]
  CHK -->|no| SQL[Aggregate SQL]
  SQL --> CACHE[redis_app TTL 300s]
  CACHE --> R
  R --> EX{Export?}
  EX -->|yes| XLS[PHPExcel -> .xlsx]
```

## Excel export

Powered by `phpexcel`. Conventions for number formatting are governed by
the `params.excelFormat` config:

```php
'excelFormat' => [
    'count'  => 1, // formatted with thin space
    'volume' => 0, // raw float
    'summa'  => 2, // currency style ("$1,234.00")
],
```
