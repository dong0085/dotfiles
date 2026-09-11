#!/usr/bin/env bash
#
# install.sh - Installs all Alfred workflows from dotfiles
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Alfred Workflow Installer ==="

# Check if Alfred is installed
if [[ ! -d "/Applications/Alfred 5.app" && ! -d "/Applications/Alfred.app" ]]; then
    echo "Warning: Alfred is not found in /Applications. Please install Alfred first."
    exit 1
fi

COUNT=0
for workflow in "$SCRIPT_DIR"/*.alfredworkflow; do
    if [[ -f "$workflow" ]]; then
        echo "Opening $(basename "$workflow")..."
        open "$workflow"
        COUNT=$((COUNT + 1))
        sleep 0.3
    fi
done

echo ""
echo "Done! Dispatched $COUNT workflow(s) to Alfred for installation."
