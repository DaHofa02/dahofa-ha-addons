ARG BUILD_FROM

# ── Stage 1: get mongod for the correct arch from official image ──────────────
FROM mongo:7.0 AS mongo-src

# ── Stage 2: get Checkmate (has Node.js built in) ────────────────────────────
FROM ghcr.io/bluewave-labs/checkmate-backend-mono:latest AS checkmate-src

# ── Stage 3: final image based on HA base ────────────────────────────────────
FROM ${BUILD_FROM}

RUN apk add --no-cache bash curl jq

# Copy mongod + mongosh from the official mongo image (correct arch)
COPY --from=mongo-src /usr/bin/mongod /usr/bin/mongod
COPY --from=mongo-src /usr/bin/mongosh /usr/bin/mongosh

# Copy all mongo shared libs
COPY --from=mongo-src /usr/lib/*-linux-gnu/libssl.so* /usr/lib/
COPY --from=mongo-src /usr/lib/*-linux-gnu/libcrypto.so* /usr/lib/
COPY --from=mongo-src /usr/lib/*-linux-gnu/libcurl.so* /usr/lib/
COPY --from=mongo-src /lib/*-linux-gnu/libc.so* /lib/
COPY --from=mongo-src /lib/*-linux-gnu/libm.so* /lib/
COPY --from=mongo-src /lib/*-linux-gnu/libpthread.so* /lib/
COPY --from=mongo-src /lib/*-linux-gnu/libdl.so* /lib/

# Copy Node.js runtime from Checkmate image
COPY --from=checkmate-src /usr/local/bin/node /usr/local/bin/node
COPY --from=checkmate-src /usr/local/lib/node_modules /usr/local/lib/node_modules

# Copy Checkmate app
COPY --from=checkmate-src /app /app

RUN mkdir -p /data/mongodb

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
