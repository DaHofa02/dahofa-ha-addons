# mongo:7.0 is Debian-based and has apt — use it as base
# then add Node.js for the Checkmate backend
FROM mongo:7.0

# Install Node.js 22 (LTS)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    jq \
    ca-certificates \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy Checkmate app from upstream image
COPY --from=ghcr.io/bluewave-labs/checkmate-backend-mono:latest /app /app

RUN mkdir -p /data/mongodb

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
