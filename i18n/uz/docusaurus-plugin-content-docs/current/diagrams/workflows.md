---
sidebar_position: 7
title: "Jarayon ish jarayonlari"
audience: Jamoaning barcha a'zolari
summary: "Ilova xususiyat oqimlari bo'lmagan operatsion-jarayon diagrammalari."
topics: [diagrams, workflows]
---

# Jarayon ish jarayonlari — diagramma galereyasi

Ilova xususiyat oqimlari bo'lmagan operatsion-jarayon diagrammalari.

Ushbu guruhdagi 3 ta diagrammaning hammasi ichki ko'rinishda chizilgan.

## Indeks

| # | Sarlavha | Tur | Manba sahifa |
|---|-------|------|-------------|
| 01 | [Oldin / keyin — to'lovni tasdiqlash oqimi](#d-01) | `flowchart` | [team/workflow-design](/docs/team/workflow-design) |
| 02 | [Swimlane retsepti](#d-02) | `flowchart` | [team/workflow-design](/docs/team/workflow-design) |
| 03 | [Ingestion pipeline (yuqori daraja)](#d-03) | `flowchart` | [team/rag-indexing](/docs/team/rag-indexing) |

## 01. Oldin / keyin — to'lovni tasdiqlash oqimi {#d-01}

- **Turi**: `flowchart`
- **Manba sahifa**: [team/workflow-design](/docs/team/workflow-design)
- **Boshlovchi bo'lim**: Oldin / keyin — to'lovni tasdiqlash oqimi

```mermaid
flowchart LR
  A["Agent collects cash"] --> B["Pay record created"]
  B --> C{"Approval needed?"}
  C -- yes --> D["Cashier reviews [SLA 4h]"]
  D --> E{"Approved?"}
  E -- yes --> F(["Auto-applied"])
  E -- no --> R(["Rejected"])
  C -- no --> F

  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000

  class A,B action
  class C,D,E approval
  class F success
  class R reject
```

## 02. Swimlane retsepti {#d-02}

- **Turi**: `flowchart`
- **Manba sahifa**: [team/workflow-design](/docs/team/workflow-design)
- **Boshlovchi bo'lim**: Swimlane retsepti

```mermaid
flowchart TB
  subgraph Agent
    A1["Collect payment"]
  end
  subgraph Cashier
    C1{"Amount > threshold?"}
    C2["Review"]
  end
  subgraph System
    S1[("Apply to debt")]
    S2[("Write PaymentDeliverHistory")]
  end
  A1 --> C1
  C1 -- yes --> C2 --> S1
  C1 -- no --> S1
  S1 --> S2

  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000

  class A1 action
  class C1,C2 approval
  class S1,S2 external
```

## 03. Ingestion pipeline (yuqori daraja) {#d-03}

- **Turi**: `flowchart`
- **Manba sahifa**: [team/rag-indexing](/docs/team/rag-indexing)
- **Boshlovchi bo'lim**: Ingestion pipeline (yuqori daraja)

```mermaid
flowchart LR
  REPO(["sd-docs git repo"]) --> BUILD["Docusaurus build"]
  BUILD --> RAW["Markdown + frontmatter"]
  RAW --> CHUNK["Section chunker"]
  CHUNK --> EMB[("Embedding model")]
  EMB --> VDB[("Vector DB")]
  VDB --> CHAT(["Team chat / IDE assistant"])

  classDef action   fill:#dbeafe,stroke:#1e40af,color:#000
  classDef approval fill:#fef3c7,stroke:#92400e,color:#000
  classDef success  fill:#dcfce7,stroke:#166534,color:#000
  classDef reject   fill:#fee2e2,stroke:#991b1b,color:#000
  classDef external fill:#f3f4f6,stroke:#374151,color:#000
  classDef cron     fill:#ede9fe,stroke:#6d28d9,color:#000

  class REPO,BUILD,RAW,CHUNK action
  class EMB,VDB external
  class CHAT success
```

