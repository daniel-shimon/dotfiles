---
name: history
description: Use when the user invokes /history, asks to browse past sessions, or references something from a previous conversation ("we talked about...", "you told me...", "find where we discussed..."). Covers searching, listing, and recalling past Claude Code sessions across all projects.
---

# history

## Overview

Browse, search, and recall past Claude Code sessions from `~/.claude/history.jsonl`. Adapt the response style to the invocation — a casual recall question gets a conversational answer; an explicit `/history` command gets a structured table.

## File Size Warning

`~/.claude/history.jsonl` can be very large. **Never read the full file.**

| Need | Strategy |
|------|----------|
| Recent sessions | `tail -n 400` |
| Keyword/topic search | Always dispatch subagent |
| Scanning result sets | Always dispatch subagent |

Always use a subagent for any search or scan of history content. Only `tail` for listing recent sessions can stay in main context.

## Invocation Modes

### `/history` or "show my history"
List ~20 most recent sessions as a formatted table.

```
| #  | Date         | Project       | Topic                                   | Session ID |
|----|--------------|---------------|-----------------------------------------|------------|
| 1  | Mar 21 14:32 | my-app        | Fixed authentication bug in login flow  | abc123…    |
```

- Parse first human message of each session as the topic
- Truncate topic to ~70 chars, session ID to 8 chars + `…`
- Remind: `claude --resume <full-session-id>` to resume

### `/history search <term>` or "find where we talked about X"
Search for keyword across history. Always dispatch a subagent to run `grep -i` on the file and summarize results.

Respond conversationally if the user asked casually ("we worked on that auth bug a few weeks ago...") rather than forcing a table.

### `/history project <name>`
Filter sessions by project path. `grep` for the project name.

### `/history last <N>` / `/history today` / `/history week`
Recency filters. `tail` for small N; dispatch subagent for any week/date-range scan.

### "You told me..." / "We talked about..."
The user is recalling something specific. Search history with relevant keywords from their message. Respond naturally — summarize what you find, quote relevant parts, give context. No need for a table.

## Common Mistakes

- Reading the full file — always use `tail` or `grep`
- Forcing table format for a casual recall question — match the tone
- Searching history in main context — always use a subagent for any grep/scan
