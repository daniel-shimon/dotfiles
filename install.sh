#!/usr/bin/env bash

echo "DOTFILES_ROOT='$PWD'" > .env

if [ -f "$HOME/.zgenom/zgenom.zsh" ]; then
	echo "ZGENOM='$HOME/.zgenom'" >> .env
elif [ -f "$HOME/.zgen/zgenom.zsh" ]; then
	echo "ZGENOM='$HOME/.zgen'" >> .env
else
	echo 'No zgenom installation found!'
	exit 1
fi

function ensure-line {
	if ! grep "$1" "$2" -q; then
		echo "$1" >> "$2"
	fi
}

touch "$HOME/.zshrc"
ensure-line "source '$PWD/.env'" "$HOME/.zshrc"
ensure-line 'source "$DOTFILES_ROOT/zshrc"' "$HOME/.zshrc"

echo '#' Installed hooks and created .env file:
echo
cat .env

