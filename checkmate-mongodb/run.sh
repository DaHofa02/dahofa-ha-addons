#!/bin/bash
echo "[mongodb] Starting MongoDB..."
echo "[mongodb] Data directory: /data/db"
mkdir -p /data/db
ls -la /data/
echo "[mongodb] Launching mongod..."
exec mongod \
    --bind_ip_all \
    --dbpath /data/db \
    --nojournal \
    --setParameter diagnosticDataCollectionEnabled=false
