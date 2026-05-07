# SalesDoctor — Developer Documentation

Comprehensive **developer documentation** for the SalesDoctor /
Novus Distribution platform — covering all three projects:
**sd-cs** (HQ), **sd-main** (dealer CRM) and **sd-billing**
(subscriptions).

This is a Docusaurus 3 site, EN canonical with RU + UZ locales.

```
docs/                  →  All developer documentation
i18n/{ru,uz}/          →  Translations
static/diagrams/       →  Diagram exports from FigJam
static/wireframes/     →  UI wireframes (extracted from SD-Web-old.fig)
skills/                →  Reusable skill bundles (sd-docs, QA, PM, AI)
```

---

## Quick start

```bash
# 1. Install (already done if node_modules/ exists)
npm install

# 2. Run locally (default = English)
npm run start

# 3. Run a specific locale
npm run start -- --locale ru
npm run start -- --locale uz

# 4. Build the static site (all locales)
npm run build

# 5. Preview the production build
npm run serve

# 6. Deploy (configure target in docusaurus.config.js first)
npm run deploy
```

---

## What's documented

### Three projects

| Project | What it is |
|---------|------------|
| **sd-cs** (HQ) | "Country Sales 3" — head-office app reading from many dealer DBs |
| **sd-main** (Dealer CRM) | The CRM each dealer runs — orders, agents, warehouse, … |
| **sd-billing** (Subscriptions) | The vendor's billing system that licenses every dealer |

Their dependency direction: `sd-cs ─► sd-main ─► sd-billing`.

### Top-level sections (developer docs)

- Ecosystem (3-project overview)
- sd-billing (subscriptions, payments, settlement)
- Billing in sd-main (the integration surface)
- sd-cs (HQ — multi-DB connection, reports, pivots, cross-system sync)
- Architecture (sd-main: tier diagram, multi-tenancy, caching, jobs,
  diagrams index)
- Project (structure, conventions, local setup, Docker, configuration)
- Modules (every Yii module reference with key features)
- Data Model (overview, ERD, core entities, conventions, migrations)
- API Reference (api / api2 / api3 / api4)
- Frontend (Yii views, JS plugins, ng-modules, asset pipeline)
- UI Wireframes (60 page screenshots extracted from SD-Web-old.fig)
- Integrations (1C, Didox, Faktura.uz, Smartup, Telegram, FCM, SMS, GPS)
- Security (auth, RBAC, sessions, data isolation)
- DevOps (deployment, Docker Compose, Nginx, monitoring, backups,
  scaling)
- Quality (testing, coding standards, contribution, release)
- ADRs (architecture decision records)
- Troubleshooting + Changelog

### FigJam diagrams

`https://www.figma.com/board/KH7PL28JoBs1GOvf6MxkJj` — split into pages
by project (Ecosystem, sd-billing, sd-cs, sd-main · System,
sd-main · Features, Workflows). See
[`docs/architecture/diagrams.md`](./docs/architecture/diagrams.md) for
the inventory.

### Wireframes

`static/wireframes/extracted-from-figma/` — 60 page screenshots
extracted from `SD-Web-old.fig`. New frontend devs should match these
patterns when building new screens. See
[`docs/ui/wireframes.md`](./docs/ui/wireframes.md).

### Skills

`skills/` — five reusable bundles for AI-assisted work:
`sd-docs-author`, `qa-process`, `pm-workflow`, `claude-ai-assist`,
`diagram-author`.

---

## Locales

| Locale | Code |
|--------|------|
| English | `en` (default) |
| Russian | `ru` |
| Uzbek | `uz` |

Translations are scaffolded for the intro page; expand page-by-page
under `i18n/<locale>/docusaurus-plugin-content-docs/current/`.

---

## License

Internal — © Novus Distribution / SalesDoctor.
