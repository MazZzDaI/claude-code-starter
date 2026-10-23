# Cold Start Protocol

**Version:** 2.5.1
**Last updated:** 2026-01-16

**Purpose:** Initialize framework session, load context, prepare for work.

**Trigger:** User types "start" or "begin"

---

## Overview

This protocol runs at the beginning of each session to:
1. Check for crashes and recover
2. Update framework if newer version available
3. Clean credentials from exported dialogs
4. Load project context
5. Mark session as active

**IMPORTANT:** This file is read FRESH at the start of each session, immune to context compaction.

---

## Step 0: First Launch Detection

Check for migration context first:
```bash
cat .claude/migration-context.json 2>/dev/null
```

If file exists, this is first launch after installation.

**Read context and route:**
- If `"mode": "legacy"` → Execute Legacy Migration workflow
- If `"mode": "upgrade"` → Execute Framework Upgrade workflow
- If `"mode": "new"` → Execute New Project Setup workflow

After completing workflow, delete marker:
```bash
rm .claude/migration-context.json
```

If no migration context, continue to Step 0.05 (Migration Cleanup).

---

## Step 0.05: Migration Cleanup Recovery

Check for leftover migration files and clean them up:

```bash
# Check for production CLAUDE.md waiting to be swapped
if [ -f ".claude/CLAUDE.production.md" ]; then
  echo "⚠️  Found leftover migration files. Cleaning up..."

  # Swap CLAUDE.md if needed
  if grep -q "Migration Mode" CLAUDE.md 2>/dev/null; then
    cp .claude/CLAUDE.production.md CLAUDE.md
    echo "✓ Swapped CLAUDE.md to production version"
  fi

  # Remove all migration artifacts
  rm -f .claude/CLAUDE.production.md
  rm -f .claude/migration-context.json
  rm -f .claude/migration-log.json
  rm -f .claude/commands/migrate-legacy.md
  rm -f .claude/commands/upgrade-framework.md
  rm -f .claude/framework-pending.tar.gz

  echo "✓ Migration cleanup complete"
fi
```

If cleanup performed, continue to Step 0.1 (Crash Recovery).

If no cleanup needed, continue to Step 0.1 (Crash Recovery).

---

## Step 0.1: Crash Recovery & Auto-Recovery

```bash
cat .claude/.last_session
```

- If `"status": "active"` → Check if real crash or just missing `/fi`:
  ```bash
  # Check for uncommitted changes
  if git diff --quiet && git diff --staged --quiet; then
    # Working tree clean - probably forgot /fi
    echo "ℹ️  Previous session didn't run /fi but working tree is clean."
    echo "Auto-recovering to clean state..."
    echo '{"status": "clean", "timestamp": "'$(date -Iseconds)'"}' > .claude/.last_session
    # Continue to Step 0.2
  else
    # True crash - has uncommitted changes
    echo "⚠️  Previous session crashed with uncommitted changes"
    git status
    npm run dialog:export --no-html
    # Read .claude/SNAPSHOT.md for context

    # Ask user what to do with uncommitted changes
    echo ""
    echo "You have uncommitted changes from a crashed session."
    echo ""
    echo "Options:"
    echo "  1. Continue - start new work (changes will remain uncommitted)"
    echo "  2. Commit first - commit the changes from the crashed session first"
    echo ""
    read -p "Your choice? (1/2): " CRASH_CHOICE

    if [ "$CRASH_CHOICE" = "2" ]; then
      echo "Creating commit for crashed session..."
      # Guide user through commit
    fi
  fi
  ```
- If `"status": "clean"` → OK, continue to Step 0.2

---

## Step 0.2: Framework Version Check

**CRITICAL: Execute this bash script using the Bash tool to check for framework updates.**

**Action:** Run the following bash script:

```bash
# 1. Parse local version from CLAUDE.md
LOCAL_VERSION=$(grep "Framework: Claude Code Starter v" CLAUDE.md | tail -1 | sed 's/.*v\([0-9.]*\).*/\1/')

# 2. Get latest version from GitHub
LATEST_VERSION=$(curl -s https://api.github.com/repos/alexeykrol/claude-code-starter/releases/latest | grep '"tag_name"' | sed 's/.*"v\(.*\)".*/\1/')

# 3. If newer version available - auto-update (aggressive)
if [ "$LOCAL_VERSION" != "$LATEST_VERSION" ] && [ "$LATEST_VERSION" != "" ]; then
  echo "📦 Framework update available: v$LOCAL_VERSION → v$LATEST_VERSION"
  echo "Updating framework..."

  # Download CLAUDE.md
  curl -sL "https://github.com/alexeykrol/claude-code-starter/releases/download/v$LATEST_VERSION/CLAUDE.md" -o CLAUDE.md.new

  # Download framework commands (5 files)
  curl -sL "https://github.com/alexeykrol/claude-code-starter/releases/download/v$LATEST_VERSION/framework-commands.tar.gz" -o /tmp/fw-cmd.tar.gz

  # Verify downloads successful
  if [ -f "CLAUDE.md.new" ] && [ -f "/tmp/fw-cmd.tar.gz" ]; then
    # Self-healing: Verify downloaded version matches expected
    DOWNLOADED_VERSION=$(grep "Framework: Claude Code Starter v" CLAUDE.md.new | tail -1 | sed 's/.*v\([0-9.]*\).*/\1/')

    if [ "$DOWNLOADED_VERSION" != "$LATEST_VERSION" ]; then
      echo "⚠️  Downloaded CLAUDE.md has wrong version (v$DOWNLOADED_VERSION)"
      echo "   Auto-correcting to v$LATEST_VERSION..."

      # Fix version in downloaded file (Darwin/BSD sed requires '' after -i)
      if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/v$DOWNLOADED_VERSION/v$LATEST_VERSION/g" CLAUDE.md.new
      else
        sed -i "s/v$DOWNLOADED_VERSION/v$LATEST_VERSION/g" CLAUDE.md.new
      fi

      echo "   ✓ Version corrected in CLAUDE.md"
    fi

    # Replace CLAUDE.md
    mv CLAUDE.md.new CLAUDE.md

    # Extract commands
    tar -xzf /tmp/fw-cmd.tar.gz -C .claude/commands/
    rm /tmp/fw-cmd.tar.gz

    echo "✅ Framework updated to v$LATEST_VERSION"
    echo ""
    echo "⚠️  IMPORTANT: Restart this session to use new framework version"
    echo "   Type 'exit' and start new session with 'claude'"
    echo ""
  else
    echo "⚠️  Update failed - continuing with v$LOCAL_VERSION"
    rm -f CLAUDE.md.new /tmp/fw-cmd.tar.gz
  fi
fi
```

**What happens:**
- If update available → Downloads and replaces CLAUDE.md + commands
- Updates only framework files (CLAUDE.md + commands)
- Does NOT touch user files (SNAPSHOT.md, BACKLOG.md, etc.)
- Safe to run - preserves all project data
- **Requires session restart** to use new version

---

## Step 0.15: Bug Reporting Consent (First Run Only)

**Purpose:** Ask user for consent to collect anonymous bug reports on first framework run.

```bash
# Check if first run or consent not yet given
if [ ! -f ".claude/.framework-config" ]; then
  # Initialize config file
  PROJECT_NAME=$(basename "$(pwd)")
  cat > .claude/.framework-config <<EOF
{
  "bug_reporting_enabled": false,
  "project_name": "$PROJECT_NAME",
  "first_run_completed": false,
  "consent_version": "1.0"
}
EOF
fi

# Read config
FIRST_RUN=$(cat .claude/.framework-config | grep -o '"first_run_completed": *[^,}]*' | sed 's/.*: *//' | tr -d ' ')

if [ "$FIRST_RUN" = "false" ]; then
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🔒 Framework Bug Reporting"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "The framework can collect anonymous bug reports to help improve it."
  echo ""
  echo "What gets sent (if errors occur):"
  echo "  • Error messages and stack traces (anonymized)"
  echo "  • Framework version and protocol step"
  echo "  • Timestamp"
  echo ""
  echo "What does NOT get sent:"
  echo "  • Your code or file contents"
  echo "  • File paths (anonymized)"
  echo "  • API keys, tokens, secrets (removed)"
  echo "  • Project name (anonymized)"
  echo ""
  echo "Reports are sent to: github.com/alexeykrol/claude-code-starter/issues"
  echo ""
  echo "You can change this anytime with: /bug-reporting enable|disable"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  # Ask for consent
  read -p "Enable anonymous bug reporting? (y/N) " -n 1 -r
  echo ""

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Enable bug reporting
    cat .claude/.framework-config | sed 's/"bug_reporting_enabled": false/"bug_reporting_enabled": true/' | sed 's/"first_run_completed": false/"first_run_completed": true/' > .claude/.framework-config.tmp
    mv .claude/.framework-config.tmp .claude/.framework-config
    echo "✅ Bug reporting enabled. Thank you for helping improve the framework!"
  else
    # Mark first run complete but keep disabled
    cat .claude/.framework-config | sed 's/"first_run_completed": false/"first_run_completed": true/' > .claude/.framework-config.tmp
    mv .claude/.framework-config.tmp .claude/.framework-config
    echo "ℹ️  Bug reporting disabled. You can enable it later with: /bug-reporting enable"
  fi
  echo ""
fi
```

**Notes:**
- Only runs once on first framework launch
- Stores preference in `.claude/.framework-config`
- Can be changed anytime with `/bug-reporting` command
- Fully opt-in, default is disabled

---

## Step 0.3: Initialize Protocol Logging

**Purpose:** Set up logging for Cold Start protocol execution (if enabled).

```bash
# Check if bug reporting enabled
if [ -f ".claude/.framework-config" ]; then
  BUG_REPORTING=$(cat .claude/.framework-config | grep -o '"bug_reporting_enabled": *[^,}]*' | sed 's/.*: *//' | tr -d ' ')

  if [ "$BUG_REPORTING" = "true" ]; then
    # Create log directory
    mkdir -p .claude/logs/cold-start

    # Generate log filename with timestamp
    PROJECT_NAME=$(basename "$(pwd)")
    TIMESTAMP=$(date +%Y%m%d-%H%M%S)
    LOG_FILE=".claude/logs/cold-start/${PROJECT_NAME}-${TIMESTAMP}.md"

    # Initialize log file
    cat > "$LOG_FILE" <<EOF
# Cold Start Protocol Log

**Project:** ${PROJECT_NAME}_anon
**Started:** $(date -Iseconds)
**Framework:** $(grep "Framework: Claude Code Starter v" CLAUDE.md | tail -1 | sed 's/.*v/v/')

## Protocol Execution

EOF

    # Export log file path for use in subsequent steps
    export COLD_START_LOG="$LOG_FILE"

    # Log function
    log_step() {
      if [ -n "$COLD_START_LOG" ]; then
        echo "- [$(date +%H:%M:%S)] $1" >> "$COLD_START_LOG"
      fi
    }

    # Log error function
    log_error() {
      if [ -n "$COLD_START_LOG" ]; then
        echo "" >> "$COLD_START_LOG"
        echo "## ⚠️ ERROR at $(date +%H:%M:%S)" >> "$COLD_START_LOG"
        echo "" >> "$COLD_START_LOG"
        echo '```' >> "$COLD_START_LOG"
        echo "$1" >> "$COLD_START_LOG"
        echo '```' >> "$COLD_START_LOG"
        echo "" >> "$COLD_START_LOG"
      fi
    }

    export -f log_step log_error

    log_step "Step 0.3: Logging initialized"
  fi
fi
```

**Notes:**
- Only creates logs if bug reporting is enabled
- Log files named: `{project}-{timestamp}.md`
- Stored in `.claude/logs/cold-start/` (gitignored)
- Includes project name (anonymized), timestamp, framework version
- Provides `log_step()` and `log_error()` functions for protocol steps

---

## Step 0.4: Framework Developer Mode

**Purpose:** Automatically check for new bug reports from host projects (framework project only).

**Trigger:** Only runs in claude-code-starter framework repository.

```bash
# Check if this is the framework project
if [ -d "migration" ] && [ -f "migration/build-distribution.sh" ]; then
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "🔧 Framework Developer Mode"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  # Check if gh CLI is available
  if ! command -v gh &> /dev/null; then
    echo "ℹ️  GitHub CLI not installed - skipping bug report check"
    echo "   Install: brew install gh (macOS) or sudo apt install gh (Linux)"
    echo ""
  else
    # Check if authenticated
    if ! gh auth status &> /dev/null; then
      echo "ℹ️  GitHub CLI not authenticated - skipping bug report check"
      echo "   Run: gh auth login"
      echo ""
    else
      # Fetch bug reports from GitHub Issues
      echo "📊 Checking for bug reports from host projects..."

      BUG_REPORTS=$(gh issue list \
        --repo "alexeykrol/claude-code-starter" \
        --label "bug-report" \
        --state "open" \
        --json number,title,createdAt \
        --limit 100 2>/dev/null)

      if [ $? -eq 0 ]; then
        REPORT_COUNT=$(echo "$BUG_REPORTS" | jq length 2>/dev/null || echo "0")

        if [ "$REPORT_COUNT" -gt 0 ]; then
          echo ""
          echo "⚠️  Found $REPORT_COUNT open bug report(s)"
          echo ""

          # Show recent reports (last 5)
          echo "Recent reports:"
          echo "$BUG_REPORTS" | jq -r '.[:5] | .[] | "  • #\(.number): \(.title)"' 2>/dev/null
          echo ""

          # Count by recency (last 7 days)
          WEEK_AGO=$(date -u -v-7d +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -u -d '7 days ago' +%Y-%m-%dT%H:%M:%SZ)
          RECENT_COUNT=$(echo "$BUG_REPORTS" | jq --arg week "$WEEK_AGO" '[.[] | select(.createdAt > $week)] | length' 2>/dev/null || echo "0")

          if [ "$RECENT_COUNT" -gt 0 ]; then
            echo "📌 $RECENT_COUNT new report(s) in the last 7 days"
            echo ""
          fi

          echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
          echo ""
          echo "💡 Recommended actions:"
          echo "   1. Run /analyze-bugs for detailed analysis"
          echo "   2. Review and prioritize bug reports"
          echo "   3. Create fixes for critical issues"
          echo ""

          # Save bug report summary for later reference
          export BUG_REPORT_COUNT="$REPORT_COUNT"
          export BUG_RECENT_COUNT="$RECENT_COUNT"
        else
          echo "✅ No open bug reports"
          echo ""
        fi
      else
        echo "⚠️  Failed to fetch bug reports"
        echo ""
      fi
    fi
  fi
fi
```

**Notes:**
- Only runs in framework repository (claude-code-starter)
- Requires GitHub CLI (`gh`) installed and authenticated
- Shows count of open bug reports with "bug-report" label
- Highlights reports from last 7 days
- Suggests running `/analyze-bugs` for detailed analysis
- Non-blocking: continues even if gh CLI unavailable
- First priority task: fix user-reported issues

---

## Step 0.5: Security Cleanup & Export Sessions

**CRITICAL: Security First**

```bash
# Security: Clean LAST dialog (from previous session)
# Removes credentials before export to prevent leaks in git
if [ -f "security/cleanup-dialogs.sh" ]; then
  bash security/cleanup-dialogs.sh --last
fi

npm run dialog:export --no-html
node dist/claude-export/cli.js generate-html
git add html-viewer/index.html && git commit -m "chore: Update student UI with latest dialogs"
```

**What this does:**
1. **Security cleanup** — Redacts credentials from last closed dialog
   - SSH credentials (user@host, IP addresses, SSH keys)
   - Database URLs (postgres://, mysql://, mongodb://)
   - API keys, JWT tokens, passwords
   - Prevents credentials from leaking into git
2. **Export dialogs** — Exports closed sessions without HTML generation
3. **Update Student UI** — Generates html-viewer/index.html with ALL sessions
4. **Auto-commit** — Commits student UI so students see complete history

**Why --last flag:**
- Only cleans LAST closed dialog (fast, 1 file vs 300+)
- Each dialog gets cleaned on next Cold Start
- Gradual cleanup ensures all dialogs eventually cleaned

**Security guarantee:**
- All closed dialogs are cleaned before ever being committed to git
- Cleanup runs BEFORE export, blocking credentials at source

---

## Step 0.55: Auto-Create COMMIT_POLICY.md (If Missing)

**Purpose:** Ensure COMMIT_POLICY.md exists to protect against accidental leaks.

**NEW in v2.5.1:** Auto-recovery for missing COMMIT_POLICY.md file.

```bash
# Check if COMMIT_POLICY.md exists
if [ ! -f ".claude/COMMIT_POLICY.md" ]; then
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "⚠️  COMMIT_POLICY.md not found"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "Creating from template..."

  # Check if template exists
  if [ -f "migration/templates/COMMIT_POLICY.template.md" ]; then
    # Get project name
    PROJECT_NAME=$(basename "$(pwd)")

    # Create COMMIT_POLICY.md from template
    sed "s/{{PROJECT_NAME}}/${PROJECT_NAME}/g" \
      migration/templates/COMMIT_POLICY.template.md > .claude/COMMIT_POLICY.md

    echo "✅ COMMIT_POLICY.md created"
    echo ""
    echo "📝 Review: .claude/COMMIT_POLICY.md"
    echo "   Add project-specific patterns if needed."
    echo ""
  else
    echo "⚠️  Template not found: migration/templates/COMMIT_POLICY.template.md"
    echo "   Creating minimal COMMIT_POLICY.md with hardcoded rules..."

    # Create minimal COMMIT_POLICY.md with essential rules
    cat > .claude/COMMIT_POLICY.md <<'EOF'
# Commit Policy — What may be committed?

## ❌ NEVER commit:

```
# Framework files (CRITICAL!)
dialog/                 # Claude dialogs
.claude/logs/           # Framework logs
reports/                # Bug reports (already in GitHub)

# Development scratch
notes/
scratch/
experiments/
WIP_*
INTERNAL_*

# Sensitive data
secrets/
credentials/
*.key
*.pem
```

## ✅ ALWAYS commit:

```
src/
tests/
README.md
CHANGELOG.md
package.json
tsconfig.json
.gitignore
```

**Edit this file to suit your project!**
EOF

    echo "✅ Minimal COMMIT_POLICY.md created"
    echo ""
    echo "⚠️  IMPORTANT: Review and customize .claude/COMMIT_POLICY.md"
    echo ""
  fi

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
fi
```

**What this does:**
- Checks if `.claude/COMMIT_POLICY.md` exists
- If missing, creates from template (`migration/templates/COMMIT_POLICY.template.md`)
- If template also missing, creates minimal version with hardcoded essential rules
- Protects against commits without policy check

**Why this matters:**
- COMMIT_POLICY.md is critical for preventing accidental leaks
- Without it, Claude AI might commit forbidden files (reports/, dialog/, etc.)
- Auto-recovery ensures policy always exists

---

## Step 0.6: Install Git Hooks (COMMIT_POLICY protection)

**Purpose:** Install pre-commit hook for last line of defense against accidental leaks.

**NEW in v2.5.0:** Automatic git hook installation for COMMIT_POLICY enforcement.

```bash
bash .claude/scripts/install-git-hooks.sh
```

**What this does:**
1. Checks if project is a git repository
2. Installs `.git/hooks/pre-commit` symlink to `.claude/scripts/pre-commit-hook.sh`
3. Hook blocks commits if forbidden files (from COMMIT_POLICY) are staged

**Protection:**
- Even if Claude AI makes mistake in Step 4 (Completion)
- Git hook will block commit if forbidden files are staged
- User sees clear error message with instructions

**Silent operation:**
- No output if successful (hooks already installed)
- Only shows message if hook installation fails

---

## Step 1: Mark Session Active

```bash
echo '{"status": "active", "timestamp": "'$(date -Iseconds)'"}' > .claude/.last_session
```

**Purpose:** Mark this session as active for crash detection on next Cold Start.

---

## Step 2: Load Context (ALWAYS read — keep compact!)

**Read these files EVERY session:**
- `.claude/SNAPSHOT.md` — current version, what's in progress (~30-50 lines)
- `.claude/BACKLOG.md` — current sprint tasks (~50-100 lines)
- `.claude/ARCHITECTURE.md` — code structure (~100-200 lines)

**CRITICAL: NEVER read `dialog/` files** — they are for archive only, not for context loading. Reading them wastes tokens.

---

## Step 3: Context (ON DEMAND — read when needed)

**Read these ONLY when specifically needed:**
- `.claude/ROADMAP.md` — strategic direction (when planning)
- `.claude/IDEAS.md` — ideas backlog (when exploring ideas)
- `CHANGELOG.md` — version history (when need history)

---

## Step 4: Confirm

Output confirmation message:

```
Context loaded. Directory: [pwd]
Framework: Claude Code Starter v2.5.0
Ready to work!
```

---

## Token Economy

**Files in Step 2 are read EVERY session** — keep them compact!

Historical/strategic content → Step 3 files or CHANGELOG.md.

**Estimated token cost:**
- Step 2 files: ~2-3k tokens
- Full protocol execution: ~3-5k tokens
- **85% savings** vs reading entire project

---

**Protocol Complete** ✅
