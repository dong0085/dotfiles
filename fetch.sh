#!/usr/bin/env bash
#
# fetch.sh - Copies the latest config files from this Mac into the dotfiles repo.
# Run it, then check `git diff` and commit what you want to keep.
#
# Usage:
#   ./fetch.sh          fetch dotfiles, Karabiner, iTerm profile, Alfred workflows
#   ./fetch.sh --brew   also rewrite Brewfile from everything Homebrew has installed
#

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ITERM_PROFILE="Eric"
ALFRED_PREFS="$(python3 -c "import json,os; print(os.path.expanduser(json.load(open(os.path.expanduser('~/Library/Application Support/Alfred/prefs.json')))['current']))" 2>/dev/null || true)"

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

# iTerm2: export one profile from the iTerm preferences as JSON
python3 - "$ITERM_PROFILE" "$DOTFILES_DIR/iterm/iterm2_eric.json" <<'EOF'
import json, os, plistlib, sys
name, dest = sys.argv[1], sys.argv[2]
plist = os.path.expanduser("~/Library/Preferences/com.googlecode.iterm2.plist")
prefs = {}
if os.path.isfile(plist):
    with open(plist, "rb") as f:
        prefs = plistlib.load(f)
profile = next((p for p in prefs.get("New Bookmarks", []) if p.get("Name") == name), None)
if profile is None:
    print(f"  missing iTerm profile '{name}'")
else:
    with open(dest, "w") as f:
        json.dump(profile, f, indent=2, separators=(",", " : "), ensure_ascii=False)
    print("  copied  iterm/iterm2_eric.json")
EOF

# Alfred: repackage each workflow that has a matching .alfredworkflow in alfred/
if [[ -d "$ALFRED_PREFS/workflows" ]]; then
    python3 - "$ALFRED_PREFS/workflows" "$DOTFILES_DIR/alfred" <<'EOF'
import io, os, plistlib, sys, zipfile
workflows_dir, dest_dir = sys.argv[1], sys.argv[2]
wanted = {f[:-len(".alfredworkflow")] for f in os.listdir(dest_dir) if f.endswith(".alfredworkflow")}

for folder in sorted(os.listdir(workflows_dir)):
    path = os.path.join(workflows_dir, folder)
    info_path = os.path.join(path, "info.plist")
    if not os.path.isfile(info_path):
        continue
    with open(info_path, "rb") as f:
        info = plistlib.load(f)
    name = info.get("name")
    if name not in wanted:
        continue

    # Blank out variables marked "Don't Export", same as Alfred's own export
    for key in info.get("variablesdontexport", []):
        if key in info.get("variables", {}):
            info["variables"][key] = ""

    # Build the zip with fixed timestamps so unchanged workflows give identical bytes
    buf = io.BytesIO()
    with zipfile.ZipFile(buf, "w", zipfile.ZIP_DEFLATED) as z:
        for root, dirs, files in os.walk(path):
            dirs[:] = sorted(d for d in dirs if d != "__pycache__")
            for file in sorted(files):
                if file == ".DS_Store":
                    continue
                full = os.path.join(root, file)
                rel = os.path.relpath(full, path)
                zi = zipfile.ZipInfo(rel, date_time=(1980, 1, 1, 0, 0, 0))
                zi.compress_type = zipfile.ZIP_DEFLATED
                zi.external_attr = (os.stat(full).st_mode & 0xFFFF) << 16
                if rel == "info.plist":
                    data = plistlib.dumps(info)
                else:
                    with open(full, "rb") as f:
                        data = f.read()
                z.writestr(zi, data)

    dest = os.path.join(dest_dir, f"{name}.alfredworkflow")
    with open(dest, "wb") as f:
        f.write(buf.getvalue())
    print(f"  copied  alfred/{name}.alfredworkflow")
    wanted.discard(name)

for name in sorted(wanted):
    print(f"  missing Alfred workflow '{name}'")
EOF
else
    echo "  missing Alfred preferences folder"
fi

# Homebrew: only with --brew, since this replaces the hand-written Brewfile
if [[ "$1" == "--brew" ]]; then
    brew bundle dump --file="$DOTFILES_DIR/Brewfile" --force
    echo "  copied  Brewfile"
fi

echo ""
echo "Done. Review changes with: git -C \"$DOTFILES_DIR\" diff --stat"
