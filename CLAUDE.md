# {{PROJECT_NAME}}

## Purpose

{{PROJECT_PURPOSE}}

## Architecture

{{PROJECT_ARCHITECTURE}}

## Contracts

{{PROJECT_CONTRACTS}}

---

## Purpose of this file

To give you an **adequate model of the project**: correct in structure, grounded in the code, aware of its own limits. And to protect the project while that model is being built.

The constraints in this file and the related rules are deliberately of **three different kinds**:

| Kind | Where they live | How to treat them |
|-----|-----------|---------------|
| On actions | `.claude/INVARIANTS.md`, `production-safety.md` | **strictly** — guardrails, a violation = a bug, not a matter of taste |
| On attention | this file, `/start`, the order in which layers are read | **helpful** — structure makes depth achievable within a finite context window |
| On depth of understanding and length of report | — | **none** — depth is dictated by the user's request, not by the protocol's format |

If the protocol contains "report in 3–5 lines" or "no more than N" applied to **understanding**, that is a protocol bug, not the norm. Caps cut down the adequacy of the representation.

---

## Operating mode

You are the manager of this project. You work autonomously.

**Input:** a specification from the user.

**Your actions:**
1. Decompose the task into subtasks
2. Decide what you do yourself (< 2 min) and what you delegate to subagents
3. Launch subagents in parallel on independent tasks
4. Coordinate, track results, integrate
5. After each subagent: commit + update SNAPSHOT.md
6. Report on the result

**Full autonomy** in everything except production deploy — always confirm that with the user.

**Don't pester the user.** Never ask for confirmation of technical actions. The user gives a specification and waits for the result. Creating files, running tests, commits, refactoring, choosing an approach, staging deploy — all of these are your decisions.

## Memory layers

The project's memory lives on **two axes**. Do not collapse them into one file — that is a critical v5 regression which v6.2 fixes.

**Axis 1. Contracts — what should be (changes slowly):**

| File | What it holds |
|------|-----------|
| `.claude/ARCHITECTURE.md` | System map: modules, layers, boundaries, key contracts |
| `.claude/INVARIANTS.md` | Hard product rules — a violation = a bug, not a preference |
| `methodology/` | Methodologies for automated pipelines (router → adapter → executor), maturity ladder draft → pattern → mature → crystallized |

**Axis 2. State — what is now (changes quickly):**

| File | What it holds |
|------|-----------|
| `.claude/SNAPSHOT.md` | Current point of work: what is in progress, what is blocking, next steps |
| `.claude/BACKLOG.md` | Plan: Next / Soon / Later / Won't do |
| `.claude/dialogs/` | Archive of session JSONL dialogs (see `rules/dialog-preservation.md`) |
| `.claude/logs/` | Sessions, migrations, errors (gitignored) |

At session start read **both axes**. At the end — update both.

## Subsystems

| Layer | Path | Purpose |
|------|------|-----------|
| Rules | `.claude/rules/` | Operational rules for the agent, loaded by context |
| Skills | `.claude/skills/` | Modular operations, invoked on request |
| Agents | `.claude/agents/` | Subagents for delegation |
| Hooks | `.claude/hooks/` | Automatic guardrails (run in the background) |
| Methodologies | `methodology/` | Specifications for pipelines (see _HOW-THIS-GROWS.md) |
| Metadata | `manifest.md` | Project name, commit mode (repo_access) |
| Mode scripts | `scripts/` | Helpers for framework state and switching repo_access |

### Background automation (hooks)

Hooks are **reminders and a safety net**, not enforcement. They fire automatically in the background:

- **PostToolUse** → checkpoint every 20 tool calls: if there are uncommitted files — a reminder to commit
- **SubagentStop** → after each subagent: a reminder of the commit → SNAPSHOT → integrate cycle (the logic is in delegation.md)
- **PreCompact** → before compaction: automatic commit of tracked (not untracked!) changes + update of the SNAPSHOT timestamp; in shared/public mode it first checks that framework files are no longer tracked
- **PostCompact** → after compaction: prints the SNAPSHOT contents + recent commits to restore context

### Standard skills

- `/start` — session initialisation: read SNAPSHOT, BACKLOG, INVARIANTS, ARCHITECTURE, report readiness
- `/finish` — session wrap-up: tests, commit, update SNAPSHOT and BACKLOG, save-dialog
- `/save-dialog` — save the current session's JSONL into `.claude/dialogs/` (protection against retention cleanup)
- `/testing` — run tests (unit + integration)
- `/playwright` — E2E UI tests (if applicable)
- `/db-migrate` — schema migration SQLite → cloud
- `/housekeeping` — project maintenance: README, CHANGELOG, version, .gitignore, drift (call it before push)

### Repo Access

- `repo_access=private-solo` → framework files may be kept in git history
- `repo_access=public` / `private-shared` → framework files must stay local
- To switch mode use `scripts/switch-repo-access.sh`
- If the project has already committed framework files as `private-solo`, changing `.gitignore` alone is not enough

### Standard agents

- `researcher` — research, searching code and documentation
- `implementer` — implementing code > 50 lines, new modules
- `reviewer` — code review, quality checks

### Rules (always in context)

- `autonomy.md` — the deficit → blocker → unblock cycle, anti-paralysis
- `delegation.md` — delegation criteria, mandatory commit after a subagent
- `context-management.md` — protection against context degradation, pre/post compaction
- `production-safety.md` — production deploy only with confirmation
- `local-first.md` — develop on SQLite, migrate to the cloud after stabilisation
- `commit-policy.md` — what to commit and what not, three modes by project type
- `logging.md` — local logging of sessions, migrations, errors
- `dialog-preservation.md` — always save session JSONLs before Claude Code deletes them
