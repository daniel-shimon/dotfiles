function measure { 
    local TIMEFMT="TIME=%E="
    { time "$@" } 1>&2 2>&1 | grep -oE 'TIME=.*?=' | cut -d= -f2 | cut -ds -f1
}

avg-file () {
	cat "$1" | pyp 'sum(map(float, lines)) / len(lines)'
}
