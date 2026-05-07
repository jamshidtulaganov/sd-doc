---
sidebar_position: 4
title: Data conventions
---

# Data conventions

## Identifiers

- **Newer tables** use `ID INT AUTO_INCREMENT`.
- **Older tables** use `<ENTITY>_ID VARCHAR(32)` containing a synthetic
  string (often `<filial>_<seq>` or a UUID-ish format).
- **External IDs** live in the `XML_ID` column. Used to round-trip with
  1C, Didox, Faktura.uz.

## Casing

Capital uppercase (`ORDER_ID`, `CLIENT_ID`) is the legacy default —
preserve it on tables that already use it. New tables may use snake_case
lowercase but be consistent.

## Soft delete

Almost everywhere `ACTIVE = 'Y' | 'N'`. Hard `DELETE` is reserved for
admin tools.

## Timestamps

- `CREATE_AT`, `UPDATE_AT` — `DATETIME`.
- `TIMESTAMP_X` — generic last-modified marker, used for sync deltas.

## Charsets

The default charset is `utf8` (3-byte). Some newer tables use `utf8mb4`.
Be explicit on `CREATE TABLE` for emoji-safe text columns.
