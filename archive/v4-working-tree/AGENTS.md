# Project Manifest

See `./manifest.md` for project metadata.

This file defines:
- `project_type`
- `project_priority`

# Codex Adapter Entry

## Purpose

This file is the Codex entry orchestrator for projects that use the framework.
It runs Codex workflows on top of shared project memory.

## Shared State

Primary memory files:
- Software profile:
  - `.claude/SNAPSHOT.md`
  - `.claude/BACKLOG.md`
  - `.claude/ARCHITECTURE.md`
- Content profile:
  - `.claude/content/SNAPSHOT.md`
  - `.claude/content/BACKLOG.md`
  - `.claude/content/ARCHITECTURE.md`
- `CHANGELOG.md` (optional, if project tracks release notes)

Codex and Claude use the same state contract.

## Command Routing

### `start`
Run:
- `bash .codex/commands/start.sh`

### `/fi`
Run:
- `bash .codex/commands/fi.sh`

### migration detection
Run:
- `bash .codex/commands/migration-router.sh`

### version check
Run:
- `bash .codex/commands/update-check.sh`

## Core Runtime

Shared command entry points:
- `python3 src/framework-core/main.py cold-start`
- `python3 src/framework-core/main.py completion`

Output contract:
- `.codex/contracts/core-cli-contract.md`


### Delegating tasks to subagents

When you receive a task from the user — first assess:
- **Yourself:** quick edits (< 2 min), discussions, analysis, questions, small fixes
- **Subagent:** code > 50 lines, new modules, refactoring, UI changes, research, any task > 5 min

When delegating to a subagent:
- Write a detailed brief with context, files to read, and the expected result
- Run it in the background
- Tell the user what has been launched
- On completion — give a short report on the result
- You can run several subagents in parallel on independent tasks

Goal: maximum parallelism and minimum waiting time for the user.
