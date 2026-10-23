# Rule: Dialog Preservation

## Goal

Preserve valuable Claude Code dialogs before they are deleted by retention.

Why this matters:
- **Methodology evolution.** Live dialogs show how approaches changed — not after the fact, but at the moment of decision.
- **Archaeology of decisions.** Why X was chosen rather than Y; what was tried and discarded — this often vanishes from commits and SNAPSHOT but remains in the discussion.
- **Anti-patterns.** Dead ends and failed attempts are more useful than successes: they teach you what not to do.
- **A source for future methodology.** Accumulated dialogs are raw material for rebuilding working practices (see [[methodology]]).

## Where Claude Code writes

Claude Code saves the full JSONL log of each session to:

```
~/.claude/projects/<encoded-cwd>/<session-id>.jsonl
```

Where `<encoded-cwd>` is the project path with every `/` replaced by `-`. For example, the project `/Users/alex/Code/foo` becomes `-Users-alex-Code-foo` (the leading `/` also becomes `-`).

These files are subject to retention — at some point Claude Code cleans them up. That is why interesting sessions need to be copied into the project.

## Where to save

In the project — in the `.claude/dialogs/` folder:

```
.claude/dialogs/
  <YYYY-MM-DD>_<session-id-short>.jsonl
  INDEX.md
```

- `YYYY-MM-DD` — creation date of the source JSONL (from the file's mtime).
- `session-id-short` — the first 8 characters of the session-id (for easy identification; the full ID is not needed).
- `INDEX.md` — the register: what the dialog is, why it was saved, what the topic is.

## When to save

1. **Automatically on `/finish`.** At the end of every session the skill itself copies the current session's JSONL into the archive. Idempotent — if it has already been copied, it does nothing.
2. **Explicitly via `/save-dialog`.** If something valuable has just happened in the session (a solution found, an anti-pattern discarded, a methodology worked out) and the session is not yet over, the user says `/save-dialog` or "save the dialog", and the skill copies the current JSONL straight away.

Better to save and delete later than to lose it.

## What to record in INDEX.md

INDEX.md is a compact register. One table row per saved dialog:

| Date | File | Session | Note |
|------|------|---------|------|
| 2026-06-11 | 2026-06-11_a1b2c3d4.jsonl | a1b2c3d4 | building the dialog-preservation feature; found the minimal bash + skill + rule pattern |

The note is short (1 line) and answers two questions:
- what topic was discussed;
- why this dialog is worth keeping (what was found in it).

An empty note is OK; it means the save was automatic (`/finish`). You can come back and fill it in later.

## Safety by repo_access

### `repo_access=private-solo`

`.claude/dialogs/` may be committed to git. It is a snapshot of the process, useful for future analysis and part of the "complete desk".

### `repo_access=private-shared` or `public`

`.claude/dialogs/` stays **local only**. The template `.gitignore` must contain the line `.claude/dialogs/`. Before publishing:

- run the archive through a regex secret scrub (planned: `scripts/cleanup-dialogs.sh` — not implemented, will be added separately);
- check that the dialogs contain no private URLs, tokens, people's names, or paths containing the user's home directory;
- only then decide whether anything can be published (usually — no; raw dialogs stay private).

## Analysis rhythm

The dialog archive grows by itself and is useless without a feedback loop. Once a month or once a quarter:

1. Read the accumulated dialogs (at least via INDEX.md and the note field).
2. Write down recurring patterns — what worked, what didn't, which approaches stabilised.
3. Lock the patterns found into `methodology/draft/` (or the project's equivalent) — this is the link to the methodology layer ([[methodology]]).

This turns the dialog archive from a "graveyard of logs" into a real source of methodology.

## Don't

- Don't send `.claude/dialogs/` anywhere external automatically.
- Don't publish to shared/public repositories without scrubbing.
- Don't edit the JSONL files themselves — they must stay raw (source of truth).
- Don't churn out empty notes — an empty cell is better than a decorative "session work".
