# My Dotfiles :rocket:

These are my dotfiles!  
Macos and windows supported (zsh on both).  
No guarantees :warning: :firecracker:

## Installation

```sh
❯ ./install.sh
# Generated env file
# Installed zsh profile
# Installed neovim and ideavim configs
# Done!!!
```

### Uninstalling

Simply remove these lines:

```sh
# ~/.zshrc
source '/path/to/dotfiles/.env'
source "$DOTFILES_ROOT/zshrc"

# ~/.config/nvim/init.vim OR ~/AppData/Local/nvim/init.vim
source /path/to/dotfiles/init.vim

# ~/.ideavimrc
source /path/to/dotfiles/init.vim
source /path/to/dotfiles/ideavimrc
```

## Whats included

###  Powerlevel10k prompt

### Zgenom with omz and other plugins (with a possible exclude list)
* Syntax highlighting
* Fish-style autosuggestions
* History with `fzf`
* Alias tips
* Autopairing
* ... and more!

### Zsh utils including:
* Persistent aliases (`persist-alias`)
* A calc alias (`=`)
* Utils for time-measurement
* +++

### My neovim and ideavim config including plugins and keybindings:
* Multiple cursors
* Surround
* Arg text object
* Remap like cutlass with OS clipboard integration
