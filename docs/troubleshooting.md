---
sidebar_position: 99
title: Troubleshooting
---

# Troubleshooting

## "Cannot resolve tenant" / blank page

**Cause**: `HTTP_HOST` doesn't match a known tenant.

- Check Nginx `server_name` and `fastcgi_param HTTP_HOST $host;`.
- Verify the tenant exists in the registry.
- Check `protected/runtime/application.log` for the resolution failure.

## 500 — `Class 'X' not found`

**Cause**: missing `import` directive in `main_static.php` or autoload
miss.

- Add `application.modules.<module>.models.*` to `import`.
- If it's a service, ensure the file is under `protected/components/`.

## "Срок лицензии программы истёк"

**Cause**: tenant's licence has expired (`hasSystemActive` returns
false).

- Update the licence record for that tenant via super-admin UI.
- Check date / system-id pairs in the licence table.

## Mobile login fails (api3)

- Confirm `deviceToken` is non-empty.
- Confirm password hash format — old users may still be MD5 (transparent
  on first login).
- Check user's `ACTIVE = 'Y'` and licence active for system 4.

## Excel export OOM

- The export probably loads everything into PHPExcel objects.
- For > 10k rows, switch to streaming via `XLSXWriter` or chunked CSV.

## Queue not draining

- Workers crashed. Check the supervisor.
- `LLEN sd_queue:default` should not climb monotonically.
- Inspect the first item: `LRANGE sd_queue:default 0 0` — common cause is
  a poison pill that throws on every retry.

## Redis db2 keeps growing

- A new code path is writing without TTL. Search for `set(.*null` or
  bare `set(` calls in recently changed files.
- `MEMORY USAGE <prefix>:*` to find offenders.

## "Cannot redeclare class"

- Two files define the same class. Look at recent renames; the old
  filename may still exist as `*.obsolete` but Composer / Yii is loading
  both.
