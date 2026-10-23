---
paths:
  - "**/db/**"
  - "**/database/**"
  - "**/schema/**"
  - "**/migrations/**"
  - "**/models/**"
  - "**/supabase/**"
---

# Rule: Local-First Development

## Principle

Development of data-backed applications always starts locally on SQLite. Migration to the cloud (Supabase, PostgreSQL) happens only after the schema has stabilised.

## Workflow

### Phase 1: Local development (SQLite)

1. Create the schema in SQLite
2. Write migrations
3. Implement CRUD and business logic
4. Test everything locally
5. Stabilise: the schema doesn't change for several iterations

### Phase 2: Migration to the cloud

Only after stabilisation:
1. Convert the schema to SQL compatible with the target DB (PostgreSQL/Supabase)
2. Create migration scripts
3. Deploy to staging
4. Test on staging
5. Production deploy (with confirmation)

## Why this way

- SQLite: instant iteration, no network latency, no external dependencies
- Changing the schema locally takes seconds; in the cloud, minutes plus a risk of data loss
- A schema mistake locally — redo it with no consequences
- A schema mistake in the cloud — migration, rollback, potential data loss

## Exceptions

If the project **already** works with a cloud DB:
- Don't move it to SQLite for the sake of the workflow
- Work with a staging copy of the database
- Apply the staging → production rule

## Skill for migration

Use `/db-migrate` for automatic SQLite → cloud migration.
