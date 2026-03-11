#!/bin/bash
input=$(cat)
id=$(echo "$input" | jq -r '.session_id // empty')
[ -n "$id" ] && rm -f ~/.claude/sessions/"$id"
