---
sidebar_position: 1
title: Testing
---

# Testing

## Status overview

- **sd-main**: zero project tests. No PHPUnit. No `tests/` directory. No CI.
- **sd-billing**: zero project tests. No PHPUnit installed. A detailed
  rollout plan exists at `doc/TESTING_PLAN.md` but Phase 0 has not started.
  No CI.
- **sd-cs**: zero project tests. No PHPUnit. No CI.

In other words: every change in every project is verified by hand against
staging or against a tenant copy. There is no automated test gate anywhere.

## sd-main

### What exists

- `composer.json` declares one runtime dep (`minishlink/web-push`). No
  `require-dev`, no `phpunit`.
- No `phpunit.xml` and no `tests/` directory.
- `framework/test/` contains Yii 1.1's built-in `CTestCase`,
  `CDbTestCase`, `CWebTestCase`, `CDbFixtureManager` — unused.
- `protected/extensions/image2/test/ImageResizeTest.php` and
  `ImageResizeExceptionTest.php` exist but are vendored from the upstream
  `Gumlet\ImageResize` library and are not run by anything in this repo.
- `protected/vendor/vendor` is a symlink pointing at
  `/var/www/novus/.../protected/vendor` — broken on every machine that
  isn't the production host. The old wiki snippet
  `./protected/vendor/bin/phpunit` does not work locally for this reason.

### How to run

There is nothing to run.

### Coverage gaps

Everything. No service-layer tests, no controller tests, no model tests,
no smoke tests against api3 / api4.

## sd-billing

### What exists

- `composer.lock` exists at the repo root with **no `composer.json`** next
  to it (see security-landmines item #7). A fresh clone has no vendored
  PHPUnit; the binary on the production host is not reproducible.
- No `phpunit.xml`, no `tests/` directory.
- `framework/test/` ships Yii 1.1's `CTestCase` / `CDbTestCase` /
  `CDbFixtureManager` — unused.
- Service classes that *would* be mockable already exist:
  `protected/components/TariffService.php`, `SystemLogService.php`,
  `SystemService.php`, `PartnerAccessService.php`.
- `doc/TESTING_PLAN.md` is the canonical plan for getting tests in. It
  defines a two-tier pyramid (unit + integration), a `billing_test`
  database, fixtures via `CDbFixtureManager`, and characterization tests
  for the money paths (Click webhook flow, payment triggers, settlement
  command). None of it is implemented yet.

### How to run

There is nothing to run.

### Coverage gaps

Everything, with the highest-risk untested paths being:

- `Diler::getBalans()` and `Diler::getTranBalans()`.
- The `Payment` insert/update DB triggers
  (`m221114_070346_create_triggers_to_payment.php`).
- Click / Payme / Paynet / P2P / MBANK webhook flows.
- The `settlement` console command.

See `sd-billing/doc/TESTING_PLAN.md` Phase 4 for the planned
characterization order.

## sd-cs

### What exists

- `composer.json` declares `phpoffice/phpspreadsheet` and `yiisoft/yii`.
  No `require-dev`, no `phpunit`.
- No `phpunit.xml` and no `tests/` directory.
- No fixtures.

### How to run

There is nothing to run.

### Coverage gaps

Everything. The HQ reporting paths and Excel export code have no
regression coverage of any kind.

## CI

None of the three projects has CI. There are no `.github/workflows/`,
`.gitlab-ci.yml`, Bitbucket pipelines, or `Makefile`-based test targets.
The only `Makefile` files in any tree belong to vendored frontend
libraries (`vendors/bootstrap-datetimepicker`, `vendors/flot-chart`).

## Conventions when writing new tests

There is no in-tree convention to follow yet. If you are starting tests
in **sd-billing**, follow `doc/TESTING_PLAN.md` exactly — it specifies
the directory layout (`tests/unit/`, `tests/integration/`,
`tests/fixtures/`, `tests/support/`), the bootstrap files, the
`phpunit.xml.dist` shape, the `composer test*` script names, the AAA
pattern, and the
`test<MethodName><ExpectedBehavior>When<Condition>` naming rule.

For **sd-main** and **sd-cs** there is no equivalent plan — propose a
matching layout in a design doc before adding tests.

Until a project's bootstrap lands, do not add stray `*Test.php` files
under `protected/`: there is no runner to pick them up and they will
silently rot.

## See also

- `sd-billing/doc/TESTING_PLAN.md` — the only concrete plan-of-record.
- [`sd-billing/security-landmines.md`](../sd-billing/security-landmines.md)
  items #7 (missing `composer.json`) and #10 (test coverage being built
  up).
- [`quality/contribution.md`](./contribution.md) for the wider PR flow.
