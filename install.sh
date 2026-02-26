#!/bin/bash
# Claude Code Starter Kit - Install Script
# Copies configuration files to ~/.claude/
#
# Usage: ./install.sh [--dry-run]
#
# This script will NOT overwrite existing files. If a file already exists,
# it will be skipped and noted in the output.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="$HOME/.claude"
DRY_RUN=false

if [ "$1" = "--dry-run" ]; then
    DRY_RUN=true
    echo "=== DRY RUN MODE - no files will be written ==="
    echo ""
fi

copy_file() {
    local src="$1"
    local dest="$2"

    if [ -f "$dest" ]; then
        echo "  SKIP (exists): $dest"
        return
    fi

    if [ "$DRY_RUN" = true ]; then
        echo "  WOULD COPY: $src -> $dest"
    else
        mkdir -p "$(dirname "$dest")"
        cp "$src" "$dest"
        echo "  COPIED: $dest"
    fi
}

echo "Claude Code Starter Kit Installer"
echo "==================================="
echo ""
echo "Source: $SCRIPT_DIR"
echo "Target: $TARGET"
echo ""

# Check if ~/.claude exists
if [ ! -d "$TARGET" ]; then
    if [ "$DRY_RUN" = true ]; then
        echo "Would create: $TARGET"
    else
        mkdir -p "$TARGET"
        echo "Created: $TARGET"
    fi
fi

echo ""
echo "--- Global Config ---"
copy_file "$SCRIPT_DIR/CLAUDE.md" "$TARGET/CLAUDE.md"
copy_file "$SCRIPT_DIR/preferences.yml" "$TARGET/preferences.yml"
copy_file "$SCRIPT_DIR/lessons-learned.yml" "$TARGET/lessons-learned.yml"
copy_file "$SCRIPT_DIR/statusline-script.sh" "$TARGET/statusline-script.sh"

echo ""
echo "--- Core Methodologies ---"
copy_file "$SCRIPT_DIR/core/methodologies.yml" "$TARGET/core/methodologies.yml"
copy_file "$SCRIPT_DIR/core/session-management.yml" "$TARGET/core/session-management.yml"

echo ""
echo "--- Workflows ---"
copy_file "$SCRIPT_DIR/workflows/session-recovery.md" "$TARGET/workflows/session-recovery.md"
copy_file "$SCRIPT_DIR/workflows/gather-context.md" "$TARGET/workflows/gather-context.md"
copy_file "$SCRIPT_DIR/workflows/git-workflow.md" "$TARGET/workflows/git-workflow.md"

echo ""
echo "--- Slash Commands ---"
copy_file "$SCRIPT_DIR/commands/session-start.md" "$TARGET/commands/session-start.md"
copy_file "$SCRIPT_DIR/commands/session-end.md" "$TARGET/commands/session-end.md"

# Make statusline script executable
if [ "$DRY_RUN" = false ] && [ -f "$TARGET/statusline-script.sh" ]; then
    chmod +x "$TARGET/statusline-script.sh"
fi

echo ""
echo "==================================="
echo ""

if [ "$DRY_RUN" = true ]; then
    echo "Dry run complete. Run without --dry-run to install."
else
    echo "Installation complete!"
    echo ""
    echo "NEXT STEPS:"
    echo ""
    echo "1. Configure the status line (shows context window %):"
    echo "   claude config set --global statusline '~/.claude/statusline-script.sh'"
    echo ""
    echo "2. Disable auto-compact (you'll manage this manually):"
    echo "   claude config set --global autoCompact false"
    echo ""
    echo "3. Install the claude-mem plugin (cross-session memory):"
    echo "   claude plugin add thedotmack/claude-mem"
    echo ""
    echo "4. Edit ~/.claude/CLAUDE.md and ~/.claude/preferences.yml"
    echo "   to customize for your own name, style, and projects."
    echo ""
    echo "5. Read the README.md for full usage instructions."
fi
