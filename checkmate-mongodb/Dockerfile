FROM mongo:6.0
RUN mkdir -p /data/db
ENTRYPOINT ["mongod", "--quiet", "--bind_ip_all", "--dbpath", "/data/db"]
