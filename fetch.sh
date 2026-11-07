#!/usr/bin/env bash
#
# fetch.sh - Copies the latest config files from this Mac into the dotfiles repo.
# Run it, then check `git diff` and commit what you want to keep.
#
# Usage:
#   ./fetch.sh          fetch dotfiles, Karabiner and Ghostty configs
#   ./fetch.sh --brew   also rewrite Brewfile from everything Homebrew has installed
#

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Plain files: "source on this Mac|path in repo"
FILES=(
    "$HOME/.bash_profile|.bash_profile"
    "$HOME/.gitconfig|.gitconfig"
    "$HOME/.gitignore|.gitignore"
    "$HOME/.zshrc|.zshrc"
    "$HOME/.p10k.zsh|.p10k.zsh"
    "$HOME/.config/karabiner/karabiner.json|karabiner.json"
    "$HOME/Library/Application Support/com.mitchellh.ghostty/config.ghostty|ghostty/config.ghostty"
)

echo "=== Fetching config files ==="

for entry in "${FILES[@]}"; do
    src="${entry%%|*}"
    dest="$DOTFILES_DIR/${entry#*|}"
    if [[ -f "$src" ]]; then
        mkdir -p "$(dirname "$dest")"
        cp "$src" "$dest"
        echo "  copied  ${entry#*|}"
    else
        echo "  missing $src"
    fi
done

# Homebrew: only with --brew, since this replaces the hand-written Brewfile
if [[ "$1" == "--brew" ]]; then
    brew bundle dump --file="$DOTFILES_DIR/Brewfile" --force
    echo "  copied  Brewfile"
fi

echo ""
echo "Done. Review changes with: git -C \"$DOTFILES_DIR\" diff --stat"
