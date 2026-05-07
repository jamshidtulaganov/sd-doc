---
sidebar_position: 4
title: API v2 (frozen)
---

# API v2 — `api2` module

Frozen. Most controllers are `*.obsolete`; only `MigrateController`
remains as a maintenance utility.

If you see a client calling `/api2/...`, it is an old build. Track it
down via `protected/modules/api/controllers/ApiLogController.php` and
plan a migration to v3 (mobile) or v4 (online).
