#!/bin/bash
# Post-Tool-Use Checkpoint
# Runs after every tool call.
# Counts calls. Every 20 calls it checks for uncommitted changes.
# Lightweight: if the threshold has not been reached, it exits in <10ms.

PROJECT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
COUNTER_FILE="$PROJECT_DIR/.claude/.tool-counter"
CHECKPOINT_INTERVAL=20

# Increment the counter (atomically via a file in the project, not /tmp)
if [ -f "$COUNTER_FILE" ]; then
    COUNT=$(cat "$COUNTER_FILE" 2>/dev/null || echo "0")
    COUNT=$((COUNT + 1))
else
    mkdir -p "$(dirname "$COUNTER_FILE")"
    COUNT=1
fi
echo "$COUNT" > "$COUNTER_FILE"

# Threshold check
if [ $((COUNT % CHECKPOINT_INTERVAL)) -ne 0 ]; then
    exit 0
fi

# === Checkpoint reached ===

# Check git only if this is a git repo
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    exit 0
fi

DIRTY=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')

if [ "$DIRTY" -gt 0 ]; then
    echo ""
    echo "⚡ CHECKPOINT ($COUNT tool calls): $DIRTY uncommitted files."
    echo "→ Commit changes now and update SNAPSHOT.md"
    echo ""
fi
