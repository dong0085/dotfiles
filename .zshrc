# ~/.zshrc

# --- Powerlevel10k Instant Prompt ---
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- Oh-My-Zsh & Theme Configuration ---
export ZSH="$HOME/.oh-my-zsh"
export COLORTERM=truecolor
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

# --- OpenSSL Cert Store Fix ---
export RUBYOPT="-r$HOME/.rubyopenssl_default_store.rb $RUBYOPT"

# --- Helper: Idempotent PATH prepend ---
path_prepend() {
  for p in "$@"; do
    case ":$PATH:" in *":$p:"*) ;; *) PATH="$p:$PATH";; esac
  done
}

# --- Environment & Toolchain Paths ---
# Homebrew
path_prepend "/opt/homebrew/bin" "/opt/homebrew/sbin"

# Rust / Cargo (brew rustup is keg-only, per `brew info rustup`)
path_prepend "/opt/homebrew/opt/rustup/bin" "$HOME/.cargo/bin"

# Java / SDKMAN
export JAVA_HOME="$HOME/.sdkman/candidates/java/current"
export SDKMAN_DIR="$HOME/.sdkman"
path_prepend "$JAVA_HOME/bin"

# Android SDK
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
path_prepend \
  "$ANDROID_SDK_ROOT/emulator" \
  "$ANDROID_SDK_ROOT/platform-tools" \
  "$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"

# Flutter / Dart / FVM
path_prepend \
  "$HOME/fvm/bin" \
  "$HOME/fvm/default/bin" \
  "$HOME/.pub-cache/bin"

# User-local & Tool Binaries
path_prepend \
  "$HOME/.local/bin" \
  "$HOME/bin" \
  "$HOME/.kimi-code/bin" \
  "/Applications/Sublime Text.app/Contents/SharedSupport/bin" \
  "/Applications/VMware Fusion.app/Contents/Public" \
  "/usr/local/share/dotnet" \
  "$HOME/.dotnet/tools" \
  "/Library/Frameworks/Mono.framework/Versions/Current/Commands" \
  "$HOME/Applications/iTerm.app/Contents/Resources/utilities" \
  "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"

# --- Shell Completions & Dynamic Inits ---
# Dart CLI completion
[[ -f "$HOME/.dart-cli-completion/zsh-config.zsh" ]] && . "$HOME/.dart-cli-completion/zsh-config.zsh" || true

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# SDKMAN init
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# iTerm2 Shell Integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# --- Aliases ---
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias update='sudo softwareupdate -i -a; brew update; brew upgrade; omz update'
alias pray="git add -A && echo 'added' && git commit -m '🙏🔥 updated' "
alias dev="cd ~/Developer"
alias devssd="cd /Volumes/Cheng/Dev_ssd"
alias dotfiles="cd '$HOME/dotfiles'"
alias gt-tronics="cd '$HOME/Developer/active/gt-tronics'"
alias blog="cd '$HOME/Developer/completed/github_dong0085'"
alias active="cd '$HOME/Developer/active'"


# --- Custom Functions ---
caffm() {
  caffeinate -d -t $(($1 * 60))
}

# Deep-clean Flutter project and Xcode build caches before shelving
flutter-shelf() {
  if [[ -f "pubspec.yaml" ]]; then
    echo "🧹 Cleaning Flutter project..."
    flutter clean
    echo "🧹 Cleaning project-local Android and iOS caches..."
    rm -rf android/.gradle ios/Pods ios/.symlinks
  else
    echo "ℹ️  No pubspec.yaml found in current directory. Skipping project-local clean."
  fi
  echo "🧹 Cleaning Xcode DerivedData..."
  rm -rf "$HOME/Library/Developer/Xcode/DerivedData"/*
  echo "✅ Done! Build caches cleared."
}

# --- Flutter Run for QK connect with Environment Variables ---
flutter_run_connect() {
  if [[ -z "$1" ]]; then
    echo "Usage: flutter_run_connect <device_id> [extra flutter args...]"
    return 1
  fi

  local device_id="$1"
  shift

  fvm flutter run \
    --dart-define-from-file=.env.local \
    --dart-define=DX_AT_TRACE=true \
    --dart-define=CSLOGGER_SHOW_MODULES=DxAtch \
    --dart-define=CSLOGGER_LEVEL=debug \
    -d "$device_id" \
    "$@"
}

# --- Flutter Run (release) for QK connect with Environment Variables ---
flutter_run_connect_release() {
  if [[ -z "$1" ]]; then
    echo "Usage: flutter_run_connect_release <device_id> [extra flutter args...]"
    return 1
  fi

  local device_id="$1"
  shift

  fvm flutter run --release \
    --dart-define-from-file=.env.local \
    --dart-define=DX_AT_TRACE=true \
    --dart-define=CSLOGGER_SHOW_MODULES=DxAtch \
    --dart-define=CSLOGGER_LEVEL=debug \
    -d "$device_id" \
    "$@"
}

# --- Flutter Run for QK Recast with Environment Variables ---
_flutter_run_recast() {
  local mode_flag="$1" name="$2"
  shift 2
  if [[ -z "$1" ]]; then
    echo "Usage: $name <device_id> [extra flutter args...]"
    return 1
  fi

  local device_id="$1"
  shift

  local -a extra
  [[ -n "$mode_flag" ]] && extra+=("$mode_flag")

  fvm flutter run \
    "${extra[@]}" \
    --dart-define=DX_AT_TRACE=true \
    --dart-define=CSLOGGER_SHOW_MODULES=DxAtch \
    -d "$device_id" \
    "$@"
}

flutter_run_recast() { _flutter_run_recast "" flutter_run_recast "$@"; }
flutter_run_recast_release() { _flutter_run_recast --release flutter_run_recast_release "$@"; }

# Recipe archive
unalias recipe recipes 2>/dev/null
unset -f recipe 2>/dev/null
recipes() {
  if [[ $# -eq 0 ]]; then
    cd /Users/eric/Developer/active/recipes
  else
    /Users/eric/Developer/active/recipes/recipe "$@"
  fi
}

# chrome-devtools-axi: use Chrome for Testing
export CHROME_DEVTOOLS_AXI_EXECUTABLE_PATH="$HOME/.cache/puppeteer/chrome/mac_arm-156.0.8078.47/chrome-mac-arm64/Google Chrome for Testing.app/Contents/MacOS/Google Chrome for Testing"


