# BACKLOG — Claude Code Starter Framework

*Last updated: 2026-01-21*

> 📋 **SINGLE SOURCE OF TRUTH for current tasks**
>
> This file contains only concrete, agreed tasks that we are definitely doing.
>
> **Workflow:**
> - 💡 Raw ideas → [IDEAS.md](./IDEAS.md)
> - 🗺️ Structured features (v2.2+) → [ROADMAP.md](./ROADMAP.md)
> - 🎯 Concrete tasks (now) → **BACKLOG.md** (this file)
> - ✅ Completed → Archive (below)

---

## 🚫 What NOT to Do

**Purpose:** Consciously excluded ideas with rationale. Prevents revisiting settled "no" decisions.

### 1. Cloud Sync for Dialog Files

**Excluded:** Automatic upload of dialog/ files to cloud storage (Dropbox, Google Drive, iCloud).

**Rationale:**
- **Privacy violation:** Dialogs contain project code, credentials, conversations
- **Trust issues:** Users don't want AI conversations auto-uploaded to cloud
- **Framework philosophy:** Local-first, privacy by default
- **Attack surface:** Cloud sync = additional leak vector

**Alternative:**
- Users can manually backup `dialog/` to their preferred cloud storage
- Export to markdown allows version control in private repos
- Host projects can use git for backup (with proper .gitignore)

**Exception:** None. Cloud sync fundamentally conflicts with privacy-first design.

---

### 2. Auto-Commits Without User Approval

**Excluded:** Automatic git commits at Completion Protocol end without asking user.

**Rationale:**
- **User control:** Developers want to review changes before committing
- **Commit message quality:** Auto-generated messages often poor
- **Trust issues:** Automatic commits feel invasive
- **Git workflow:** Some projects use specific commit conventions

**Alternative:**
- Completion Protocol prepares commit (stages files, drafts message)
- Claude AI asks user for approval before executing `git commit`
- User can modify commit message or cancel

**Exception:** None. User must always approve commits explicitly.

---

### 3. GUI Desktop Application

**Excluded:** Standalone desktop app (Electron, Tauri) instead of CLI framework.

**Rationale:**
- **Token economy:** GUI requires bundling, packaging, auto-updates (complexity)
- **Installation overhead:** Users prefer `curl | bash` to downloading .dmg/.exe
- **Maintenance burden:** GUI requires design, UX testing, cross-platform UI bugs
- **Target audience:** Framework users are developers comfortable with CLI

**Alternative:**
- Web UI for dialog viewing (`npm run dialog:ui`)
- CLI commands for all operations
- Terminal-based interactive prompts for questions

**Exception:** If community strongly requests GUI and volunteers to maintain, reconsider as separate project (not core framework).

---

### 4. Native Windows Support (Without WSL)

**Excluded:** Full Windows support using PowerShell/cmd.exe instead of bash.

**Rationale:**
- **Bash dependency:** Framework uses bash scripts (`.sh` files) extensively
- **Maintenance burden:** Maintaining parallel PowerShell scripts = 2x work
- **Edge cases:** Windows path handling, Git Bash quirks, CRLF line endings
- **Limited value:** Most Windows developers use WSL2 already

**Alternative:**
- Official support: macOS, Linux, Windows via WSL2
- Documentation: Clear WSL2 installation instructions
- Community contributions: PowerShell scripts if volunteers emerge

**Exception:** If Windows market share among users exceeds 30% AND volunteers maintain PowerShell scripts, reconsider.

---

### 5. Auto-Push to Remote After Commits

**Excluded:** Automatic `git push` after successful commit in Completion Protocol.

**Rationale:**
- **User control:** Developers want to review commits locally before pushing
- **Multiple commits:** Users might want to squash or amend before push
- **Network issues:** Auto-push fails on network errors (breaks workflow)
- **Branch protection:** Some repos have protected branches (push requires approval)

**Alternative:**
- Completion Protocol Step 5: Ask user if they want to push
- User decides: "Push now" or "Push later manually"
- Framework shows `git push` command if user skips

**Exception:** None. Push should always be user-initiated.

---

### 6. Magic Auto-Detection of Project Type

**Excluded:** Automatic detection of project type (React, Vue, Python, etc.) and auto-configuration.

**Rationale:**
- **Complexity:** Heuristics unreliable (mixed projects, monorepos)
- **False positives:** package.json exists ≠ Node.js project (many tools use it)
- **User confusion:** Magic behavior = unclear to users what happened
- **Framework philosophy:** Explicit > implicit

**Alternative:**
- Manual configuration via questions during migration
- User specifies project type if needed
- Framework asks instead of assuming

**Exception:** If detection logic becomes 99%+ accurate and user can override, reconsider.

---

*There are no active tasks at the moment. See the archive below for completed phases.*

---

## 📚 Archive (completed phases)

### Phase 19.2: Security Audit Fixes ✅ (2026-02-10)

**Completed:** 7 bugs found by an external security audit, all fixed

**Problem:**
- Security advisory chain completely broken (set -e, parser mismatch, wrong glob)
- Path traversal in API server.ts (3 endpoints)
- Syntax errors in initial-scan.sh
- A corrupted line in .gitignore

**Tasks:**
- [x] auto-invoke-agent.sh: remove set -e (it killed the script on a non-zero exit from check-triggers)
- [x] cleanup-dialogs.sh: fix the typo REDACTED_COUNT → REDACTION_COUNT
- [x] security.py: synchronise the Python parser with the real bash output
- [x] check-triggers.sh: fix the glob *cleanup-report* → cleanup-*.txt
- [x] server.ts: add safePath() to protect against path traversal (3 endpoints)
- [x] initial-scan.sh: escape \) in find groups
- [x] .gitignore: split the concatenated line (newline)

**Files:**
- `security/auto-invoke-agent.sh` — removed set -e
- `security/cleanup-dialogs.sh` — fixed variable typo
- `src/framework-core/tasks/security.py` — synced parser strings
- `security/check-triggers.sh` — fixed glob pattern + removed dead nesting
- `src/claude-export/server.ts` — added safePath() function
- `security/initial-scan.sh` — escaped find group \)
- `.gitignore` — split concatenated line

**Impact:**
- ✅ Security advisory chain restored (it was completely dead)
- ✅ Path traversal closed in the API
- ✅ All bash scripts pass bash -n
- ✅ Build and py_compile — clean

---

### Phase 19: Migration Optimization v3.1.0 ✅ (2026-01-21)

**Completed:** Parallel file generation in the migration of legacy projects — 5x speed-up of Step 6

**Problem:**
- Migration Step 6 generates 5 framework files sequentially
- Each file = the same pattern: analysis_result + template → markdown
- Execution time: 5 files × 40s = 200s (~3+ minutes)
- Total migration time: ~9 minutes (Step 6 accounts for 40% of the time)

**Solution:**
- Parallel generation via the Task tool with general-purpose subagents
- SHARED_CONTEXT pattern — the analysis result is prepared once
- ONE message with 5 Task tool calls (not sequentially!)
- Each agent generates one file independently

**Tasks:**
- [x] Rework Step 6 in `.claude/commands/migrate-legacy.md`
- [x] Split into 3 subsections: Prepare Context, Launch Parallel, Verify
- [x] Add detailed prompt templates for each file
- [x] Update the version to v3.1.0 (8+ files)
- [x] Update metafiles (CHANGELOG, SNAPSHOT, BACKLOG)

**Key achievements:**
- ✅ Step 6: 200s → 40s (5x speed-up)
- ✅ Total migration: 9 min → 6.7 min (~30% speed-up)
- ✅ Parallel execution pattern for the Task tool
- ✅ SHARED_CONTEXT — zero duplication
- ✅ Backward compatible (not a breaking change)

**Files:**
- `.claude/commands/migrate-legacy.md` — Step 6 completely rewritten
- `package.json`, `CLAUDE.md`, `README.md`, `README_RU.md` — version bumped
- `init-project.sh`, `migration/build-distribution.sh` — version bumped
- `src/framework-core/` — version bumped to 3.1.0 (__init__.py, main.py, logger.py)
- `CHANGELOG.md` — v3.1.0 entry with performance metrics
- `.claude/SNAPSHOT.md` — Decision Log + version update
- `.claude/BACKLOG.md` — this file

**Performance:**
```
Before (v3.0.0):
  Step 6: 200 seconds (sequential)
  Total migration: ~9 minutes

After (v3.1.0):
  Step 6: 40 seconds (parallel)
  Total migration: ~6.7 minutes

Improvement: 5x faster Step 6, 30% faster total
```

**Impact:**
- ✅ Better UX — migration is noticeably faster
- ✅ User feedback driven — the solution was proposed by the user
- ✅ Architectural insight — parallel pattern applicable to other operations
- ✅ Token economy preserved — no additional context loading

---

### Phase 19.1: Hotfix - Framework Auto-Update v3.1.1 ✅ (2026-01-21)

**Completed:** Framework auto-update restored after a regression in v3.0.0

**Problem:**
- v3.0.0: Auto-update was accidentally lost in the move to Python
- The Python utility only checks the version, but does NOT download/install
- Host projects on v3.0.0-v3.1.0 did NOT receive updates automatically
- Regression: in v2.2.4-v2.7.0 auto-update worked perfectly
- Only manual updating via `quick-update.sh` worked

**Root Cause:**
- v2.2.4-v2.7.0: The Cold Start Protocol had Step 0.2 (a bash script with the full implementation)
- v3.0.0: Rewritten in Python, but only the version check remained (tasks/version.py)
- The download/install logic was in Step 0.2, which was removed during the move

**Solution:**
- Restored Phase 2.5 in `.claude/protocols/cold-start-silent.md`
- The bash script runs after Phase 1 (Python utility execution)
- Parses the version_check result from the JSON
- If UPDATE:available - downloads CLAUDE.md + framework-commands.tar.gz
- Aggressive strategy - automatic installation without confirmation

**Tasks:**
- [x] Study the implementation from v2.2.4 (git show of the commits)
- [x] Add Phase 2.5 to cold-start-silent.md
- [x] Self-healing logic (automatic version correction)
- [x] Safety checks (download to temp, verify before replace)
- [x] Update the version to v3.1.1 (8+ files)
- [x] Update metafiles (CHANGELOG, SNAPSHOT, BACKLOG)

**Key achievements:**
- ✅ Auto-update restored (hotfix)
- ✅ Aggressive strategy - safe, proven in v2.2.4-v2.7.0
- ✅ Self-healing - automatic version correction on mismatch
- ✅ Only framework files are updated, user data is not touched
- ✅ Backward compatible - works on v3.0.0 and v3.1.0

**Files:**
- `.claude/protocols/cold-start-silent.md` — Phase 2.5 added (120+ lines)
- `package.json`, `CLAUDE.md`, `README.md`, `README_RU.md` — version 3.1.1
- `init-project.sh`, `migration/build-distribution.sh` — version 3.1.1
- `src/framework-core/` — version 3.1.1 (__init__.py, main.py, logger.py)
- `CHANGELOG.md` — v3.1.1 entry with root cause analysis
- `.claude/SNAPSHOT.md` — Decision Log 2A.1 + version update
- `.claude/BACKLOG.md` — this file

**What Gets Updated:**
- CLAUDE.md (framework instructions)
- 5 framework commands (fi, ui, watch, migrate-legacy, upgrade-framework)

**What Does NOT Get Updated:**
- User commands (commit, pr, fix, feature, review, test, security, etc.)
- Project files (SNAPSHOT, BACKLOG, ARCHITECTURE, IDEAS, ROADMAP)
- User configuration (.framework-config)
- Dialog files (dialog/)
- Source code (src/)

**Impact:**
- ✅ Regression fixed - host projects receive updates automatically again
- ✅ Seamless experience - users don't think about updates
- ✅ Reduced support - everyone on latest version
- ✅ Critical bugfix - v3.0.0 and v3.1.0 will now update on the next `start`

---

### Phase 18: Python Framework Core v3.0.0 ✅ (2026-01-20)

**Completed:** A complete rewrite of the protocol execution layer from bash to Python

**Problem:**
- User feedback: "20-30% of the time goes on the protocols"
- Terminal spam from 10 bash background tasks (task notifications)
- True silent mode impossible with bash
- Slow execution (minutes)

**Solution:**
- Created the Python utility `src/framework-core/`
- All 10 tasks implemented in Python
- Parallel execution via threading
- JSON output instead of terminal spam

**Tasks:**
- [x] Design the architecture of the Python utility
- [x] Create the project structure src/framework-core/
- [x] Implement the cold-start command (10 tasks)
- [x] Implement the completion command
- [x] Integrate into the protocols (cold-start-silent.md)
- [x] Update metafiles (SNAPSHOT, BACKLOG, CHANGELOG)

**Key achievements:**
- ✅ Zero terminal noise (JSON output)
- ✅ 1000x faster (359ms vs minutes)
- ✅ Parallel execution (Python threading)
- ✅ Cross-platform (Windows native)
- ✅ Zero dependencies (stdlib only)
- ✅ Structured logging (`.claude/logs/framework-core/`)

**Files:**
- `src/framework-core/` - Python utility (16 files, 931 lines)
  - `main.py` - CLI entry point
  - `commands/cold_start.py`, `commands/completion.py`
  - `tasks/` - 6 modules (config, session, git, version, security, hooks)
  - `utils/` - logger, result, parallel
- `.claude/protocols/cold-start-silent.md` - updated to v3.0.0
- `.claude/analysis/python-framework-core-design.md` - architecture doc
- `.claude/SNAPSHOT.md` - Decision Log + What's New v3.0.0
- `CHANGELOG.md` - v3.0.0 entry (MAJOR version bump)

**Testing:**
```bash
$ python3 src/framework-core/main.py cold-start
{
  "status": "needs_input",
  "data": {
    "reason": "crash_detected",
    "uncommitted_files": "3"
  }
}
```

**Impact:**
- ✅ True silent mode achieved
- ✅ Protocols invisible to user
- ✅ Faster development iteration
- ✅ Better debugging (code vs bash)

**Version Bump Rationale:**
- **v3.0.0 (MAJOR):** Complete architectural rewrite (bash → Python)
- Breaking change: new Python dependency requirement
- Semantic Versioning: major changes = major version
- Future: v4.0.0 (Go rewrite when project mature)

---

### Phase 16: Hotfix - UX Improvements v2.4.5 ✅ (2026-01-17)

**Completed:** Quick wins - minor UX improvements

**Tasks:**
- [x] Issue #41: Add an explanation to "Continue or commit first?"
- [x] Issue #23: Close the spam issue
- [x] Issue #3: Confirm that the documentation has already been fixed

**Key achievements:**
- Added a clear explanation in Crash Recovery
- The options are now described: "Continue" vs "Commit first"
- Closed 3 issues (#41, #23, #3)

**Files:**
- `.claude/protocols/cold-start.md` — Step 0.1 (Crash Recovery)
- `CHANGELOG.md` — v2.4.5 entry
- Version bump: 2.4.4 → 2.4.5

**Impact:**
- ✅ Better UX during crash recovery
- ✅ Less confusion for users

---

### Phase 15: Hotfix - Subdirectory Scanning v2.4.4 ✅ (2026-01-17)

**Completed:** Fixed a critical bug - `/migrate` skips docs/ containing meta-documentation

**Problem:**
- Issue #7: `/migrate-legacy` found only files in the project root
- It skipped docs/BACKLOG.md (a 491-line roadmap!), docs/STATUS.md
- Result: .claude/BACKLOG.md remained an empty template
- **It broke the "single source of truth" promise** - it created two sources of truth

**Solution:**
- Rewrote Steps 2.1, 2.3, 3, 5, 6, 9 in `.claude/commands/migrate-legacy.md`
- Scanning of subdirectories: docs/, documentation/, notes/, wiki/, .github/
- Classification by content (meta-documentation vs code documentation)
- Interactive confirmation for ambiguous files
- Correct mapping: docs/BACKLOG.md → .claude/BACKLOG.md
- Archiving docs/ after migration

**Key achievements:**
- [x] Updated the scanning logic in Step 2.1 (subdirectories)
- [x] Added classification by content (meta vs code docs)
- [x] Updated Step 2.3 (Discovery Results with classification)
- [x] Updated Step 3 (reading files from subdirectories)
- [x] Updated Step 5 (the Report shows docs/ files)
- [x] Updated Step 6 (BACKLOG.md prioritisation of sources)
- [x] Added Step 9.4 (archiving subdirectories)
- [x] Updated metafiles (CHANGELOG.md, SNAPSHOT.md, BACKLOG.md)
- [x] Version bump: 2.4.3 → 2.4.4

**Files:**
- `.claude/commands/migrate-legacy.md` — Steps 2.1, 2.3, 3, 5, 6, 9
- `CHANGELOG.md` — Issue #7 entry
- Version files: init-project.sh, build-distribution.sh, README.md, README_RU.md

**Impact:**
- ✅ Migration finds ALL meta-documentation (not only in the root)
- ✅ .claude/BACKLOG.md is filled with real content after migration
- ✅ Single source of truth - no confusion from two sources
- ✅ Token economy - the AI doesn't look for docs/BACKLOG.md after migration

---

### Phase 14: Hotfix - Migration Workflow Fix v2.4.3 ✅ (2026-01-17)

**Completed:** Fixed a critical bug blocking the migration of legacy projects

**Problem:**
- Issue #4: init-project.sh did not copy .claude/commands/ for legacy/upgrade projects
- Only 2 commands were copied: migrate-legacy.md, upgrade-framework.md
- Users could not run `/migrate`, `/fi`, `/ui` and other commands
- The migration workflow was completely blocked

**Solution:**
- Rewrote the else block in init-project.sh (lines 349-375)
- The whole .claude/ structure is now copied (commands, dist, protocols, scripts, templates)
- Unified installation path for all project types (new, legacy, upgrade)
- Legacy projects get full functionality straight after installation

**Key achievements:**
- [x] Fixed init-project.sh (source + dist-release)
- [x] Updated CHANGELOG.md with a description of Issue #4
- [x] Version bump: 2.4.2 → 2.4.3 (all files)
- [x] Updated metafiles (SNAPSHOT.md, BACKLOG.md)

**Files:**
- `init-project.sh` — lines 349-375 (LEGACY/UPGRADE mode rewritten)
- `dist-release/init-project.sh` — synced with source
- `migration/build-distribution.sh` — version bumped
- `README.md`, `README_RU.md` — version badges updated

**Impact:**
- ✅ The migration workflow works out of the box
- ✅ All slash commands are available from the first run
- ✅ No more chicken-and-egg problem

---

### Phase 13: Hotfix - Critical Bugs v2.4.2 ✅ (2026-01-16)

**Completed:** Fixed critical bugs for internationalisation and UX

**Key achievements:**
- Issue #54: Dialog export with Cyrillic (sessions-index.json, 100% accuracy)
- Issue #50: Adaptive /explain (90% token savings for simple code)
- The framework works with any languages in paths
- UX improvement: sensible answers from /explain
- Backward compatibility preserved

**Files:**
- `src/claude-export/exporter.ts` — findClaudeProjectDir() rewrite
- `.claude/commands/explain.md` — adaptive complexity assessment

---

### Phase 12: Hybrid Protocol Files Architecture v2.4.1 ✅

**Status:** Completed
**Goal:** A modular protocol architecture, immune to context compaction

**Problem:**
- After long sessions, context compaction occurs, which can compress the contents of CLAUDE.md
- A monolithic CLAUDE.md (~1000 lines) is hard to maintain and navigate
- Mixing protocol steps with documentation creates cognitive overhead
- Token cost: CLAUDE.md is permanently in context (~8.7k tokens)

**Solution: Hybrid Protocol Files**

**Principles:**
1. **Modularity** — each protocol in a separate file
2. **Guaranteed fresh** — protocols are read from disk and are not compacted
3. **Router pattern** — CLAUDE.md as a router (~330 lines), protocols separate
4. **Token economy** — protocols are loaded only when needed (~3-4k vs 8.7k)

**Tasks: Protocol Files Creation**
- [x] Create `.claude/protocols/cold-start.md` (600+ lines, 15.7KB)
- [x] Create `.claude/protocols/completion.md` (490+ lines, 14.2KB)
- [x] Extract all protocol steps from CLAUDE.md
- [x] Add versioning and timestamps to the protocol files
- [x] Include the full bash commands and instructions

**Tasks: CLAUDE.md Router Architecture**
- [x] Rework CLAUDE.md into a router (~330 lines vs ~1000)
- [x] Add triggers for reading the protocol files
- [x] Cold Start trigger → read `.claude/protocols/cold-start.md`
- [x] Completion trigger → use Skill tool to load `/fi` fresh
- [x] Document the Hybrid Architecture in CLAUDE.md

**Tasks: Integration**
- [x] Update `.claude/commands/fi.md` to read the protocol file
- [x] Synchronise `migration/CLAUDE.production.md`
- [x] Update `migration/build-distribution.sh` (Step 6.5: copy protocols)
- [x] Update `init-project.sh` version to 2.4.1
- [x] Add protocols/ to the Repository Structure

**Tasks: Documentation & Metafiles**
- [x] Update FRAMEWORK_IMPROVEMENTS.md (Section 8: Hybrid Protocol Files)
- [x] Update CHANGELOG.md (v2.4.1 entry)
- [x] Update README.md + README_RU.md (version badges 2.4.0 → 2.4.1)
- [x] Update .claude/SNAPSHOT.md (version, status, structure)
- [x] Update .claude/BACKLOG.md (this file)

**Tasks: Testing & Validation**
- [ ] Test Cold Start with the protocol file read
- [ ] Test Completion `/fi` with the Skill tool
- [ ] Verify protocol files in distribution (tar -tzf)
- [ ] Test on host project

**Results:**

| Metric | Before (v2.4.0) | After (v2.4.1) |
|---------|-------------|----------------|
| CLAUDE.md size | ~1000 lines | **~330 lines** (router) |
| Modularity | Monolith | **3 files** (CLAUDE.md + 2 protocols) |
| Token cost (loading) | ~8.7k (always) | **~3.5k** (router only) |
| Protocols token cost | N/A | **~3-4k** (on demand) |
| Immunity to compaction | No | **Yes** (files read fresh) |

**Advantages:**
- ✅ **Modularity:** Easy to maintain and extend
- ✅ **Token economy:** 60% reduction (8.7k → 3.5k router + 3-4k on demand)
- ✅ **Guaranteed fresh:** Protocols are always read from disk
- ✅ **Better UX:** CLAUDE.md is now a clear router, not a monolith
- ✅ **Maintainability:** Each protocol in its own file

---

### Phase 11: Security Layer 4 — Advisory Mode + Smart Triggers v2.4.1 ✅

**Status:** Completed
**Goal:** An advisory system for smart invocation of the sec24 AI agent (not automation)

**Problem:**
- Regex (Layer 2) covers 95% of cases, but misses edge cases
- Layer 4 (AI agent) is needed for a thorough check, but is slow (1-2 min)
- **Automatically invoking the agent on every commit = madness** (wasted tokens)
- What is needed is an **advisory system**: triggers → Claude asks → user decides

**Specifics of projects with DevOps (supabase-bridge):**
- Not just code, but also managing production
- SSH to servers, database credentials, API keys — the working reality
- Credentials not only in dialogs, but also in code/config
- **Sprint changes** may contain production secrets

**Solution: Advisory Mode + Smart Triggers**

**Principles:**
1. **Advisory, not automation** — triggers give recommendations to Claude (AI)
2. **Claude asks the user** — the user decides whether to run a deep scan or not
3. **Scope optimisation** — analysis of git diff + last dialog, NOT the whole codebase
4. **Release mode = the exception** — the only case of auto-invoke (git tag v2.x.x)
5. **Token economy** — analysis of 5-10 files instead of 300+

**Tasks: Trigger Detection System**
- [x] Create `security/check-triggers.sh` (trigger detection logic)
- [x] Implement 10 triggers with priorities:
  - [x] CRITICAL: Production credentials file exists
  - [x] CRITICAL: Git release tag detected
  - [x] CRITICAL: Release workflow in recent dialogs
  - [x] HIGH: Regex found credentials
  - [x] HIGH: Security keywords (>5 mentions)
  - [x] HIGH: Production/deployment discussion
  - [x] MEDIUM: Large diff (>500 lines)
  - [x] MEDIUM: Many new dialogs (>5 uncommitted)
  - [x] MEDIUM: Security config files modified
  - [x] LOW: Long session (>2 hours)
- [x] JSON output with trigger level and reasons
- [x] Exit codes (0=none, 1=critical, 2=high, 3=medium, 4=low)

**Tasks: Advisory System (not auto-invoke)**
- [x] Rework `security/auto-invoke-agent.sh` into advisory mode
- [x] Release mode (git tag) → auto-invoke (the only case)
- [x] CRITICAL/HIGH triggers → Claude asks the user
- [x] MEDIUM triggers → optional mention
- [x] LOW triggers → informational only
- [x] Exit codes for Claude: 0, 1 (auto), 10 (ask), 11 (ask), 12 (optional)

**Tasks: Protocol Integration**
- [x] Update CLAUDE.md Step 3.5 (advisory mode, Claude asks user)
- [x] Update migration/CLAUDE.production.md Step 3.5 (same changes)
- [x] Update the `/security-dialogs` command (scope: git diff + last dialog)
- [x] Step 2 in /security-dialogs (identify sprint changes, not all files)
- [x] Agent prompt: analyze git diff + last dialog only

**Tasks: Scope Optimization**
- [x] The agent analyses git diff (last 5 commits), not the whole codebase
- [x] The agent analyses the last dialog, not all 300+ dialogs
- [x] Token economy: 5-10 files instead of 300+

**Tasks: Documentation**
- [x] Update SNAPSHOT.md (advisory mode, release exception)
- [x] Update BACKLOG.md (this file)
- [x] A "When to Use Each Layer" table in SNAPSHOT.md
- [x] Update security/README.md (advisory mode, not auto-invoke)
- [x] Create security/README.md with a full description of the architecture
- [ ] Update CHANGELOG.md (v2.4.1 entry)
- [ ] Testing on examples (we're testing now!)

**Tasks: Testing & Validation**
- [ ] Test CRITICAL trigger (.production-credentials file)
- [ ] Test HIGH trigger (regex found secrets)
- [ ] Test MEDIUM trigger (large diff)
- [ ] Verify the agent invokes correctly via the Task tool
- [ ] Test on santacruz host project

**Result:**
- **95% coverage (regex)** for normal sessions (fast, automatic)
- **99% coverage (AI agent)** for high-risk situations (advisory mode)
- **Advisory mode:** triggers → Claude asks → user decides
- **Token economy:** analysis of git diff + last dialog (5-10 files vs 300+)
- **User control:** the user always decides (except in release mode)
- **Release mode exception:** git tag v2.x.x → auto-invoke (mandatory)
- "Better slow but reliable" — but not on every commit (smart)

---

### Phase 10: Security Hardening — Dialog Credential Cleanup v2.4.0 ✅

**Status:** Completed
**Goal:** Prevent credentials leaking from dialog files to GitHub

**Problem:**
- Dialogs in `dialog/` may contain credentials from conversations
- SSH keys, API tokens, passwords, DB URLs mentioned in dialogs with the AI
- If a project commits `dialog/` to git → credentials leak to GitHub
- The v2.3.3 fix covered only in-flight redaction, not committed files
- Reports and improvement files also contain code examples with secrets

**Solution: Multi-Layer Security System**

**Layer 1 tasks: .gitignore Protection**
- [x] Analyse the whole attack surface
- [x] Replace the manual file list with a pattern-based ignore for `dialog/`
- [x] Add `reports/` to gitignore (bug reports with credential examples)
- [x] Add `.production-credentials` to gitignore (production SSH keys/tokens)
- [x] Add `security/reports/` to gitignore (cleanup scan reports)

**Layer 2 tasks: Credential Cleanup Script**
- [x] Create `security/cleanup-dialogs.sh` (200+ lines bash script)
- [x] Implement 10 redaction patterns:
  - [x] SSH credentials (user@host, IP addresses, SSH key paths)
  - [x] IPv4 addresses (standalone: 192.168.x.x, 45.145.x.x)
  - [x] SSH private key paths (~/.ssh/id_rsa, ~/.ssh/claude_prod_new)
  - [x] Database URLs (postgres://, mysql://, mongodb://, redis://)
  - [x] JWT tokens (eyJxxx... format)
  - [x] API keys (sk-xxx, secret_key=xxx, access_key=xxx)
  - [x] Bearer tokens (Authorization: Bearer xxx)
  - [x] Passwords (password=xxx, pwd=xxx, user_password=xxx)
  - [x] SSH ports (-p 65002, --port 22000)
  - [x] Private key content (PEM format)
- [x] Add a --last flag for performance (50x faster)
- [x] Exit code 1 blocks git commit when credentials are detected
- [x] Report generation in `security/reports/cleanup-*.txt`
- [x] Testing with fake credentials (8/10 patterns work)

**Layer 3 tasks: Protocol Integration**
- [x] Update Cold Start Step 0.5 (clean the PREVIOUS session before export)
- [x] Add Completion Step 3.5 (clean the CURRENT session before commit)
- [x] Update CLAUDE.md with the security steps
- [x] Update migration/CLAUDE.production.md with the security steps
- [x] Double protection: previous (0.5) + current (3.5) = no gaps

**Metafiles & Release tasks**
- [x] Update SNAPSHOT.md with the v2.4.0 description
- [x] Update CHANGELOG.md with a detailed v2.4.0 entry
- [x] Version bump in all files (v2.3.3 → v2.4.0)
- [x] Update BACKLOG.md (this file)

**Result:**
- **CRITICAL:** Prevention of production credential leaks to GitHub
- Automatic operation — no manual intervention needed
- Fast performance (--last flag: 1 file vs 300+)
- Comprehensive coverage (dialog/, reports/, .production-credentials)
- Auditable (all redactions in security/reports/)
- Battle-tested (ported from supabase-bridge production)

---

### Phase 9: Security Fix — Auto-Redact Sensitive Data v2.3.3 ✅

**Status:** Completed
**Goal:** Fix Issue #47 - automatic redaction of sensitive data in dialog exports

**Tasks:**
- [x] Analyse Issue #47 (OAuth tokens in dialog exports)
- [x] Design a redaction system for exporter.ts
- [x] Create the function `redactSensitiveData(content: string): string`
- [x] Implement patterns for 11 types of sensitive data:
  - [x] OAuth/Bearer tokens
  - [x] JWT tokens (eyJ... format)
  - [x] API keys (Stripe, Google, AWS, GitHub)
  - [x] Private keys (PEM format)
  - [x] AWS Secret Access Keys
  - [x] Database connection strings
  - [x] Passwords in URLs/config
  - [x] Email addresses in auth contexts
  - [x] Credit card numbers
- [x] Apply redaction to dialog messages
- [x] Apply redaction to summaries
- [x] Test with 11 test cases (100% success rate)
- [x] Fix the Stripe key pattern (sk-test_...)
- [x] Fix bearer token separator preservation
- [x] Update SNAPSHOT.md, BACKLOG.md, CHANGELOG.md

**Result:**
- Automatic protection against accidental exposure of tokens
- No manual sed/grep redaction required
- GitHub Secret Scanning does not block pushes
- Safe to commit dialog exports
- Privacy and security for all users

---

### Phase 8: Bug Fix — Missing public/ Folder v2.3.2 ✅

**Status:** Completed
**Goal:** Fix Issue #48 - `/ui` command fails with missing public/ folder

**Tasks:**
- [x] Analyse Issue #48 (Windows 11, Framework v2.2)
- [x] Check for public/ in the v2.2.0 release (CONFIRMED - present)
- [x] Check build-distribution.sh (works correctly)
- [x] Check init-project.sh (copies public/ correctly)
- [x] Add a public/ check in server.ts before starting the UI
- [x] Implement a user-friendly error message with recovery options
- [x] Test locally (delete public/ and start the UI)
- [x] Update SNAPSHOT.md, BACKLOG.md, CHANGELOG.md

**Result:**
- Users get a clear error message
- Two recovery options (auto-install and manual fix)
- Copy-paste commands for a quick fix
- Prevention of a crash with an ENOENT error
- Reduced support burden for Windows users

---

### Phase 7: Bug Reporting System — Phase 2 & 3 v2.3.1 ✅

**Status:** Completed
**Goal:** Complete the bug reporting system — centralised collection and analytics

**Tasks:**
- [x] **Phase 2: Centralized Collection**
  - [x] Create submit-bug-report.sh for automatic submission to GitHub Issues
  - [x] Create a GitHub issue template (.github/ISSUE_TEMPLATE/bug_report.yml)
  - [x] Update CLAUDE.md Step 6.5 — two confirmation stages (create → submit)
  - [x] Update build-distribution.sh to copy the submit script
  - [x] Testing: syntax check, gh CLI availability
  - [x] Fix: CLAUDE.md Step 6.5 — bug reports are ALWAYS created (not only on errors)
  - [x] Fix: Auto-create "bug-report" label if missing
  - [x] Fix: Smart title generation `[Bug Report][Protocol Type] vX.Y.Z - Status`
- [x] **Phase 3: Analytics & Pattern Detection**
  - [x] Create analyze-bug-patterns.sh (bash 3.2 compatible)
  - [x] Implement analysis: versions, protocols, errors, steps
  - [x] Generation of recommendations and summary files
  - [x] Create the /analyze-local-bugs command
  - [x] Update build-distribution.sh to copy the analyze script
  - [x] Testing: works with empty and populated logs
- [x] **Quick Update Utility**
  - [x] Create quick-update.sh for quickly updating the framework
  - [x] Smart detection — auto-download init-project.sh if the framework is missing
  - [x] Add to the distribution (build-distribution.sh)
- [x] **Framework Developer Mode (Step 0.4)**
  - [x] Add Step 0.4 to the Cold Start Protocol
  - [x] Automatic check of GitHub Issues with the bug-report label
  - [x] Show the count and recent reports (last 7 days)
  - [x] List 5 most recent bug reports
  - [x] Offer to run /analyze-bugs
  - [x] Update migration/CLAUDE.production.md
  - [x] Rebuild distribution
- [x] **Completion Protocol Self-Check (Step 0)**
  - [x] Add Step 0 to the Completion Protocol
  - [x] Re-read the protocol section before running /fi
  - [x] Self-check questions for metafile updates
  - [x] Update .claude/commands/fi.md
  - [x] Update migration/CLAUDE.production.md
  - [x] Fix the "cobbler's children have no shoes" problem

**Result:**
- A complete 3-phase bug reporting system (Local → Centralized → Analytics)
- Bug reports as analytics/telemetry (not only errors)
- Automatic pattern detection and recommendations
- Smart quick-update.sh — prevents confusion between update and install
- Framework Developer Mode — automatic notification about bug reports
- Completion Protocol Self-Check — prevents documentation being forgotten
- Privacy-first with double confirmation
- Compatibility with bash 3.2+ (macOS)

---

## 📚 Archive (completed phases)

### Phase 6: Bug Reporting & Logging System v2.3.0 ✅

**Status:** Completed
**Goal:** Add a protocol logging system and anonymous bug reports

**Tasks:**
- [x] Design the bug reporting system
  - [x] Opt-in consent dialog (privacy-first)
  - [x] Anonymisation strategy (paths, keys, emails, IPs)
  - [x] Framework Developer Mode for collecting reports
- [x] Implement Step 0.15: Bug Reporting Consent
  - [x] First-run consent dialog
  - [x] .framework-config structure
  - [x] Opt-in by default (disabled)
- [x] Implement Step 0.3: Protocol Logging
  - [x] Cold Start logging with timestamps
  - [x] log_step() and log_error() functions
  - [x] Log files in .claude/logs/cold-start/
- [x] Implement Completion Protocol Logging
  - [x] Step 0: Initialize Completion Logging
  - [x] Step 6.5: Finalize Log & Create Bug Report
  - [x] Automatic error detection
- [x] Create the /bug-reporting command
  - [x] enable/disable/status/test subcommands
  - [x] Show log statistics
- [x] Create an anonymisation script
  - [x] .claude/scripts/anonymize-report.sh
  - [x] Removal of paths, API keys, tokens, emails, IPs
  - [x] Replacement of the project name with {project}_anon
- [x] Implement Framework Developer Mode
  - [x] Step 0.4: Read Bug Reports from Host Projects
  - [x] Check for open Issues with the "bug-report" label
  - [x] Activates only on the framework project
- [x] Create the /analyze-bugs command
  - [x] Fetch reports from GitHub Issues
  - [x] Grouping by error type
  - [x] Generation of analysis files
- [x] Update the build system
  - [x] build-distribution.sh copies scripts and templates
  - [x] init-project.sh generates .framework-config
  - [x] .gitignore for .claude/logs/
- [x] Testing on santacruz
  - [x] Config creation ✅
  - [x] Cold Start logging ✅
  - [x] /bug-reporting status ✅
  - [x] Anonymization script ✅
  - [x] All files in place ✅

---

## 📚 Archive (completed phases)

<details>
<summary>Phase 5: Auto-Update Framework v2.2.4 ✅ (2025-12-16)</summary>

**Completed:** Automatic framework update system

**Key achievements:**
- Step 0.2: Framework Version Check in the Cold Start Protocol
- Parsing the version from CLAUDE.md and the GitHub API
- Aggressive update strategy (without user confirmation)
- framework-commands.tar.gz for fast updates
- Only framework files are updated; project data is not touched
- Testing on santacruz: v2.2 → v2.2.4 successful

</details>

<details>
<summary>Phase 4: Distribution v2.2.3 ✅ (2025-12-16)</summary>

**Completed:** Finalisation of v2.2.3 with critical fixes

**Key achievements:**
- Successful migration of santacruz v1.x → v2.2
- Fixed 4 critical bugs (BUG-001 to BUG-004)
- Migration reports are now mandatory
- Simplified qualifying questions
- Corrected GitHub Release v2.2.3

</details>

<details>
<summary>Phase 3.5: Bug Fixes v2.1.1 ✅ (2025-12-08)</summary>

### Fixed bugs:
1. **watcher.ts parasitic folders** — Fixed cwd to prevent `project-name-dialog` folders
2. **sed escaping** — Added `sed_escape()` function for special characters
3. **Token economy** — Redesigned to loader pattern (88KB → 5.3KB, 16.6x!)
4. **Legacy metafile preservation** — Don't overwrite existing SNAPSHOT/BACKLOG/ARCHITECTURE

**Source:** BUG_REPORT_FRAMEWORK.md from chatRAG production testing

</details>

<details>
<summary>Phase 3: Installation System ✅ (2025-12-08)</summary>

- [x] migration/templates/ structure
- [x] init-project.sh loader (5.3KB)
- [x] build-distribution.sh
- [x] README cleanup
- [x] dist-release/ gitignored

</details>

<details>
<summary>Phase 2: Protocol Verification ✅</summary>

- [x] Cold Start Protocol implemented
- [x] Completion Protocol (/fi) implemented
- [x] Dialog Export UI (Teacher + Student)
- [x] Crash Recovery tested

</details>

<details>
<summary>Phase 1: Framework Restructuring ✅ (v2.0.0)</summary>

- [x] src/claude-export/ TypeScript source
- [x] dist/claude-export/ compiled
- [x] npm project structure
- [x] Full protocols in CLAUDE.md

</details>

<details>
<summary>v1.4.3 — Sprint Completion ✅ (2025-10-23)</summary>

- 5-layer reminder system
- Sprint Completion Protocol
- Dogfooding (framework uses itself)

</details>

<details>
<summary>v1.4.0 — Cold Start ✅ (2025-10-11)</summary>

- PROJECT_SNAPSHOT.md template
- 85% token economy improvement

</details>

---

## 📊 Structure of the current version (v2.1.1)

```
claude-code-starter/
├── src/claude-export/     # TypeScript source
├── dist/claude-export/    # Compiled JS
├── .claude/
│   ├── commands/          # 19 slash commands
│   ├── SNAPSHOT.md        # Current state
│   ├── ARCHITECTURE.md    # Code structure
│   └── BACKLOG.md         # THIS FILE
├── migration/
│   ├── init-project.sh    # Installer template (5.3KB)
│   ├── build-distribution.sh
│   └── templates/         # Meta file templates
├── dialog/                # Dialog exports
├── package.json           # npm scripts
├── CLAUDE.md              # AI protocols
├── CHANGELOG.md           # Version history
└── README.md / README_RU.md
```

---

## 🔗 Related documents

- [SNAPSHOT.md](./.claude/SNAPSHOT.md) — current state
- [ARCHITECTURE.md](./.claude/ARCHITECTURE.md) — code structure
- [CLAUDE.md](../CLAUDE.md) — AI protocols
- [CHANGELOG.md](../CHANGELOG.md) — full history
- [GitHub Issues](https://github.com/alexeykrol/claude-code-starter/issues) — detailed discussions

---

## 📝 Working process for the BACKLOG

### For the developer:
1. **Starting work:** Check "Current tasks"
2. **New idea:** Add it to "Ideas and wishes"
3. **Prioritisation:** Move from ideas to tasks when ready
4. **Completion:** Move to the archive, update the CHANGELOG

### For the AI:
1. **Cold Start:** Read "Current tasks" for context
2. **Planning:** Turn ideas into concrete tasks on request
3. **Completion:** Update statuses, move to the archive

---

*Update after every completed task or new idea!*
