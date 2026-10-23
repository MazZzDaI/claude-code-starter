---
name: save-dialog
description: Save the current Claude Code session's JSONL to .claude/dialogs/. Triggers: /save-dialog, "save the dialog", "archive the dialog".
---

# Skill: Save Dialog

## Why

Lock in a valuable moment of the session before Claude Code performs its retention cleanup. Useful when a solution, an anti-pattern or a piece of methodology has just been found in the dialog — and the session isn't over yet.

The full behaviour rule: `~/.claude/rules/dialog-preservation.md` (or `.claude/rules/dialog-preservation.md` in the project).

## Steps

1. **Ask the user in one line** for the topic / why this dialog is valuable. This goes into `INDEX.md` next to the entry for the saved file.
   - If the user says "no note", "skip", "not needed" — record it without a note (empty cell).
   - If they answer with a topic — take it in full as the note (1 line).

2. **Run the script:**

   ```bash
   if [ -f scripts/save-dialogs.sh ]; then
       if [ -n "$NOTE" ]; then
           bash scripts/save-dialogs.sh --note "$NOTE"
       else
           bash scripts/save-dialogs.sh
       fi
   else
       echo "Framework is not fully installed — scripts/save-dialogs.sh is missing."
       echo "Run /setup-project to upgrade the framework in this folder."
       exit 0
   fi
   ```

3. **Show the user the script's output** (one line: `saved: N, new: M, updated: K, total in archive: T`).

## What not to do

- Don't edit the JSONL files themselves.
- Don't ask more than one question (the topic is the only one).
- Don't send the archive outside.
- Don't fail if the script is missing — it's a signal to upgrade the framework, not a blocker.

## After running

Briefly (1-2 lines): saved/not saved, how many new files, where they are.
