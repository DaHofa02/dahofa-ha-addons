#!/usr/bin/env bash
set -euo pipefail

# ── Read options from HA config ──────────────────────────────────────────────
CONFIG_PATH=/data/options.json
JWT_SECRET=$(jq -r '.jwt_secret // "change_me_please"' "$CONFIG_PATH")
MONGO_PORT=$(jq -r '.mongodb_port // 27017' "$CONFIG_PATH")
BASE_URL=$(jq -r '.base_url // "http://localhost:52345"' "$CONFIG_PATH")
BASE_URL="${BASE_URL%/}"

echo "[checkmate] Using base URL: ${BASE_URL}"

# ── Directories ───────────────────────────────────────────────────────────────
MONGO_DATA=/data/mongodb
mkdir -p "$MONGO_DATA"

# ── Start MongoDB ─────────────────────────────────────────────────────────────
echo "[checkmate] Starting MongoDB on port ${MONGO_PORT}…"
mongod \
    --quiet \
    --bind_ip 127.0.0.1 \
    --port "$MONGO_PORT" \
    --dbpath "$MONGO_DATA" \
    --logpath /dev/null \
    &
MONGO_PID=$!

# Wait for MongoDB to be ready (use mongo CLI if mongosh not available)
echo "[checkmate] Waiting for MongoDB to become ready…"
for i in $(seq 1 30); do
    if mongosh --port "$MONGO_PORT" --eval "db.adminCommand('ping')" --quiet &>/dev/null 2>&1; then
        break
    elif mongo --port "$MONGO_PORT" --eval "db.adminCommand('ping')" --quiet &>/dev/null 2>&1; then
        break
    fi
    sleep 1
done
echo "[checkmate] MongoDB is ready."

# ── Start Checkmate backend ───────────────────────────────────────────────────
echo "[checkmate] Starting Checkmate backend…"
export NODE_ENV=production
export PORT=52345
export UPTIME_APP_API_BASE_URL="${BASE_URL}/api/v1"
export UPTIME_APP_CLIENT_HOST="${BASE_URL}"
export CLIENT_HOST="${BASE_URL}"
export DB_CONNECTION_STRING="mongodb://127.0.0.1:${MONGO_PORT}/uptime_db"
export JWT_SECRET="$JWT_SECRET"

cd /app
node server.js &
APP_PID=$!

# ── Trap signals for clean shutdown ──────────────────────────────────────────
trap 'echo "[checkmate] Shutting down…"; kill $APP_PID $MONGO_PID 2>/dev/null; wait' SIGTERM SIGINT

wait $APP_PID
