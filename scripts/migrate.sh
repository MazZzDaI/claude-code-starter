#!/bin/bash
#
# Claude Code Starter — Migration Payload
# Version: 6.3.0 (additive migration; backs up new memory layers too)
#
# Internal migration used by the public root launcher.
# Additive integration of the framework into an existing project.
#
# Principle: TOUCH NOTHING, ONLY ADD.
# - Existing code, documentation and meta-files stay as they are
# - Only missing framework files are added (rules/skills/agents/hooks)
# - CLAUDE.md is merged additively via scripts/lib/merge_claude_md.py
# - On a hard conflict — stop + a concrete proposal in .claude/CLAUDE.md.merge-proposal.md
# - A backup is always created before any changes
# - Rollback restores the latest backup
#
# Usage:
#   bash migrate.sh                                # Auto-detect the type
#   bash migrate.sh --name "My Project"
#   bash migrate.sh --type code|content|hybrid|auto
#   bash migrate.sh --content-type book|course|knowledge-base|documents|transcripts|mixed
#   bash migrate.sh --template /path/to/framework
#   bash migrate.sh --rollback                     # Restore from the latest backup
#   bash migrate.sh --apply-proposal               # Apply the CLAUDE.md merge proposal
#   bash migrate.sh --force                        # Overwrite existing files
#

set -e

# === Config (caller responsibilities) ===
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE_DIR="${SCRIPT_DIR}/.."
PROJECT_DIR="$(pwd)"

# Load the shared library.
# shellcheck source=lib/install_common.sh
source "$SCRIPT_DIR/lib/install_common.sh"

# === Defaults ===
PROJECT_NAME=""
TEMPLATE_PATH=""
PROJECT_TYPE="auto"
CONTENT_TYPE=""
MODE="migrate"
FORCE=0

# === Parse Arguments ===
while [[ $# -gt 0 ]]; do
    case $1 in
        --name)            PROJECT_NAME="$2"; shift 2 ;;
        --template)        TEMPLATE_PATH="$2"; shift 2 ;;
        --type)            PROJECT_TYPE="$2"; shift 2 ;;
        --content-type)    CONTENT_TYPE="$2"; shift 2 ;;
        --rollback)        MODE="rollback"; shift ;;
        --apply-proposal)  MODE="apply-proposal"; shift ;;
        --force)           FORCE=1; shift ;;
        *)                 shift ;;
    esac
done

# === Determine Template Source ===
if [ -n "$TEMPLATE_PATH" ] && [ -d "$TEMPLATE_PATH" ]; then
    TEMPLATE_DIR="$TEMPLATE_PATH"
elif [ -d "$SCRIPT_DIR/../.claude/rules" ]; then
    TEMPLATE_DIR="$SCRIPT_DIR/.."
else
    if [ "$MODE" = "migrate" ]; then
        log_error "Template not found. Provide --template path or run from a framework checkout with scripts/"
        exit 1
    fi
fi

# ============================================================================
# Migration logging
# ============================================================================

# Writes a JSON migration log to .claude/logs/migrations/.
write_migration_log() {
    local end_ts
    end_ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    local log_file
    log_file=".claude/logs/migrations/$(date +%Y-%m-%d_%H-%M).json"
    mkdir -p .claude/logs/migrations

    local doc_count
    doc_count=$(find . -maxdepth 3 -type f \( -name '*.md' -o -name '*.txt' -o -name '*.rst' \) \
        -not -path './node_modules/*' -not -path './.venv/*' -not -path './.git/*' \
        -not -path './.claude/*' 2>/dev/null | wc -l | tr -d ' ')

    local claude_enriched="false"
    grep -qE "Operating mode|Операционный режим" "CLAUDE.md" 2>/dev/null && claude_enriched="true"

    cat > "$log_file" <<LOGEOF
{
  "timestamp": "$TIMESTAMP",
  "completed": "$end_ts",
  "project": "$PROJECT_NAME",
  "project_type": "$PROJECT_TYPE",
  "content_type": "$CONTENT_TYPE",
  "doc_files_found": $doc_count,
  "claude_md_enriched": $claude_enriched,
  "backup_dir": "$BACKUP_DIR",
  "errors": []
}
LOGEOF

    log_success "Migration log: $log_file"
}

# ============================================================================
# Mode dispatcher
# ============================================================================

# Header
echo ""
echo -e "${BLUE}Claude Code Starter v6.0 — Migration${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

case "$MODE" in
    rollback)
        rollback
        exit 0
        ;;
    apply-proposal)
        apply_proposal
        exit 0
        ;;
    migrate)
        # Resolve project name
        if [ -z "$PROJECT_NAME" ]; then
            PROJECT_NAME=$(basename "$PROJECT_DIR")
        fi

        log_info "Project: $PROJECT_NAME"
        log_info "Analyzing existing structure..."
        analyze_existing_project
        echo ""

        # Project type detection (if auto)
        if [ "$PROJECT_TYPE" = "auto" ]; then
            log_info "Detecting project type..."
            PROJECT_TYPE=$(detect_project_type)
            log_info "Detected project type: $PROJECT_TYPE"
        fi

        # Content type detection (if applicable)
        if [ "$PROJECT_TYPE" = "content" ] || [ "$PROJECT_TYPE" = "hybrid" ]; then
            if [ -z "$CONTENT_TYPE" ]; then
                CONTENT_TYPE=$(detect_content_type)
                log_info "Detected content type: $CONTENT_TYPE"
            fi
        fi

        # Unknown → fall back to code (the safe choice for an existing code project)
        if [ "$PROJECT_TYPE" = "unknown" ]; then
            log_warning "Could not detect project type. Defaulting to 'code'. Use --type to override."
            PROJECT_TYPE="code"
        fi

        # Backup before any changes
        backup_existing

        # Installation (additive — every function uses copy_if_missing internally)
        install_common

        case "$PROJECT_TYPE" in
            code)
                install_code
                ;;
            content)
                install_content
                ;;
            hybrid)
                install_hybrid
                ;;
            *)
                log_error "Unknown project type: $PROJECT_TYPE"
                exit 1
                ;;
        esac

        # CLAUDE.md merge — with conflict detection
        merge_claude_md "CLAUDE.md" "$(claude_md_template_for_type)"

        # Manifest (with extended fields)
        generate_manifest

        # No git init in migrate — an existing project already has its own git

        # Migration log
        write_migration_log

        # Final summary
        print_migration_summary
        ;;
    *)
        log_error "Unknown mode: $MODE"
        exit 1
        ;;
esac
