# ~/.zshrc
export ZSH="$HOME/.oh-my-zsh"

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"


# --- Powerlevel10k Instant Prompt ---
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Theme and options
ZSH_THEME="powerlevel10k/powerlevel10k"
CASE_SENSITIVE="true"
ENABLE_CORRECTION="false"
DISABLE_UPDATE_PROMPT="true"

# Plugins
plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
  web-search
)
source "$ZSH/oh-my-zsh.sh"
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
# ---- Helper: idempotent PATH prepend ----
path_prepend() {
  for p in "$@"; do
    case ":$PATH:" in *":$p:"*) ;; *) PATH="$p:$PATH";; esac
  done
}

# --- Language / SDK bins (NO Homebrew here; brew is in .zprofile) ---
export JAVA_HOME="/opt/homebrew/opt/openjdk@17"
path_prepend "$JAVA_HOME/bin"

# Android SDK (de-duplicated)
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
path_prepend \
  "$ANDROID_SDK_ROOT/emulator" \
  "$ANDROID_SDK_ROOT/platform-tools" \
  "$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"

# Flutter / Dart
path_prepend "$HOME/Developer/flutter/bin" "$HOME/.pub-cache/bin"

# User-local bins
path_prepend "$HOME/.local/bin" "$HOME/bin"

# Keep this misc tooling you had
path_prepend \
  "/Applications/Sublime Text.app/Contents/SharedSupport/bin" \
  "/Applications/VMware Fusion.app/Contents/Public" \
  "/usr/local/share/dotnet" \
  "$HOME/.dotnet/tools" \
  "/Library/Frameworks/Mono.framework/Versions/Current/Commands" \
  "/Users/eric/Applications/iTerm.app/Contents/Resources/utilities" \
  "/Users/eric/Library/Application Support/JetBrains/Toolbox/scripts"

export PATH

# OpenSSL cert fix you had (left intact)
export RUBYOPT="-r$HOME/.rubyopenssl_default_store.rb $RUBYOPT"

# Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias update='sudo softwareupdate -i -a; brew update; brew upgrade; omz update'
alias pray="git add -A && echo 'added' && git commit -m '🙏🔥 updated' "

# Completion (kept)
[[ -f /Users/eric/.dart-cli-completion/zsh-config.zsh ]] && . /Users/eric/.dart-cli-completion/zsh-config.zsh || true
