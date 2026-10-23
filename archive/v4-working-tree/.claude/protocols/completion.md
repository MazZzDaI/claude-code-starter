# Completion Protocol

**Version:** 2.5.1
**Last updated:** 2026-01-16

**Purpose:** Finalize sprint/task, update metafiles, export sessions, commit changes.

**Trigger:** User types "wrap up", "finish up", "finish", or "done"

---

## Overview

This protocol runs at the end of each sprint or task to:
1. Build the project (if code changed)
2. Update all metafiles (SNAPSHOT, BACKLOG, CHANGELOG, etc.)
3. Export dialog sessions
4. Security check on current session
5. Commit changes with proper message
6. Optionally push and create PR
7. Mark session as clean
8. Create bug report (if enabled)

**IMPORTANT:** This file is read FRESH when executing completion, immune to context compaction.

---

## Step 0: Re-read Completion Protocol (Self-Check)

**Purpose:** Ensure protocol is followed correctly by re-reading instructions.

**Why needed:**
- During long sessions, context may be compacted/summarized
- Re-reading ensures sharp focus on protocol steps
- Prevents forgetting metafile updates (CLAUDE.md, SNAPSHOT.md, BACKLOG.md)
- "Practice what we preach" — we require this from host projects
- Catches systemic errors where changes are made but not documented

**Action:**
```
Read the Completion Protocol file (.claude/protocols/completion.md) to refresh protocol steps.
Mentally review what was done in this session and what needs to be updated.
```

**Self-check questions:**
- Did I add new features? → Update SNAPSHOT.md, BACKLOG.md, CHANGELOG.md
- Did I modify CLAUDE.md? → Ensure changes are in migration/CLAUDE.production.md too
- Did I add new commands? → Are they in distribution?
- Did I fix bugs? → Document in CHANGELOG.md

---

## Step 0.1: Initialize Completion Logging

**Purpose:** Set up logging for Completion protocol execution (if enabled).

```bash
# Check if bug reporting enabled
if [ -f ".claude/.framework-config" ]; then
  BUG_REPORTING=$(cat .claude/.framework-config | grep -o '"bug_reporting_enabled": *[^,}]*' | sed 's/.*: *//' | tr -d ' ')

  if [ "$BUG_REPORTING" = "true" ]; then
    # Create log directory
    mkdir -p .claude/logs/completion

    # Generate log filename with timestamp
    PROJECT_NAME=$(basename "$(pwd)")
    TIMESTAMP=$(date +%Y%m%d-%H%M%S)
    LOG_FILE=".claude/logs/completion/${PROJECT_NAME}-${TIMESTAMP}.md"

    # Initialize log file
    cat > "$LOG_FILE" <<EOF
# Completion Protocol Log

**Project:** ${PROJECT_NAME}_anon
**Started:** $(date -Iseconds)
**Framework:** $(grep "Framework: Claude Code Starter v" CLAUDE.md | tail -1 | sed 's/.*v/v/')

## Protocol Execution

EOF

    # Export log file path for use in subsequent steps
    export COMPLETION_LOG="$LOG_FILE"

    # Log function
    log_completion_step() {
      if [ -n "$COMPLETION_LOG" ]; then
        echo "- [$(date +%H:%M:%S)] $1" >> "$COMPLETION_LOG"
      fi
    }

    # Log error function
    log_completion_error() {
      if [ -n "$COMPLETION_LOG" ]; then
        echo "" >> "$COMPLETION_LOG"
        echo "## ⚠️ ERROR at $(date +%H:%M:%S)" >> "$COMPLETION_LOG"
        echo "" >> "$COMPLETION_LOG"
        echo '```' >> "$COMPLETION_LOG"
        echo "$1" >> "$COMPLETION_LOG"
        echo '```' >> "$COMPLETION_LOG"
        echo "" >> "$COMPLETION_LOG"
      fi
    }

    export -f log_completion_step log_completion_error

    log_completion_step "Step 0.1: Logging initialized"
  fi
fi
```

**Notes:**
- Only creates logs if bug reporting is enabled
- Log files named: `{project}-{timestamp}.md`
- Stored in `.claude/logs/completion/` (gitignored)

---

## Step 1: Build (if code changed)

```bash
npm run build
```

**When to skip:**
- No TypeScript files were modified
- Only documentation or metafiles updated
- Only dialog exports or configuration changes

**When to run:**
- Modified any `.ts` or `.tsx` files
- Added new source code
- Changed build configuration

---

## Step 2: Update Metafiles

**Files to update:**

- **`.claude/BACKLOG.md`** — Mark completed tasks with `[x]`, add new tasks if discovered
- **`.claude/SNAPSHOT.md`** — Update version and status section
- **`CHANGELOG.md`** — Add entry for this version (if creating release)
- **`README.md` + `README_RU.md`** — Update if major features added
- **`.claude/ARCHITECTURE.md`** — Update if code structure changed

**Checklist:**
- [ ] Mark completed backlog items
- [ ] Update SNAPSHOT.md version/status
- [ ] Add CHANGELOG entry (if release)
- [ ] Update README if needed
- [ ] Update ARCHITECTURE if structure changed

---

## Step 2.1: Version Bumping (if creating release)

**Semantic Versioning (X.Y.Z):**
- **X** (major) — breaking changes, major architecture rewrites
- **Y** (minor) — new features, significant improvements (e.g., 2.1.0 → 2.2.0)
- **Z** (patch) — bug fixes, small tweaks (e.g., 2.2.0 → 2.2.1)

**Files to update with new version:**
- `init-project.sh` — line 4 (comment) and line 11 (VERSION variable)
- `migration/build-distribution.sh` — line 4 (comment) and line 12 (VERSION variable)
- `README.md` — version badge (line ~13)
- `README_RU.md` — version badge (line ~13)
- `.claude/SNAPSHOT.md` — Version field
- `CHANGELOG.md` — new section header

**After version bump:**
1. Run `bash migration/build-distribution.sh` to rebuild dist-release/
2. Create GitHub Release with `gh release create vX.Y.Z dist-release/init-project.sh dist-release/framework.tar.gz`

---

## Step 3: Export Dialogs

```bash
npm run dialog:export --no-html
```

**What this does:**
- Exports dialog sessions without generating html-viewer
- Student UI (html-viewer) is NOT updated here (current session still active)
- Student UI will be updated on next Cold Start (Step 0.5)

**Why --no-html:**
- Current session is still active
- HTML generation happens in Cold Start when session is closed
- Avoids generating incomplete viewer

---

## Step 3.5: Security: Clean Current Dialog + Auto AI Agent

**MANDATORY SECURITY CHECK** — Prevents credentials from leaking into git

### Part 1: Regex-Based Cleanup (Layer 2)

```bash
# Clean CURRENT dialog (this session) before commit
if [ -f "security/cleanup-dialogs.sh" ]; then
  bash security/cleanup-dialogs.sh --last
  CLEANUP_EXIT=$?
fi
```

**What this does:**
- Cleans CURRENT (active) dialog session before git commit
- Redacts credentials using regex patterns (fast, ~1-2 seconds)
- Blocks commit if credentials detected (script exits with error)
- **CRITICAL:** This is the LAST line of defense before credentials enter git

**What gets redacted by regex:**
- SSH credentials (user@host, IPs, SSH keys, ports)
- Database URLs (postgres, mysql, mongodb)
- API keys, tokens, passwords
- JWT tokens, bearer tokens
- Private keys (PEM format)

### Part 2: Smart Trigger Detection (Advisory for Claude AI)

```bash
# Check security triggers (advisory mode)
if [ -f "security/auto-invoke-agent.sh" ]; then
  bash security/auto-invoke-agent.sh
  TRIGGER_EXIT=$?
fi
```

**Claude AI Decision Logic:**

**Exit code interpretation:**
- `0` = No triggers → skip deep scan
- `1` = CRITICAL + release mode → **auto-invoke agent (no confirmation)**
- `10` = CRITICAL triggers → **ask user**
- `11` = HIGH triggers → **ask user**
- `12` = MEDIUM triggers → **optional mention**

**If exit code = 1 (Release Mode):**
```
Claude automatically invokes /security-dialogs without asking.
User sees: "🚨 RELEASE MODE: Running mandatory deep scan..."
```

**If exit code = 10 or 11 (CRITICAL/HIGH):**
```
Claude asks user:

⚠️  Potential security risks detected:
  • [reasons from trigger detection]

I recommend running a deep scan of the sprint changes (1-2 minutes).
Run the AI agent to check? (y/N)

If user answers "y" → Claude invokes /security-dialogs
If user answers "N" → Claude skips, proceeds with commit
```

**If exit code = 12 (MEDIUM):**
```
Claude optionally mentions:
"💡 If you want an additional check, you can run /security-dialogs"
```

**Important:**
- Claude (AI) reads trigger info and sprint context
- Claude decides whether to ask based on what was discussed in session
- Only release mode (git tag v2.x.x) auto-invokes without asking
- Normal commits → user always decides

### Why this is mandatory:

- Cold Start Step 0.5 cleans PREVIOUS session
- This step cleans CURRENT session (the one being committed now)
- Double protection: previous session (0.5) + current session (3.5)
- Auto-invokes AI agent when high-risk conditions detected

### Trigger Levels:

**CRITICAL triggers (exit code 1 - auto-invoke in release mode, exit code 10 - ask in normal mode):**
- Production credentials file exists (`.production-credentials`)
- Git release tag detected (creating release)
- Release workflow in recent dialogs

**HIGH triggers (exit code 11 - ask user):**
- Regex cleanup found credentials
- Security-sensitive keywords in dialogs (ssh, api key, password, etc.)
- Production/deployment discussion detected

**MEDIUM triggers (exit code 12 - optional mention):**
- Large diff (>500 lines changed)
- Many new dialog files (>5 uncommitted)
- Security config files modified

**If credentials detected:**
- Script exits with error (non-zero exit code)
- Commit is blocked
- Review `security/reports/cleanup-*.txt` for details
- AI agent may be invoked for deep context analysis
- Manually verify redactions before proceeding

---

## Step 4: Git Commit (with COMMIT_POLICY check)

**CRITICAL: Check COMMIT_POLICY.md BEFORE staging files to prevent accidental leaks.**

**NEW in v2.5.1:** Replaced dangerous `git add -A` with policy-based selective staging.

### Step 4.1: Load COMMIT_POLICY (MANDATORY)

**CRITICAL:** This step is MANDATORY. Do NOT skip or proceed without COMMIT_POLICY.

**Action:** Read `.claude/COMMIT_POLICY.md` to understand what can be committed.

```bash
# Check if COMMIT_POLICY.md exists
if [ ! -f ".claude/COMMIT_POLICY.md" ]; then
  echo ""
  echo "⚠️ CRITICAL: COMMIT_POLICY.md not found!"
  echo ""

  # Try to create from template
  if [ -f "migration/templates/COMMIT_POLICY.template.md" ]; then
    echo "Creating from template..."
    PROJECT_NAME=$(basename "$(pwd)")
    sed "s/{{PROJECT_NAME}}/${PROJECT_NAME}/g" \
      migration/templates/COMMIT_POLICY.template.md > .claude/COMMIT_POLICY.md
    echo "✅ COMMIT_POLICY.md created"
    echo ""
  else
    echo "⚠️ Template not found. Creating minimal COMMIT_POLICY.md..."

    # Create minimal version with hardcoded rules
    cat > .claude/COMMIT_POLICY.md <<'EOF'
# Commit Policy

## ❌ NEVER:
\`\`\`
dialog/
.claude/logs/
reports/
notes/
scratch/
secrets/
credentials/
*.key
*.pem
\`\`\`

## ✅ ALWAYS:
\`\`\`
src/
tests/
README.md
CHANGELOG.md
package.json
\`\`\`
EOF
    echo "✅ Minimal COMMIT_POLICY.md created"
    echo ""
  fi

  echo "📝 Please review .claude/COMMIT_POLICY.md before committing"
  echo ""

  # Ask user to confirm
  read -p "Continue with commit? Review policy first? (y/N) " -n 1 -r
  echo ""
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Commit cancelled. Please review .claude/COMMIT_POLICY.md"
    exit 1
  fi
fi
```

**Hardcoded Fallback Rules (if COMMIT_POLICY.md cannot be read):**

**NEVER stage these patterns (last resort):**
```
dialog/                 # Framework dialogs
.claude/logs/           # Framework logs
reports/                # Bug reports (CRITICAL - already in GitHub)
notes/                  # Personal notes
scratch/                # Scratch files
experiments/            # Experiments
WIP_*, INTERNAL_*, DRAFT_*
secrets/                # Secrets
credentials/            # Credentials
*.key, *.pem            # Private keys
.vscode/, .idea/        # IDE configs
*.local.*               # Local configs
```

**ALWAYS stage these patterns (safe files):**
```
src/, lib/, tests/      # Source code
README.md, CHANGELOG.md, LICENSE
package.json, tsconfig.json
.claude/SNAPSHOT.md, .claude/BACKLOG.md, .claude/ARCHITECTURE.md
.gitignore
```

**If unsure:** ASK USER before staging!

### Step 4.2: Get Changed Files

```bash
git status --short
```

**Parse output:** Extract modified/added/deleted files from git status.

### Step 4.3: Claude AI Analyzes Each File

**For each changed file, check against COMMIT_POLICY patterns:**

**1. Check "NEVER" patterns (auto-block):**
```
notes/, scratch/, experiments/, WIP_*, INTERNAL_*, DRAFT_*
dialog/, .claude/logs/, *.debug.log, debug/, reports/
*.local.*, .env.local, .vscode/, .idea/
secrets/, credentials/, *.key, *.pem, .production-credentials, backup/
```

**If file matches "NEVER":**
- DO NOT stage this file
- Add to blocked list
- Continue to next file

**2. Check "ALWAYS" patterns (auto-approve):**
```
src/, lib/, tests/
README.md, CHANGELOG.md, LICENSE
package.json, tsconfig.json, .gitignore
.claude/ARCHITECTURE.md (if public project)
```

**If file matches "ALWAYS":**
- Add to staging list
- Continue to next file

**3. Check "ASK" patterns (ask user):**
```
- New folders not in NEVER/ALWAYS lists
- Filenames containing: api-key, password, secret, prod, production
- Files >1000 lines (may be generated)
```

**If file matches "ASK":**
- Add to ask-user list
- Will prompt user later

### Step 4.4: Show What Will Be Staged

**If blocked files found:**
```
⚠️  WARNING: Following files match COMMIT_POLICY "NEVER" and will NOT be committed:

  • notes/my-internal-plans.md (matches: notes/)
  • WIP_new-feature.js (matches: WIP_*)
  • .vscode/settings.json (matches: .vscode/)

Review .claude/COMMIT_POLICY.md if this is incorrect.
```

**If ask-user files found:**
```
⚠️  These files are not in COMMIT_POLICY auto-approval list:

  • config/production.yml (contains: 'production')
  • data/export.csv (new file, 2500 lines)

Add these files to commit? (y/N)
```

**Wait for user response:**
- If "y" → Add to staging list
- If "N" → Do NOT stage

### Step 4.5: Stage Only Approved Files

```bash
# NOT git add -A! Selective staging:
git add src/ tests/ README.md package.json CHANGELOG.md
# (only files from auto-approve + user-approved)
```

**Important:** Use explicit paths, NOT `git add -A`!

### Step 4.6: Show Final Status

```bash
git status
```

**Output shows exactly what will be committed.**

Ask user: "Review changes above. Proceed with commit? (y/N)"

**If user says "N":**
- Cancel commit
- User can manually adjust

### Step 4.7: Create Commit

**Only after user approval:**

```bash
git commit -m "$(cat <<'EOF'
type: Brief description

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

**Commit message format:**
- **type:** feat, fix, refactor, docs, test, chore, etc.
- **Brief description:** One line summary
- **Attribution:** Include Claude Code attribution and co-author

**Examples:**
- `feat: Add AI-powered security agent for credential detection`
- `fix: Resolve trigger detection parsing error on macOS`
- `refactor: Extract protocols into modular files`
- `docs: Update completion protocol with security steps`

### Step 4.8: Pre-commit Hook Protection

**Last line of defense:** Git pre-commit hook runs automatically.

**If blocked files somehow got staged:**
```
❌ COMMIT BLOCKED by COMMIT_POLICY.md

Forbidden files detected:
  • dialog/2026-01-17_session-abc123.md

Review .claude/COMMIT_POLICY.md
```

**Hook location:** `.git/hooks/pre-commit` (installed by framework)

**Result:** Commit fails, user must fix and retry.

---

## Step 5: Ask About Push & PR

### Push to Remote

**Ask user:** "Push to remote?"

**If yes:**
```bash
git push
```

### Check PR Status

```bash
git log origin/main..HEAD --oneline
```

**If empty** → All merged, no PR needed
**If has commits** → Ask: "Create PR?"

**If user wants PR:**
- Use `/pr` command or `gh pr create`
- Include summary of changes
- Reference related issues if any

---

## Step 6: Mark Session Clean

```bash
echo '{"status": "clean", "timestamp": "'$(date -Iseconds)'"}' > .claude/.last_session
```

**Purpose:** Mark this session as successfully completed for crash detection on next Cold Start.

**Status values:**
- `"clean"` — Session completed successfully
- `"active"` — Session in progress (set during Cold Start)

---

## Step 6.5: Finalize Completion Log & Create Bug Report

**Purpose:** Complete the log, check for errors, and create bug report if needed.

```bash
# Finalize log if enabled
if [ -n "$COMPLETION_LOG" ] && [ -f "$COMPLETION_LOG" ]; then
  log_completion_step "Step 6: Session marked clean"

  # Add completion timestamp
  cat >> "$COMPLETION_LOG" <<EOF

## Completion

**Finished:** $(date -Iseconds)
**Status:** Success
EOF

  echo "✅ Completion log saved: $COMPLETION_LOG"

  # Check if bug reporting is enabled
  if [ -f ".claude/.framework-config" ] && grep -q '"bug_reporting_enabled": true' ".claude/.framework-config" 2>/dev/null; then
    # Check if there were any errors in the log
    if grep -q "## ⚠️ ERROR" "$COMPLETION_LOG"; then
      echo ""
      echo "⚠️  Errors detected during completion protocol"
      echo "Log contains error information: $COMPLETION_LOG"
      echo ""
    else
      echo ""
      echo "✓ Completion protocol executed successfully (no errors)"
      echo ""
    fi

    # ALWAYS offer to create bug report (for analytics & telemetry)
    echo "📊 Bug reporting is enabled (analytics & telemetry)"
    read -p "Create anonymized report? (y/N) " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
      # Run anonymization script
      if [ -f ".claude/scripts/anonymize-report.sh" ]; then
        REPORT_FILE=$(bash .claude/scripts/anonymize-report.sh "$COMPLETION_LOG")
        echo "✅ Report created: $REPORT_FILE"
        echo ""

        # Offer to submit to GitHub automatically
        read -p "Submit report to GitHub? (y/N) " -n 1 -r
        echo ""

        if [[ $REPLY =~ ^[Yy]$ ]]; then
          # Submit to GitHub Issues
          if [ -f ".claude/scripts/submit-bug-report.sh" ]; then
            ISSUE_URL=$(bash .claude/scripts/submit-bug-report.sh "$REPORT_FILE")
            if [ $? -eq 0 ]; then
              echo "✅ Submitted to GitHub: $ISSUE_URL"
            fi
          else
            echo "⚠️  Submit script not found"
            echo "You can submit manually: github.com/alexeykrol/claude-code-starter/issues"
          fi
        else
          echo "ℹ️  Report saved locally: $REPORT_FILE"
          echo "You can submit later: github.com/alexeykrol/claude-code-starter/issues"
        fi
      else
        echo "⚠️  Anonymization script not found"
        echo "Manual review needed before sharing: $COMPLETION_LOG"
      fi
    fi
  fi
fi
```

**Notes:**
- Finalizes log with completion timestamp
- Checks for errors in log
- **ALWAYS offers to create bug report if bug reporting is enabled** (for analytics & telemetry)
- Creates report regardless of errors (successful executions are valuable data)
- Uses anonymization script to remove sensitive data
- Two-step confirmation: create report → submit to GitHub

---

## Token Economy

**This protocol file is read FRESH on each completion** — immune to context compaction!

**Estimated token cost:**
- Protocol file read: ~3-4k tokens
- Actual execution: depends on session scope
- Total overhead: ~5-7k tokens vs 50-100k for full project scan

**Benefits:**
- No lost context during long sessions
- Consistent protocol execution
- Clear step-by-step checklist
- Deterministic workflow

---

**Protocol Complete** ✅
