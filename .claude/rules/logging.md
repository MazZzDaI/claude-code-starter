# Rule: Local logging

## Principle

Every session and migration leaves a log. Logs are stored locally in `.claude/logs/`, are not sent anywhere, and are needed for analysing framework errors.

## What is logged

### Sessions (`.claude/logs/sessions/`)

On every `/start` and `/finish` the current session's log is created/updated:

**File:** `.claude/logs/sessions/YYYY-MM-DD_HH-MM.md`

**Contents:**
```
# Session: YYYY-MM-DD HH:MM

## Start
- Timestamp: ...
- SNAPSHOT status: [found / not found / empty]
- Git status: [clean / N uncommitted files]
- Framework version: ...

## Actions
- [timestamp] action description
- [timestamp] subagent:implementer launched → completed/failed
- [timestamp] commit: abc1234 "message"
- [timestamp] error: description

## Finish
- Timestamp: ...
- Tests: [passed N / failed N / skipped]
- Commits: [list of hashes]
- Duration: ...
```

### Migrations (`.claude/logs/migrations/`)

On every run of `migrate.sh`:

**File:** `.claude/logs/migrations/YYYY-MM-DD_HH-MM.json`

**Contents:**
```json
{
  "timestamp": "...",
  "completed": "...",
  "project": "project-name",
  "doc_files_found": 15,
  "claude_md_enriched": true,
  "settings_upgraded": false,
  "errors": []
}
```

### Errors (`.claude/logs/errors/`)

On any error in the framework's operation (a failed hook, an unsuccessful subagent, a broken script):

**File:** `.claude/logs/errors/YYYY-MM-DD_HH-MM_error.md`

**Contents:**
- What happened
- Context (which skill/agent/hook)
- Stack trace or command output
- What came before the error (the last 3 actions)

## How to log

Logging is an **agent convention**, not automation. Only migration is logged automatically (migrate.sh writes JSON). Everything else is the responsibility of the agent, which follows the formats above.

The agent keeps the log while working:
- On `/start` — create the session file, record the initial state
- During work — append significant actions (subagents, commits, errors)
- On `/finish` — append the outcomes, tests, duration
- On error — create a separate error log

Logging must not slow down the work. Writing means appending to the end of the file, without re-reading it. If logging gets in the way — skip it. Better to do the work without a log than to not do it with one.

## Storage

- All logs are in `.gitignore` (automatically)
- Logs are not deleted automatically
- For analysing framework problems: read `.claude/logs/errors/`
- For the work chronology: read `.claude/logs/sessions/`
