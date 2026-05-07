# Translations

The site supports three locales: **English (default)**, **Russian**,
**Uzbek**.

```
i18n/
├── ru/
│   ├── code.json                                    Theme strings
│   ├── docusaurus-plugin-content-docs/current/      Developer docs (RU)
│   └── docusaurus-plugin-content-docs-client/current/   Client docs (RU)
└── uz/
    ├── code.json
    ├── docusaurus-plugin-content-docs/current/
    └── docusaurus-plugin-content-docs-client/current/
```

## Translating a page

1. Find the canonical English file under `docs/<path>.md` or
   `client-docs/<path>.md`.
2. Mirror the path under
   `i18n/<locale>/docusaurus-plugin-content-docs[-client]/current/<path>.md`.
3. Keep the same frontmatter (`sidebar_position`, `slug`, `id`).
4. Translate the body.
5. Build & smoke test:
   ```bash
   npm run start -- --locale ru
   npm run start -- --locale uz
   ```

## Translation strategy

- Currently we ship **canonical English everywhere** plus full
  translations for the **intro** and any high-traffic landing pages.
- Other pages: translate page-by-page as priorities dictate. Fallback
  is the English version (Docusaurus shows the original for any missing
  translation).

## Sidebar labels

To translate sidebar category labels, add entries to:

- `i18n/<locale>/docusaurus-plugin-content-docs/current.json`
- `i18n/<locale>/docusaurus-plugin-content-docs-client/current.json`

Generate stubs with:

```bash
npm run write-translations -- --locale ru
npm run write-translations -- --locale uz
```
