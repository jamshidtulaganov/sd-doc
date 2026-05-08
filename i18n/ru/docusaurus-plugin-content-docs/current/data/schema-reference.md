---
sidebar_position: 6
title: Справка по схеме (live + модели)
audience: Backend engineers, QA, PM, Data engineers
summary: Авторитетная справка по схеме sd-main, построенная ОДНОВРЕМЕННО из live MySQL-дампа И активных Yii-моделей. Источник истины для миграций, отчётов и любого RAG-запроса о слое данных.
topics: [schema, erd, models, tables, columns, indexes, mysql, charset, engine]
---

# Справка по схеме (live + модели)

Эта страница объединяет два источника:

- **`live-schema.sql`** — `mysqldump --no-data --routines --triggers` с
  development-инстанса sd-main на MySQL 8.0.
- **`schema-extract.json`** — распарсенные docblock'и `@property`,
  `tableName()` / `filialTable()` / `primaryKey()` / `relations()` из
  каждой активной Yii-модели под `sd-main/protected/models/`.

Запустите процедуру под [Процедура обновления](#refresh-procedure)
после любого PR, меняющего схему.

## Ключевые числа

| Метрика | Значение |
|---------|----------|
| Таблиц в live MySQL | **335** |
| Активных моделей | **306** |
| Моделей, резолвящихся к реальной таблице | **296** |
| Таблиц в MySQL без модели | **40** |
| Всего колонок (live) | **4073** |
| Всего объявленных `relations()` | **93** |
| Внешних ключей на уровне БД | **2** |
| Индексов (неуникальных) | **292** |
| Уникальных ключей | **25** |

## Движки и кодировки

| Движок | Количество |
|--------|-----------|
| `InnoDB` | 331 |
| `MyISAM` | 4 |

| Кодировка | Количество |
|-----------|-----------|
| `utf8mb3` | 293 |
| `utf8mb4` | 42 |

**Action item**: любые MyISAM-таблицы и любые `utf8mb3`-таблицы — legacy.
Со временем планируйте миграцию на InnoDB + `utf8mb4`.

## Таблицы в БД без Yii-модели

40 таблиц существуют в MySQL, но к ним не маппится ни одна Yii-модель.

| Таблица | Колонки | Индексы | Движок | Кодировка |
|---------|---------|---------|--------|-----------|
| `authassignment` | 5 | 0 | `InnoDB` | `utf8mb3` |
| `authitem` | 5 | 0 | `InnoDB` | `utf8mb3` |
| `authitemchild` | 2 | 1 | `InnoDB` | `utf8mb3` |
| `d0_adt_unit` | 4 | 0 | `InnoDB` | `utf8mb3` |
| `d0_apelsin_transaction` | 7 | 0 | `InnoDB` | `utf8mb3` |
| `d0_click_transaction` | 9 | 2 | `InnoDB` | `utf8mb3` |
| `d0_client_paket` | 7 | 0 | `InnoDB` | `utf8mb3` |
| `d0_contract` | 16 | 1 | `InnoDB` | `utf8mb3` |
| `d0_expeditor_paket` | 7 | 0 | `InnoDB` | `utf8mb3` |
| `d0_idokon_client_setting` | 5 | 1 | `InnoDB` | `utf8mb3` |
| `d0_idokon_incoming_request` | 8 | 0 | `InnoDB` | `utf8mb4` |
| `d0_idokon_product` | 7 | 1 | `InnoDB` | `utf8mb3` |
| `d0_knowledge_bind` | 4 | 0 | `InnoDB` | `utf8mb3` |
| `d0_knowledge_bind_dealer` | 4 | 0 | `InnoDB` | `utf8mb3` |
| `d0_knowledge_categories` | 8 | 0 | `InnoDB` | `utf8mb3` |
| `d0_knowledge_post` | 11 | 0 | `InnoDB` | `utf8mb3` |
| `d0_license_limit` | 8 | 0 | `InnoDB` | `utf8mb3` |
| `d0_lot` | 17 | 0 | `InnoDB` | `utf8mb4` |
| `d0_lot_distribution` | 21 | 1 | `InnoDB` | `utf8mb4` |
| `d0_loyalty_program` | 12 | 0 | `InnoDB` | `utf8mb3` |
| `d0_loyalty_program_detail` | 8 | 0 | `InnoDB` | `utf8mb3` |
| `d0_loyalty_transactions` | 10 | 0 | `InnoDB` | `utf8mb3` |
| `d0_order_idokon` | 7 | 2 | `InnoDB` | `utf8mb4` |
| `d0_payme_transaction` | 10 | 3 | `InnoDB` | `utf8mb3` |
| `d0_planning` | 15 | 4 | `InnoDB` | `utf8mb3` |
| `d0_planning_history` | 4 | 0 | `InnoDB` | `utf8mb3` |
| `d0_planning_min_plan` | 11 | 3 | `InnoDB` | `utf8mb3` |
| `d0_planning_outlet` | 8 | 4 | `InnoDB` | `utf8mb3` |
| `d0_planning_percent_day` | 10 | 0 | `InnoDB` | `utf8mb4` |
| `d0_planning_pulse` | 8 | 1 | `InnoDB` | `utf8mb3` |
| `d0_product_unit` | 13 | 0 | `InnoDB` | `utf8mb3` |
| `d0_rating` | 1 | 0 | `InnoDB` | `utf8mb3` |
| `d0_rating_comment` | 1 | 0 | `InnoDB` | `utf8mb3` |
| `d0_rating_question` | 1 | 0 | `InnoDB` | `utf8mb3` |
| `d0_rating_result` | 1 | 0 | `InnoDB` | `utf8mb3` |
| `d0_sms_message` | 7 | 1 | `InnoDB` | `utf8mb4` |
| `d0_sms_message_item` | 6 | 0 | `InnoDB` | `utf8mb4` |
| `d0_sms_template` | 8 | 0 | `InnoDB` | `utf8mb4` |
| `d0_sync_log_delete` | 15 | 2 | `InnoDB` | `utf8mb3` |
| `tbl_migration` | 2 | 0 | `InnoDB` | `utf8mb4` |

## Таблицы по доменам

### AKB (3 таблицы)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_akb_category` | 8 | `(`ID`)` | InnoDB/utf8mb3 | `AkbCategory` |
| `d0_akb_category_product` | 7 | `(`ID`)` | InnoDB/utf8mb3 | `AkbCategoryProduct` |
| `d0_akb_filter` | 6 | `(`ID`)` | InnoDB/utf8mb3 | `AkbFilter` |

### Agents (4 таблицы)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_agent` | 29 | `(`AGENT_ID`)` | InnoDB/utf8mb3 | `Agent` |
| `d0_agent_paket` | 18 | `(`AGENT_PAKET_ID`)` | InnoDB/utf8mb3 | `AgentPaket` |
| `d0_agent_plan` | 14 | `(`AGENT_PLAN_ID`)` | InnoDB/utf8mb3 | `AgentPlan` |
| `d0_agent_settings` | 7 | `(`ID`)` | InnoDB/utf8mb4 | `AgentSettings` |

### Audit (2 таблицы)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_audit_storchek_cat` | 8 | `(`ID`)` | InnoDB/utf8mb3 | `AuditStorchekCat` |
| `d0_auditor` | 19 | `(`ID`)` | InnoDB/utf8mb3 | `Auditor` |

### Audit ADT (25 таблиц)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_adt_audit` | 19 | `(`ID`)` | InnoDB/utf8mb3 | `AdtAudit` |
| `d0_adt_audit_bind_products` | 3 | `(`ID`)` | InnoDB/utf8mb3 | `AdtAuditProducts` |
| `d0_adt_audit_bind_users` | 3 | `(`ID`)` | InnoDB/utf8mb3 | `AdtAuditUsers` |
| `d0_adt_audit_result` | 12 | `(`ID`)` | InnoDB/utf8mb3 | `AdtAuditResult` |
| `d0_adt_audit_result_data` | 12 | `(`ID`)` | InnoDB/utf8mb3 | `AdtAuditResultData` |
| `d0_adt_brand` | 9 | `(`ID`)` | InnoDB/utf8mb3 | `AdtBrands` |
| `d0_adt_comment` | 8 | `(`ID`)` | InnoDB/utf8mb3 | `AdtComment` |
| `d0_adt_comment_result` | 11 | `(`ID`)` | InnoDB/utf8mb3 | `AdtCommentResult` |
| `d0_adt_config` | 11 | `(`ID`)` | InnoDB/utf8mb3 | `AdtConfig` |
| `d0_adt_note_result` | 11 | `(`ID`)` | InnoDB/utf8mb3 | `AdtNoteResult` |
| `d0_adt_pack` | 8 | `(`ID`)` | InnoDB/utf8mb3 | `AdtPack` |
| `d0_adt_params` | 9 | `(`ID`)` | InnoDB/utf8mb3 | `AdtParams` |
| `d0_adt_poll` | 11 | `(`ID`)` | InnoDB/utf8mb3 | `AdtPoll` |
| `d0_adt_poll_bind` | 8 | `(`ID`)` | InnoDB/utf8mb3 | `AdtPollBind` |
| `d0_adt_poll_question` | 13 | `(`ID`)` | InnoDB/utf8mb3 | `AdtPollQuestion` |
| `d0_adt_poll_result` | 13 | `(`ID`)` | InnoDB/utf8mb3 | `AdtPollResult` |
| `d0_adt_poll_result_data` | 8 | `(`ID`)` | InnoDB/utf8mb3 | `AdtPollResultData` |
| `d0_adt_poll_variant` | 10 | `(`ID`)` | InnoDB/utf8mb3 | `AdtPollVariant` |
| `d0_adt_producer` | 9 | `(`ID`)` | InnoDB/utf8mb3 | `AdtProducer` |
| `d0_adt_property` | 7 | `(`ID`)` | InnoDB/utf8mb3 | `AdtProperty` |
| `d0_adt_property1` | 8 | `(`ID`)` | InnoDB/utf8mb3 | `AdtProperty1` |
| `d0_adt_property2` | 8 | `(`ID`)` | InnoDB/utf8mb3 | `AdtProperty2` |
| `d0_adt_reports` | 3 | `(`ID`)` | InnoDB/utf8mb3 | `AdtReports` |
| `d0_adt_segment` | 8 | `(`ID`)` | InnoDB/utf8mb3 | `AdtSegment` |
| `d0_adt_unit` | 4 | `(`ID`)` | InnoDB/utf8mb3 | `—` |

### Audit master (6 таблиц)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_aud_brands` | 8 | `(`ID`)` | InnoDB/utf8mb3 | `AudBrands` |
| `d0_aud_category` | 13 | `(`ID`)` | InnoDB/utf8mb3 | `AudCategory` |
| `d0_aud_facing` | 15 | `(`ID`)` | InnoDB/utf8mb3 | `AudFacing` |
| `d0_aud_place_type` | 6 | `(`ID`)` | InnoDB/utf8mb3 | `AudPlaceType` |
| `d0_aud_product` | 12 | `(`ID`)` | InnoDB/utf8mb3 | `AudProduct` |
| `d0_aud_sku` | 15 | `(`ID`)` | InnoDB/utf8mb3 | `AudSku` |

### Bonus (10 таблиц)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_bonus` | 36 | `(`BONUS_ID`)` | InnoDB/utf8mb3 | `Bonus` |
| `d0_bonus_agent` | 3 | `(`ID`)` | InnoDB/utf8mb3 | `BonusAgent` |
| `d0_bonus_city` | 3 | `(`ID`)` | InnoDB/utf8mb3 | `BonusCity` |
| `d0_bonus_exclude` | 7 | `(`ID`)` | InnoDB/utf8mb3 | `BonusExclude` |
| `d0_bonus_filial` | 3 | `(`ID`)` | InnoDB/utf8mb3 | `BonusFilial` |
| `d0_bonus_limit` | 5 | `(`ID`)` | InnoDB/utf8mb4 | `BonusLimit` |
| `d0_bonus_order` | 22 | `(`BONUS_ORDER_ID`)` | InnoDB/utf8mb3 | `BonusOrder` |
| `d0_bonus_order_detail` | 20 | `(`BONUS_ORDER_DET_ID`)` | InnoDB/utf8mb3 | `BonusOrderDetail` |
| `d0_bonus_order_history` | 8 | `(`ID`)` | InnoDB/utf8mb3 | `BonusOrderHistory` |
| `d0_bonus_relation` | 7 | `(`ID`)` | InnoDB/utf8mb3 | `BonusRelation` |

### Cache (1 таблица)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_cache` | 6 | `(`ID`)` | InnoDB/utf8mb3 | `Cache` |

### Cashbox (2 таблицы)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_cashbox` | 15 | `(`ID`)` | InnoDB/utf8mb3 | `Cashbox` |
| `d0_cashbox_displacement` | 15 | `(`ID`)` | InnoDB/utf8mb3 | `CashboxDisplacement` |

### Catalog (19 таблиц)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_catalog_product` | 16 | `(`id`)` | InnoDB/utf8mb3 | `CatalogProduct` |
| `d0_catalog_product_bind` | 9 | `(`id`)` | InnoDB/utf8mb3 | `CatalogProductBind` |
| `d0_catalog_section` | 13 | `(`id`)` | InnoDB/utf8mb3 | `CatalogSection` |
| `d0_catalog_state` | 12 | `(`id`)` | InnoDB/utf8mb3 | `CatalogState` |
| `d0_price` | 20 | `(`PRICE_ID`)` | InnoDB/utf8mb3 | `Price` |
| `d0_price_change_log` | 7 | `(`id`)` | InnoDB/utf8mb3 | `PriceChangeLog` |
| `d0_price_type` | 25 | `(`PRICE_TYPE_ID`)` | InnoDB/utf8mb3 | `PriceType` |
| `d0_price_type_filial` | 3 | `(`ID`)` | InnoDB/utf8mb3 | `PriceTypeFilial` |
| `d0_product` | 57 | `(`PRODUCT_ID`)` | InnoDB/utf8mb3 | `Product` |
| `d0_product_case_type` | 9 | `(`ID`)` | InnoDB/utf8mb3 | `ProductCaseType` |
| `d0_product_cat_group` | 10 | `(`ID`)` | InnoDB/utf8mb3 | `ProductCatGroup` |
| `d0_product_category` | 14 | `(`PRODUCT_CAT_ID`)` | InnoDB/utf8mb3 | `ProductCategory` |
| `d0_product_competitor` | 39 | `(`PRODUCT_ID`)` | InnoDB/utf8mb3 | `ProductCompetitor` |
| `d0_product_group` | 9 | `(`ID`)` | MyISAM/utf8mb3 | `ProductGroup` |
| `d0_product_price_markup` | 11 | `(`ID`)` | InnoDB/utf8mb4 | `ProductPriceMarkup` |
| `d0_product_subcategory` | 10 | `(`SUB_CAT_ID`)` | InnoDB/utf8mb3 | `ProductSubCategory` |
| `d0_product_unit` | 13 | `(`UNIT_ID`)` | InnoDB/utf8mb3 | `—` |
| `d0_product_units` | 12 | `(`ID`)` | InnoDB/utf8mb3 | `ProductUnit` |
| `d0_product_values` | 8 | `(`ID`)` | InnoDB/utf8mb3 | `ProductValues` |

### Clients (20 таблиц)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_client` | 58 | `(`CLIENT_ID`)` | InnoDB/utf8mb3 | `Client` |
| `d0_client_active_log` | 6 | `(`ID`)` | MyISAM/utf8mb3 | `ClientActiveLog` |
| `d0_client_category` | 15 | `(`CLIENT_CAT_ID`)` | InnoDB/utf8mb3 | `ClientCategory` |
| `d0_client_channel` | 8 | `(`ID`)` | InnoDB/utf8mb3 | `ClientChannel` |
| `d0_client_class` | 5 | `(`ID`)` | InnoDB/utf8mb3 | `ClientClass` |
| `d0_client_finans` | 18 | `(`CLIENT_FIN_ID`)` | InnoDB/utf8mb3 | `ClientFinans` |
| `d0_client_firm` | 14 | `(`ID`)` | InnoDB/utf8mb4 | `ClientFirm` |
| `d0_client_kaspi_transaction` | 8 | `(`ID`)` | InnoDB/utf8mb4 | `ClientKaspiTransaction` |
| `d0_client_log` | 7 | `(`ID`)` | InnoDB/utf8mb3 | `ClientLog` |
| `d0_client_odengi_transaction` | 9 | `(`ID`)` | InnoDB/utf8mb4 | `ClientOdengiTransaction` |
| `d0_client_optima_transaction` | 1 | `(`id`)` | InnoDB/utf8mb3 | `ClientOptimaTransaction` |
| `d0_client_paket` | 7 | `(`ID`)` | InnoDB/utf8mb3 | `—` |
| `d0_client_payme_transactions` | 15 | `(`ID`)` | InnoDB/utf8mb4 | `ClientPaymeTransaction` |
| `d0_client_pending` | 35 | `(`ID`)` | InnoDB/utf8mb3 | `ClientPending` |
| `d0_client_phones` | 9 | `(`ID`)` | InnoDB/utf8mb3 | `ClientPhones` |
| `d0_client_photo` | 5 | `(`ID`)` | MyISAM/utf8mb3 | `ClientPhoto` |
| `d0_client_stock` | 14 | `(`ID`)` | InnoDB/utf8mb3 | `ClientStock` |
| `d0_client_transaction` | 40 | `(`CLIENT_TRANS_ID`)` | InnoDB/utf8mb3 | `ClientTransaction` |
| `d0_client_transaction_history` | 32 | `(`TRANS_ID`)` | InnoDB/utf8mb3 | `ClientTransactionHistory` |
| `d0_client_type` | 9 | `(`ID`)` | InnoDB/utf8mb3 | `ClientType` |

### Config (1 таблица)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_config` | 5 | `(`ID`)` | InnoDB/utf8mb3 | `Config` |

### Contact (2 таблицы)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_contact` | 17 | `(`ID`)` | InnoDB/utf8mb3 | `Contact` |
| `d0_contact_client` | 3 | `(`ID`)` | InnoDB/utf8mb3 | `ContactClient` |

### Contract (1 таблица)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_contract` | 16 | `(`ID`)` | InnoDB/utf8mb3 | `—` |

### Contragent (3 таблицы)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_contragent` | 39 | `(`CLIENT_ID`)` | InnoDB/utf8mb3 | `Contragent` |
| `d0_contragent_history` | 10 | `(`ID`)` | InnoDB/utf8mb3 | `ContragentHistory` |
| `d0_contragent_log` | 7 | `(`ID`)` | InnoDB/utf8mb3 | `ContragentLog` |

### Defect (2 таблицы)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_defect_detail_log` | 8 | `(`ID`)` | InnoDB/utf8mb3 | `DefectDetailLog` |
| `d0_defects` | 12 | `(`ID`)` | InnoDB/utf8mb3 | `Defects` |

### Diler (1 таблица)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_diler` | 24 | `(`DILER_ID`)` | InnoDB/utf8mb3 | `Diler` |

### Discount (11 таблиц)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_skidka` | 37 | `(`SKIDKA_ID`)` | InnoDB/utf8mb3 | `Skidka` |
| `d0_skidka_agent` | 3 | `(`ID`)` | InnoDB/utf8mb3 | `SkidkaAgent` |
| `d0_skidka_budget` | 8 | `(`ID`)` | InnoDB/utf8mb3 | `SkidkaBudget` |
| `d0_skidka_exclude` | 7 | `(`ID`)` | InnoDB/utf8mb4 | `SkidkaExclude` |
| `d0_skidka_filial` | 3 | `(`ID`)` | InnoDB/utf8mb3 | `SkidkaFilial` |
| `d0_skidka_manual` | 17 | `(`SKIDKA_ID`)` | InnoDB/utf8mb3 | `SkidkaManual` |
| `d0_skidka_manual_agent` | 3 | `(`ID`)` | InnoDB/utf8mb3 | `SkidkaManualAgent` |
| `d0_skidka_manual_filial` | 3 | `(`ID`)` | InnoDB/utf8mb3 | `SkidkaManualFilial` |
| `d0_skidka_order` | 12 | `(`ID`)` | InnoDB/utf8mb3 | `SkidkaOrder` |
| `d0_skidka_relation` | 7 | `(`ID`)` | InnoDB/utf8mb3 | `SkidkaRelation` |
| `d0_skidka_store` | 3 | `(`ID`)` | InnoDB/utf8mb4 | `SkidkaStore` |

### Doctor (2 таблицы)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_doctor_strike` | 43 | `(`ID`)` | InnoDB/utf8mb3 | `DoctorStrike` |
| `d0_doctor_volume` | 43 | `(`ID`)` | InnoDB/utf8mb3 | `DoctorVolume` |

### Expeditor (8 таблиц)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_expeditor` | 28 | `(`EXPEDITOR_ID`)` | InnoDB/utf8mb3 | `Expeditor` |
| `d0_expeditor_kpi_job` | 16 | `(`ID`)` | InnoDB/utf8mb4 | `ExpeditorKpiJob` |
| `d0_expeditor_kpi_setup` | 7 | `(`ID`)` | InnoDB/utf8mb4 | `ExpeditorKpiSetup` |
| `d0_expeditor_load` | 8 | `(`ID`)` | InnoDB/utf8mb3 | `ExpeditorLoad` |
| `d0_expeditor_load_detail` | 10 | `(`ID`)` | InnoDB/utf8mb3 | `ExpeditorLoadDetail` |
| `d0_expeditor_load_history` | 6 | `(`ID`)` | InnoDB/utf8mb3 | `ExpeditorLoadHistory` |
| `d0_expeditor_load_neo` | 1 | `(`id`)` | InnoDB/utf8mb3 | `ExpeditorLoadNeo` |
| `d0_expeditor_paket` | 7 | `(`ID`)` | InnoDB/utf8mb3 | `—` |

### Filial (6 таблиц)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_filial` | 8 | `(`id`)` | InnoDB/utf8mb3 | `Filial` |
| `d0_filial_client` | 2 | `—` | InnoDB/utf8mb3 | `FilialClient` |
| `d0_filial_currency` | 3 | `(`id`)` | InnoDB/utf8mb3 | `FilialCurrency` |
| `d0_filial_order` | 9 | `—` | InnoDB/utf8mb3 | `FilialOrder` |
| `d0_filial_photo_category` | 3 | `(`ID`)` | InnoDB/utf8mb3 | `FilialPhotoCategory` |
| `d0_filial_product` | 3 | `(`ID`)` | InnoDB/utf8mb3 | `ProductFilial` |

### GPS (2 таблицы)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_gps` | 20 | `(`ID`,`DATE`)` | InnoDB/utf8mb3 | `Gps` |
| `d0_gps_adt` | 18 | `(`ID`)` | InnoDB/utf8mb3 | `GpsAdt` |

### Integration (5 таблиц)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_apelsin_transaction` | 7 | `(`ID`)` | InnoDB/utf8mb3 | `—` |
| `d0_click_transaction` | 9 | `(`ID`)` | InnoDB/utf8mb3 | `—` |
| `d0_idokon_client_setting` | 5 | `(`id`)` | InnoDB/utf8mb3 | `—` |
| `d0_idokon_incoming_request` | 8 | `(`id`)` | InnoDB/utf8mb4 | `—` |
| `d0_idokon_product` | 7 | `(`id`)` | InnoDB/utf8mb3 | `—` |

### Inventory (6 таблиц)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_inventory` | 20 | `(`INVENTORY_ID`)` | InnoDB/utf8mb3 | `Inventory` |
| `d0_inventory_check` | 11 | `(`ID`)` | InnoDB/utf8mb4 | `InventoryCheck` |
| `d0_inventory_check_photo` | 3 | `(`ID`)` | InnoDB/utf8mb4 | `InventoryCheckPhoto` |
| `d0_inventory_group` | 7 | `(`ID`)` | InnoDB/utf8mb3 | `InventoryGroup` |
| `d0_inventory_history` | 20 | `(`INVENTORY_HIST_ID`)` | InnoDB/utf8mb3 | `InventoryHistory` |
| `d0_inventory_type` | 18 | `(`INV_TYPE_ID`)` | InnoDB/utf8mb3 | `InventoryType` |

### KPI (6 таблиц)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_kpi` | 38 | `(`KPI_ID`)` | InnoDB/utf8mb3 | `Kpi` |
| `d0_kpi_group` | 7 | `(`ID`)` | InnoDB/utf8mb3 | `KpiGroup` |
| `d0_kpi_group_link` | 3 | `(`ID`)` | InnoDB/utf8mb3 | `KpiGroupLink` |
| `d0_kpi_task` | 58 | `(`KPI_TASK_ID`)` | InnoDB/utf8mb3 | `KpiTask` |
| `d0_kpi_task_template` | 62 | `(`ID`)` | InnoDB/utf8mb3 | `KpiTaskTemplate` |
| `d0_kpi_task_template_group` | 10 | `(`ID`)` | InnoDB/utf8mb4 | `KpiTaskTemplateGroup` |

### Knowledge base (4 таблицы)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_knowledge_bind` | 4 | `(`ID`)` | InnoDB/utf8mb3 | `—` |
| `d0_knowledge_bind_dealer` | 4 | `(`ID`)` | InnoDB/utf8mb3 | `—` |
| `d0_knowledge_categories` | 8 | `(`ID`)` | InnoDB/utf8mb3 | `—` |
| `d0_knowledge_post` | 11 | `(`ID`)` | InnoDB/utf8mb3 | `—` |

### Lot management (2 таблицы)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_lot` | 17 | `(`ID`)` | InnoDB/utf8mb4 | `—` |
| `d0_lot_distribution` | 21 | `(`ID`)` | InnoDB/utf8mb4 | `—` |

### Loyalty (3 таблицы)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_loyalty_program` | 12 | `(`ID`)` | InnoDB/utf8mb3 | `—` |
| `d0_loyalty_program_detail` | 8 | `(`ID`)` | InnoDB/utf8mb3 | `—` |
| `d0_loyalty_transactions` | 10 | `(`ID`)` | InnoDB/utf8mb3 | `—` |

### Notification (1 таблица)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_notify_read` | 5 | `(`ID`)` | InnoDB/utf8mb3 | `NotifyRead` |

### Orders (14 таблиц)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_order` | 59 | `(`ORDER_ID`)` | InnoDB/utf8mb3 | `Order` |
| `d0_order_cises` | 12 | `(`CIS`)` | InnoDB/utf8mb4 | `OrderCises` |
| `d0_order_cises_log` | 5 | `(`ID`)` | InnoDB/utf8mb4 | `OrderCisesLog` |
| `d0_order_code` | 5 | `(`ID`)` | InnoDB/utf8mb4 | `OrderCode` |
| `d0_order_comment` | 9 | `(`ID`)` | InnoDB/utf8mb3 | `OrderComment` |
| `d0_order_defect` | 30 | `(`ORDER_DEFECT_ID`)` | InnoDB/utf8mb3 | `OrderDefect` |
| `d0_order_defect_detail` | 26 | `(`ORDER_DEFECT_DETAIL_ID`)` | InnoDB/utf8mb3 | `OrderDefectDetail` |
| `d0_order_detail` | 29 | `(`ORDER_DET_ID`)` | InnoDB/utf8mb3 | `OrderDetail` |
| `d0_order_detail_history` | 28 | `(`ID`)` | InnoDB/utf8mb3 | `OrderDetailHistory` |
| `d0_order_esf` | 10 | `(`ORDER_ID`)` | InnoDB/utf8mb4 | `OrderEsf` |
| `d0_order_history` | 38 | `(`ID`)` | InnoDB/utf8mb3 | `OrderHistory` |
| `d0_order_idokon` | 7 | `(`id`)` | InnoDB/utf8mb4 | `—` |
| `d0_order_replace` | 30 | `(`ORDER_REPLACE_ID`)` | InnoDB/utf8mb3 | `OrderReplace` |
| `d0_order_replace_detail` | 20 | `(`ORDER_REPLACE_DETAIL_ID`)` | InnoDB/utf8mb3 | `OrderReplaceDetail` |

### Other (102 таблицы)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_afacing` | 1 | `(`id`)` | InnoDB/utf8mb3 | `AFacing` |
| `d0_aproduct` | 1 | `(`id`)` | InnoDB/utf8mb3 | `AProduct` |
| `d0_asku` | 1 | `(`id`)` | InnoDB/utf8mb3 | `ASku` |
| `d0_brand` | 1 | `(`id`)` | InnoDB/utf8mb3 | `Brand` |
| `d0_cars` | 18 | `(`ID`)` | InnoDB/utf8mb4 | `Car` |
| `d0_cises_info` | 12 | `(`CIS`)` | InnoDB/utf8mb4 | `CisesInfo` |
| `d0_city` | 14 | `(`CITY_ID`)` | InnoDB/utf8mb3 | `City` |
| `d0_closed` | 10 | `(`ID`)` | InnoDB/utf8mb3 | `Closed` |
| `d0_consumption` | 20 | `(`ID`)` | InnoDB/utf8mb3 | `Consumption` |
| `d0_consumption_child` | 12 | `(`ID`)` | InnoDB/utf8mb3 | `ConsumptionChild` |
| `d0_consumption_history` | 7 | `(`ID`)` | InnoDB/utf8mb4 | `ConsumptionHistory` |
| `d0_consumption_parent` | 11 | `(`ID`)` | InnoDB/utf8mb3 | `ConsumptionParent` |
| `d0_conversion` | 7 | `(`CURRENCY_RATE`)` | InnoDB/utf8mb3 | `Conversion` |
| `d0_created_stores` | 11 | `(`CREATED_STORE_ID`)` | InnoDB/utf8mb3 | `CreatedStores` |
| `d0_currency` | 16 | `(`CURRENCY_ID`)` | InnoDB/utf8mb3 | `Currency` |
| `d0_debt_finans` | 14 | `(`DEBT_ID`)` | InnoDB/utf8mb3 | `DebtFinans` |
| `d0_entity_xml_map` | 5 | `(`ID`)` | InnoDB/utf8mb3 | `EntityXmlMap` |
| `d0_exchange` | 24 | `(`EXCHANGE_ID`)` | InnoDB/utf8mb3 | `Exchange` |
| `d0_exchange_detail` | 14 | `(`EXCHANGE_DET_ID`)` | InnoDB/utf8mb3 | `ExchangeDetail` |
| `d0_excretion` | 17 | `(`ID`)` | InnoDB/utf8mb3 | `Excretion` |
| `d0_feedbacks` | 5 | `(`ID`)` | InnoDB/utf8mb3 | `Feedbacks` |
| `d0_forecast_category` | 6 | `(`ID`)` | InnoDB/utf8mb3 | `ForecastCategory` |
| `d0_incoming_invoices` | 17 | `(`ID`)` | InnoDB/utf8mb4 | `IncomingInvoice` |
| `d0_incoming_invoices_details` | 9 | `(`ID`)` | InnoDB/utf8mb4 | `IncomingInvoiceDetail` |
| `d0_incoming_invoices_scanned_cises` | 6 | `(`ID`)` | InnoDB/utf8mb4 | `IncomingInvoiceScannedCis` |
| `d0_integrations` | 7 | `(`ID`)` | InnoDB/utf8mb4 | `Integration` |
| `d0_invoice` | 1 | `(`id`)` | InnoDB/utf8mb3 | `Invoice` |
| `d0_invoice_detail` | 1 | `(`id`)` | InnoDB/utf8mb3 | `InvoiceDetail` |
| `d0_invoice_template` | 9 | `(`ID`)` | InnoDB/utf8mb3 | `InvoiceTemplate` |
| `d0_license_limit` | 8 | `(`ID`)` | InnoDB/utf8mb3 | `—` |
| `d0_log` | 13 | `(`ID`)` | InnoDB/utf8mb3 | `Log` |
| `d0_manufacture` | 1 | `(`id`)` | InnoDB/utf8mb3 | `Manufacture` |
| `d0_model_log` | 4 | `(`ID`)` | InnoDB/utf8mb3 | `ModelLog` |
| `d0_model_tags` | 4 | `(`ID`)` | InnoDB/utf8mb4 | `ModelTag` |
| `d0_notification` | 12 | `(`ID`)` | InnoDB/utf8mb3 | `Notification` |
| `d0_old_price` | 20 | `(`PRICE_ID`)` | InnoDB/utf8mb3 | `OldPrice` |
| `d0_old_price_type` | 19 | `(`OLD_PRICE_TYPE_ID`)` | InnoDB/utf8mb3 | `OldPriceType` |
| `d0_online_order` | 20 | `(`ID`)` | InnoDB/utf8mb3 | `OnlineOrder` |
| `d0_online_order_detail` | 6 | `(`ID`)` | InnoDB/utf8mb3 | `OnlineOrderDetail` |
| `d0_online_payments` | 8 | `(`ID`)` | InnoDB/utf8mb4 | `OnlinePayment` |
| `d0_outlet_fact` | 19 | `(`O_FACT_ID`)` | InnoDB/utf8mb3 | `OutletFact` |
| `d0_outlet_plan` | 23 | `(`O_PLAN_ID`)` | InnoDB/utf8mb3 | `OutletPlan` |
| `d0_parent_photo_report` | 9 | `(`PR_CAT_ID`)` | InnoDB/utf8mb3 | `ParentPhotoReport` |
| `d0_poll` | 7 | `(`ID`)` | InnoDB/utf8mb3 | `Poll` |
| `d0_poll_question` | 9 | `(`ID`)` | InnoDB/utf8mb3 | `PollQuestion` |
| `d0_poll_result` | 13 | `(`ID`)` | InnoDB/utf8mb3 | `PollResult` |
| `d0_poll_variant` | 7 | `(`ID`)` | InnoDB/utf8mb3 | `PollVariant` |
| `d0_printer` | 9 | `(`ID`)` | InnoDB/utf8mb3 | `Printer` |
| `d0_printer_attach` | 7 | `(`ID`)` | InnoDB/utf8mb3 | `PrinterAttach` |
| `d0_properties` | 10 | `(`ID`)` | InnoDB/utf8mb3 | `Properties` |
| `d0_purchase` | 30 | `(`PURCHASE_ID`)` | InnoDB/utf8mb3 | `Purchase` |
| `d0_purchase_detail` | 21 | `(`PURCHASE_DET_ID`)` | InnoDB/utf8mb3 | `PurchaseDetail` |
| `d0_purchase_draft` | 17 | `(`ID`)` | InnoDB/utf8mb4 | `PurchaseDraft` |
| `d0_purchase_refund` | 28 | `(`ID`)` | InnoDB/utf8mb3 | `PurchaseRefund` |
| `d0_purchase_refund_detail` | 17 | `(`ID`)` | InnoDB/utf8mb3 | `PurchaseRefundDetail` |
| `d0_push_subscriptions` | 6 | `(`ID`)` | InnoDB/utf8mb4 | `PushSubscriptions` |
| `d0_question_result` | 1 | `(`id`)` | InnoDB/utf8mb3 | `QuestionResult` |
| `d0_question_variants` | 1 | `(`id`)` | InnoDB/utf8mb3 | `QuestionVariants` |
| `d0_questions` | 1 | `(`id`)` | InnoDB/utf8mb3 | `Questions` |
| `d0_rates` | 7 | `(`ID`)` | InnoDB/utf8mb3 | `Rates` |
| `d0_region` | 11 | `(`REGION_ID`)` | InnoDB/utf8mb3 | `Region` |
| `d0_rlp` | 8 | `(`RLP_ID`)` | InnoDB/utf8mb3 | `Rlp` |
| `d0_rlp_bonus` | 13 | `(`RLP_BONUS_ID`)` | InnoDB/utf8mb3 | `RlpBonus` |
| `d0_royalty` | 25 | `(`ROYALTY_ID`)` | InnoDB/utf8mb3 | `Royalty` |
| `d0_royalty_filial` | 3 | `(`ID`)` | InnoDB/utf8mb3 | `RoyaltyFilial` |
| `d0_royalty_transaction` | 13 | `(`ROYALTY_TRANS_ID`)` | InnoDB/utf8mb3 | `RoyaltyTransaction` |
| `d0_sales_category` | 7 | `(`ID`)` | InnoDB/utf8mb3 | `SalesCategory` |
| `d0_setting_template` | 5 | `(`ID`)` | InnoDB/utf8mb3 | `SettingTemplate` |
| `d0_shipper` | 17 | `(`ID`)` | InnoDB/utf8mb3 | `Shipper` |
| `d0_shipper_transaction` | 13 | `(`ID`)` | InnoDB/utf8mb3 | `ShipperTransaction` |
| `d0_structure_filial` | 11 | `(`ID`)` | InnoDB/utf8mb3 | `StructureFilial` |
| `d0_supervayzer` | 11 | `(`SV_AGENT_ID`)` | InnoDB/utf8mb3 | `Supervayzer` |
| `d0_sync` | 5 | `(`ID`)` | InnoDB/utf8mb3 | `Sync` |
| `d0_sync_log` | 15 | `(`ID`)` | InnoDB/utf8mb3 | `SyncLog` |
| `d0_sync_log_delete` | 15 | `(`ID`)` | InnoDB/utf8mb3 | `—` |
| `d0_system_log` | 7 | `(`ID`)` | InnoDB/utf8mb3 | `SystemLog` |
| `d0_tableControl` | 7 | `(`ID`)` | InnoDB/utf8mb3 | `TableControl` |
| `d0_table_config` | 11 | `(`ID`)` | InnoDB/utf8mb3 | `TableConfig` |
| `d0_tags` | 8 | `(`ID`)` | InnoDB/utf8mb3 | `Tag` |
| `d0_target_akb` | 16 | `(`AKB_ID`)` | InnoDB/utf8mb3 | `TargetAkb` |
| `d0_target_coverage` | 1 | `(`id`)` | InnoDB/utf8mb3 | `TargetCoverage` |
| `d0_target_sku` | 20 | `(`SKU_ID`)` | InnoDB/utf8mb3 | `TargetSku` |
| `d0_target_strike` | 19 | `(`ORDER_VOL_ID`)` | InnoDB/utf8mb3 | `TargetStrike` |
| `d0_target_volume` | 17 | `(`TAR_VOL_ID`)` | InnoDB/utf8mb3 | `TargetVolume` |
| `d0_task_log` | 6 | `(`ID`)` | InnoDB/utf8mb3 | `TaskLog` |
| `d0_task_type` | 9 | `(`ID`)` | InnoDB/utf8mb3 | `TaskType` |
| `d0_tasks` | 29 | `(`ID`)` | InnoDB/utf8mb3 | `Tasks` |
| `d0_tasks_status_log` | 7 | `(`ID`)` | MyISAM/utf8mb3 | `TaskStatusLog` |
| `d0_tg_bot` | 12 | `(`ID`)` | InnoDB/utf8mb3 | `TgBot` |
| `d0_tg_package` | 7 | `(`ID`)` | InnoDB/utf8mb3 | `TgPackage` |
| `d0_tg_package_contact` | 7 | `(`ID`)` | InnoDB/utf8mb3 | `TgPackageContact` |
| `d0_tg_package_product` | 7 | `(`ID`)` | InnoDB/utf8mb3 | `TgPackageProduct` |
| `d0_tg_regular` | 4 | `(`ID`)` | InnoDB/utf8mb3 | `TgRegular` |
| `d0_tg_report` | 7 | `(`ID`)` | InnoDB/utf8mb3 | `TgReport` |
| `d0_tg_user_report` | 4 | `(`ID`)` | InnoDB/utf8mb3 | `TgUserReport` |
| `d0_trade_direction` | 8 | `(`ID`)` | InnoDB/utf8mb3 | `TradeDirection` |
| `d0_transaction_closed` | 9 | `(`ID`)` | InnoDB/utf8mb3 | `TransactionClosed` |
| `d0_transaction_log` | 8 | `(`ID`)` | InnoDB/utf8mb3 | `TransactionLog` |
| `d0_units` | 12 | `(`UNIT_ID`)` | InnoDB/utf8mb3 | `Unit` |
| `d0_valyuta` | 11 | `(`VALYUTA_ID`)` | InnoDB/utf8mb3 | `Valyuta` |
| `d0_working_days` | 10 | `(`WORKING_DAY_ID`)` | InnoDB/utf8mb3 | `WorkingDays` |
| `tbl_migration` | 2 | `(`version`)` | InnoDB/utf8mb4 | `—` |

### Partner (1 таблица)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_partner` | 14 | `(`PARTNER_CAT_ID`)` | InnoDB/utf8mb3 | `Partner` |

### Payment / Pay (4 таблицы)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_payme_transaction` | 10 | `(`ID`)` | InnoDB/utf8mb3 | `—` |
| `d0_payment_deliver` | 23 | `(`ID`)` | InnoDB/utf8mb3 | `PaymentDeliver` |
| `d0_payment_displacement` | 12 | `(`ID`)` | InnoDB/utf8mb3 | `PaymentDisplacement` |
| `d0_payment_transfer` | 13 | `(`PAYMENT_TRANSFER_ID`)` | InnoDB/utf8mb4 | `PaymentTransfer` |

### Photo (2 таблицы)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_photo_inventory` | 7 | `(`ID`)` | InnoDB/utf8mb3 | `PhotoInventory` |
| `d0_photo_report` | 23 | `(`PR_ID`)` | InnoDB/utf8mb3 | `PhotoReport` |

### Plan (8 таблиц)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_plan` | 12 | `(`PLAN_ID`)` | InnoDB/utf8mb3 | `Plan` |
| `d0_plan_product` | 13 | `(`ID`)` | InnoDB/utf8mb3 | `PlanProduct` |
| `d0_planning` | 15 | `(`ID`)` | InnoDB/utf8mb3 | `—` |
| `d0_planning_history` | 4 | `(`ID`)` | InnoDB/utf8mb3 | `—` |
| `d0_planning_min_plan` | 11 | `(`ID`)` | InnoDB/utf8mb3 | `—` |
| `d0_planning_outlet` | 8 | `(`ID`)` | InnoDB/utf8mb3 | `—` |
| `d0_planning_percent_day` | 10 | `(`ID`)` | InnoDB/utf8mb4 | `—` |
| `d0_planning_pulse` | 8 | `(`ID`)` | InnoDB/utf8mb3 | `—` |

### Rating (4 таблицы)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_rating` | 1 | `(`id`)` | InnoDB/utf8mb3 | `—` |
| `d0_rating_comment` | 1 | `(`id`)` | InnoDB/utf8mb3 | `—` |
| `d0_rating_question` | 1 | `(`id`)` | InnoDB/utf8mb3 | `—` |
| `d0_rating_result` | 1 | `(`id`)` | InnoDB/utf8mb3 | `—` |

### Reject (5 таблиц)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_reject` | 12 | `(`REJECT_ID`)` | InnoDB/utf8mb3 | `Reject` |
| `d0_reject_client` | 17 | `(`REJECT_CLIENT_ID`)` | InnoDB/utf8mb3 | `RejectClient` |
| `d0_reject_defect` | 11 | `(`ID`)` | InnoDB/utf8mb3 | `RejectDefect` |
| `d0_reject_diler` | 1 | `(`id`)` | InnoDB/utf8mb3 | `RejectDiler` |
| `d0_reject_expeditor` | 9 | `(`ID`)` | InnoDB/utf8mb3 | `RejectExpeditor` |

### SMS (4 таблицы)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_sms_message` | 7 | `(`id`)` | InnoDB/utf8mb4 | `—` |
| `d0_sms_message_item` | 6 | `(`id`)` | InnoDB/utf8mb4 | `—` |
| `d0_sms_pending` | 13 | `(`ID`)` | InnoDB/utf8mb3 | `SmsPending` |
| `d0_sms_template` | 8 | `(`id`)` | InnoDB/utf8mb4 | `—` |

### Stock (1 таблица)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_stock_exp` | 1 | `(`id`)` | InnoDB/utf8mb3 | `StockExp` |

### Store (6 таблиц)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_store` | 22 | `(`STORE_ID`)` | InnoDB/utf8mb3 | `Store` |
| `d0_store_corrector` | 24 | `(`CORRECTOR_ID`)` | InnoDB/utf8mb3 | `StoreCorrector` |
| `d0_store_detail` | 11 | `(`STORE_DETAIL_ID`)` | InnoDB/utf8mb3 | `StoreDetail` |
| `d0_store_history` | 4 | `(`STORE_HIS_ID`)` | InnoDB/utf8mb3 | `StoreHistory` |
| `d0_store_log` | 11 | `(`ID`)` | InnoDB/utf8mb3 | `StoreLog` |
| `d0_store_stats` | 15 | `(`ID`)` | InnoDB/utf8mb3 | `StoreStats` |

### Tara (4 таблицы)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_tara` | 8 | `(`TARA_ID`)` | InnoDB/utf8mb3 | `Tara` |
| `d0_tara_client` | 15 | `(`ID`)` | InnoDB/utf8mb3 | `TaraClient` |
| `d0_tara_document` | 13 | `(`ID`)` | InnoDB/utf8mb3 | `TaraDocument` |
| `d0_tara_document_detail` | 10 | `(`ID`)` | InnoDB/utf8mb3 | `TaraDocumentDetail` |

### Telegram (5 таблиц)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_telegram_function` | 12 | `(`ID`)` | InnoDB/utf8mb3 | `TelegramFunction` |
| `d0_telegram_group` | 8 | `(`ID`)` | InnoDB/utf8mb3 | `TelegramGroup` |
| `d0_telegram_group_topic` | 6 | `(`ID`)` | InnoDB/utf8mb4 | `TelegramGroupTopic` |
| `d0_telegram_report` | 4 | `(`ID`)` | InnoDB/utf8mb3 | `TelegramReport` |
| `d0_telegram_sent_messages` | 3 | `(`ID`)` | InnoDB/utf8mb3 | `TelegramSentMessages` |

### User / Auth (4 таблицы)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `authassignment` | 5 | `(`itemname`,`userid`,`filial_id`) USING ` | InnoDB/utf8mb3 | `—` |
| `authitem` | 5 | `(`name`)` | InnoDB/utf8mb3 | `—` |
| `authitemchild` | 2 | `(`parent`,`child`)` | InnoDB/utf8mb3 | `—` |
| `d0_user` | 22 | `(`USER_ID`)` | InnoDB/utf8mb3 | `User` |

### Vansel (4 таблицы)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_vs_exchange` | 16 | `(`ID`)` | InnoDB/utf8mb3 | `VsExchange` |
| `d0_vs_exchange_details` | 10 | `(`ID`)` | InnoDB/utf8mb3 | `VsExchangeDetails` |
| `d0_vs_return` | 15 | `(`ID`)` | InnoDB/utf8mb3 | `VsReturn` |
| `d0_vs_return_details` | 10 | `(`ID`)` | InnoDB/utf8mb3 | `VsReturnDetails` |

### Visit (6 таблиц)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_visit` | 28 | `(`ID`,`DATE`)` | InnoDB/utf8mb3 | `Visit` |
| `d0_visit_exp` | 13 | `(`ID`)` | InnoDB/utf8mb3 | `VisitExp` |
| `d0_visiting` | 19 | `(`VISIT_ID`)` | InnoDB/utf8mb3 | `Visiting` |
| `d0_visiting_aud` | 11 | `(`VISIT_ID`)` | InnoDB/utf8mb3 | `VisitingAud` |
| `d0_visiting_history` | 11 | `(`ID`)` | InnoDB/utf8mb3 | `VisitingHistory` |
| `d0_visiting_month` | 8 | `(`ID`)` | InnoDB/utf8mb4 | `VisitingMonth` |

### Warehouse (3 таблицы)

| Таблица | Колонки | PK | Движок / кодировка | Модель |
|---------|---------|----|--------------------|--------|
| `d0_warehouse` | 14 | `(`WAREHOUSE_ID`)` | InnoDB/utf8mb3 | `Warehouse` |
| `d0_warehouse_detail` | 14 | `(`WAREHOUSE_DETAIL_ID`)` | InnoDB/utf8mb3 | `WarehouseDetail` |
| `d0_warehouse_location` | 8 | `(`ID`)` | InnoDB/utf8mb4 | `WarehouseLocation` |

## Индекс активных моделей

Все 306 активных Yii-моделей, отсортированных по алфавиту.

| Класс | Таблица | PK | Колонки (модель) | Колонки (live) | Связи |
|-------|---------|----|------------------|----------------|-------|
| `AdtAudit` | `d0_adt_audit` | `ID` | 16 | 19 | 2 |
| `AdtAuditProducts` | `d0_adt_audit_bind_products` | `ID` | 3 | 3 | 1 |
| `AdtAuditResult` | `d0_adt_audit_result` | `ID` | 10 | 12 | 5 |
| `AdtAuditResultData` | `d0_adt_audit_result_data` | `ID` | 12 | 12 | 3 |
| `AdtAuditUsers` | `d0_adt_audit_bind_users` | `ID` | 3 | 3 | 0 |
| `AdtBrands` | `d0_adt_brand` | `ID` | 8 | 9 | 0 |
| `AdtComment` | `d0_adt_comment` | `ID` | 8 | 8 | 0 |
| `AdtCommentResult` | `d0_adt_comment_result` | `ID` | 12 | 11 | 1 |
| `AdtConfig` | `d0_adt_config` | `ID` | 4 | 11 | 1 |
| `AdtNoteResult` | `d0_adt_note_result` | `ID` | 12 | 11 | 0 |
| `AdtPack` | `d0_adt_pack` | `ID` | 8 | 8 | 0 |
| `AdtParams` | `d0_adt_params` | `—` | 9 | 9 | 0 |
| `AdtPoll` | `d0_adt_poll` | `ID` | 10 | 11 | 3 |
| `AdtPollBind` | `d0_adt_poll_bind` | `ID` | 8 | 8 | 0 |
| `AdtPollQuestion` | `d0_adt_poll_question` | `ID` | 11 | 13 | 3 |
| `AdtPollResult` | `d0_adt_poll_result` | `ID` | 13 | 13 | 2 |
| `AdtPollResultData` | `d0_adt_poll_result_data` | `ID` | 8 | 8 | 1 |
| `AdtPollVariant` | `d0_adt_poll_variant` | `ID` | 9 | 10 | 0 |
| `AdtProducer` | `d0_adt_producer` | `ID` | 9 | 9 | 0 |
| `AdtProperty` | `d0_adt_property` | `ID` | 6 | 7 | 0 |
| `AdtProperty1` | `d0_adt_property1` | `ID` | 8 | 8 | 0 |
| `AdtProperty2` | `d0_adt_property2` | `ID` | 8 | 8 | 0 |
| `AdtReports` | `d0_adt_reports` | `—` | 4 | 3 | 0 |
| `AdtSegment` | `d0_adt_segment` | `ID` | 8 | 8 | 0 |
| `AFacing` | `d0_afacing` | `ID` | 11 | 1 | 0 |
| `Agent` | `d0_agent` | `AGENT_ID` | 26 | 29 | 0 |
| `AgentPaket` | `d0_agent_paket` | `—` | 17 | 18 | 0 |
| `AgentPlan` | `d0_agent_plan` | `AGENT_PLAN_ID` | 14 | 14 | 0 |
| `AgentSettings` | `d0_agent_settings` | `—` | 0 | 7 | 0 |
| `AkbCategory` | `d0_akb_category` | `ID` | 8 | 8 | 0 |
| `AkbCategoryProduct` | `d0_akb_category_product` | `ID` | 7 | 7 | 0 |
| `AkbFilter` | `d0_akb_filter` | `ID` | 6 | 6 | 0 |
| `AProduct` | `d0_aproduct` | `ID` | 13 | 1 | 0 |
| `ASku` | `d0_asku` | `ID` | 16 | 1 | 0 |
| `AudBrands` | `d0_aud_brands` | `ID` | 7 | 8 | 0 |
| `AudCategory` | `d0_aud_category` | `ID` | 12 | 13 | 0 |
| `AudFacing` | `d0_aud_facing` | `ID` | 15 | 15 | 0 |
| `Auditor` | `d0_auditor` | `ID` | 19 | 19 | 0 |
| `AuditStorchekCat` | `d0_audit_storchek_cat` | `ID` | 8 | 8 | 0 |
| `AudPlaceType` | `d0_aud_place_type` | `ID` | 5 | 6 | 0 |
| `AudProduct` | `d0_aud_product` | `ID` | 11 | 12 | 0 |
| `AudSku` | `d0_aud_sku` | `ID` | 15 | 15 | 0 |
| `BaseFilial` | `d0_basefilial` ⚠ | `—` | 0 | — | 0 |
| `BasePaket` | `d0_basepaket` ⚠ | `—` | 0 | — | 0 |
| `Bonus` | `d0_bonus` | `BONUS_ID` | 33 | 36 | 0 |
| `BonusAgent` | `d0_bonus_agent` | `—` | 3 | 3 | 0 |
| `BonusCity` | `d0_bonus_city` | `—` | 3 | 3 | 0 |
| `BonusExclude` | `d0_bonus_exclude` | `—` | 1 | 7 | 0 |
| `BonusFilial` | `d0_bonus_filial` | `—` | 3 | 3 | 0 |
| `BonusLimit` | `d0_bonus_limit` | `—` | 5 | 5 | 0 |
| `BonusOrder` | `d0_bonus_order` | `—` | 22 | 22 | 0 |
| `BonusOrderDetail` | `d0_bonus_order_detail` | `—` | 22 | 20 | 1 |
| `BonusOrderHistory` | `d0_bonus_order_history` | `ID` | 8 | 8 | 0 |
| `BonusRelation` | `d0_bonus_relation` | `—` | 1 | 7 | 0 |
| `Brand` | `d0_brand` | `ID` | 8 | 1 | 0 |
| `Cache` | `d0_cache` | `—` | 6 | 6 | 0 |
| `Car` | `d0_cars` | `ID` | 7 | 18 | 0 |
| `Cashbox` | `d0_cashbox` | `—` | 14 | 15 | 0 |
| `CashboxDisplacement` | `d0_cashbox_displacement` | `ID` | 11 | 15 | 0 |
| `CatalogProduct` | `d0_catalog_product` | `id` | 12 | 16 | 0 |
| `CatalogProductBind` | `d0_catalog_product_bind` | `id` | 8 | 9 | 0 |
| `CatalogSection` | `d0_catalog_section` | `id` | 12 | 13 | 0 |
| `CatalogState` | `d0_catalog_state` | `id` | 11 | 12 | 0 |
| `CisesInfo` | `d0_cises_info` | `—` | 12 | 12 | 0 |
| `City` | `d0_city` | `—` | 12 | 14 | 0 |
| `Client` | `d0_client` | `CLIENT_ID` | 52 | 58 | 2 |
| `ClientActiveLog` | `d0_client_active_log` | `ID` | 9 | 6 | 0 |
| `ClientCategory` | `d0_client_category` | `—` | 13 | 15 | 0 |
| `ClientChannel` | `d0_client_channel` | `ID` | 7 | 8 | 0 |
| `ClientClass` | `d0_client_class` | `—` | 3 | 5 | 0 |
| `ClientFinans` | `d0_client_finans` | `CLIENT_FIN_ID` | 17 | 18 | 0 |
| `ClientFirm` | `d0_client_firm` | `—` | 14 | 14 | 0 |
| `ClientKaspiTransaction` | `d0_client_kaspi_transaction` | `—` | 8 | 8 | 1 |
| `ClientLog` | `d0_client_log` | `ID` | 9 | 7 | 0 |
| `ClientOdengiTransaction` | `d0_client_odengi_transaction` | `—` | 9 | 9 | 1 |
| `ClientOptimaTransaction` | `d0_client_optima_transaction` | `—` | 8 | 1 | 1 |
| `ClientPaymeTransaction` | `d0_client_payme_transactions` | `—` | 15 | 15 | 0 |
| `ClientPending` | `d0_client_pending` | `—` | 32 | 35 | 2 |
| `ClientPhones` | `d0_client_phones` | `ID` | 8 | 9 | 0 |
| `ClientPhoto` | `d0_client_photo` | `—` | 5 | 5 | 0 |
| `ClientStock` | `d0_client_stock` | `ID` | 14 | 14 | 0 |
| `ClientTransaction` | `d0_client_transaction` | `CLIENT_TRANS_ID` | 37 | 40 | 0 |
| `ClientTransactionHistory` | `d0_client_transaction_history` | `TRANS_ID` | 23 | 32 | 0 |
| `ClientType` | `d0_client_type` | `ID` | 9 | 9 | 0 |
| `Closed` | `d0_closed` | `ID` | 9 | 10 | 0 |
| `Config` | `d0_config` | `ID` | 5 | 5 | 0 |
| `Consumption` | `d0_consumption` | `—` | 17 | 20 | 0 |
| `ConsumptionChild` | `d0_consumption_child` | `ID` | 10 | 12 | 0 |
| `ConsumptionHistory` | `d0_consumption_history` | `—` | 7 | 7 | 1 |
| `ConsumptionParent` | `d0_consumption_parent` | `—` | 9 | 11 | 0 |
| `Contact` | `d0_contact` | `ID` | 15 | 17 | 0 |
| `ContactClient` | `d0_contact_client` | `—` | 3 | 3 | 0 |
| `ContactForm` | `d0_contactform` ⚠ | `—` | 0 | — | 0 |
| `Contragent` | `d0_contragent` | `CLIENT_ID` | 38 | 39 | 2 |
| `ContragentHistory` | `d0_contragent_history` | `ID` | 12 | 10 | 0 |
| `ContragentLog` | `d0_contragent_log` | `ID` | 9 | 7 | 0 |
| `Conversion` | `d0_conversion` | `CURRENCY_RATE` | 8 | 7 | 0 |
| `CreatedStores` | `d0_created_stores` | `CREATED_STORE_ID` | 11 | 11 | 0 |
| `Currency` | `d0_currency` | `CURRENCY_ID` | 16 | 16 | 0 |
| `DebtFinans` | `d0_debt_finans` | `DEBT_ID` | 13 | 14 | 0 |
| `DefectDetailLog` | `d0_defect_detail_log` | `ID` | 9 | 8 | 0 |
| `Defects` | `d0_defects` | `—` | 12 | 12 | 0 |
| `Device` | `d0_device` ⚠ | `—` | 6 | — | 0 |
| `Diler` | `d0_diler` | `DILER_ID` | 23 | 24 | 5 |
| `DoctorStrike` | `d0_doctor_strike` | `ID` | 39 | 43 | 0 |
| `DoctorVolume` | `d0_doctor_volume` | `ID` | 39 | 43 | 0 |
| `EntityXmlMap` | `d0_entity_xml_map` | `—` | 5 | 5 | 0 |
| `Exchange` | `d0_exchange` | `EXCHANGE_ID` | 22 | 24 | 0 |
| `ExchangeDetail` | `d0_exchange_detail` | `—` | 14 | 14 | 0 |
| `Excretion` | `d0_excretion` | `—` | 17 | 17 | 0 |
| `Expeditor` | `d0_expeditor` | `—` | 27 | 28 | 0 |
| `ExpeditorKpiJob` | `d0_expeditor_kpi_job` | `ID` | 16 | 16 | 0 |
| `ExpeditorKpiSetup` | `d0_expeditor_kpi_setup` | `ID` | 7 | 7 | 0 |
| `ExpeditorLoad` | `d0_expeditor_load` | `ID` | 0 | 8 | 0 |
| `ExpeditorLoadDetail` | `d0_expeditor_load_detail` | `ID` | 0 | 10 | 0 |
| `ExpeditorLoadHistory` | `d0_expeditor_load_history` | `ID` | 0 | 6 | 0 |
| `ExpeditorLoadNeo` | `d0_expeditor_load_neo` | `ID` | 0 | 1 | 0 |
| `Feedbacks` | `d0_feedbacks` | `ID` | 5 | 5 | 0 |
| `Filial` | `d0_filial` | `—` | 5 | 8 | 0 |
| `FilialClient` | `d0_filial_client` | `—` | 2 | 2 | 0 |
| `FilialCurrency` | `d0_filial_currency` | `—` | 0 | 3 | 0 |
| `FilialMovementRequest` | `d0_filial_movement_request` ⚠ | `—` | 12 | — | 5 |
| `FilialMovementRequestDetail` | `d0_filial_movement_request_detail` ⚠ | `—` | 7 | — | 3 |
| `FilialOrder` | `d0_filial_order` | `—` | 8 | 9 | 0 |
| `FilialPhotoCategory` | `d0_filial_photo_category` | `—` | 3 | 3 | 0 |
| `FilialProduct` | `d0_filial_product` | `—` | 0 | 3 | 0 |
| `ForecastCategory` | `d0_forecast_category` | `—` | 6 | 6 | 0 |
| `Gps` | `d0_gps` | `—` | 18 | 20 | 0 |
| `GpsAdt` | `d0_gps_adt` | `—` | 18 | 18 | 0 |
| `IncomingInvoice` | `d0_incoming_invoices` | `—` | 17 | 17 | 0 |
| `IncomingInvoiceDetail` | `d0_incoming_invoices_details` | `—` | 9 | 9 | 0 |
| `IncomingInvoiceScannedCis` | `d0_incoming_invoices_scanned_cises` | `—` | 6 | 6 | 0 |
| `Integration` | `d0_integrations` | `—` | 7 | 7 | 0 |
| `Inventory` | `d0_inventory` | `INVENTORY_ID` | 20 | 20 | 0 |
| `InventoryCheck` | `d0_inventory_check` | `—` | 11 | 11 | 0 |
| `InventoryCheckPhoto` | `d0_inventory_check_photo` | `—` | 2 | 3 | 0 |
| `InventoryGroup` | `d0_inventory_group` | `ID` | 7 | 7 | 0 |
| `InventoryHistory` | `d0_inventory_history` | `INVENTORY_HIST_ID` | 20 | 20 | 2 |
| `InventoryType` | `d0_inventory_type` | `INV_TYPE_ID` | 17 | 18 | 0 |
| `Invoice` | `d0_invoice` | `INVOICE_ID` | 11 | 1 | 0 |
| `InvoiceDetail` | `d0_invoice_detail` | `INVOICE_DET_ID` | 15 | 1 | 0 |
| `InvoiceTemplate` | `d0_invoice_template` | `—` | 4 | 9 | 0 |
| `Kpi` | `d0_kpi` | `KPI_ID` | 31 | 38 | 0 |
| `KpiGroup` | `d0_kpi_group` | `ID` | 7 | 7 | 0 |
| `KpiGroupLink` | `d0_kpi_group_link` | `ID` | 3 | 3 | 0 |
| `KpiTask` | `d0_kpi_task` | `KPI_TASK_ID` | 42 | 58 | 0 |
| `KpiTaskTemplate` | `d0_kpi_task_template` | `ID` | 56 | 62 | 0 |
| `KpiTaskTemplateGroup` | `d0_kpi_task_template_group` | `—` | 0 | 10 | 0 |
| `Log` | `d0_log` | `—` | 13 | 13 | 0 |
| `LoginForm` | `d0_loginform` ⚠ | `—` | 0 | — | 0 |
| `Manufacture` | `d0_manufacture` | `ID` | 8 | 1 | 0 |
| `ModelLog` | `d0_model_log` | `—` | 4 | 4 | 0 |
| `ModelTag` | `d0_model_tags` | `ID` | 4 | 4 | 0 |
| `MustBuyRule` | `d0_must_buy_rule` ⚠ | `—` | 13 | — | 1 |
| `MustBuyRuleItem` | `d0_must_buy_rule_item` ⚠ | `—` | 14 | — | 0 |
| `Neakb` | `d0_neakb` ⚠ | `—` | 0 | — | 0 |
| `Notification` | `d0_notification` | `—` | 12 | 12 | 0 |
| `NotifyRead` | `d0_notify_read` | `—` | 5 | 5 | 0 |
| `OldPrice` | `d0_old_price` | `PRICE_ID` | 20 | 20 | 0 |
| `OldPriceType` | `d0_old_price_type` | `OLD_PRICE_TYPE_ID` | 19 | 19 | 0 |
| `OnlineOrder` | `d0_online_order` | `—` | 20 | 20 | 3 |
| `OnlineOrderDetail` | `d0_online_order_detail` | `—` | 6 | 6 | 1 |
| `OnlinePayment` | `d0_online_payments` | `—` | 8 | 8 | 0 |
| `Order` | `d0_order` | `—` | 53 | 59 | 0 |
| `OrderCises` | `d0_order_cises` | `—` | 12 | 12 | 0 |
| `OrderCisesLog` | `d0_order_cises_log` | `—` | 5 | 5 | 0 |
| `OrderCode` | `d0_order_code` | `—` | 5 | 5 | 0 |
| `OrderComment` | `d0_order_comment` | `—` | 9 | 9 | 0 |
| `OrderDefect` | `d0_order_defect` | `ORDER_DEFECT_ID` | 27 | 30 | 0 |
| `OrderDefectDetail` | `d0_order_defect_detail` | `—` | 26 | 26 | 1 |
| `OrderDetail` | `d0_order_detail` | `—` | 29 | 29 | 0 |
| `OrderDetailHistory` | `d0_order_detail_history` | `—` | 28 | 28 | 0 |
| `OrderEsf` | `d0_order_esf` | `—` | 10 | 10 | 0 |
| `OrderHistory` | `d0_order_history` | `—` | 36 | 38 | 0 |
| `OrderReplace` | `d0_order_replace` | `ORDER_REPLACE_ID` | 27 | 30 | 0 |
| `OrderReplaceDetail` | `d0_order_replace_detail` | `—` | 17 | 20 | 1 |
| `OutletFact` | `d0_outlet_fact` | `O_FACT_ID` | 19 | 19 | 0 |
| `OutletPlan` | `d0_outlet_plan` | `O_PLAN_ID` | 21 | 23 | 0 |
| `ParentPhotoReport` | `d0_parent_photo_report` | `—` | 9 | 9 | 0 |
| `Partner` | `d0_partner` | `PARTNER_CAT_ID` | 14 | 14 | 0 |
| `PaymentDeliver` | `d0_payment_deliver` | `ID` | 16 | 23 | 0 |
| `PaymentDisplacement` | `d0_payment_displacement` | `ID` | 11 | 12 | 0 |
| `PaymentTransfer` | `d0_payment_transfer` | `—` | 0 | 13 | 0 |
| `PhotoInventory` | `d0_photo_inventory` | `ID` | 7 | 7 | 0 |
| `PhotoReport` | `d0_photo_report` | `PR_ID` | 20 | 23 | 0 |
| `Plan` | `d0_plan` | `PLAN_ID` | 11 | 12 | 0 |
| `PlanProduct` | `d0_plan_product` | `ID` | 11 | 13 | 0 |
| `Poll` | `d0_poll` | `ID` | 7 | 7 | 0 |
| `PollQuestion` | `d0_poll_question` | `ID` | 9 | 9 | 0 |
| `PollResult` | `d0_poll_result` | `ID` | 13 | 13 | 0 |
| `PollVariant` | `d0_poll_variant` | `ID` | 7 | 7 | 0 |
| `Price` | `d0_price` | `PRICE_ID` | 19 | 20 | 0 |
| `PriceChangeLog` | `d0_price_change_log` | `—` | 7 | 7 | 0 |
| `PriceType` | `d0_price_type` | `PRICE_TYPE_ID` | 24 | 25 | 0 |
| `PriceTypeFilial` | `d0_price_type_filial` | `—` | 3 | 3 | 0 |
| `Printer` | `d0_printer` | `—` | 8 | 9 | 0 |
| `PrinterAttach` | `d0_printer_attach` | `—` | 7 | 7 | 0 |
| `Product` | `d0_product` | `—` | 51 | 57 | 8 |
| `ProductCaseType` | `d0_product_case_type` | `ID` | 9 | 9 | 0 |
| `ProductCategory` | `d0_product_category` | `PRODUCT_CAT_ID` | 12 | 14 | 2 |
| `ProductCatGroup` | `d0_product_cat_group` | `ID` | 10 | 10 | 0 |
| `ProductCompetitor` | `d0_product_competitor` | `PRODUCT_ID` | 25 | 39 | 7 |
| `ProductFilial` | `d0_filial_product` | `—` | 3 | 3 | 0 |
| `ProductGroup` | `d0_product_group` | `ID` | 7 | 9 | 0 |
| `ProductPriceMarkup` | `d0_product_price_markup` | `ID` | 11 | 11 | 1 |
| `ProductSubCategory` | `d0_product_subcategory` | `SUB_CAT_ID` | 10 | 10 | 1 |
| `ProductUnit` | `d0_product_units` | `—` | 13 | 12 | 1 |
| `ProductValues` | `d0_product_values` | `ID` | 8 | 8 | 0 |
| `Properties` | `d0_properties` | `ID` | 10 | 10 | 0 |
| `Purchase` | `d0_purchase` | `—` | 30 | 30 | 0 |
| `PurchaseDetail` | `d0_purchase_detail` | `—` | 21 | 21 | 0 |
| `PurchaseDraft` | `d0_purchase_draft` | `—` | 17 | 17 | 0 |
| `PurchaseRefund` | `d0_purchase_refund` | `ID` | 27 | 28 | 0 |
| `PurchaseRefundDetail` | `d0_purchase_refund_detail` | `—` | 17 | 17 | 0 |
| `PushSubscriptions` | `d0_push_subscriptions` | `—` | 6 | 6 | 0 |
| `QuestionResult` | `d0_question_result` | `QUESTION_RES_ID` | 13 | 1 | 0 |
| `Questions` | `d0_questions` | `QUESTION_ID` | 12 | 1 | 0 |
| `QuestionVariants` | `d0_question_variants` | `QUESTION_VAR_ID` | 10 | 1 | 0 |
| `Rates` | `d0_rates` | `ID` | 7 | 7 | 0 |
| `Region` | `d0_region` | `REGION_ID` | 10 | 11 | 0 |
| `Reject` | `d0_reject` | `REJECT_ID` | 12 | 12 | 0 |
| `RejectClient` | `d0_reject_client` | `REJECT_CLIENT_ID` | 17 | 17 | 0 |
| `RejectDefect` | `d0_reject_defect` | `ID` | 11 | 11 | 0 |
| `RejectDiler` | `d0_reject_diler` | `—` | 9 | 1 | 0 |
| `RejectExpeditor` | `d0_reject_expeditor` | `ID` | 9 | 9 | 0 |
| `Rlp` | `d0_rlp` | `RLP_ID` | 8 | 8 | 0 |
| `RlpBonus` | `d0_rlp_bonus` | `RLP_BONUS_ID` | 13 | 13 | 0 |
| `Royalty` | `d0_royalty` | `ROYALTY_ID` | 27 | 25 | 0 |
| `RoyaltyFilial` | `d0_royalty_filial` | `—` | 3 | 3 | 0 |
| `RoyaltyTransaction` | `d0_royalty_transaction` | `ROYALTY_TRANS_ID` | 0 | 13 | 0 |
| `SalesCategory` | `d0_sales_category` | `ID` | 7 | 7 | 0 |
| `SettingTemplate` | `d0_setting_template` | `—` | 5 | 5 | 0 |
| `Shipper` | `d0_shipper` | `ID` | 17 | 17 | 0 |
| `ShipperTransaction` | `d0_shipper_transaction` | `—` | 13 | 13 | 0 |
| `Skidka` | `d0_skidka` | `SKIDKA_ID` | 29 | 37 | 0 |
| `SkidkaAgent` | `d0_skidka_agent` | `—` | 3 | 3 | 0 |
| `SkidkaBudget` | `d0_skidka_budget` | `—` | 7 | 8 | 0 |
| `SkidkaExclude` | `d0_skidka_exclude` | `—` | 0 | 7 | 0 |
| `SkidkaFilial` | `d0_skidka_filial` | `—` | 3 | 3 | 0 |
| `SkidkaManual` | `d0_skidka_manual` | `SKIDKA_ID` | 14 | 17 | 0 |
| `SkidkaManualAgent` | `d0_skidka_manual_agent` | `—` | 3 | 3 | 0 |
| `SkidkaManualFilial` | `d0_skidka_manual_filial` | `—` | 3 | 3 | 0 |
| `SkidkaOrder` | `d0_skidka_order` | `—` | 12 | 12 | 0 |
| `SkidkaRelation` | `d0_skidka_relation` | `—` | 1 | 7 | 0 |
| `SkidkaStore` | `d0_skidka_store` | `—` | 3 | 3 | 0 |
| `SmsPending` | `d0_sms_pending` | `ID` | 13 | 13 | 0 |
| `StockExp` | `d0_stock_exp` | `ID` | 16 | 1 | 0 |
| `Store` | `d0_store` | `—` | 22 | 22 | 0 |
| `StoreCorrector` | `d0_store_corrector` | `—` | 23 | 24 | 0 |
| `StoreDetail` | `d0_store_detail` | `STORE_DETAIL_ID` | 10 | 11 | 0 |
| `StoreHistory` | `d0_store_history` | `—` | 4 | 4 | 0 |
| `StoreLog` | `d0_store_log` | `—` | 11 | 11 | 0 |
| `StoreStats` | `d0_store_stats` | `ID` | 15 | 15 | 0 |
| `StructureFilial` | `d0_structure_filial` | `ID` | 11 | 11 | 1 |
| `Supervayzer` | `d0_supervayzer` | `SV_AGENT_ID` | 11 | 11 | 0 |
| `Sync` | `d0_sync` | `—` | 5 | 5 | 0 |
| `SyncLog` | `d0_sync_log` | `—` | 12 | 15 | 0 |
| `SystemLog` | `d0_system_log` | `—` | 7 | 7 | 0 |
| `TableConfig` | `d0_table_config` | `—` | 1 | 11 | 0 |
| `TableControl` | `d0_tableControl` | `ID` | 7 | 7 | 0 |
| `Tag` | `d0_tags` | `ID` | 8 | 8 | 0 |
| `Tara` | `d0_tara` | `TARA_ID` | 8 | 8 | 0 |
| `TaraClient` | `d0_tara_client` | `—` | 14 | 15 | 0 |
| `TaraDocument` | `d0_tara_document` | `ID` | 9 | 13 | 0 |
| `TaraDocumentDetail` | `d0_tara_document_detail` | `ID` | 6 | 10 | 0 |
| `TargetAkb` | `d0_target_akb` | `AKB_ID` | 16 | 16 | 0 |
| `TargetCoverage` | `d0_target_coverage` | `COVERAGE_ID` | 16 | 1 | 0 |
| `TargetSku` | `d0_target_sku` | `SKU_ID` | 20 | 20 | 0 |
| `TargetStrike` | `d0_target_strike` | `ORDER_VOL_ID` | 19 | 19 | 0 |
| `TargetVolume` | `d0_target_volume` | `TAR_VOL_ID` | 17 | 17 | 0 |
| `TaskLog` | `d0_task_log` | `—` | 6 | 6 | 3 |
| `Tasks` | `d0_tasks` | `ID` | 27 | 29 | 4 |
| `TaskStatusLog` | `d0_tasks_status_log` | `ID` | 1 | 7 | 0 |
| `TaskType` | `d0_task_type` | `ID` | 8 | 9 | 0 |
| `TelegramFunction` | `d0_telegram_function` | `ID` | 11 | 12 | 0 |
| `TelegramGroup` | `d0_telegram_group` | `ID` | 4 | 8 | 0 |
| `TelegramGroupTopic` | `d0_telegram_group_topic` | `ID` | 5 | 6 | 0 |
| `TelegramReport` | `d0_telegram_report` | `ID` | 3 | 4 | 0 |
| `TelegramSentMessages` | `d0_telegram_sent_messages` | `ID` | 3 | 3 | 0 |
| `TgBot` | `d0_tg_bot` | `ID` | 12 | 12 | 1 |
| `TgPackage` | `d0_tg_package` | `ID` | 7 | 7 | 0 |
| `TgPackageContact` | `d0_tg_package_contact` | `ID` | 7 | 7 | 0 |
| `TgPackageProduct` | `d0_tg_package_product` | `ID` | 7 | 7 | 0 |
| `TgRegular` | `d0_tg_regular` | `—` | 4 | 4 | 0 |
| `TgReport` | `d0_tg_report` | `—` | 7 | 7 | 0 |
| `TgUserReport` | `d0_tg_user_report` | `—` | 4 | 4 | 0 |
| `TradeDirection` | `d0_trade_direction` | `ID` | 8 | 8 | 0 |
| `TransactionClosed` | `d0_transaction_closed` | `ID` | 9 | 9 | 0 |
| `TransactionLog` | `d0_transaction_log` | `—` | 8 | 8 | 0 |
| `Unit` | `d0_units` | `UNIT_ID` | 12 | 12 | 0 |
| `User` | `d0_user` | `USER_ID` | 16 | 22 | 2 |
| `Valyuta` | `d0_valyuta` | `VALYUTA_ID` | 11 | 11 | 0 |
| `Visit` | `d0_visit` | `—` | 27 | 28 | 5 |
| `VisitExp` | `d0_visit_exp` | `ID` | 12 | 13 | 0 |
| `Visiting` | `d0_visiting` | `VISIT_ID` | 16 | 19 | 0 |
| `VisitingAud` | `d0_visiting_aud` | `VISIT_ID` | 5 | 11 | 2 |
| `VisitingHistory` | `d0_visiting_history` | `—` | 9 | 11 | 0 |
| `VisitingMonth` | `d0_visiting_month` | `—` | 0 | 8 | 0 |
| `VsExchange` | `d0_vs_exchange` | `—` | 16 | 16 | 0 |
| `VsExchangeDetails` | `d0_vs_exchange_details` | `—` | 10 | 10 | 0 |
| `VsReturn` | `d0_vs_return` | `—` | 15 | 15 | 0 |
| `VsReturnDetails` | `d0_vs_return_details` | `—` | 10 | 10 | 0 |
| `Warehouse` | `d0_warehouse` | `WAREHOUSE_ID` | 14 | 14 | 0 |
| `WarehouseDetail` | `d0_warehouse_detail` | `WAREHOUSE_DETAIL_ID` | 14 | 14 | 0 |
| `WarehouseLocation` | `d0_warehouse_location` | `—` | 8 | 8 | 0 |
| `WorkingDays` | `d0_working_days` | `WORKING_DAY_ID` | 10 | 10 | 0 |

⚠ = ожидаемая таблица не найдена в live-дампе.

## Процедура обновления

```bash
# 1. Re-extract from models
cd ~/projects/salesdoctor/sd-main
python3 ../sd-docs/scripts/extract-schema.py \
    > ../sd-docs/static/data/schema-extract.json

# 2. Re-dump the live schema (no rows)
docker compose exec db mysqldump --no-data --routines --triggers \
    -uroot -proot sd_main \
    > ../sd-docs/static/data/live-schema.sql

# 3. Parse the live SQL
python3 ../sd-docs/scripts/parse-live-schema.py \
    < ../sd-docs/static/data/live-schema.sql \
    > ../sd-docs/static/data/live-schema-parsed.json

# 4. Render this page
python3 ../sd-docs/scripts/render-schema-reference.py \
    > ../sd-docs/docs/data/schema-reference.md
```
