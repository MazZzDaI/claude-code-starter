---
name: db-migrate
description: "Database schema migration: SQLite → PostgreSQL/Supabase. SQL generation, compatibility checks."
paths:
  - "**/schema*"
  - "**/migrations/**"
  - "**/db/**"
  - "**/*.sql"
allowed-tools: Read Edit Write Glob Grep Bash
disable-model-invocation: true
---

# Skill: Database Migration

## Workflow: SQLite → PostgreSQL/Supabase

### 1. Analyse the current schema

```bash
# Extract the schema from SQLite
sqlite3 database.db ".schema" > schema-sqlite.sql
```

### 2. Type conversion

| SQLite | PostgreSQL |
|--------|-----------|
| INTEGER | INTEGER / BIGINT |
| TEXT | TEXT / VARCHAR |
| REAL | DOUBLE PRECISION |
| BLOB | BYTEA |
| DATETIME (text) | TIMESTAMPTZ |
| BOOLEAN (0/1) | BOOLEAN |
| AUTOINCREMENT | SERIAL / GENERATED ALWAYS AS IDENTITY |

### 3. Generate the PostgreSQL schema

- Convert the types
- Use TIMESTAMPTZ instead of TEXT for dates
- Replace AUTOINCREMENT with SERIAL
- Add Row Level Security (RLS) for Supabase
- Generate the migration file

### 4. Verification

- Validate the SQL syntax
- Check foreign keys
- Check indexes
- Check constraints

### 5. Deploy

**Staging (autonomously):**
```bash
# Apply on staging
psql $STAGING_DATABASE_URL -f migration.sql
```

**Production (with confirmation):**
- Show the user the migration plan
- Wait for confirmation
- Apply
- Check the result

## Supabase specifics

- Automatically add RLS policies
- Use the Supabase CLI if available:
  ```bash
  supabase db push
  ```
- Generate TypeScript types:
  ```bash
  supabase gen types typescript --local > src/types/database.ts
  ```
