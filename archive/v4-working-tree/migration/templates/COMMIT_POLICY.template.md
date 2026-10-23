# Commit Policy — What may be committed?

**Goal:** Protection against accidental leakage of confidential information into git.

**How it works:** Claude AI reads this file before every commit and checks the changes.

---

## ❌ NEVER commit (blocked automatically)

### 1. Internal development kitchen

```
notes/                  # Personal notes, TODO lists
scratch/                # Drafts, experiments
experiments/            # Experiments and tests
WIP_*                   # Work in progress files
INTERNAL_*              # Internal documents
DRAFT_*                 # Drafts
```

### 2. Framework logs and dialogs (CRITICAL!)

```
dialog/                 # Claude dialogs (may contain credentials!)
.claude/logs/           # Framework execution logs
*.debug.log             # Debug logs
debug/                  # Debug files
reports/                # Bug reports and migration logs (already in GitHub Issues)
```

### 3. Technical files

```
*.local.*               # Local configs
.env.local              # Local environment variables
.vscode/                # IDE settings (personal)
.idea/                  # IDE settings (personal)
```

### 4. Sensitive data

```
secrets/                # Secrets
credentials/            # Credentials
*.key                   # Private keys
*.pem                   # SSL certificates
.production-credentials # Production credentials
backup/                 # Backup files
```

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
CHANGELOG.md            # Version history
LICENSE                 # License file
```

### 3. Project configuration

```
package.json            # npm config
tsconfig.json           # TypeScript config
.gitignore              # Git ignore rules
```

---

## ⚠️ ASK THE USER (requires confirmation)

- New folders not in the lists above
- Names containing: `api-key`, `password`, `secret`, `prod`
- Files >1000 lines

---

## 🔧 Customising for your project

**Add your rules here:**

```markdown
## ❌ NEVER ({{PROJECT_NAME}}):

# Add folders/files specific to your project
# Example:
# business-plans/
# internal-docs/
```

---

**Edit this file to suit your project!**
