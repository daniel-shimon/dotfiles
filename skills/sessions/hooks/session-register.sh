#!/bin/bash
input=$(cat)
id=$(echo "$input" | jq -r '.session_id // empty')
[ -z "$id" ] && exit 0
mkdir -p ~/.claude/sessions
tty=$(ps -o tty= -p $PPID 2>/dev/null | tr -d ' ')
cat > ~/.claude/sessions/"$id" << INNER
pid="$PPID"
tty="${tty:-bg}"
cwd="${CLAUDE_PROJECT_DIR:-$(pwd)}"
started="$(date +%s)"
status="idle"
prompt=""
INNER
