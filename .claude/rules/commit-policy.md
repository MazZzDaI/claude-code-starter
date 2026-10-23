# Rule: Commit Policy

## Principle

The agent decides for itself what to commit. Don't ask the user. Use `git add` with specific files — never `git add .` or `git add -A`.

The commit policy depends on the project type. The type is specified in `manifest.md` → `repo_access`.

## Three modes

### 1. `repo_access=public` or `repo_access=private-shared`

A public repository, or a private one with external users / a team. **Only the product** goes to the remote: clean code, user documentation, configs. Everything to do with the development process stays local.

**Commit (product):**
- Source code (src/, lib/, app/, pages/)
- User documentation (README.md, CHANGELOG.md, docs/)
- Project configs (package.json, pyproject.toml, tsconfig.json)
- DB migrations (migrations/, schema/)
- Production tests (tests/, e2e/)
- .gitignore, LICENSE

**Do NOT commit (development process → .gitignore):**
- Experiments, prototypes, drafts (experiments/, drafts/, scratch/)
- Test logs, coverage reports (test-results/, playwright-report/, coverage/, *.log)
- Development utilities, helper scripts (scripts/dev-*, tools/local-*)
- Analysis, research, notes (analysis/, research/, notes/)
- Intermediate data, dumps (data/, dumps/, fixtures/)
- Framework meta-files (.claude/, CLAUDE.md, manifest.md, AGENTS.md)
- Any reflections, protocols, internal process documentation

**SNAPSHOT.md** in public/shared mode is a **local file**, not part of the shared git history. This is only safe if framework files were never committed to this branch, or were removed from the index via `scripts/switch-repo-access.sh`.

If the project previously lived as `private-solo` and then became shared/public:
- `.gitignore` alone is not enough;
- tracked framework files must be removed from the index;
- if they have already been pushed upstream, a history rewrite or a new shared/public branch is needed.

**Analogy:** the workbench is covered in tools, reference books and drafts, but the user is handed only the finished product.

### 2. `repo_access=private-solo`

A private project with only one person working on it. **Everything** is committed — code, experiments, meta-files, notes, analysis. The repository is a full snapshot of the workbench.

**Commit:**
- Everything not on the "Always forbidden" list (see below)
- Including: .claude/, CLAUDE.md, manifest.md, experiments/, notes/, analysis/

### 3. `repo_access` not specified

Default: work as `private-solo`. If a public remote is detected (github.com without /private/ in the URL, or explicitly public) — switch to `public` mode.

## Always forbidden (any mode)

These files are **never** committed, in any project type. If they aren't in `.gitignore` — add them automatically:

- `.env`, `.env.*` — environment variables
- `*.key`, `*.pem`, `*.p12` — keys and certificates
- `credentials.json`, `secrets/`, `*secret*` — credentials
- `.claude/settings.local.json` — personal agent settings
- `CLAUDE.local.md` — personal notes
- `*.db`, `*.sqlite`, `*.sqlite3` — local databases
- `node_modules/`, `__pycache__/`, `.venv/` — dependencies
- `dist/`, `build/`, `*.egg-info/` — build artefacts

## Building .gitignore

The template `.gitignore` contains a commented-out block for public/shared mode. The agent enables it via `scripts/switch-repo-access.sh`:

1. At bootstrap — the base set (dependencies, artefacts, .env, secrets, personal files)
2. Before the first framework commit in `public`/`private-shared` mode — run `scripts/switch-repo-access.sh public --commit` or `scripts/switch-repo-access.sh private-shared --commit`
3. If the project is already switching from `private-solo`, the same script removes framework files from the index and halts the process if they are already in the upstream history
4. Over time it stabilises — new patterns are added as they are discovered

## Check before pushing

Before `git push` — check `git diff --name-only origin/main..HEAD`:
- In any mode: are there any files from "Always forbidden"
- In `public`/`private-shared` mode: are there any dev artefacts

If there are — `git rm --cached`, update `.gitignore`, warn the user.
