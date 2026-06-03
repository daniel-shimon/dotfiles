#!/bin/bash
# Send a query to the Snowflake bridge and wait for results.
# Usage: snowflake_query.sh "SELECT ..."
set -e

BRIDGE_DIR="/tmp/snowflake-bridge"
QUERY_FILE="$BRIDGE_DIR/query.sql"
RESULT_FILE="$BRIDGE_DIR/result.json"
STATUS_FILE="$BRIDGE_DIR/status"
TIMEOUT=${2:-60}

# Check bridge is running
status=$(cat "$STATUS_FILE" 2>/dev/null || echo "stopped")
if [ "$status" = "stopped" ] || [ ! -f "$STATUS_FILE" ]; then
    echo "Error: Snowflake bridge is not running. Start it first." >&2
    exit 1
fi

# Wait if bridge is busy
elapsed=0
while [ "$(cat "$STATUS_FILE" 2>/dev/null)" = "running" ]; do
    sleep 0.3
    elapsed=$((elapsed + 1))
    if [ "$elapsed" -gt "$TIMEOUT" ]; then
        echo "Error: Timed out waiting for bridge to become ready." >&2
        exit 1
    fi
done

# Remove stale result
rm -f "$RESULT_FILE"

# Submit query
echo "$1" > "$QUERY_FILE"

# Wait for result
elapsed=0
while true; do
    s=$(cat "$STATUS_FILE" 2>/dev/null)
    if [ "$s" = "done" ]; then
        break
    fi
    sleep 0.3
    elapsed=$((elapsed + 1))
    if [ "$elapsed" -gt "$TIMEOUT" ]; then
        echo "Error: Query timed out after ${TIMEOUT}s." >&2
        exit 1
    fi
done

# Output result and reset status
cat "$RESULT_FILE"
echo "ready" > "$STATUS_FILE"
