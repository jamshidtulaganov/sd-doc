---
sidebar_position: 2
title: ERD
---

# Entity-relationship diagram

The canonical ERD is the FigJam diagram — open the
[Diagrams page](../architecture/diagrams.md) to access it. A locally
rendered Mermaid version is below.

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

When you export the FigJam version, drop it at `static/diagrams/erd.png`
and reference it:

```markdown
![Core ERD](/diagrams/erd.png)
```
