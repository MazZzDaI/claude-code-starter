#!/bin/bash
# Subagent Done Hook
# Runs automatically after any subagent finishes.
# This is a REMINDER, not a command. The logic lives in rules/delegation.md.

# Guard: if this is not a git repo, do not check
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    exit 0
fi

DIRTY=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')

if [ "$DIRTY" -gt 0 ]; then
    echo ""
    echo "⚡ Subagent done. $DIRTY uncommitted files."
    echo "→ Commit subagent result, update SNAPSHOT.md (see delegation.md)"
    echo ""
fi
