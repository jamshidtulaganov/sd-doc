---
sidebar_position: 6
title: Diagrammalar (FigJam)
---

# Diagrammalar

Barcha kanonik SalesDoctor arxitektura va ish jarayoni diagrammalari **bitta
konsolidatsiyalangan FigJam masterda** yashaydi va sohaga ko'ra yuqori
darajadagi Sectionlarga taqsimlangan. Masterni bir marta oching va
sectionlar orasida scroll qiling — har bir diagramma bir xil canvas da.

## Master doska

**[Master FigJam ni oching](https://www.figma.com/board/y2kWMuxLwrpdaCGhVwYYYI)**

| # | Section | Ichida nima bor |
|---|---------|---------------|
| 1 | **System Design** | Ekotizim · sd-main System Architecture · sd-billing Architecture · sd-cs Architecture (multi-DB) · sd-main Core ERD · sd-billing Domain ERD |
| 2 | **Inter-project integration & feature catalog** | Loyihalararo integratsiya xaritasi (sd-cs ↔ sd-main ↔ sd-billing endpointlari) · Loyiha bo'yicha asosiy xususiyatlar katalogi |
| 3 | **sd-billing workflows** | Subscription Lifecycle · Click two-phase payment · Payme JSON-RPC payment · Settlement cron · Notify cron · sd-billing integration sequence |
| 4 | **sd-cs workflows** | sd-cs Onboarding Flow |
| 5 | **sd-main Order flows** | Order State Machine · Order Create (api3) · Payment Collection & Approval · Online Order · Client Approval |
| 6 | **sd-main Field & ops flows** | Visit & GPS Geofence · Warehouse Goods Receipt · Inventory Stocktake · Defect & Return · Audit Submission |

Jami 25 ta diagramma. Kelajakdagi Process Workflows (QA / PM / Release / Bug
lifecycle) uchun alohida joy egallovchi, ushbu jarayonlar kod bazasida rasmiy
ravishda hujjatlashtirilgunga qadar masterdan tashqarida qoldirilgan.

## Nega bitta doska

Yirik CRM jamoalari (Salesforce Architects, Zoho) avval arxitektura
materiallarini bir nechta yo'naltirilgan doskalarda — har bir auditoriya
uchun bittadan, har bir abstraktsiya darajasi uchun bittadan — chop etishar
edi, lekin amaliyotda o'quvchilar qaysi doskani ochish kerakligini yo'qotib
qo'yishadi. Nomli Sectionlarga ega bitta master C4 modeliga (Context →
Container → Component) mos keladi va shu bilan birga hammasini bir click
masofada saqlaydi. Sectionlar sahifalar beradigan bir xil vizual bo'linishni
beradi; FigJam Plugin API bugun dasturiy sahifa yaratishni ochib bermaydi,
shuning uchun Sectionlar to'g'ri vositadir.

## Haqiqat manbasi — hujjatlardagi Mermaid

Har bir diagrammaning Mermaid manbasi **mos keluvchi hujjat sahifasida ichki
ravishda** yashaydi. Mermaid blokini tahrirlang, lokal lint qiling, keyin
FigJam nusxasini yangilash uchun master `fileKey` ga qarshi
`generate_diagram` ni qayta ishga tushiring.

| Section diagrammasi | Mermaid manbasi |
|-----------------|----------------|
| Ekotizim | [`docs/ecosystem.md`](../ecosystem.md) |
| Loyihalararo integratsiya xaritasi | [`docs/ecosystem.md`](../ecosystem.md) |
| Loyiha bo'yicha asosiy xususiyatlar katalogi | [`docs/ecosystem.md`](../ecosystem.md) |
| sd-main System Architecture | [`docs/architecture/overview.md`](./overview.md) |
| sd-billing Architecture | [`docs/sd-billing/overview.md`](../sd-billing/overview.md) |
| sd-cs Architecture (multi-DB) | [`docs/sd-cs/overview.md`](../sd-cs/overview.md) |
| sd-main Core ERD | [`docs/data/erd.md`](../data/erd.md) |
| sd-billing Domain ERD | [`docs/sd-billing/domain-model.md`](../sd-billing/domain-model.md) |
| Subscription Lifecycle | [`docs/sd-billing/subscription-flow.md`](../sd-billing/subscription-flow.md) |
| Click / Payme to'lov ketma-ketliklari | [`docs/sd-billing/payment-gateways.md`](../sd-billing/payment-gateways.md) |
| Settlement & Notify cron | [`docs/sd-billing/cron-and-settlement.md`](../sd-billing/cron-and-settlement.md) |
| sd-billing integration sequence | [`docs/sd-billing/integration.md`](../sd-billing/integration.md) |
| sd-cs Onboarding | [`docs/sd-cs/sd-main-integration.md`](../sd-cs/sd-main-integration.md) |
| Order State Machine + Order Create | [`docs/modules/orders.md`](../modules/orders.md) |
| Payment Collection & Approval | [`docs/modules/payment.md`](../modules/payment.md) |
| Online Order | [`docs/modules/onlineOrder.md`](../modules/onlineOrder.md) |
| Client Approval | [`docs/modules/clients.md`](../modules/clients.md) |
| Visit & GPS Geofence | [`docs/modules/agents.md`](../modules/agents.md) |
| Warehouse Goods Receipt | [`docs/modules/warehouse.md`](../modules/warehouse.md) |
| Inventory Stocktake | [`docs/modules/inventory.md`](../modules/inventory.md) |
| Defect & Return | [`docs/modules/stock.md`](../modules/stock.md) |
| Audit Submission | [`docs/modules/audit-adt.md`](../modules/audit-adt.md) |

Stilizatsiya cookbook i (rang taksonomiyasi, shakl lug'ati, swimlane
retsepti, oq subgraph qoidasi) [Workflow design standards · Mermaid styling cookbook](../team/workflow-design.md#mermaid-styling-cookbook)
da yashaydi. Push qilishdan oldin Mermaid bloklarini lokal ravishda
`npm run lint:mermaid` bilan lint qiling.

## Eski doskalar (eskirgan — faqat redirect)

Avvalgi 6 ta doska tozalangan va har biri bu yerga ishora qiluvchi sticker
ko'tarib turadi. Ularni tahrirlamang; kanonik kontent yuqoridagi master.

| Eski doska | Sticker redirect | Status |
|--------------|-----------------|--------|
| Ekotizim | https://www.figma.com/board/NIhRaLqT67FQZNKq4cLQtr | Tozalangan |
| sd-billing | https://www.figma.com/board/8gPJ5OFsIjhhaKFn4kRwDH | Tozalangan |
| sd-cs (HQ) | https://www.figma.com/board/n7CzNpfgyykdCYYJiuQG7L | Tozalangan |
| sd-main · System Design | https://www.figma.com/board/tw0B3eE1bKNbvmmny8TVvx | Tozalangan |
| sd-main · Feature Flows | https://www.figma.com/board/MyvyaeEluqvHofH4E2qIoU | Tozalangan |
| Process Workflows | https://www.figma.com/board/YvAliP5jI2oqizJeOReYxk | Bo'sh (manba hali yozilmagan) |
| All-in-one (juda eski arxiv) | https://www.figma.com/board/KH7PL28JoBs1GOvf6MxkJj | Konsolidatsiyadan oldingi; tahrirlamang |

## Hujjatlarga PNG larni embed qilish

Masterdagi har bir diagrammani alohida eksport qilish mumkin. PNG larni
`static/diagrams/<name>.png` ga tashlang va har qanday markdown dan
murojaat qiling:

```markdown
![Ecosystem](/diagrams/ecosystem.png)
```

## Diagramma qanday qo'shish yoki yangilash

Manba hujjatlardagi Mermaid kanonikdir. FigJam master — bu qayta
generatsiya qilinadigan nusxa. Avval hujjatni tahrirlang, lint qiling,
keyin FigJam ni push qiling.

### Old shartlar

- `generate_diagram` va `use_figma` vositalari mavjud Figma MCP. (Yozilayotgan
  vaqtda ikkalasini ham ochib beradigan `959fd320-…` server qisman ishlaydi.
  Agar faqat read-only Figma MCP ulangan bo'lsa, hujjatlarda Mermaid yozish +
  lint qilish mumkin, lekin FigJam ga push qilib bo'lmaydi — FigJam
  yangilashni keyingi sessiyaga qoldiring.)
- Master `fileKey`: `y2kWMuxLwrpdaCGhVwYYYI`.
- Cookbook: [Workflow design standards · Mermaid styling cookbook](../team/workflow-design.md#mermaid-styling-cookbook).

### A. Mavjud diagrammani yangilash

Manba Mermaid o'zgarganda (masalan, holat o'tishi qo'shilgan, label
mahkamlangan):

1. Manba hujjatdagi **Mermaid blokini tahrirlang**. Cookbook ga mos keling —
   o'lchanadigan predikatlar, rol bo'yicha nomlangan action node lari, oq
   subgraph to'ldirishlari, classDef ranglari.
2. Render xatolarini push qilishdan oldin tutib olish uchun **lokal lint
   qiling**:
   ```bash
   npm run lint:mermaid -- docs/path/to/file.md
   ```
   Yoki butun repo bo'yicha ishga tushiring: `npm run lint:mermaid`.
3. Masterdagi mavjud diagrammani nom bo'yicha **toping**. `use_figma`
   so'rovini ishga tushiring:
   ```js
   // skillNames: "figma-use", fileKey: y2kWMuxLwrpdaCGhVwYYYI
   const TARGET_NAME = "Order State Machine"; // exact diagram name
   const sections = figma.root.children[0].children.filter(n => n.type === "SECTION");
   const matches = [];
   for (const s of sections) {
     for (const child of s.children) {
       if (child.name === TARGET_NAME || (child.children || []).some(c => c.name === TARGET_NAME)) {
         matches.push({ sectionId: s.id, sectionName: s.name, nodeId: child.id, nodeName: child.name });
       }
     }
   }
   return { matches };
   ```
4. Ushbu Section ichidan **eski diagramma node larini olib tashlang**
   (qaytgan ID lar bilan keyingi `use_figma` ni ishga tushiring). Section
   ning o'zini saqlab qoling.
5. Faylga **yangi Mermaid ni generatsiya qiling**:
   ```
   generate_diagram(
     name: "Order State Machine",
     fileKey: "y2kWMuxLwrpdaCGhVwYYYI",
     mermaidSyntax: <verbatim block from the doc, without the ```mermaid fences>,
     userIntent: "Refresh after edit in docs/modules/orders.md"
   )
   ```
6. Qavs-va-ko'chirish patterni yordamida **yangi node larni to'g'ri Section
   ga qaytarib ko'chiring**:
   ```js
   // Snapshot BEFORE generate (run as use_figma):
   const page = figma.root.children[0];
   await figma.setCurrentPageAsync(page);
   return { ids: page.children.map(n => n.id) };
   ```
   ```js
   // After generate, run use_figma with PRE_IDS captured above + TARGET_SECTION_ID:
   const PRE_IDS = ["..."]; // from snapshot
   const TARGET_SECTION_ID = "...";
   const page = figma.root.children[0];
   await figma.setCurrentPageAsync(page);
   const newNodes = page.children.filter(n => !PRE_IDS.includes(n.id));
   const target = await figma.getNodeByIdAsync(TARGET_SECTION_ID);
   for (const n of newNodes) target.appendChild(n);
   return { moved: newNodes.length };
   ```
7. `Update <flow> diagram (refreshed in master FigJam)` kabi xabar bilan
   hujjat tahririni **commit qiling**.

### B. Mutlaqo yangi diagramma qo'shish

Yangi xususiyat oqimi katalogga qo'shilganda:

1. To'g'ri manba hujjatda **Mermaid blokini yozing** (proza yashaydigan bir
   xil modul sahifasida — har bir xususiyat uchun haqiqat manbasini bir
   sahifada saqlang).
2. Yuqoridagi kabi **lint qiling**.
3. Masterdagi maqsad Section ni **hal qiling** (ushbu sahifada avval keltirilgan
   oltita bittasidan biri). Agar diagramma mavjud sectionlarning birortasiga
   mos kelmasa, push qilishdan oldin PR ko'rib chiqishda yangi section
   taklif qiling.
4. `figma.root.children[0].children` ni bir marta o'qib, **Section ning id
   sini qayd qiling**.
5. **Qavs-va-ko'chirish**: pre-generate ID larini snapshot qilish →
   `generate_diagram` ni chaqirish → diff va maqsad Section ga ko'chirish.
   Yuqoridagi 6-qadam bilan bir xil pattern.
6. Agar yangi diagramma har bir section jadvalida ko'rinishi kerak bo'lsa,
   ushbu `diagrams.md` sahifasini **yangilang**.
7. Manba hujjat + ushbu sahifani bitta commit da **commit qiling**.

### C. Bugun vosita mavjud emas — qanday qilib ham harakat qilish kerak

Agar `generate_diagram` / `use_figma` ulanmagan bo'lsa:

- Hujjatdagi Mermaid ni tahrirlang, `npm run lint:mermaid` bilan lint
  qiling, commit qiling. Hujjat tushadi; FigJam eskirgan.
- Keyingi issue oching: `Sync <diagram name> to master FigJam`.
- Keyingi safar MCP qaytib kelganda, har bir kechiktirilgan diagramma uchun
  A yoki B dagi protsedurani ishga tushiring. Hujjatdagi bir xil Mermaid
  hali ham kanonikdir — qayta ishlash kerak emas.
