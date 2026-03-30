#!/usr/bin/env bash
set -euo pipefail

CONFIG_PATH=/data/options.json
JWT_SECRET=$(jq -r '.jwt_secret // "change_me_please"' "$CONFIG_PATH")
BASE_URL=$(jq -r '.base_url // "http://localhost:52345"' "$CONFIG_PATH")
MONGO_HOST=$(jq -r '.mongodb_host // "localhost"' "$CONFIG_PATH")
MONGO_PORT=$(jq -r '.mongodb_port // 27017' "$CONFIG_PATH")
BASE_URL="${BASE_URL%/}"

echo "[checkmate] Starting Checkmate backend..."
echo "[checkmate] Connecting to MongoDB at ${MONGO_HOST}:${MONGO_PORT}"
echo "[checkmate] Using base URL: ${BASE_URL}"

export NODE_ENV=production
export PORT=52345
export UPTIME_APP_API_BASE_URL="${BASE_URL}/api/v1"
export UPTIME_APP_CLIENT_HOST="${BASE_URL}"
export CLIENT_HOST="${BASE_URL}"
export DB_CONNECTION_STRING="mongodb://${MONGO_HOST}:${MONGO_PORT}/uptime_db"
export JWT_SECRET="$JWT_SECRET"

# Find the actual entrypoint
cd /app
if [ -f "dist/index.js" ]; then
    exec node dist/index.js
elif [ -f "index.js" ]; then
    exec node index.js
elif [ -f "server.js" ]; then
    exec node server.js
elif [ -f "src/index.js" ]; then
    exec node src/index.js
else
    echo "[checkmate] Looking for entrypoint..."
    find /app -maxdepth 2 -name "*.js" | head -20
    exit 1
fi
