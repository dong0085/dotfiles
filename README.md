# dotfiles

My Mac setup: shell config, git config, apps, Karabiner and Ghostty.

Keep this repo at `~/dotfiles`. `config.sh` expects it there.

---

## Save your current setup to this repo

`fetch.sh` copies the latest config files from your Mac into this repo.

```bash
cd ~/dotfiles
./fetch.sh          # copy the latest configs into the repo
./fetch.sh --brew   # same, plus rewrite Brewfile from everything Homebrew has installed
git diff            # check what changed, then commit
```

| Repo file | Copied from |
| :--- | :--- |
| `.bash_profile`, `.gitconfig`, `.gitignore`, `.zshrc` | `~/` |
| `karabiner.json` | `~/.config/karabiner/karabiner.json` |
| `ghostty/config.ghostty` | `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty` |
| `Brewfile` | `brew bundle dump` (only with `--brew`) |

Notes:

- `--brew` replaces the hand-sorted Brewfile with the full list of installed apps and tools. Run it when you want that full list.
- To back up another plain config file, add a line to the `FILES` list at the top of `fetch.sh`:

  ```bash
  "$HOME/path/to/file|name-in-repo"
  ```

---

## Set up a new Mac

### 1. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

This also installs Apple's command-line tools, which include `git`.

### 2. Download this repo

```bash
git clone https://github.com/dong0085/dotfiles.git ~/dotfiles
```

The repo is public, so this works before you sign in to GitHub.

### 3. Install apps and tools

```bash
brew bundle --file=~/dotfiles/Brewfile
```

Homebrew installs everything in the list, skips anything already installed, and lists any that failed at the end.

### 4. Copy the dotfiles into your home folder

```bash
~/dotfiles/config.sh
```

This copies `.bash_profile`, `.gitconfig`, `.gitignore`, `.zshrc` and `.p10k.zsh` to `~/`.

Then install Oh-My-Zsh and the theme and plugins `.zshrc` uses:

```bash
KEEP_ZSHRC=yes RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
ZSH_CUSTOM=~/.oh-my-zsh/custom
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
```

Open a new terminal window to load them. If there's no `.p10k.zsh` in the repo yet, the prompt wizard starts; run `./fetch.sh` afterwards to save its result.

### 5. Sign in to GitHub

Your git settings come over with the dotfiles, but your logins and keys stay on the old Mac. Sign in once on the new Mac:

```bash
gh auth login
```

Pick **GitHub.com → SSH → Generate a new SSH key → Login with a web browser**. This creates `~/.ssh/id_ed25519`, adds it to your GitHub account, and signs in the `gh` tool.

After that:

- **SSH repos** (`git@github.com:...`) use the new key.
- **HTTPS repos** (`https://github.com/...`) use Git Credential Manager. The first time you push, it opens a browser to sign in, then saves the login in your Keychain.
- **Codeberg** uses its own key. Make one with `ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_codeberg` and add the `.pub` file in Codeberg's SSH settings.

To push changes to this repo over SSH:

```bash
git -C ~/dotfiles remote set-url origin git@github.com:dong0085/dotfiles.git
```

To keep your old keys instead, copy the `~/.ssh` folder from the old Mac (AirDrop or USB drive), then run `chmod 700 ~/.ssh && chmod 600 ~/.ssh/id_*`. Keep `~/.ssh` out of this repo, since the repo is public.

### 6. Karabiner-Elements

```bash
mkdir -p ~/.config/karabiner
cp ~/dotfiles/karabiner.json ~/.config/karabiner/karabiner.json
```

Karabiner picks up the new file on its own. On a new Mac, open Karabiner-Elements once and give it the permissions it asks for:

- Approve the driver extension (**System Settings → General → Login Items & Extensions → Driver Extensions**).
- Turn on **Karabiner-Core-Service** in **System Settings → Privacy & Security → Input Monitoring**.

To check it works, tap Caps Lock: it should act as Escape.

### 7. Ghostty

```bash
mkdir -p ~/Library/Application\ Support/com.mitchellh.ghostty
cp ~/dotfiles/ghostty/config.ghostty ~/Library/Application\ Support/com.mitchellh.ghostty/config.ghostty
```

In Ghostty, press `Cmd+Shift+,` to reload the config.

---

## What's in this repo

| File / folder | What it is |
| :--- | :--- |
| `fetch.sh` | Copies the latest configs from this Mac into the repo |
| `config.sh` | Copies the dotfiles from the repo into `~/` |
| `Brewfile` | Apps and command-line tools to install with Homebrew |
| `.zshrc`, `.bash_profile` | Shell settings |
| `.gitconfig`, `.gitignore` | Git settings |
| `karabiner.json` | Karabiner-Elements key remapping |
| `ghostty/` | Ghostty terminal settings |
| `apps.txt`, `cli-apps.txt` | Older app lists (the Brewfile now covers these) |
| `instructions.rtf` | Older Homebrew setup notes (steps 1 and 3 above cover these) |
