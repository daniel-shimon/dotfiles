_ALIASES_FILE="$HOME/.zsh_utils/paliases.zsh"

persist-alias() {
	if ! which $1 >/dev/null; then
		echo Alias "'$1'" does not exist
		return 1
	fi
	sed -i '' "/^alias $1=/d" "$_ALIASES_FILE"
	echo "$(alias -L $1)" >> "$_ALIASES_FILE"
}

persist-function() {
	which "$1" >> "$_ALIASES_FILE"
}

sync-persistant() {
	source "$_ALIASES_FILE"
}

mkdir -p "$HOME/.zsh_utils"
touch "$_ALIASES_FILE"
sync-persistant

_comp-persist-alias() {
	compadd $(alias -r | pcre2grep -o1 '^(\S+)=')
}

compdef _comp-persist-alias persist-alias

