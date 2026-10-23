---
description: Create a database migration with the proper process
---

Create a database migration following best practices.

**IMPORTANT: Migrations are a critical part. Test everything thoroughly!**

## Process:

### 1. Analyse the current database schema

Read and analyse:
```bash
# Find the database schema files
find . -name "schema.*" -o -name "*.prisma" -o -name "*migration*"

# Look at the latest migrations
ls -la supabase/migrations/ || ls -la prisma/migrations/ || ls -la migrations/
```

Read:
- The current database schema
- The latest migrations
- Database documentation (if present in ARCHITECTURE.md)

### 2. Understand the requirements

Ask yourself:
- What schema changes are needed?
- Is there existing data that must be preserved?
- Is backward compatibility needed?
- Are there dependencies on other tables?

### 3. Plan the migration

**Types of changes:**

**Safe (can be done in production):**
- ✅ ADD column (with DEFAULT or NULL)
- ✅ ADD index (concurrent)
- ✅ ADD new table
- ✅ ADD constraint (NOT VALID, then VALIDATE)

**Dangerous (require caution):**
- ⚠️ DROP column (may break the application)
- ⚠️ RENAME column (requires a two-phase migration)
- ⚠️ CHANGE column type (may lose data)
- ⚠️ ADD NOT NULL (populate the data first)

**Very dangerous (only with downtime):**
- 🔴 DROP table
- 🔴 CHANGE primary key
- 🔴 Major structural rework

### 4. Create the migration file

**Naming convention:**
```
YYYYMMDDHHMMSS_descriptive_name.sql
```

Example: `20250110120000_add_user_preferences_table.sql`

**Migration structure:**

```sql
-- Migration: Add user preferences table
-- Created: 2025-01-10
-- Author: Claude Code
-- Description: Add table to store user preferences with foreign key to users

-- ============================================
-- Up Migration
-- ============================================

BEGIN;

-- Create table
CREATE TABLE IF NOT EXISTS user_preferences (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  theme VARCHAR(20) DEFAULT 'light' CHECK (theme IN ('light', 'dark', 'auto')),
  language VARCHAR(10) DEFAULT 'en',
  notifications_enabled BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- Constraints
  CONSTRAINT unique_user_preferences UNIQUE(user_id)
);

-- Create indexes
CREATE INDEX idx_user_preferences_user_id ON user_preferences(user_id);

-- Add comments
COMMENT ON TABLE user_preferences IS 'Stores user-specific preferences';
COMMENT ON COLUMN user_preferences.theme IS 'UI theme preference';

-- Enable Row Level Security
ALTER TABLE user_preferences ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
CREATE POLICY "Users can view own preferences"
  ON user_preferences
  FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update own preferences"
  ON user_preferences
  FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own preferences"
  ON user_preferences
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

COMMIT;

-- ============================================
-- Down Migration (Rollback)
-- ============================================

-- Uncomment to enable rollback:
-- BEGIN;
-- DROP TABLE IF EXISTS user_preferences CASCADE;
-- COMMIT;
```

### 5. Create TypeScript types (if TypeScript is used)

**File: `src/types/database.ts` or update the existing one:**

```typescript
// Database Types
export interface UserPreferences {
  id: string;
  user_id: string;
  theme: 'light' | 'dark' | 'auto';
  language: string;
  notifications_enabled: boolean;
  created_at: string;
  updated_at: string;
}

// Database Tables
export interface Database {
  public: {
    Tables: {
      user_preferences: {
        Row: UserPreferences;
        Insert: Omit<UserPreferences, 'id' | 'created_at' | 'updated_at'>;
        Update: Partial<Omit<UserPreferences, 'id' | 'created_at'>>;
      };
      // ... other tables
    };
  };
}
```

### 6. Testing the migration

**In Development:**
```bash
# Apply the migration
make db-migrate
# or
npm run db:migrate
# or
supabase db push

# Check that the table has been created
# (the command depends on your database)

# Test operations
# - INSERT test data
# - SELECT check reading
# - UPDATE check updating
# - DELETE check deletion
# - Check RLS policies
```

**Rollback test:**
```bash
# Roll back the migration
make db-rollback
# or
npm run db:rollback

# Check that the rollback works
# Apply again to continue working
make db-migrate
```

### 7. Update the documentation

**Update ARCHITECTURE.md:**
```markdown
### Database Schema

#### user_preferences
Stores user-specific UI and notification preferences.

**Columns:**
- `id` (UUID, PK) - Unique identifier
- `user_id` (UUID, FK → users.id) - Reference to user
- `theme` (VARCHAR) - UI theme: 'light', 'dark', 'auto'
- `language` (VARCHAR) - Preferred language code
- `notifications_enabled` (BOOLEAN) - Email notifications toggle
- `created_at` (TIMESTAMP) - Record creation time
- `updated_at` (TIMESTAMP) - Last update time

**Constraints:**
- One preference record per user (unique user_id)
- Cascading delete when user is deleted

**Security:**
- RLS enabled
- Users can only view/edit their own preferences
```

### 8. Update the related code

**Create/update API endpoints:**
```typescript
// Example: API route for preferences
import { Database } from '@/types/database';

export async function GET(req: Request) {
  const supabase = createClient<Database>();

  const { data, error } = await supabase
    .from('user_preferences')
    .select('*')
    .single();

  if (error) {
    return Response.json({ error: error.message }, { status: 400 });
  }

  return Response.json(data);
}
```

### 9. Create the commit

Use the `/commit` command with the following changes:
- Migration SQL file
- TypeScript types
- Updated documentation
- New/updated code using the new schema

### 10. Security Checklist for migrations

- [ ] RLS (Row Level Security) is enabled for new tables
- [ ] RLS policies are created and tested
- [ ] Foreign keys are configured correctly
- [ ] Indexes are added for performance
- [ ] Sensitive data is properly protected
- [ ] Cascading deletes are configured where needed
- [ ] Comments are added for documentation
- [ ] No hardcoded values (use constants/enums)

## 📋 Migration Checklist

### Before creating:
- [ ] Read the current database schema
- [ ] Understood the change requirements
- [ ] Planned a safe migration
- [ ] Checked dependencies on other tables

### During creation:
- [ ] Created the migration file with a proper name
- [ ] Added comments and a description
- [ ] Created a rollback (down migration)
- [ ] Updated TypeScript types
- [ ] Added indexes for performance
- [ ] Configured RLS and policies

### After creation:
- [ ] Tested in development
- [ ] Tested the rollback
- [ ] Updated ARCHITECTURE.md
- [ ] Updated the related code
- [ ] Created a commit with a description

## 🚫 Dangerous operations

**NEVER do without explicit confirmation:**
- ❌ DROP TABLE in production
- ❌ DROP COLUMN with data
- ❌ TRUNCATE TABLE
- ❌ ALTER TYPE on large tables (may lock)
- ❌ Migrations without a rollback plan

**If you need to remove a column:**
1. First remove its usage in the code
2. Deploy the code without using the column
3. Only then DROP the column in a migration

## 💡 Best Practices

1. **Atomic migrations:** Use BEGIN/COMMIT
2. **Idempotent:** Use IF EXISTS / IF NOT EXISTS
3. **Reversible:** Always create a down migration
4. **Documented:** Add SQL comments and docs
5. **Tested:** Test up and down migrations
6. **Small:** One migration = one logical change
7. **Safe defaults:** Use DEFAULT for new columns

## Examples of common scenarios:

### Add column (safe):
```sql
ALTER TABLE users
ADD COLUMN avatar_url TEXT DEFAULT NULL;
```

### Add NOT NULL column (two-phase):
```sql
-- Phase 1: Add column as nullable with default
ALTER TABLE users ADD COLUMN email_verified BOOLEAN DEFAULT false;

-- Phase 2 (after data backfill): Make NOT NULL
-- ALTER TABLE users ALTER COLUMN email_verified SET NOT NULL;
```

### Rename column (two-phase):
```sql
-- Phase 1: Add new column
ALTER TABLE users ADD COLUMN full_name TEXT;
UPDATE users SET full_name = name;

-- Phase 2 (after code update): Drop old column
-- ALTER TABLE users DROP COLUMN name;
```

**After running the migration, be sure to update BACKLOG.md!**
