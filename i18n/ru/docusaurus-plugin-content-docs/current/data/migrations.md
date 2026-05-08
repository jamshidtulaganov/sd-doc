---
sidebar_position: 5
title: Миграции
---

# Миграции

В Yii 1 идёт собственный миграционный инструмент: `yiic migrate`.

## Создать новую миграцию

```bash
docker compose exec web php protected/yiic migrate create add_priority_to_orders
```

Это создаёт `protected/migrations/m<YYMMDD_HHMMSS>_add_priority_to_orders.php`.

## Применить

```bash
# Apply pending
docker compose exec web php protected/yiic migrate up

# Roll back the last
docker compose exec web php protected/yiic migrate down
```

## Multi-tenant подвох

`yiic migrate` запускается против **дефолтной** БД из `main.php`. Чтобы
мигрировать все тенанты, итерируйте:

```bash
for db in $(mysql -uroot -proot -Nsre 'SHOW DATABASES LIKE "sd\\_%"'); do
  docker compose exec -e DB_NAME=$db web php protected/yiic migrate up
done
```

(или используйте wrapper-скрипт, который меняет `connectionString` на
каждой итерации).

## Соглашения

- Одна миграция = одно логическое изменение.
- Всегда давайте `down()`, даже если это просто `return false;` для
  необратимых операций.
- Не ссылайтесь на код приложения изнутри миграции — держите её чисто
  SQL/DDL, где возможно.
