#!/usr/bin/env sh

set -e

BIN="/usr/local/v2node/v2node"
CONF_PATH="${V2NODE_CONFIG:-/etc/v2node/config.json}"

# Ensure config directory exists
CONF_DIR="$(dirname "$CONF_PATH")"
[ -d "$CONF_DIR" ] || mkdir -p "$CONF_DIR"

# If config is missing and auto-generate is not disabled, try to generate from env vars
if [ ! -f "$CONF_PATH" ] && [ -z "${V2NODE_SKIP_GENERATE:-}" ]; then
  if [ -n "${V2NODE_API_HOST:-}" ] && [ -n "${V2NODE_NODE_ID:-}" ] && [ -n "${V2NODE_API_KEY:-}" ]; then
    echo "[docker-entrypoint] Generating $CONF_PATH from environment variables" >&2

    # Build Nodes array: V2NODE_NODE_ID supports comma-separated values (e.g. "1,2,3")
    nodes_json=""
    IFS=","
    for id in ${V2NODE_NODE_ID}; do
      id="$(echo "$id" | tr -d ' ')"
      [ -z "$id" ] && continue
      [ -n "$nodes_json" ] && nodes_json="${nodes_json},"
      nodes_json="${nodes_json}
    {
      \"ApiHost\": \"${V2NODE_API_HOST}\",
      \"NodeID\": ${id},
      \"ApiKey\": \"${V2NODE_API_KEY}\",
      \"Timeout\": ${V2NODE_TIMEOUT:-15}
    }"
    done
    unset IFS

    cat > "$CONF_PATH" <<EOF
{
  "Log": {
    "Level": "${V2NODE_LOG_LEVEL:-warning}",
    "Output": "${V2NODE_LOG_OUTPUT:-}",
    "Access": "${V2NODE_LOG_ACCESS:-none}"
  },
  "Nodes": [${nodes_json}
  ]
}
EOF
  else
    echo "[docker-entrypoint] Config $CONF_PATH does not exist and V2NODE_API_HOST/V2NODE_NODE_ID/V2NODE_API_KEY are not all set" >&2
    echo "[docker-entrypoint] Either mount an existing config file or set these env vars to enable auto-generation." >&2
    exit 1
  fi
fi

# Exec v2node with passed arguments (default CMD is [\"server\"])
exec "$BIN" "$@"
