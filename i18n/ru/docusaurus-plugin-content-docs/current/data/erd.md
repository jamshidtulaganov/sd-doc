---
sidebar_position: 2
title: ER
---

# ER-диаграмма (entity-relationship)

Канонический ER — это FigJam-диаграмма, открывайте
[Страницу диаграмм](../architecture/diagrams.md), чтобы попасть к ней.
Локально отрендеренная Mermaid-версия ниже.

```mermaid
erDiagram
  FILIAL ||--o{ USER : has
  FILIAL ||--o{ AGENT : employs
  FILIAL ||--o{ CLIENT : owns
  FILIAL ||--o{ ORDER : owns
  FILIAL ||--o{ STOCK : owns
  AGENT ||--o{ VISIT : performs
  AGENT ||--o{ ORDER : creates
  CLIENT ||--o{ ORDER : places
  CLIENT ||--o{ VISIT : receives
  CLIENT ||--o{ PAYMENT : pays
  ORDER ||--|{ ORDER_LINE : contains
  ORDER_LINE }o--|| PRODUCT : refers
  PRODUCT }o--|| CATEGORY : in
  PRODUCT ||--o{ STOCK : tracked
  STOCK }o--|| WAREHOUSE : at
  ORDER ||--o{ PAYMENT : settled_by
  ORDER ||--o{ INVOICE : invoiced
  AUDIT ||--o{ AUDIT_RESULT : produces
  AUDIT_RESULT }o--|| CLIENT : at
  GPS_TRACK }o--|| AGENT : from
```

Когда экспортируете FigJam-версию, положите её в `static/diagrams/erd.png`
и сошлитесь:

```markdown
![Core ERD](/diagrams/erd.png)
```
