---
name: snowflake-tmux-connection
description: Use when querying Snowflake, running SQL against Snowflake, or needing a persistent Snowflake database connection from Claude Code
allowed-tools: Bash(~/.claude/skills/snowflake-tmux-connection/snowflake_query.sh:*)
---

# Snowflake Persistent Connection

Maintains a long-lived Snowflake connection in tmux so queries execute instantly without re-authenticating.

## Starting the Bridge

```bash
# Start bridge in tmux (authenticates once via browser SSO)
tmux new-session -d -s snowflake "uv run ~/.claude/skills/snowflake-tmux-connection/snowflake_bridge.py main"

# Verify it's ready
cat /tmp/snowflake-bridge/status
```

Connection name defaults to `main`. Pass a different name to use another `~/.snowsql/config` profile.

## Querying

```bash
# Run a query and get JSON result
~/.claude/skills/snowflake-tmux-connection/snowflake_query.sh "SELECT CURRENT_USER(), CURRENT_WAREHOUSE()"
```

Result format:
```json
{
  "status": "ok",
  "columns": ["CURRENT_USER()", "CURRENT_WAREHOUSE()"],
  "rows": [["USER@EXAMPLE.COM", "MY_WAREHOUSE"]],
  "row_count": 1
}
```

On error: `{"status": "error", "error": "...message..."}`

## Stopping

```bash
tmux kill-session -t snowflake
```

## How It Works

- Python script with `snowflake-connector-python` (auto-installed by `uv run`)
- File-based protocol via `/tmp/snowflake-bridge/` (query.sql -> result.json)
- Keepalive ping every 5 minutes, auto-reconnects on connection loss
- Reads connection params from `~/.snowsql/config`
