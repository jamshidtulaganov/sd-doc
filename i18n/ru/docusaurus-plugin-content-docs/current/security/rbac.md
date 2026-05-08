---
sidebar_position: 3
title: RBAC
---

# Контроль доступа на основе ролей

## Таблицы

| Таблица | Назначение |
|-------|---------|
| `authitem` | Роли, задачи, операции |
| `authitemchild` | Рёбра наследования |
| `authassignment` | (user_id, item, biz_rule, data) — кто что имеет |

`DbAuthManager` (`protected/components/DbAuthManager.php`) кеширует
вышеуказанные таблицы пер-тенант в `redis_app` на 600 с.

## Проверка доступа

```php
if (Yii::app()->user->checkAccess('orders.create')) { ... }
```

`checkAccess` обходит граф `authitemchild` снизу вверх (так что выдача роли `9`
прав также передаст их ролям 8, 5–10, если они наследуют, и т.д.).

## Добавление нового permission

1. Вставка в `authitem` (`type=0`):
   ```sql
   INSERT INTO authitem (name,type,description) VALUES
   ('reports.bonus.export', 0, 'Export bonus report');
   ```
2. Привяжите его к роли(ям), которые должны им владеть, через `authitemchild`.
3. В коде ограничьте действие:
   ```php
   public function accessRules() {
     return [
       ['allow', 'actions' => ['export'],
        'expression' => '$user->checkAccess("reports.bonus.export")'],
       ['deny'],
     ];
   }
   ```
4. Поднимите версию кеша: `Yii::app()->tenantContext->scoped()->delete('authitem');`
   (или подождите до 600 с).

## Видимость филиалов

Даже если у пользователя роль `1` (Super Admin) на уровне тенанта, он может
быть ограничен конкретными филиалами через `User.FILIAL_ID` и query scope
`BaseFilial`. Всегда используйте scope, а не читайте `FILIAL_ID` вручную.
