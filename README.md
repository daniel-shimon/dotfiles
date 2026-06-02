# Dotfiles :rocket:

macOS dotfiles. Shell: **fish**. Editor: **neovim** (+ IdeaVim for JetBrains).
Managed with [GNU stow](https://www.gnu.org/software/stow/) (symlink packages).

## Layout

Each top-level dir is a stow package mirroring `$HOME`:

```
fish/    → ~/.config/fish/   config.fish, fish_plugins, functions, conf.d, tide-config
nvim/    → ~/.config/nvim/   init.vim (vim-plug: treesitter, catppuccin, gitsigns, ...)
ideavim/ → ~/.ideavimrc      (sources init.vim + ideavim extras)
git/     → ~/.config/git/    config (delta pager, includeIf for work identity)
bat/     → ~/.config/bat/
tmux/    → ~/.tmux.conf
claude/  → ~/.claude/        CLAUDE.md, RTK.md
Brewfile → generic Homebrew packages
```

## New machine

```sh
# 1. Homebrew + packages
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew bundle --file=Brewfile

# 2. Symlink configs
stow fish nvim ideavim git bat tmux claude

# 3. Fish plugins (fisher reads fish_plugins)
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
fisher update

# 4. tide/fzf customizations apply automatically (conf.d/tide-config.fish)

# 5. neovim plugins
nvim +PlugInstall +qall

# 6. Secrets — copy template, fill real values (gitignored)
cp ~/.config/fish/conf.d/secrets.fish.example ~/.config/fish/conf.d/secrets.fish
$EDITOR ~/.config/fish/conf.d/secrets.fish
```

## Secrets

Real secrets live in `~/.config/fish/conf.d/secrets.fish` (gitignored, auto-loaded by fish).
Template: `secrets.fish.example`. **Never commit real values.**

## Work config

Work-specific functions, env, and ssh live in a separate private repo.
Its fish files stow into `~/.config/fish/conf.d/` and load automatically —
this public config has no hardcoded reference to it.
Work git identity (email) applies under `~/src/` via `includeIf`.
