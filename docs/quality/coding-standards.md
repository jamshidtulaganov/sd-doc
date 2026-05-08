---
sidebar_position: 2
title: Coding standards
---

# Coding standards

## Style

- PSR-12, four-space indent.
- Single-quote strings unless interpolating.
- Always docblock public methods.
- Don't `declare(strict_types=1)` in legacy files.
- Prefer early returns to nested ifs.

## Pull request rules

- One logical change per PR.
- Migrations in their own commit.
- A description that includes:
  - **Context** (why)
  - **What changed**
  - **How to verify**
  - **Roll back plan**

## Don'ts

- Don't add new `*.obsolete` files. Delete the dead code if you're sure;
  preserve via git history if you're not.
- Don't expand v1 / v2 APIs. Add to v3 or v4.
- Don't add direct cache calls (`Yii::app()->cache`). Use `ScopedCache`.
- Don't write SQL that targets a hard-coded DB name.
