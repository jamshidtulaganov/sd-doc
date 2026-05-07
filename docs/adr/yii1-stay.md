---
sidebar_position: 2
title: ADR-0001 — Stay on Yii 1.x
---

# ADR 0001 — Stay on Yii 1.x for now

- Status: **Accepted**
- Date: 2024-09-12
- Deciders: Engineering leads

## Context

The application is a 12+ year-old Yii 1.x codebase with heavy use of
`CActiveRecord`, magic getters, and a number of vendored extensions. PHP
7.3 is end-of-life. Yii 1.x is officially out of support but a community
fork (`yii1/yii1-php8`) ships PHP 8 fixes.

We considered:

1. **Stay on Yii 1.x + PHP 7.3** (status quo).
2. **Yii 1.x + PHP 8.2** via the community fork.
3. **Migrate to Yii 2 / Yii 3.**
4. **Migrate to Laravel.**
5. **Strangler fig: rewrite slice by slice into a new framework.**

## Decision

Stay on **Yii 1.x** for the foreseeable future. Schedule a PHP 8.2
upgrade behind a flag once the community fork passes our test matrix.

## Consequences

- ✅ Zero rewrite cost in the short term.
- ✅ Existing skills on the team transfer 1:1.
- ❌ We must continue running EOL PHP until the fork upgrade lands.
- ❌ We can't easily attract new hires who expect Yii 2 / Laravel.
- ❌ Some modern features (typed properties, attributes) unavailable.

## Mitigations

- WAF in front of the app.
- Aggressive container patching cycle.
- New features should sit on the strangler boundary so we can revisit
  framework choice for the next major.
