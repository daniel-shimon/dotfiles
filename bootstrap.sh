#!/usr/bin/env bash
# Public dotfiles bootstrap. Idempotent. Run from repo root.
set -euo pipefail
cd "$(dirname "$0")"

step() { printf '\n\033[1;36m==> %s\033[0m\n' "$1"; }

# 1. Homebrew
if ! command -v brew >/dev/null; then
  step "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

step "Installing Brewfile packages"
brew bundle --file=Brewfile

# 2. Stow symlinks
step "Stowing config packages"
command -v stow >/dev/null || brew install stow
stow --no-folding --target="$HOME" --restow fish nvim git bat tmux claude bin
stow --no-folding --target="$HOME" --restow ideavim   # ideavimrc -> ~/.ideavimrc


# 3. Fisher + fish plugins
step "Installing fisher + fish plugins"
fish -c '
  if not functions -q fisher
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
    fisher install jorgebucaran/fisher
  end
  fisher update
'
# tide/fzf customizations auto-apply via conf.d/tide-config.fish on next shell.

# 3b. Language toolchains
step "Rust toolchain (rustup)"
if command -v rustup >/dev/null; then
  rustup default stable   # install + default to latest stable; no pinned version
fi

step "uv tools"
if command -v uv >/dev/null; then
  uv tool install ipython
  uv tool install playwright
fi

# 4. Neovim plugins (vim-plug)
step "Installing neovim plugins"
if [ ! -f "$HOME/.local/share/nvim/site/autoload/plug.vim" ]; then
  curl -fLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
nvim +PlugInstall +qall || true

# 5. Claude Code tooling (hooks self-install — not tracked in settings.json)
step "Claude Code tooling"
# rtk: token-killer proxy. Installs its own PreToolUse hook.
if command -v rtk >/dev/null; then
  rtk init --global || true
else
  echo "rtk not found (add to Brewfile or 'brew install rtk-ai/tap/rtk'), skipping rtk init"
fi
# caveman: ultra-compress mode plugin. Declares its own SessionStart/UserPromptSubmit hooks.
if command -v claude >/dev/null; then
  claude plugin marketplace add JuliusBrussee/caveman || true
  claude plugin install caveman@caveman || true
else
  echo "claude CLI not found, skipping caveman plugin install"
fi

# 6. Secrets reminder
step "Secrets"
SECRETS="$HOME/.config/fish/conf.d/secrets.fish"
if [ ! -f "$SECRETS" ]; then
  cp "$HOME/.config/fish/conf.d/secrets.fish.example" "$SECRETS"
  echo "Created $SECRETS from template — fill in real values."
fi

# 7. macOS Terminal.app profile
step "Terminal.app profile"
if [ -f macos/Material.terminal ]; then
  open macos/Material.terminal       # imports "Material" profile into Terminal.app
  sleep 1
  defaults write com.apple.Terminal "Default Window Settings" -string "Material"
  defaults write com.apple.Terminal "Startup Window Settings" -string "Material"
  echo "Imported Material profile + set as default (restart Terminal to apply)."
fi

# 8. Set fish as default shell
step "Default shell"
FISH="$(command -v fish)"
if ! grep -q "$FISH" /etc/shells; then echo "$FISH" | sudo tee -a /etc/shells; fi
[ "$SHELL" = "$FISH" ] || chsh -s "$FISH"

echo
echo "Done. Work config: clone your private work-config repo into ~/src and run its bootstrap."
