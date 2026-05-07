---
sidebar_position: 5
title: ADR-0004 — Versioned API modules
---

# ADR 0004 — Versioned API modules (api / api2 / api3 / api4)

- Status: **Accepted**
- Date: 2024-08-08
- Deciders: API working group

## Context

Mobile clients can't be force-upgraded. A v1 mobile build from 2018 is
still on devices in the field. Breaking the contract is not an option.

## Decision

Each API generation lives in **its own Yii module** under
`protected/modules/api*`. New endpoints go to the latest active version
(currently v3 for mobile, v4 for online / B2B). v1 / v2 are frozen.

## Consequences

- ✅ Old clients keep working unchanged.
- ✅ Engineers see at a glance which surface they're touching.
- ❌ Code duplication: similar endpoints exist in v3 and v4. Mitigated by
  pushing logic into shared services.
- ❌ Discoverability for external consumers — addressed by this
  documentation site.
