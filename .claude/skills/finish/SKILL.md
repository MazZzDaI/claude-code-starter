---
name: finish
description: "End the working session. Tests, commit, SNAPSHOT update, report."
allowed-tools: Read Edit Write Glob Grep Bash
disable-model-invocation: true
---

# Skill: Finish Session

## What to do

### 1. Run the tests

If the project has tests:
```bash
# Detect the project type and run the tests
if [ -f "package.json" ]; then
  npm test 2>&1 || true
elif [ -f "pytest.ini" ] || [ -f "pyproject.toml" ] || [ -d "tests" ]; then
  python3 -m pytest tests/ 2>&1 || true
fi
```

If the tests fail:
- Try to fix them (up to 3 attempts, autonomously)
- If that fails — commit the code, but record in SNAPSHOT.md that the tests are red and what exactly is failing
- Don't block the whole finish because of a failing test

### 2. Check git status

```bash
git status --short
git diff --stat
```

### 3. Commit the changes (per the Commit Policy)

If there are uncommitted changes — follow the `commit-policy.md` rule:

1. For each file, determine its category:
   - **Forbidden** (.env, *.key, *.db, node_modules/ etc.) → make sure it is in `.gitignore`; if not — add it automatically
   - **Allowed** (src/, tests/, CLAUDE.md, package.json etc.) → stage
   - **Everything else** → decide by context, without asking the user
2. `git add` only the allowed files (by name, not `git add .`)
3. Write a descriptive commit message
4. git commit

### 4. Update the memory layers

**SNAPSHOT.md** — what is now:
- **Done** — add entries about this session's work
- **In progress** — clear or update
- **Next steps** — what remains
- **Known issues** — if any were found
- **Date** — update the timestamp

**BACKLOG.md** (if present) — what is planned:
- Move closed tasks from Next to done
- Add newly discovered tasks (Next/Soon/Later)
- If the decision is "we won't do it" — move it to Won't do with a one-line reason

**INVARIANTS.md** (if present) — if a new invariant arose in the session, or a violation of an existing one was found:
- Add a new INV-NNN describing the rule, the reason, the check
- This is a signal of maturity — don't skip it

**ARCHITECTURE.md** (if present) — if the system map changed in the session (a new module, new boundaries):
- Update the corresponding section

### 4b. Save the session dialog

Protection against Claude Code's retention cleanup — the dialog may contain valuable methodological findings:
```bash
[ -f scripts/save-dialogs.sh ] && bash scripts/save-dialogs.sh || true
```
Without a note (a quick autosave). If something particularly valuable happened in the session, the user can manually run `/save-dialog` with a note before or after `/finish`.

### 5. Commit the updated layers

```bash
# Check the framework state mode
scripts/framework-state-mode.sh check-safe-mode

# Only private-solo commits memory layers into the git history.
if [ "$(scripts/framework-state-mode.sh should-commit-framework-state)" = "true" ]; then
  for f in .claude/SNAPSHOT.md .claude/BACKLOG.md .claude/INVARIANTS.md .claude/ARCHITECTURE.md; do
    [ -f "$f" ] && git add "$f"
  done
  git diff --cached --quiet || git commit -m "docs: update memory layers after session"
else
  echo "Memory layers kept local due repo_access=$(scripts/framework-state-mode.sh repo-access)"
fi
```

In `public`/`private-shared` mode SNAPSHOT stays a local file and is not committed. If the helper reports a blocker because of tracked framework files, first run `scripts/switch-repo-access.sh <mode>`.

### 6. Close the session log

Append to the current file `.claude/logs/sessions/YYYY-MM-DD_HH-MM.md`:
- Test outcomes (passed/failed/skipped)
- The list of the session's commits
- Errors (if any)
- Session duration

### 7. Report to the user

Briefly (5-7 lines):
- What was done during the session
- Test results
- Commit hashes
- What is left for the next session

## What NOT to do

- Don't push automatically (push is a separate decision)
- Don't commit files from the "Always forbidden" list (see commit-policy.md)
- Don't drag finish out beyond 2 minutes
