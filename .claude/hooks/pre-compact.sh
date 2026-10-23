#!/bin/bash
# Pre-Compaction Hook
# Invoked automatically before context compaction.
# Commits tracked changes and updates the timestamp in SNAPSHOT.
# Does NOT update the substantive sections of SNAPSHOT — that is the agent's responsibility.

# We do NOT use set -e — the script must run to the end even on errors

PROJECT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
SNAPSHOT="$PROJECT_DIR/.claude/SNAPSHOT.md"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
STATE_HELPER="$PROJECT_DIR/scripts/framework-state-mode.sh"

# Guard: if this is not a git repo, just exit — there is nothing to save via git
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "pre-compact: not a git repo, skipping"
    exit 0
fi

# Shared/public mode is only safe when framework files are already untracked.
# If they are still tracked, stop and surface the blocker instead of creating
# more framework-history commits on the main branch.
if [ -x "$STATE_HELPER" ]; then
    if ! "$STATE_HELPER" check-safe-mode; then
        echo "pre-compact: framework-state mode is unsafe, skipping auto-commit"
        exit 0
    fi
fi

# 1. Commit changes in already-tracked files (git add -u).
#    Untracked files are NOT added automatically — this is a deliberate decision:
#    a blind git add . in a hook could capture secrets, build artefacts, etc.
#    The agent must add new files deliberately as part of its workflow.
if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
    git add -u
    # Inline git config in case the user has not configured user.name/email
    git -c user.name="Claude" -c user.email="claude@local" \
        commit -m "auto: pre-compaction save ($TIMESTAMP)" 2>/dev/null || true
fi

# 2. Update the timestamp in SNAPSHOT (the file is always updated locally).
# Matches "Last updated" / "Last Updated"; always writes "Last updated".
if [ -f "$SNAPSHOT" ]; then
    sed -i.bak -E "s/\*\*Last [Uu]pdated:\*\*.*/**Last updated:** $TIMESTAMP (pre-compaction)/" "$SNAPSHOT" 2>/dev/null || true
    rm -f "$SNAPSHOT.bak"

    if [ -x "$STATE_HELPER" ] && [ "$("$STATE_HELPER" should-commit-framework-state)" = "false" ]; then
        echo "pre-compact: SNAPSHOT kept local due repo_access=$("$STATE_HELPER" repo-access)"
    else
        git add "$SNAPSHOT" 2>/dev/null || true
        git -c user.name="Claude" -c user.email="claude@local" \
            commit -m "auto: update SNAPSHOT before compaction" 2>/dev/null || true
    fi
fi

echo "pre-compact: state saved at $TIMESTAMP"
