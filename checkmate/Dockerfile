ARG BUILD_FROM
FROM ${BUILD_FROM}

# ── system packages ──────────────────────────────────────────────────────────
RUN apk add --no-cache \
    bash \
    curl \
    jq

# ── MongoDB (from Checkmate's own image) ────────────────────────────────────
COPY --from=ghcr.io/bluewave-labs/checkmate-mongo:latest \
    /usr/bin/mongod \
    /usr/bin/mongod

COPY --from=ghcr.io/bluewave-labs/checkmate-mongo:latest \
    /usr/bin/mongosh \
    /usr/bin/mongosh

COPY --from=ghcr.io/bluewave-labs/checkmate-mongo:latest \
    /usr/lib/libssl.so* \
    /usr/lib/libcrypto.so* \
    /usr/lib/

# ── Checkmate backend ────────────────────────────────────────────────────────
COPY --from=ghcr.io/bluewave-labs/checkmate-backend-mono:latest \
    /app \
    /app

# ── data directory ───────────────────────────────────────────────────────────
RUN mkdir -p /data/mongodb

# ── startup script ───────────────────────────────────────────────────────────
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
