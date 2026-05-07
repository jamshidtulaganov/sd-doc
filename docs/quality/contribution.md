---
sidebar_position: 3
title: Contributing
---

:::warning Stub
This page is a placeholder. The content is incomplete — verify against source before relying on it. See [the audit's stub-backfill list](#) for status.
:::

# Contributing

## Workflow

1. **Pick a ticket** in the project board (Jira / Linear / GitHub).
2. **Branch**: `feat/<short>` or `fix/<short>` from `main`.
3. **Implement** — keep commits small and self-explanatory.
4. **Run tests + lint** locally.
5. **Open PR** against `main`. Fill in the PR template.
6. **Review** by at least one maintainer.
7. **Merge** after green CI + 1 approval.
8. **Deploy** via the release train.

See `claude-ai-assist`, `qa-process`, `pm-workflow` skills for AI/QA/PM
sub-flows.

## Local environment

See [Local setup](../project/local-setup.md).

## Areas needing help

- Migrating away from MD5 passwords.
- Replacing `bootstrap/` with utility CSS.
- Writing tests for `OrderService` transitions.
- Cleaning up `*.obsolete` files.
