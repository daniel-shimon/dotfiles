# /// script
# dependencies = ["snowflake-connector-python[secure-local-storage]"]
# ///
"""
Persistent Snowflake connection bridge.

Runs as a long-lived process, polls for query files, executes them,
and writes results. Designed to run inside tmux for persistence.

Usage: uv run snowflake_bridge.py [connection_name]
"""
import configparser
import json
import os
import signal
import sys
import time

BRIDGE_DIR = "/tmp/snowflake-bridge"
QUERY_FILE = os.path.join(BRIDGE_DIR, "query.sql")
RESULT_FILE = os.path.join(BRIDGE_DIR, "result.json")
STATUS_FILE = os.path.join(BRIDGE_DIR, "status")
PID_FILE = os.path.join(BRIDGE_DIR, "pid")


def write_status(status):
    with open(STATUS_FILE, "w") as f:
        f.write(status)


def read_snowsql_config(connection_name):
    config = configparser.ConfigParser()
    config.read(os.path.expanduser("~/.snowsql/config"))
    section = f"connections.{connection_name}"

    params = {}
    mapping = {
        "account": ["account", "accountname"],
        "user": ["username", "user"],
        "password": ["password"],
        "authenticator": ["authenticator"],
        "role": ["role"],
        "warehouse": ["warehouse", "warehousename"],
        "database": ["database", "dbname"],
        "schema": ["schema", "schemaname"],
    }

    for key, aliases in mapping.items():
        for alias in aliases:
            try:
                val = config.get(section, alias).strip('"').strip("'")
                if val and val not in ("<none selected>", ""):
                    params[key] = val
                    break
            except (configparser.NoSectionError, configparser.NoOptionError):
                continue

    return params


def main():
    import snowflake.connector

    conn_name = sys.argv[1] if len(sys.argv) > 1 else "main"
    print(f"Reading config for connection '{conn_name}'...")

    params = read_snowsql_config(conn_name)
    print(f"Connecting to {params.get('account')} as {params.get('user')}...")

    conn = snowflake.connector.connect(**params)
    cursor = conn.cursor()
    print("Connected.")

    os.makedirs(BRIDGE_DIR, exist_ok=True)
    with open(PID_FILE, "w") as f:
        f.write(str(os.getpid()))

    # Clean up stale files
    for f in (QUERY_FILE, RESULT_FILE):
        if os.path.exists(f):
            os.remove(f)

    write_status("ready")
    print(f"Bridge ready. Watching {QUERY_FILE}")

    def shutdown(sig, frame):
        print("\nShutting down...")
        conn.close()
        write_status("stopped")
        sys.exit(0)

    signal.signal(signal.SIGTERM, shutdown)
    signal.signal(signal.SIGINT, shutdown)

    last_keepalive = time.time()

    while True:
        # Keepalive every 5 minutes
        if time.time() - last_keepalive > 300:
            try:
                cursor.execute("SELECT 1")
                last_keepalive = time.time()
            except Exception:
                print("Connection lost, reconnecting...")
                conn = snowflake.connector.connect(**params)
                cursor = conn.cursor()
                last_keepalive = time.time()
                print("Reconnected.")

        if os.path.exists(QUERY_FILE):
            write_status("running")

            with open(QUERY_FILE) as f:
                query = f.read().strip()
            os.remove(QUERY_FILE)

            print(f"Executing: {query[:100]}...")

            try:
                cursor.execute(query)
                columns = [desc[0] for desc in cursor.description] if cursor.description else []
                rows = cursor.fetchall()
                result = {
                    "status": "ok",
                    "columns": columns,
                    "rows": [list(row) for row in rows],
                    "row_count": len(rows),
                }
                print(f"  -> {len(rows)} rows")
            except Exception as e:
                result = {"status": "error", "error": str(e)}
                print(f"  -> Error: {e}")

            with open(RESULT_FILE, "w") as f:
                json.dump(result, f, indent=2, default=str)

            write_status("done")

        time.sleep(0.2)


if __name__ == "__main__":
    main()
