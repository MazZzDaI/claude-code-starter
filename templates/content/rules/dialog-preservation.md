# Rule: Dialog Preservation (content)

Claude Code writes the full JSONL of the current session to `~/.claude/projects/<encoded-cwd>/`. These files are deleted over time by retention. To avoid losing valuable discussions — methodology, archaeology of decisions, anti-patterns — copy interesting sessions into `.claude/dialogs/` and keep a register in `.claude/dialogs/INDEX.md`. Automation: on `/finish` the dialog is saved automatically; explicitly — via `/save-dialog`. With `repo_access=private-solo` the archive may be committed; with `private-shared`/`public` — keep it local and scrub secrets before any publication.

The full description of the behaviour, the INDEX format, the repo_access policy and the analysis rhythm is in the global rule `~/.claude/rules/dialog-preservation.md`.
