ARG BUILD_FROM
FROM ${BUILD_FROM}

# ── system packages ──────────────────────────────────────────────────────────
RUN apk add --no-cache \
    bash \
    curl \
    jq \
    libssl3 \
    libcrypto3

# ── MongoDB binary (arch-aware) ──────────────────────────────────────────────
# We download the correct MongoDB binary for the build architecture
ARG TARGETARCH
RUN set -eux; \
    case "${TARGETARCH}" in \
        amd64) \
            MONGO_URL="https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2204-7.0.14.tgz" ;; \
        arm64) \
            MONGO_URL="https://fastdl.mongodb.org/linux/mongodb-linux-aarch64-ubuntu2204-7.0.14.tgz" ;; \
        *) echo "Unsupported arch: ${TARGETARCH}"; exit 1 ;; \
    esac; \
    curl -fsSL "${MONGO_URL}" -o /tmp/mongodb.tgz; \
    tar -xzf /tmp/mongodb.tgz -C /tmp; \
    mv /tmp/mongodb-linux-*/bin/mongod /usr/bin/mongod; \
    rm -rf /tmp/mongodb*

# ── mongosh ──────────────────────────────────────────────────────────────────
RUN set -eux; \
    case "${TARGETARCH}" in \
        amd64) \
            MONGOSH_URL="https://downloads.mongodb.com/compass/mongosh-2.3.1-linux-x64.tgz" ;; \
        arm64) \
            MONGOSH_URL="https://downloads.mongodb.com/compass/mongosh-2.3.1-linux-arm64.tgz" ;; \
        *) echo "Unsupported arch: ${TARGETARCH}"; exit 1 ;; \
    esac; \
    curl -fsSL "${MONGOSH_URL}" -o /tmp/mongosh.tgz; \
    tar -xzf /tmp/mongosh.tgz -C /tmp; \
    mv /tmp/mongosh-*/bin/mongosh /usr/bin/mongosh; \
    mv /tmp/mongosh-*/bin/mongosh_crypt_v1.so /usr/lib/ 2>/dev/null || true; \
    rm -rf /tmp/mongosh*

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
