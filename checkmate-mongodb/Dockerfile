FROM mongo:6.0
RUN mkdir -p /data/db && chown -R mongodb:mongodb /data/db
USER mongodb
ENTRYPOINT ["mongod", "--quiet", "--bind_ip_all", "--dbpath", "/data/db"]
