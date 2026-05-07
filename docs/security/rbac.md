---
sidebar_position: 3
title: RBAC
---

# Role-based access control

## Tables

| Table | Purpose |
|-------|---------|
| `authitem` | Roles, tasks, operations |
| `authitemchild` | Inheritance edges |
| `authassignment` | (user_id, item, biz_rule, data) — who has what |

`DbAuthManager` (`protected/components/DbAuthManager.php`) caches the
above per-tenant in `redis_app` for 600 s.

## Checking access

```php
if (Yii::app()->user->checkAccess('orders.create')) { ... }
```

`checkAccess` walks up the `authitemchild` graph (so granting role `9` a
permission also grants it to roles 8, 5–10 if those inherit, etc.).

## Adding a new permission

1. Insert into `authitem` (`type=0`):
   ```sql
   INSERT INTO authitem (name,type,description) VALUES
   ('reports.bonus.export', 0, 'Export bonus report');
   ```
2. Wire it under the role(s) that should hold it via `authitemchild`.
3. In code, gate the action:
   ```php
   public function accessRules() {
     return [
       ['allow', 'actions' => ['export'],
        'expression' => '$user->checkAccess("reports.bonus.export")'],
       ['deny'],
     ];
   }
   ```
4. Bump the cache version: `Yii::app()->tenantContext->scoped()->delete('authitem');`
   (or wait up to 600 s).

## Filial visibility

Even if a user has role `1` (Super Admin) at the tenant level, they may
be limited to specific filials via `User.FILIAL_ID` and the
`BaseFilial` query scope. Always rely on the scope rather than reading
`FILIAL_ID` manually.
