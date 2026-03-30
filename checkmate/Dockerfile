ARG BUILD_FROM
FROM ${BUILD_FROM}

# ── system packages ──────────────────────────────────────────────────────────
RUN apk add --no-cache \
    bash \
    curl \
    gnupg \
    s6-overlay \
    jq

# ── MongoDB (from Checkmate's own image) ────────────────────────────────────
# We copy the mongod binary + required libs from the upstream mongo image
# so we stay single-container (HA add-on best practice).
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

# ── s6-overlay service definitions ──────────────────────────────────────────
COPY rootfs /

# ── data directory ───────────────────────────────────────────────────────────
RUN mkdir -p /data/mongodb

# ── startup script ───────────────────────────────────────────────────────────
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
