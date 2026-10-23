# Commit Policy — What may be committed?

**Goal:** Protection against accidental leaks of confidential information into git.

**How it works:** Claude AI reads this file before every commit and checks the changes.

---

## ❌ NEVER commit (blocked automatically)

### 1. Internal development kitchen

```
notes/                  # Personal notes, TODO lists
scratch/                # Drafts, experiments
experiments/            # Experiments and tests
WIP_*                   # Work-in-progress files
INTERNAL_*              # Internal documents
DRAFT_*                 # Drafts
```

**Why:** This is your personal kitchen, not for the public/team.

### 2. Framework logs and dialogs (CRITICAL!)

```
dialog/                 # Claude dialogs (may contain credentials!)
.claude/logs/           # Framework execution logs
*.debug.log             # Debug logs
debug/                  # Debug files
reports/                # Bug reports and migration logs (already in GitHub Issues)
```

**Why:** Dialogs may contain mentions of passwords, SSH keys and API tokens in discussions. Bug reports have already been sent to GitHub Issues; local copies are not needed in git.

### 2.1 Framework internal development files

```
BUGS_FIXED_*.md                 # Bug fix documentation (internal)
BUG_FIX_SUMMARY.md              # Bug fix summaries (internal)
COMMIT_POLICY_FIX_SUMMARY.md    # Commit policy fixes (internal)
commit-policy-missing-*.md      # Policy violation reports (internal)
framework-version-*.md          # Version issue reports (internal)
```

**Why:** These files are internal documentation of the framework's development. Bug reports are sent to GitHub Issues; local markdown reports are not needed in the public repository.

### 3. Technical files

```
*.local.*               # Local configs (config.local.js etc.)
.env.local              # Local environment variables
.vscode/                # IDE settings (personal)
.idea/                  # IDE settings (personal)
*.swp, *.swo            # Vim temporary files
.DS_Store               # macOS clutter
```

**Why:** Local configuration and IDE settings are individual.

### 4. Generated files (if not required)

```
dist/                   # Build output (if not needed in the repo)
build/                  # Build output
node_modules/           # Dependencies (already in .gitignore)
*.log                   # Logs
coverage/               # Test coverage reports
```

**Why:** They are generated automatically and bloat the repo.

### 5. Sensitive data

```
secrets/                # Secrets
credentials/            # Credentials
*.key                   # Private keys
*.pem                   # SSL certificates
.production-credentials # Production credentials
backup/                 # Backup files (may contain data)
```

**Why:** CRITICAL — never commit credentials!

---

## ✅ ALWAYS commit (approved automatically)

### 1. Source code

```
src/                    # Source code
lib/                    # Libraries
tests/                  # Tests
```

### 2. Public documentation

```
README.md               # Project README
README_*.md             # Localized READMEs
CHANGELOG.md            # Version history
LICENSE                 # License file
```

### 3. Project configuration

```
package.json            # npm config
tsconfig.json           # TypeScript config
.eslintrc.*             # Linter config
.prettierrc.*           # Formatter config
```

### 4. Framework metafiles (public)

```
.claude/ARCHITECTURE.md # If this is a public project
.gitignore              # Git ignore rules
```

---

## ⚠️ ASK THE USER (requires confirmation)

### 1. New folders/files not in the lists above

**Criteria:**
- A new folder that is not in "NEVER" or "ALWAYS"
- The file name contains: `api-key`, `password`, `secret`, `prod`, `production`
- The file is >1000 lines (may be generated)

**What Claude does:**
Shows the list of files and asks: "These files are not in COMMIT_POLICY. Add to commit? (y/N)"

---

## 🔧 Customising for your project

### Add rules specific to your project:

**Example for a business project:**
```markdown
## ❌ NEVER (your project):

business-plans/         # Business plans
competitors/            # Competitor analysis
clients/                # Client information
financial/              # Financial documents
```

**Example for an open-source project:**
```markdown
## ✅ ALWAYS (open-source):

docs/                   # Documentation
examples/               # Code examples
.github/                # GitHub config (workflows, templates)
```

---

## 🔄 Synchronisation with .gitignore

**IMPORTANT:** Everything in the "NEVER" section must be in `.gitignore`!

**Check:** Claude automatically checks the synchronisation when `/fi` is run.

**The current .gitignore includes:**
```
# Internal development (from COMMIT_POLICY)
notes/
scratch/
experiments/
WIP_*
INTERNAL_*
DRAFT_*

# Framework logs and dialogs (CRITICAL!)
dialog/
.claude/logs/
reports/

# Framework internal development files
BUGS_FIXED_*.md
BUG_FIX_SUMMARY.md
COMMIT_POLICY_FIX_SUMMARY.md
commit-policy-missing-*.md
framework-version-*.md

# Sensitive data
secrets/
credentials/
*.key
*.pem
.production-credentials
backup/
```

---

## 📊 How this works in the Completion Protocol

**Step 4 (Git Commit):**

1. Claude reads this file
2. Gets the list of changed files (`git status --short`)
3. Checks the patterns for each file:
   - If the file is in "NEVER" → does **NOT** add it to the commit
   - If the file is in "ALWAYS" → adds it to the commit
   - If the file is in "ASK" → asks the user
4. Stages only permitted files (NOT `git add -A`!)
5. Shows `git status` for review
6. Asks for confirmation
7. Creates the commit

**Protection:** A pre-commit hook blocks the commit if forbidden files still slip through.

---

## 🚨 What to do if Claude gets it wrong?

**If Claude tries to commit something from "NEVER":**
1. Say "No"
2. Update this file (add the pattern)
3. Repeat `/fi`

**If Claude does NOT commit a file you need:**
1. Add the pattern to the "ALWAYS" section
2. Or confirm manually when Claude asks

---

## 📝 Change history

**v2.5.0 (2026-01-17):**
- First version of COMMIT_POLICY.md
- Replaced `git add -A` with selective staging
- Added a pre-commit hook for protection

---

**Edit this file to suit your project!**
**This is your protection against accidental leaks.**
