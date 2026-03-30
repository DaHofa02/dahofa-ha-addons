FROM node:22-bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    jq \
    bash \
    ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Download MongoDB 6.0 binary directly — pick correct URL based on arch
RUN ARCH=$(dpkg --print-architecture) \
    && if [ "$ARCH" = "amd64" ]; then \
         curl -fsSL "https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-debian12-6.0.19.tgz" -o /tmp/mongo.tgz; \
       elif [ "$ARCH" = "arm64" ]; then \
         curl -fsSL "https://fastdl.mongodb.org/linux/mongodb-linux-aarch64-debian12-6.0.19.tgz" -o /tmp/mongo.tgz; \
       else echo "Unsupported arch: $ARCH" && exit 1; fi \
    && tar -xzf /tmp/mongo.tgz -C /tmp \
    && mv /tmp/mongodb-linux-*/bin/mongod /usr/local/bin/mongod \
    && chmod +x /usr/local/bin/mongod \
    && rm -rf /tmp/mongo* \
    && mongod --version

# Download mongosh
RUN ARCH=$(dpkg --print-architecture) \
    && if [ "$ARCH" = "amd64" ]; then \
         curl -fsSL "https://downloads.mongodb.com/compass/mongosh-2.3.1-linux-x64.tgz" -o /tmp/mongosh.tgz; \
       elif [ "$ARCH" = "arm64" ]; then \
         curl -fsSL "https://downloads.mongodb.com/compass/mongosh-2.3.1-linux-arm64.tgz" -o /tmp/mongosh.tgz; \
       else echo "Unsupported arch: $ARCH" && exit 1; fi \
    && tar -xzf /tmp/mongosh.tgz -C /tmp \
    && mv /tmp/mongosh-*/bin/mongosh /usr/local/bin/mongosh \
    && chmod +x /usr/local/bin/mongosh \
    && rm -rf /tmp/mongosh* \
    && mongosh --version

COPY --from=ghcr.io/bluewave-labs/checkmate-backend-mono-multiarch:latest /app /app

RUN mkdir -p /data/mongodb

COPY run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
