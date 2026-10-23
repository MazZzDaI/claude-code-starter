---
title: Invariants
type: invariants
updated: YYYY-MM-DD
---

# Invariants

## Why this file exists

This is where the **hard rules of the product** live, the ones that must not be broken. Not style,
not preference, not "the way we usually do it". Violating an invariant = a bug, not
a matter of taste.

How it differs from `.claude/rules/`:
- `rules/` — how the **agent** works (when to commit, how to delegate).
- `INVARIANTS.md` — what must not happen to the **product** (data,
  security, contracts, state invariants).

If an invariant gets in the way of a task, that is no reason to break it. It is a reason
to open a discussion and either relax the wording or change the task.
Before changing an invariant, record in `History` what prompted it.

**Categories (hint):** `data` · `security` · `api` · `performance` ·
`concurrency` · `migration` · `compatibility` · `licensing` · `pii`

---

### INV-001: Do not use `DROP TABLE` in migrations

**Category:** data / migration
**Rule:** Schema migrations are performed only via `ALTER`, `ADD`,
`RENAME`, `CREATE` or additional tables. `DROP TABLE`, `TRUNCATE`,
`DELETE FROM` without `WHERE` are forbidden in migration code.
**Why:** Data loss is unacceptable. History has already seen cases where
a single "safe clean-up" in a migration destroyed production data
irreversibly. It cannot be rolled back — a backup restores only what
existed before the migration.
**How to check:**
- review every migration by hand;
- lint: `grep -rE 'DROP TABLE|TRUNCATE|DELETE FROM [^W]' migrations/`
  must be empty;
- an integration test runs the migration on a copy of production data and
  checks row counts before/after.
**History:** <!-- link to the incident report, if there was one; otherwise leave empty -->

<!--
Add new invariants below. Template:

### INV-NNN: <short name>

**Category:** ...
**Rule:** <one sentence, in the affirmative>
**Why:** <the real risk it protects against>
**How to check:** <test / lint / review checklist / manual check>
**History:** <the incident that led to it, if there was one>

Rules for a good invariant:
- One rule = one item. Do not combine unrelated prohibitions.
- The wording is verifiable: either by machine or in a review checklist.
- If you cannot explain the "why", it is most likely not an invariant
  but a stylistic preference, and it does not belong here.
-->
