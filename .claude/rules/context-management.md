# Rule: Context management

## The problem

Context degradation begins at 50-60% window fill. During compaction the agent loses details and may repeat work already done or break code.

## Preventive measures

### Regular state saving

After every significant block of work (at least every 20 tool calls — matches the checkpoint hook):
- Check: are there uncommitted changes
- If so: git commit with a descriptive message
- Update SNAPSHOT.md if the project state has changed

### Signs of context degradation

If you notice yourself:
- Repeating something discussed earlier
- Not remembering what was done at the start of the session
- Confusing files or the project structure

**Immediately:**
1. Re-read `.claude/SNAPSHOT.md`
2. Re-read `CLAUDE.md`
3. Check `git log --oneline -20` to restore the chronology

### Don't accumulate uncommitted changes

A large volume of uncommitted changes = a high risk of loss during compaction. Commit often, commit atomically.

## Pre-Compaction protocol

Before compaction the `PreCompact` hook fires automatically, which:

1. **git add -u + commit** of tracked changes (untracked files are not added — deliberately)
2. **Updates the timestamp** in SNAPSHOT.md

**What the hook does NOT do** (this is the agent's responsibility in the workflow):
- Doesn't update the content sections of SNAPSHOT (Done, In progress, Next steps)
- Doesn't add new untracked files
- Doesn't bypass `repo_access`: in shared/public mode SNAPSHOT stays local, and if framework files are still tracked — the hook stops and requires `scripts/switch-repo-access.sh`

That is why it matters to update SNAPSHOT.md **before** compaction — as part of regular commits (every 20 tool calls). If the agent has been updating SNAPSHOT as it went, the hook simply records the latest state.

## Post-Compaction protocol

After compaction (automatically via the `PostCompact` hook):

1. **Re-read SNAPSHOT.md** — restore the understanding of the state
2. **Re-read CLAUDE.md** — restore the project context
3. **git log --oneline -10** — check the commit chronology
4. **Don't start new work** until the context has been restored

## Rule for long sessions

When working for more than 30 minutes:
- Every 15 minutes: commit + SNAPSHOT update
- Before every major task: check that SNAPSHOT is up to date
- After every subagent: the full cycle (commit + SNAPSHOT update)
