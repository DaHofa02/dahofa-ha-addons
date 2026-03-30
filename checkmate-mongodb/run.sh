#!/bin/bash
set -e
mkdir -p /data/db
chown -R $(id -u):$(id -g) /data/db
exec mongod --quiet --bind_ip_all --dbpath /data/db
