# Framework Upgrade Protocol

**Purpose:** Migrate project from old Framework version (v1.x or v2.0) to current version (v2.2).

**When to use:** Project already has `.claude/` directory with older Framework structure.

---

## Step 0: Initialize Migration Log

Before starting, create migration log for crash recovery:

```bash
# Get old version from migration context
OLD_VERSION=$(cat .claude/migration-context.json 2>/dev/null | grep -o '"old_version"[^,]*' | cut -d'"' -f4)

echo '{
  "status": "in_progress",
  "mode": "upgrade",
  "old_version": "'$OLD_VERSION'",
  "started": "'$(date -Iseconds)'",
  "updated": "'$(date -Iseconds)'",
  "current_step": 1,
  "current_step_name": "detect",
  "steps_completed": [],
  "last_error": null
}' > .claude/migration-log.json
```

**Update log after each step** (same as migrate-legacy).

---

## Core Principles

1. 💾 **Preserve ALL existing data** - never lose user's work
2. 🔄 **Incremental migration** - step by step with verification
3. 📋 **Show migration plan** before executing
4. 🎓 **Explain changes** in simple terms
5. ✅ **Backup first** - create safety backup before changes

---

## Step 1: Detect Old Framework Version

### 1.1 Check Framework Markers

```bash
# Check for v2.x markers
if [ -f ".claude/SNAPSHOT.md" ]; then
  grep "Framework:" .claude/SNAPSHOT.md | awk '{print $2}'
fi

# Check for v1.x markers (old structure)
if [ -f "Init/PROJECT_SNAPSHOT.md" ]; then
  echo "v1.x (legacy structure)"
fi

# Check BACKLOG structure
if [ -f ".claude/BACKLOG.md" ]; then
  # v2.0 if no ROADMAP.md
  if [ ! -f ".claude/ROADMAP.md" ]; then
    echo "v2.0 (missing ROADMAP/IDEAS)"
  fi
fi
```

### 1.2 Report Detected Version

Show user what was detected:

````
🔍 Framework Version Detection

Found: Framework v[VERSION]

Structure detected:
[v1.x]
  ✅ Init/PROJECT_SNAPSHOT.md
  ✅ Init/BACKLOG.md
  ✅ Init/ARCHITECTURE.md
  ❌ .claude/ (missing)

[v2.0]
  ✅ .claude/SNAPSHOT.md
  ✅ .claude/BACKLOG.md
  ✅ .claude/ARCHITECTURE.md
  ❌ ROADMAP.md (missing)
  ❌ IDEAS.md (missing)

[v2.1+] TARGET
  ✅ .claude/SNAPSHOT.md
  ✅ .claude/BACKLOG.md
  ✅ .claude/ROADMAP.md (new)
  ✅ .claude/IDEAS.md (new)
  ✅ .claude/ARCHITECTURE.md

Migration required: [VERSION] → v2.1
````

---

## Step 2: Read Existing Files

Read all existing Framework files to preserve data.

### 2.1 For v1.x Projects

```bash
# Old structure
cat Init/PROJECT_SNAPSHOT.md
cat Init/BACKLOG.md
cat Init/ARCHITECTURE.md
cat Init/CHANGELOG.md 2>/dev/null
cat Init/docs/MIGRATION_GUIDE.md 2>/dev/null

# Check for migration/ folder
ls -la migration/ 2>/dev/null
```

### 2.2 For v2.0 Projects

```bash
# Current structure
cat .claude/SNAPSHOT.md
cat .claude/BACKLOG.md
cat .claude/ARCHITECTURE.md

# Check what's missing
[ -f ".claude/ROADMAP.md" ] || echo "ROADMAP.md missing"
[ -f ".claude/IDEAS.md" ] || echo "IDEAS.md missing"
```

### 2.3 Extract Key Information

From read files, extract:
- **Current version** (from SNAPSHOT)
- **Active tasks** (from BACKLOG)
- **Project structure** (from ARCHITECTURE)
- **Development phase** (from SNAPSHOT)
- **Recent achievements** (from SNAPSHOT)

---

## Step 3: Create Migration Plan

Based on detected version, create detailed migration plan.

### Migration: v1.x → v2.1

````markdown
# 📋 Migration Plan: v1.x → v2.1

## Overview
Upgrade from legacy Init/ structure to modern .claude/ structure.

## Changes Required:

### 1. File Relocations
```
Init/PROJECT_SNAPSHOT.md  →  .claude/SNAPSHOT.md
Init/BACKLOG.md           →  .claude/BACKLOG.md
Init/ARCHITECTURE.md      →  .claude/ARCHITECTURE.md
Init/                     →  [archived]
```

### 2. New Files to Create
```
.claude/ROADMAP.md   (NEW) - Strategic planning
.claude/IDEAS.md     (NEW) - Spontaneous ideas
```

### 3. BACKLOG.md Restructure
**Current format:**
```markdown
## Tasks
- [ ] Task 1
- [ ] Task 2
```

**New format (3-level):**
```markdown
## Phase X: [Current Sprint]
- [ ] Task 1
  - [ ] Subtask

Priority 1 moved to → ROADMAP.md
Ideas moved to → IDEAS.md
```

### 4. SNAPSHOT.md Updates
**Add new sections:**
- Link to ROADMAP.md
- Link to IDEAS.md
- Framework version marker

### 5. migration/ Folder
```
Keep migration/ folder (contains templates)
Add init-project.sh if missing
```

## What Will NOT Change:
✅ All your task data preserved
✅ All your architecture notes preserved
✅ All your project information preserved
✅ Git history untouched
✅ Code untouched

## Backup Strategy:
Before making changes:
```bash
cp -r Init/ Init-backup-$(date +%Y%m%d)
cp -r .claude/ .claude-backup-$(date +%Y%m%d) 2>/dev/null
```

## Estimated Time: 2-3 minutes
## Estimated Tokens: ~5k tokens
````

### Migration: v2.0 → v2.1

````markdown
# 📋 Migration Plan: v2.0 → v2.1

## Overview
Add new 3-level planning structure (IDEAS → ROADMAP → BACKLOG).

## Changes Required:

### 1. Extract from Current BACKLOG

Analyze current `.claude/BACKLOG.md`:
- **Concrete tasks** → stay in BACKLOG.md
- **Priority 1 ideas** → move to ROADMAP.md
- **Unstructured ideas** → move to IDEAS.md

### 2. Create New Files
```
.claude/ROADMAP.md (NEW)
  - Extract from BACKLOG Priority 1
  - Extract from README roadmap section if exists
  - Organize by versions (v2.2, v2.3, v3.0)

.claude/IDEAS.md (NEW)
  - Create empty template
  - Optionally extract "good to have" from BACKLOG
```

### 3. Restructure BACKLOG.md

**Current:**
```markdown
## Phase X
- tasks

## Priority 1
- ideas
```

**New:**
```markdown
## Phase X
- only concrete tasks

[Priority 1 moved to ROADMAP.md]
```

### 4. Update SNAPSHOT.md

Add references:
```markdown
> **Planning:**
> - Current tasks: [BACKLOG.md](./BACKLOG.md)
> - Strategic plan: [ROADMAP.md](./ROADMAP.md)
> - Ideas: [IDEAS.md](./IDEAS.md)
```

### 5. Update README.md

Replace full roadmap with link:
```markdown
## Roadmap
See [.claude/ROADMAP.md](.claude/ROADMAP.md)
```

## What Will NOT Change:
✅ All your tasks preserved
✅ All your ideas preserved (just reorganized)
✅ SNAPSHOT content intact
✅ ARCHITECTURE content intact

## Backup Strategy:
```bash
cp .claude/BACKLOG.md .claude/BACKLOG-backup-$(date +%Y%m%d).md
```

## Estimated Time: 1-2 minutes
## Estimated Tokens: ~3k tokens
````

Show migration plan to user and ask:

```
✅ Migration plan ready

This upgrade will:
1. [List key changes]
2. [List key changes]
3. [List key changes]

All existing data will be preserved.
Backup will be created before changes.

Proceed with migration? (y/N)
```

---

## Step 4: Execute Migration

Use TodoWrite to track migration progress.

### For v1.x → v2.2:

```markdown
Create todos:
- [ ] Create .claude/ directory structure
- [ ] Migrate SNAPSHOT.md (Init/ → .claude/)
- [ ] Migrate BACKLOG.md with restructuring
- [ ] Migrate ARCHITECTURE.md
- [ ] Create ROADMAP.md (extract from BACKLOG)
- [ ] Create IDEAS.md (empty template)
- [ ] Update CLAUDE.md (if needed)
- [ ] Verify migration completed
- [ ] Archive Init/ folder to .archive/
```

### For v2.0 → v2.2:

```markdown
Create todos:
- [ ] Create backup of BACKLOG.md
- [ ] Analyze current BACKLOG structure
- [ ] Extract Priority 1 items for ROADMAP
- [ ] Create ROADMAP.md
- [ ] Create IDEAS.md
- [ ] Restructure BACKLOG.md (remove Priority 1)
- [ ] Update SNAPSHOT.md (add links)
- [ ] Update README.md (roadmap → link)
- [ ] Verify migration completed
```

---

## Step 5: Migration Execution Details

> **Token Economy Principle:**
> Some files are read EVERY Cold Start session — keep them compact!
> Historical/strategic content goes to on-demand files or CHANGELOG.md.

| File | Read When | Target Size |
|------|-----------|-------------|
| `SNAPSHOT.md` | ALWAYS (Cold Start) | ~30-50 lines |
| `BACKLOG.md` | ALWAYS (Cold Start) | ~50-100 lines |
| `ARCHITECTURE.md` | ALWAYS (Cold Start) | ~100-200 lines |
| `ROADMAP.md` | On demand | ~50-150 lines |
| `IDEAS.md` | On demand | ~30-50 lines |
| `CHANGELOG.md` | On demand | No limit |

### 5.1 Create Backup

```bash
# For v2.0 only (backup BACKLOG before restructuring)
cp .claude/BACKLOG.md ".claude/BACKLOG-backup-$(date +%Y%m%d-%H%M%S).md"

# Note: For v1.x, Init/ will be archived in Step 5.7 (not copied + archived)
```

### 5.2 Migrate SNAPSHOT.md (v1.x only)

```bash
# Read old file
OLD_CONTENT=$(cat Init/PROJECT_SNAPSHOT.md)

# Add Framework version marker
NEW_CONTENT="# SNAPSHOT — [Project Name]

*Framework: Claude Code Starter v2.1*
*Last Updated: $(date +%Y-%m-%d)*

$OLD_CONTENT
"

# Write to new location
echo "$NEW_CONTENT" > .claude/SNAPSHOT.md
```

### 5.3 Extract and Create ROADMAP.md

**For v1.x:** Analyze BACKLOG.md, extract future plans

**For v2.0:** Extract Priority 1 section from BACKLOG.md

Use Read tool to read current BACKLOG, then use pattern matching:

```markdown
Find sections like:
- ## Priority 1
- ## Future
- ## v3.0
- ## Ideas

Extract these → ROADMAP.md
Organize by versions (v2.2, v2.3, v3.0)
```

### 5.4 Create IDEAS.md

Use Write tool to create empty template:

```markdown
# IDEAS — [Project Name]

*Last Updated: $(date +%Y-%m-%d)*

> 💡 Spontaneous ideas and thoughts
>
> **Workflow:** IDEAS.md → ROADMAP.md → BACKLOG.md

## 💭 Unstructured Ideas

- ...

## 🤔 Ideas on Review

- ...

## ❌ Rejected Ideas

- ...
```

### 5.5 Restructure BACKLOG.md

**Philosophy:** BACKLOG.md should be lean (~50-100 lines max), containing ONLY current sprint tasks.

**Content to MOVE OUT of BACKLOG.md:**

| Content Type | Move To |
|--------------|---------|
| Planned Features / Priority 1 | → `ROADMAP.md` |
| Future versions (v2.x, v3.0) | → `ROADMAP.md` |
| Resolved Issues (detailed) | → DELETE or `.archive/` |
| Release History / Recent Updates | → `CHANGELOG.md` or DELETE |
| Technical Debt (future) | → `ROADMAP.md` |

**Keep in BACKLOG.md:**
- Current sprint header
- Active tasks `[ ]` and `[x]`
- Bugs to fix NOW
- Link to ROADMAP.md for future work

**Restructuring Steps:**

1. Read current BACKLOG.md
2. Identify sections:
   - Current sprint tasks (KEEP)
   - Planned features (→ ROADMAP)
   - Resolved issues (→ DELETE/ARCHIVE)
   - Release history (→ DELETE if in CHANGELOG)
3. Extract strategic content → ROADMAP.md
4. Remove resolved/historical content
5. Update header with links to ROADMAP/IDEAS
6. Verify final size < 100 lines (ideally)

**Example clean BACKLOG.md structure:**

```markdown
# BACKLOG — [Project Name]

*Current Sprint: [date]*

> 📋 Active tasks only. Strategic planning → [ROADMAP.md](./ROADMAP.md)

## Current Sprint

- [ ] Task 1
- [ ] Task 2
- [x] Completed task

## Bugs

- [ ] Bug to fix

## Next Up

- [ ] Ready for next sprint
```

### 5.6 Update SNAPSHOT.md

Add planning references:

```markdown
> **Planning Documents:**
> - 🎯 Current tasks: [BACKLOG.md](./BACKLOG.md)
> - 🗺️ Strategic roadmap: [ROADMAP.md](./ROADMAP.md)
> - 💡 Ideas: [IDEAS.md](./IDEAS.md)
> - 📊 Architecture: [ARCHITECTURE.md](./ARCHITECTURE.md)
```

### 5.7 Archive Old Structure (v1.x only)

```bash
# Move Init/ to archive
mkdir -p .archive
mv Init/ .archive/Init-v1-archived-$(date +%Y%m%d)/

echo "Old Init/ folder archived to .archive/"
echo "You can safely delete .archive/ later if migration successful"
```

---

## Step 6: Verification

Verify migration completed successfully:

```bash
# Check all new files exist
echo "Checking new structure..."

[ -f ".claude/SNAPSHOT.md" ] && echo "✅ SNAPSHOT.md" || echo "❌ SNAPSHOT.md MISSING"
[ -f ".claude/BACKLOG.md" ] && echo "✅ BACKLOG.md" || echo "❌ BACKLOG.md MISSING"
[ -f ".claude/ROADMAP.md" ] && echo "✅ ROADMAP.md" || echo "❌ ROADMAP.md MISSING"
[ -f ".claude/IDEAS.md" ] && echo "✅ IDEAS.md" || echo "❌ IDEAS.md MISSING"
[ -f ".claude/ARCHITECTURE.md" ] && echo "✅ ARCHITECTURE.md" || echo "❌ ARCHITECTURE.md MISSING"

# Check file sizes (should not be empty)
echo ""
echo "File sizes:"
ls -lh .claude/*.md

# Show first few lines of each
echo ""
echo "Quick preview:"
head -3 .claude/SNAPSHOT.md
head -3 .claude/BACKLOG.md
head -3 .claude/ROADMAP.md
```

---

## Step 6.5: Install Remaining Framework Files

After migration, install remaining Framework files:

```bash
# Extract staged framework files
if [ -f ".claude/framework-pending.tar.gz" ]; then
    tar -xzf .claude/framework-pending.tar.gz -C /tmp/

    # Copy ALL new commands (use -n to not overwrite existing)
    cp -n /tmp/framework/.claude/commands/*.md .claude/commands/ 2>/dev/null || true

    # Copy dist (CLI tools)
    cp -r /tmp/framework/.claude/dist .claude/ 2>/dev/null || true

    # Copy templates
    cp -r /tmp/framework/.claude/templates .claude/ 2>/dev/null || true

    # Copy FRAMEWORK_GUIDE.md
    cp /tmp/framework/FRAMEWORK_GUIDE.md . 2>/dev/null || true

    # Install npm dependencies for CLI tools
    if [ -f ".claude/dist/claude-export/package.json" ]; then
        echo "📦 Installing framework dependencies..."
        if command -v npm &> /dev/null; then
            (cd .claude/dist/claude-export && npm install --silent 2>&1 | grep -v "^npm WARN" || true) && \
                echo "✅ Framework dependencies installed" || \
                echo "⚠️  Failed to install dependencies (run manually: cd .claude/dist/claude-export && npm install)"
        else
            echo "⚠️  npm not found - install it, then run: cd .claude/dist/claude-export && npm install"
        fi
    fi

    # Cleanup temp
    rm .claude/framework-pending.tar.gz
    rm -rf /tmp/framework

    echo "✅ Installed remaining Framework files"
fi
```

### 6.5.1 Remove Old v1.x Migration Commands

Old migration commands from v1.x are not compatible with v2.2:

```bash
# Remove obsolete v1.x migration commands
rm .claude/commands/migrate.md 2>/dev/null
rm .claude/commands/migrate-finalize.md 2>/dev/null
rm .claude/commands/migrate-resolve.md 2>/dev/null
rm .claude/commands/migrate-rollback.md 2>/dev/null
echo "✅ Removed obsolete v1.x migration commands"
```

### 6.5.2 Verify New Commands Installed

```bash
# Check essential new commands exist
ls -la .claude/commands/fi.md
ls -la .claude/commands/ui.md
ls -la .claude/commands/watch.md
```

---

## Step 7: Migration Summary

Show simple completion message:

````
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Migration complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 Framework Upgrade:

  From: Framework v[OLD_VERSION]
  To:   Framework v2.1.1

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁 Files Updated:

  ✅ .claude/SNAPSHOT.md (updated)
  ✅ .claude/BACKLOG.md (restructured)
  ✅ .claude/ARCHITECTURE.md (preserved)
  ✨ .claude/ROADMAP.md (created)
  ✨ .claude/IDEAS.md (created)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💾 Backups:

  ✅ Backup created: [path]
  ✅ All your data preserved

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
````

---

## Step 8: Finalize Migration

### 8.1 Save Migration Artifacts

Get project name and save migration artifacts with unique names:

```bash
PROJECT_NAME=$(basename "$(pwd)")

# Create reports directory
mkdir -p reports

# Save migration log with project name
cp .claude/migration-log.json "reports/${PROJECT_NAME}-migration-log.json"
echo "✅ Migration log saved: reports/${PROJECT_NAME}-migration-log.json"
```

**CRITICAL: Generate Migration Report NOW**

Before proceeding to cleanup, you MUST create the migration report:

1. Read `.claude/migration-log.json` to get migration details
2. Create `reports/${PROJECT_NAME}-MIGRATION_REPORT.md` with:
   - **Summary:** Migration type, versions, status, duration
   - **Files Migrated/Created:** List all files with sizes
   - **Changes Made:** Key restructuring, optimizations
   - **Verification Results:** All checks passed
   - **Errors/Warnings:** Any issues encountered (or "None")
   - **Post-Migration Actions:** What user needs to do next
   - **Rollback Procedure:** If needed
   - **Success Criteria:** Checklist of what was accomplished

3. **Verify report created:**
   ```bash
   ls -lh "reports/${PROJECT_NAME}-MIGRATION_REPORT.md"
   ```

4. **ONLY AFTER** confirming report exists, proceed to Step 8.2

**DO NOT proceed to cleanup until migration report is created and verified!**

### 8.2 Swap CLAUDE.md to Production

```bash
# Swap migration CLAUDE.md with production version
if [ -f ".claude/CLAUDE.production.md" ]; then
    cp .claude/CLAUDE.production.md CLAUDE.md
    rm .claude/CLAUDE.production.md
    echo "✅ Swapped CLAUDE.md to production mode"
fi
```

### 8.3 Remove Migration Commands

Migration commands are not needed in host projects after migration:

```bash
rm .claude/commands/migrate-legacy.md 2>/dev/null
rm .claude/commands/upgrade-framework.md 2>/dev/null
echo "✅ Removed migration commands"
```

### 8.4 Cleanup Temporary Files

```bash
rm .claude/migration-log.json 2>/dev/null
rm .claude/migration-context.json 2>/dev/null
rm .claude/framework-pending.tar.gz 2>/dev/null
echo "✅ Migration cleanup complete"
```

### 8.5 Commit Migration Changes

Commit all migration changes so next Cold Start is clean:

```bash
git add -A
git commit -m "$(cat <<'EOF'
chore: Upgrade to Claude Code Starter Framework v2.2

- Migrated metafiles to new .claude/ structure
- Added ROADMAP.md, IDEAS.md
- Updated SNAPSHOT.md, BACKLOG.md, ARCHITECTURE.md
- Installed Framework commands and CLI tools
- Archived old Init/ folder to .archive/

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
echo "✅ Migration changes committed"
```

### 8.6 Show Final Message

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎉 Upgrade Complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Framework is now in production mode (v2.2).

📁 Migration artifacts saved:
  • reports/[PROJECT]-migration-log.json
  • reports/[PROJECT]-MIGRATION_REPORT.md

⚠️ IMPORTANT: Restart terminal for new commands!

  New slash commands (/fi, /ui, /watch) won't work
  until you restart the terminal or Claude session.

🚀 Next Steps:

  1. Exit terminal (Ctrl+C or type "exit")
  2. Start new Claude session: claude
  3. Type "start" to begin working

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Error Handling

### If backup fails:

```
❌ Error: Could not create backup

This is unusual. Possible causes:
- Disk full
- Permission issues

Cannot proceed without backup for safety.

Please check:
1. Disk space: df -h
2. Permissions: ls -la Init/

Then try again.
```

### If file migration fails:

```
⚠️ Warning: Migration partially complete

Completed:
✅ Backup created
✅ SNAPSHOT.md migrated
❌ BACKLOG.md migration failed

Error: [error message]

Options:
1. Retry migration from this point
2. Restore from backup and cancel
3. Fix manually (I'll guide you)

Your choice?
```

### If verification fails:

```
⚠️ Warning: Verification found issues

Missing files:
❌ .claude/ROADMAP.md (failed to create)

Present files:
✅ .claude/SNAPSHOT.md
✅ .claude/BACKLOG.md

Backup is safe at: [path]

Options:
1. Retry creating missing files
2. Restore from backup
3. Continue anyway (files can be created manually later)

Your choice?
```

---

## Rollback Procedure

If user wants to rollback migration:

```bash
# For v1.x → v2.1 rollback
echo "Rolling back migration..."

# Restore from backup
rm -rf .claude/
cp -r Init-backup-[timestamp]/ Init/

echo "✅ Rollback complete"
echo "Restored to: Framework v1.x"

# For v2.0 → v2.1 rollback
rm .claude/ROADMAP.md .claude/IDEAS.md
cp .claude/BACKLOG-backup-[timestamp].md .claude/BACKLOG.md

echo "✅ Rollback complete"
echo "Restored to: Framework v2.0"
```

---

## Important Notes

- **Always create backup before changes**
- **Preserve all existing data - never lose work**
- **Show migration plan before executing**
- **Verify each step completes successfully**
- **Provide clear rollback option if needed**
- **Track progress with TodoWrite**
- **Report token usage**

---

*This protocol ensures safe, reversible Framework upgrades while preserving all user work.*
