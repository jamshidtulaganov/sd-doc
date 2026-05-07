---
sidebar_position: 5
title: Local setup
---

# sd-cs local setup

Per the project README:

```bash
git clone <repo> sd-cs
cd sd-cs

# 1. Provide DB credentials
cp protected/config/db_sample.php protected/config/db.php
# edit db.php to point 'db' at your cs_* DB and 'dealer' at one dealer DB

# 2. Composer
composer install

# 3. Bootstrap runtime folders
php default_folders.php
```

If `assets/` doesn't get generated automatically, create it manually
and ensure `www-data` (or your local user) can write to it.

## Theme

sd-cs uses Yii's theme system. The `classic` theme is in
`themes/classic/`. To customise:

1. Copy the view you want to override into
   `themes/classic/views/<module>/<controller>/<action>.php`.
2. Edit. The themed copy wins over the original.

## Two databases at once

You'll likely keep a local MySQL with **two databases**:

```sql
CREATE DATABASE cs_dev;             -- own data (cs_* tables)
CREATE DATABASE sd_dealer_demo;     -- one dealer's d0_* tables
```

Point `db` and `dealer` connections accordingly in `db.php`.
