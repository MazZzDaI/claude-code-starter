# Dialog Archive

This is where saved JSONL logs of Claude Code sessions are kept, which would otherwise be deleted by retention.

## How to save the current dialog

```bash
bash scripts/save-dialogs.sh
# or with a topic:
bash scripts/save-dialogs.sh --note "dialog topic"
```

Idempotent: it can be run as many times as you like — only new/changed files are copied.

## Structure

```
.claude/dialogs/
  YYYY-MM-DD_<session-id-short>.jsonl   # raw session JSONL
  INDEX.md                              # registry: what the dialog is, why it was saved
  README.md                             # this file
```

## Commit policy

| `repo_access` | `.claude/dialogs/` |
|---------------|--------------------|
| `private-solo` | may be committed |
| `private-shared` | local; do not commit without scrubbing secrets |
| `public` | local; do not commit without scrubbing secrets |

Full rule: `.claude/rules/dialog-preservation.md` (and the global `~/.claude/rules/dialog-preservation.md`).
