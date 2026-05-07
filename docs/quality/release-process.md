---
sidebar_position: 4
title: Release process
---

# Release process

## Cadence

- **Hotfix**: any time, fast-track.
- **Minor**: weekly on Wednesday.
- **Major**: quarterly with notice + tenant-by-tenant rollout.

## Versioning

`v<major>.<minor>.<patch>`. Tag in git. The `VERSION` constant in PHP
reflects the active build.

## Steps

1. Branch `release/<version>` from `main`.
2. Update `VERSION` and `docs/changelog.md`.
3. Tag and push.
4. CI builds the image with the tag.
5. Deploy to **staging** via the release train pipeline.
6. QA + UAT on staging.
7. Promote to **production** with a stage rollout (canary tenant first).
8. Watch metrics for 24 h. If clean, mark closed.

## Communication

- Internal: post to `#release` Slack with the changelog.
- External: customer-facing changelog page.
- Multi-language release notes (EN / RU / UZ) — see the `pm-workflow`
  skill for the template.
