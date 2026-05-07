---
sidebar_position: 1
title: Testing
---

# Testing

## What exists today

- Manual QA against staging.
- A small number of PHPUnit tests under `protected/extensions/test`
  (legacy).
- Postman collections per integration (kept by integration owners).

## What we want

- Unit tests for `*Service.php` classes (pure functions).
- Smoke tests against api3 / api4 for every release.
- E2E tests for the order lifecycle (Cypress against staging).

## Running PHPUnit

```bash
docker compose exec web ./protected/vendor/bin/phpunit \
    --testsuite Unit
```

## Conventions

- Test files mirror source paths under `tests/`.
- One assertion per test where possible.
- Use factories (or fixtures) — never hit a live tenant DB.

See the `qa-process` skill for the wider QA process.
