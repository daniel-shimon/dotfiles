#!/bin/bash
input=$(cat)
id=$(echo "$input" | jq -r '.session_id // empty')
file=~/.claude/sessions/"$id"
[ -z "$id" ] || [ ! -f "$file" ] && exit 0
pid=$(grep '^pid=' "$file" | cut -d'"' -f2)
tty=$(grep '^tty=' "$file" | cut -d'"' -f2)
cwd=$(grep '^cwd=' "$file" | cut -d'"' -f2)
started=$(grep '^started=' "$file" | cut -d'"' -f2)
prompt=$(grep '^prompt=' "$file" | cut -d'"' -f2)
event=$(echo "$input" | jq -r '.hook_event_name // empty')
[ "$event" = "UserPromptSubmit" ] && status="working" || status="idle"
new_prompt=$(echo "$input" | jq -r '.prompt // empty' | head -c 100 | tr '\n"' '  ')
[ -n "$new_prompt" ] && prompt="$new_prompt"
cat > "$file" << INNER
pid="$pid"
tty="$tty"
cwd="$cwd"
started="$started"
status="$status"
prompt="$prompt"
updated="$(date +%s)"
INNER
