# Use Node.js slim (Debian) as base — correct arch via Docker Buildx
FROM node:22-bookworm-slim

# Install MongoDB 6.0 — the version Checkmate officially uses for ARM
# mongo:6.0 supports ARM without AVX requirement
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg \
    curl \
    jq \
    bash \
    && curl -fsSL https://www.mongodb.org/static/pgp/server-6.0.asc \
       | gpg --dearmor -o /usr/share/keyrings/mongodb-server-6.0.gpg \
    && echo "deb [ arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/debian bookworm/mongodb-org/6.0 main" \
       > /etc/apt/sources.list.d/mongodb-org-6.0.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       mongodb-org-server \
       mongodb-mongosh \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy Checkmate app — use multiarch image for correct Node modules
COPY --from=ghcr.io/bluewave-labs/checkmate-backend-mono-multiarch:latest /app /app

RUN mkdir -p /data/mongodb

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
