---
sidebar_position: 5
title: Migrations
---

# Migrations

Yii 1 ships its own migration tool: `yiic migrate`.

## Create a new migration

```bash
docker compose exec web php protected/yiic migrate create add_priority_to_orders
```

This creates `protected/migrations/m<YYMMDD_HHMMSS>_add_priority_to_orders.php`.

## Apply

```bash
# Apply pending
docker compose exec web php protected/yiic migrate up

# Roll back the last
docker compose exec web php protected/yiic migrate down
```

## Multi-tenant gotcha

`yiic migrate` runs against the **default** DB from `main.php`. To migrate
all tenants, iterate:

```bash
for db in $(mysql -uroot -proot -Nsre 'SHOW DATABASES LIKE "sd\\_%"'); do
  docker compose exec -e DB_NAME=$db web php protected/yiic migrate up
done
```

(or use a wrapper script that swaps `connectionString` per iteration).

## Conventions

- One migration = one logical change.
- Always provide `down()` even if it's just `return false;` for irreversible
  ops.
- Don't reference application code from inside a migration — keep them
  pure SQL/DDL where possible.
