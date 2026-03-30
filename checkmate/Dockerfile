# Build directly on Checkmate image — Node.js is already correct arch
FROM ghcr.io/bluewave-labs/checkmate-backend-mono:latest

# Install MongoDB
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    gnupg \
    jq \
    && curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg \
    && echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/debian bookworm/mongodb-org/7.0 main" > /etc/apt/sources.list.d/mongodb-org-7.0.list \
    && apt-get update && apt-get install -y --no-install-recommends \
    mongodb-org-server \
    mongodb-mongosh \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /data/mongodb

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
