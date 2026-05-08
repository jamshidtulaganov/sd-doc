---
sidebar_position: 6
title: Диаграммы (FigJam)
---

# Диаграммы

Все каноничные диаграммы архитектуры и воркфлоу SalesDoctor живут в **одном консолидированном FigJam-мастере**, организованном по доменам в верхнеуровневые секции. Откройте мастер один раз и прокручивайте между секциями — каждая диаграмма на одном холсте.

## Мастер-доска

**[Открыть мастер FigJam](https://www.figma.com/board/y2kWMuxLwrpdaCGhVwYYYI)**

| # | Секция | Что внутри |
|---|---------|---------------|
| 1 | **Системный дизайн** | Экосистема · sd-main System Architecture · sd-billing Architecture · sd-cs Architecture (multi-DB) · sd-main Core ERD · sd-billing Domain ERD |
| 2 | **Межпроектная интеграция и каталог фич** | Карта межпроектной интеграции (sd-cs ↔ sd-main ↔ sd-billing endpoints) · Каталог ключевых фич по проектам |
| 3 | **Воркфлоу sd-billing** | Subscription Lifecycle · Click two-phase payment · Payme JSON-RPC payment · Settlement cron · Notify cron · sd-billing integration sequence |
| 4 | **Воркфлоу sd-cs** | sd-cs Onboarding Flow |
| 5 | **Order-флоу sd-main** | Order State Machine · Order Create (api3) · Payment Collection & Approval · Online Order · Client Approval |
| 6 | **Field & ops флоу sd-main** | Visit & GPS Geofence · Warehouse Goods Receipt · Inventory Stocktake · Defect & Return · Audit Submission |

Всего 25 диаграмм. Отдельный плейсхолдер для будущих Process Workflows (QA / PM / Release / Bug lifecycle) оставлен вне мастера, пока эти процессы не задокументированы формально в кодовой базе.

## Почему одна доска

Команды больших CRM (Salesforce Architects, Zoho) раньше публиковали архитектурные материалы по нескольким сфокусированным доскам — одна на аудиторию, одна на уровень абстракции — но на практике читатели теряются, какую доску открыть. Один мастер с именованными секциями соответствует модели C4 (Context → Container → Component) и при этом всё в одном клике. Секции дают то же визуальное разделение, что и страницы; FigJam Plugin API сегодня не предоставляет программное создание страниц, поэтому Sections — правильный инструмент.

## Источник истины — Mermaid в доках

Mermaid-исходник каждой диаграммы живёт **inline на соответствующей странице доков**. Отредактируйте Mermaid-блок, локально запустите линт, затем повторно прогоните `generate_diagram` против мастер-`fileKey`, чтобы обновить FigJam-копию.

| Диаграмма секции | Mermaid-исходник |
|-----------------|----------------|
| Экосистема | [`docs/ecosystem.md`](../ecosystem.md) |
| Карта межпроектной интеграции | [`docs/ecosystem.md`](../ecosystem.md) |
| Каталог ключевых фич по проектам | [`docs/ecosystem.md`](../ecosystem.md) |
| sd-main System Architecture | [`docs/architecture/overview.md`](./overview.md) |
| sd-billing Architecture | [`docs/sd-billing/overview.md`](../sd-billing/overview.md) |
| sd-cs Architecture (multi-DB) | [`docs/sd-cs/overview.md`](../sd-cs/overview.md) |
| sd-main Core ERD | [`docs/data/erd.md`](../data/erd.md) |
| sd-billing Domain ERD | [`docs/sd-billing/domain-model.md`](../sd-billing/domain-model.md) |
| Subscription Lifecycle | [`docs/sd-billing/subscription-flow.md`](../sd-billing/subscription-flow.md) |
| Click / Payme payment sequences | [`docs/sd-billing/payment-gateways.md`](../sd-billing/payment-gateways.md) |
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

Кулинарная книга стилистики (цветовая таксономия, словарь форм, рецепт swimlane, white subgraph rule) живёт в [Стандарты дизайна воркфлоу · Mermaid styling cookbook](../team/workflow-design.md#mermaid-styling-cookbook). Линтите Mermaid-блоки локально через `npm run lint:mermaid` перед пушем.

## Legacy-доски (deprecated — только редирект)

6 предыдущих досок очищены, на каждой стикер указывает сюда. Не редактируйте их; каноничный контент — мастер выше.

| Legacy-доска | Стикер-редирект | Статус |
|--------------|-----------------|--------|
| Ecosystem | https://www.figma.com/board/NIhRaLqT67FQZNKq4cLQtr | Wiped |
| sd-billing | https://www.figma.com/board/8gPJ5OFsIjhhaKFn4kRwDH | Wiped |
| sd-cs (HQ) | https://www.figma.com/board/n7CzNpfgyykdCYYJiuQG7L | Wiped |
| sd-main · System Design | https://www.figma.com/board/tw0B3eE1bKNbvmmny8TVvx | Wiped |
| sd-main · Feature Flows | https://www.figma.com/board/MyvyaeEluqvHofH4E2qIoU | Wiped |
| Process Workflows | https://www.figma.com/board/YvAliP5jI2oqizJeOReYxk | Empty (no source authored yet) |
| All-in-one (very old archive) | https://www.figma.com/board/KH7PL28JoBs1GOvf6MxkJj | Pre-consolidation; do not edit |

## Встраивание PNG в доки

Каждую диаграмму в мастере можно экспортировать индивидуально. Кладите PNG в `static/diagrams/<name>.png` и ссылайтесь из любого markdown:

```markdown
![Ecosystem](/diagrams/ecosystem.png)
```

## Как добавить или обновить диаграмму

Mermaid в исходных доках — каноничный. Мастер FigJam — регенерируемая копия. Сначала редактируйте док, линтите, затем пушите FigJam.

### Предусловия

- Figma MCP с доступными инструментами `generate_diagram` и `use_figma`. (На момент написания, сервер `959fd320-…`, экспонирующий оба, нестабилен. Если подключён только read-only Figma MCP, можно авторить + линтить Mermaid в доках, но нельзя пушить во FigJam — отложите обновление FigJam на следующую сессию.)
- Мастер `fileKey`: `y2kWMuxLwrpdaCGhVwYYYI`.
- Кукбук: [Стандарты дизайна воркфлоу · Mermaid styling cookbook](../team/workflow-design.md#mermaid-styling-cookbook).

### A. Обновить существующую диаграмму

Когда исходник Mermaid меняется (например, добавлен переход состояния, ужата подпись):

1. **Редактируйте Mermaid-блок** в исходном доке. Сверьтесь с кукбуком — измеримые предикаты, role-named action-ноды, белые заливки subgraph, classDef-цвета.
2. **Локальный линт**, чтобы поймать render-ошибки до пуша:
   ```bash
   npm run lint:mermaid -- docs/path/to/file.md
   ```
   Или против всего репо: `npm run lint:mermaid`.
3. **Найдите существующую диаграмму на мастере** по имени. Запустите `use_figma`-запрос:
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
4. **Удалите старые ноды диаграммы** из этой Section (запустите follow-up `use_figma` с возвращёнными ID). Саму Section оставьте.
5. **Сгенерируйте новый Mermaid** в файл:
   ```
   generate_diagram(
     name: "Order State Machine",
     fileKey: "y2kWMuxLwrpdaCGhVwYYYI",
     mermaidSyntax: <verbatim block from the doc, without the ```mermaid fences>,
     userIntent: "Refresh after edit in docs/modules/orders.md"
   )
   ```
6. **Переместите новые ноды обратно в правильную Section** через паттерн bracket-and-move:
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
7. **Закоммитьте правку дока** с сообщением вроде `Update <flow> diagram (refreshed in master FigJam)`.

### B. Добавить совершенно новую диаграмму

Когда новый feature-flow появляется в каталоге:

1. **Напишите Mermaid-блок** в правильный исходный док (та же страница модуля, где живёт проза — держите single-source-of-truth-page-per-feature).
2. **Линт** как выше.
3. **Решите целевую Section** на мастере (одна из шести, перечисленных ранее на этой странице). Если диаграмма не подходит ни к одной Section, предложите новую в PR-ревью до пуша.
4. **Запишите id Section**, прочитав `figma.root.children[0].children` один раз.
5. **Bracket-and-move**: snapshot pre-generate ID → вызвать `generate_diagram` → diff и переместить в целевую Section. Тот же паттерн, что в шаге 6 выше.
6. **Обновите эту страницу `diagrams.md`**, если новая диаграмма должна появиться в посекционной таблице.
7. **Закоммитьте** исходный док + эту страницу одним коммитом.

### C. Tool недоступен сегодня — что делать

Если `generate_diagram` / `use_figma` не подключены:

- Редактируйте Mermaid в доке, линтите через `npm run lint:mermaid`, коммитьте. Док лендится; FigJam становится stale.
- Откройте follow-up issue: `Sync <diagram name> to master FigJam`.
- В следующий раз, когда MCP вернётся, выполните процедуру A или B для каждой ожидающей диаграммы. Тот же Mermaid в доке всё ещё каноничный — переделывать не нужно.
