# Rule: Dialog Preservation

Claude Code writes the full JSONL of the current session to `~/.claude/projects/<encoded-cwd>/`, where `<encoded-cwd>` is the project path with `/` replaced by `-`. These files are deleted over time by retention. To avoid losing valuable discussions — the evolution of the methodology, the archaeology of decisions, anti-patterns — copy interesting sessions to `.claude/dialogs/` and keep a short register in `.claude/dialogs/INDEX.md`.

## Behaviour

- **Automatically:** on `/finish` the current session's dialog is saved to the archive (idempotently).
- **Explicitly:** if something valuable is happening in the session right now — the user says `/save-dialog` or "save the dialog", and `scripts/save-dialogs.sh` copies the JSONL immediately.
- **Record:** in `INDEX.md`, a table row `| Date | File | Session | Note |`. Note — 1 line: the topic and why it is valuable.

## Policy by repo_access

| Mode | `.claude/dialogs/` |
|-------|--------------------|
| `private-solo` | May be committed (part of the full snapshot of the process) |
| `private-shared` | Local, don't commit. Before publishing — scrub secrets |
| `public` | Local, don't commit. Before publishing — scrub secrets |

For shared/public, add `.claude/dialogs/` to `.gitignore`. A separate `scripts/cleanup-dialogs.sh` for regex scrubbing before publishing is planned (not implemented yet — scrub manually or don't publish).

## Analysis rhythm

Once a month or quarter, re-read `INDEX.md`, write out recurring patterns and consolidate them into `methodology/draft/` (see the methodology layer). Without this the archive is useless.

## Don't

- Don't edit the JSONL files themselves (the source of truth).
- Don't forward the archive outside automatically.
- Don't publish in shared/public without scrubbing secrets.

Global version of the rule: `~/.claude/rules/dialog-preservation.md`.
