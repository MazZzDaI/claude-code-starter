# v4 Archive Note

This repository has been moved to `Claude Code Starter v5`, but the `v4` working tree has been preserved inside the repository for a full rollback and manual comparison.

What has been preserved:
- `archive/v4-working-tree/` — a copy of the live working tree before the migration to `v5`;
- `archive-v4-head-2026-04-06` — a git tag on the last `v4` commit before `v5` was moved into the repository root.

What matters:
- the archive was made from the working tree, not just from `HEAD`, so it contains local changes and new files that had not yet been committed at the time of the migration;
- heavy local artefacts such as `node_modules/`, `dist/`, `dist-release/`, `reports/` were not copied into the archive;
- for an exact rollback to the original tracked state, use the git tag; for manual restoration of the tree and comparison, use `archive/v4-working-tree/`.
