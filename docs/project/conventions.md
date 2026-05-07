---
sidebar_position: 2
title: Conventions
---

# Conventions

## File naming

- **Models** — `PascalCase`, one model per file, file name = class name
  (`Order.php`, `Client.php`).
- **Controllers** — `PascalCaseController.php` (`OrderController.php`).
- **Modules** — `lowerCamel/` folder with `<Name>Module.php` inside
  (`onlineOrder/OnlineOrderModule.php`).
- **Views** — folder per controller, `lowercase.php` per action
  (`views/order/list.php`).
- **Jobs** — `<Name>Job.php` extending `BaseJob`.

## Database conventions

- **Tables** — prefixed `d0_` (configurable per tenant via `tablePrefix` in
  `main.php`). Always use the `{{prefix}}` placeholder in raw SQL.
- **Primary keys** — `ID` for new tables, but legacy mixes `<entity>_ID`
  capital uppercase (e.g. `ORDER_ID`, `CLIENT_ID`). Don't fight existing
  conventions — match the table you're touching.
- **Audit columns** — `CREATE_BY`, `CREATE_AT`, `UPDATE_BY`, `UPDATE_AT`,
  `TIMESTAMP_X`. Filled by `BaseFilial` save hooks.
- **Soft delete / inactive** — `ACTIVE` (`Y` / `N`) on most legacy tables.
- **Filial scoping** — every tenant-scoped table has `FILIAL_ID`. Models
  inherit from `BaseFilial`, which auto-applies the scope.

## PHP code style

- **PSR-12** style, four-space indent.
- **Strict typing** is *not* enabled across the codebase (PHP 7.3 era code).
  Don't add `declare(strict_types=1)` to existing files.
- **Docblocks** on public methods (helps IDE intellisense over CActiveRecord
  magic properties).
- **Single quotes** for strings unless interpolating.

## Git conventions

- Branch names: `feat/<short-desc>`, `fix/<short-desc>`, `chore/...`.
- Commit subject: imperative present tense, ≤ 72 chars.
- One PR = one logical change. Avoid mixing refactor + feature.
- Migrations go in their own commit.
