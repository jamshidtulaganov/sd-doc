---
sidebar_position: 3
title: RBAC
---

# Rolga asoslangan kirish nazorati (RBAC)

## Jadvallar

| Jadval | Maqsad |
|--------|--------|
| `authitem` | Rollar, vazifalar, operatsiyalar |
| `authitemchild` | Meros qirralari |
| `authassignment` | (user_id, item, biz_rule, data) — kimda nima bor |

`DbAuthManager` (`protected/components/DbAuthManager.php`) yuqoridagilarni
har bir tenant uchun `redis_app` da 600 s davomida keshlaydi.

## Kirishni tekshirish

```php
if (Yii::app()->user->checkAccess('orders.create')) { ... }
```

`checkAccess` `authitemchild` grafini yuqoriga yuradi (shuning uchun `9`
roliga ruxsat berish, agar 8, 5–10 rollari meros olsalar, ularga ham
ruxsatni beradi va h.k.).

## Yangi ruxsat qo'shish

1. `authitem` ga kiriting (`type=0`):
   ```sql
   INSERT INTO authitem (name,type,description) VALUES
   ('reports.bonus.export', 0, 'Export bonus report');
   ```
2. Uni `authitemchild` orqali tegishli rol(lar) ostiga ulang.
3. Kodda harakatni cheklang:
   ```php
   public function accessRules() {
     return [
       ['allow', 'actions' => ['export'],
        'expression' => '$user->checkAccess("reports.bonus.export")'],
       ['deny'],
     ];
   }
   ```
4. Kesh versiyasini yangilang: `Yii::app()->tenantContext->scoped()->delete('authitem');`
   (yoki 600 s gacha kuting).

## Filial ko'rinishi

Foydalanuvchi tenant darajasida `1` (Super Admin) roliga ega bo'lsa ham,
ular `User.FILIAL_ID` va `BaseFilial` so'rov scope orqali ma'lum
filiallar bilan cheklangan bo'lishi mumkin. Har doim `FILIAL_ID` ni
qo'lda o'qish o'rniga scope ga tayaning.
