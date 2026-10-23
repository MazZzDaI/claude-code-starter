---
name: housekeeping
description: "Background project maintenance: keeping README, CHANGELOG, version, .gitignore and meta-files up to date."
allowed-tools: Read Edit Write Glob Grep Bash
disable-model-invocation: true
---

# Skill: Housekeeping

Run at the request of the user or the agent. The agent **must call housekeeping before `git push`** — this is its responsibility, not an automatic hook. It checks and tidies up everything that may have gone stale.

## What to check

### 1. README.md

Read README.md and compare it with the actual state of the project:

- **Project description** — does it match the current functionality?
- **Installation instructions** — are `npm install` / `pip install` up to date? Have the dependencies changed?
- **API / usage** — do the documented endpoints, functions, CLI commands exist in the code?
- **Examples** — do the code examples work?

If the README is out of date — update it automatically. Don't ask the user.

### 2. CHANGELOG.md

If the project has a CHANGELOG.md:

```bash
# Commits since the last entry in CHANGELOG
git log --oneline $(grep -m1 -oP '\d+\.\d+\.\d+' CHANGELOG.md 2>/dev/null | head -1)..HEAD
```

If there are undocumented commits — add a section with the new changes. Format: Keep a Changelog (Added, Changed, Fixed, Removed).

If there is no CHANGELOG.md — create one if the project has more than 10 commits.

### 3. Version

If the project has a `package.json` or `pyproject.toml`:

- Check: were there breaking changes (new/removed APIs, interface changes)?
- If so → bump minor or major
- If only fixes → bump patch
- Update the version in package.json / pyproject.toml

Don't publish. Only update the number.

### 4. .gitignore audit

Check `git status` for files that, per commit-policy, should be in `.gitignore`:

```bash
# Check tracked files for forbidden patterns
git ls-files | grep -E '\.(env|key|pem|db|sqlite)$'
git ls-files | grep -E '^(node_modules|__pycache__|dist|build)/'
```

If any are found — `git rm --cached`, add them to `.gitignore`.

### 5. Framework meta-files

- `.claude/SNAPSHOT.md` — is the update date no older than the last commit?
- `manifest.md` — are project_name and repo_access filled in?

If SNAPSHOT is out of date — update it. If the manifest is empty — fill it in based on an analysis of the project (basename → project_name, git remote → repo_access).

### 6. Drift detection

Compare what is described in the documentation with what actually exists in the code:

```bash
# Example: functions mentioned in README but missing from the code
# Endpoints described in docs/ but not existing in src/
```

If drift is detected — fix the documentation automatically.

## When to run

- **Before push** — the agent is obliged to call housekeeping before `git push` (this is an agent rule, not an automatic hook)
- **On request** — the user says "tidy up" or "housekeeping"
- **On /finish** — if finish includes a push

## What NOT to do

- Don't change the project's code — only documentation and meta-files
- Don't push automatically
- Don't delete the user's files
- Don't spend more than 3 minutes on housekeeping
