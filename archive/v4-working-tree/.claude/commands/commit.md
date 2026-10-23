---
description: Create a git commit with a proper message
---

Create a git commit following best practices.

**IMPORTANT: DO NOT use git add . thoughtlessly!**

## Process:

### 1. Analyse the changes
Run in parallel:
- `git status` - look at all changed files
- `git diff` - look at unstaged changes
- `git diff --staged` - look at staged changes
- `git log --oneline -n 5` - look at recent commits for style

### 2. Check what must not be committed
❌ DO NOT add to the commit:
- `.env` or `.env.local` (secrets!)
- `node_modules/`
- `dist/`, `build/`, `.next/` (build artefacts)
- Files with secrets (credentials.json, secrets.yaml, etc.)
- Temporary files (*.log, *.tmp, .DS_Store)

⚠️ If the user explicitly asks to commit these files - warn them about the risks!

### 3. Add the required files
Add files **individually** or in groups, NOT `git add .`:
```bash
git add path/to/file1.ts path/to/file2.ts
```

Or by pattern:
```bash
git add src/**/*.ts
```

### 4. Compose the commit message

**Format:**
```
<type>: <short description> (up to 50 characters)

<detailed description - WHY, not WHAT>
- Reason for the change
- What problem it solves
- Important details

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Types:**
- `feat`: new functionality
- `fix`: bug fix
- `refactor`: refactoring without changing functionality
- `docs`: documentation
- `style`: formatting, semicolons
- `test`: adding tests
- `chore`: dependency updates, CI configuration

**Examples of good messages:**
```
feat: add user authentication with JWT

Implement JWT-based authentication to secure API endpoints.
- Add login/logout endpoints
- Create auth middleware for protected routes
- Store tokens in httpOnly cookies for security

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

```
fix: prevent memory leak in useEffect cleanup

Users reported app slowdown after long sessions. Root cause
was missing cleanup in dashboard useEffect hook.
- Add cleanup function to WebSocket subscription
- Clear intervals on component unmount

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

### 5. Create the commit
Use a HEREDOC for correct formatting:

```bash
git commit -m "$(cat <<'EOF'
<type>: <short description>

<detailed description>

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### 6. Check the result
```bash
git log -1 --stat
```

## ⚠️ Pre-commit hook
If the commit failed because of a pre-commit hook:
1. Look at what changes the hook made
2. If the hook only formatted the code - amend:
   ```bash
   git add <changed files>
   git commit --amend --no-edit
   ```

## 🔐 Security check
Before committing, ALWAYS check:
- [ ] No hardcoded secrets (API keys, passwords, tokens)
- [ ] .env files are in .gitignore
- [ ] No confidential data in logs/comments
- [ ] Environment variables are used for secrets

## 📋 Checklist
- [ ] `git status` - checked the changes
- [ ] `git diff` - I understand what I changed
- [ ] Checked the style of recent commits
- [ ] Added ONLY the required files (not `git add .`)
- [ ] Checked for secrets
- [ ] Wrote a meaningful message (why, not what)
- [ ] Added Co-Authored-By: Claude
- [ ] `git log -1` - checked the result

## 🚫 DO NOT:
- ❌ `git add .` without checking what you are adding
- ❌ Commit .env files
- ❌ Vague messages ("fix", "update", "changes")
- ❌ Commit commented-out code
- ❌ Commit TODO comments without context
- ❌ `--no-verify` (skipping hooks) without the user's explicit instruction

**If the user has not specified what to commit - ask them!**
