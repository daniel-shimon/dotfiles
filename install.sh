#!/usr/bin/env bash

function ensure-line {
	if ! grep "$1" "$2" -q; then
		echo "$1" >> "$2"
	fi
}

function announce {
	echo '#' "$@"
}

function warn {
	echo '!' "$@"
}

function os-path {
	if [ "$OS" = "Windows_NT" ]; then
		cygpath -w "$1"
	else
		echo "$1"
	fi
}

# Env file

echo "DOTFILES_ROOT='$PWD'" > .env

if [ -f "$HOME/.zgenom/zgenom.zsh" ]; then
	echo "ZGENOM='$HOME/.zgenom'" >> .env
elif [ -f "$HOME/.zgen/zgenom.zsh" ]; then
	echo "ZGENOM='$HOME/.zgen'" >> .env
else
	warn 'No zgenom installation found!'
	exit 1
fi

announce Generated env file

# Zshrc

touch "$HOME/.zshrc"
ensure-line "source '$PWD/.env'" "$HOME/.zshrc"
ensure-line 'source "$DOTFILES_ROOT/zshrc"' "$HOME/.zshrc"

announce Installed zsh profile

# Vim and IdeaVim

touch "$HOME/.ideavimrc"
if [ -f "$HOME/.config/nvim/init.vim" ]; then
	ensure-line "source $PWD/init.vim" "$HOME/.config/nvim/init.vim"
elif [ -f "$HOME/AppData/Local/nvim/init.vim" ]; then
	ensure-line "source $(os-path $PWD/init.vim)" "$HOME/AppData/Local/nvim/init.vim"
else
	warn Skipping neovim config
fi
ensure-line "source $(os-path $PWD/init.vim)" "$HOME/.ideavimrc"
ensure-line "source $(os-path $PWD/ideavimrc)" "$HOME/.ideavimrc"

announce Installed neovim and ideavim configs

# Done

announce "Done!!!"

