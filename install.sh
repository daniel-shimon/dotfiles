#!/usr/bin/env bash

echo "DOTFILES_ROOT='$PWD'" > .env

function ensure-line {
	if ! grep "$1" "$2" -q; then
		echo "$1" >> "$2"
	fi
}

ensure-line "source '$PWD/.env'" "$HOME/.zshrc"
ensure-line 'source "$DOTFILES_ROOT/zshrc"' "$HOME/.zshrc"

