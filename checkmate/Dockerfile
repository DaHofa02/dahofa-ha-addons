ARG BUILD_FROM
FROM ${BUILD_FROM}

# ── system packages ──────────────────────────────────────────────────────────
RUN apk add --no-cache \
    bash \
    curl \
    jq \
    mongodb \
    mongodb-tools

# ── Checkmate backend ────────────────────────────────────────────────────────
COPY --from=ghcr.io/bluewave-labs/checkmate-backend-mono:latest \
    /app \
    /app

# ── data directory ───────────────────────────────────────────────────────────
RUN mkdir -p /data/mongodb

# ── startup script ───────────────────────────────────────────────────────────
COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
