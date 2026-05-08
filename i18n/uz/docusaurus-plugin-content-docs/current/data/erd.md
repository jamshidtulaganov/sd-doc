---
sidebar_position: 2
title: ERD
---

# Entity-relationship diagrammasi

Kanonik ERD — bu FigJam diagrammasi — kirish uchun [Diagrams sahifasi](../architecture/diagrams.md) ni oching. Mahalliy ravishda render qilingan Mermaid versiyasi quyida.

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

FigJam versiyasini eksport qilganingizda, uni `static/diagrams/erd.png` ga tashlang va havola qiling:

```markdown
![Core ERD](/diagrams/erd.png)
```
