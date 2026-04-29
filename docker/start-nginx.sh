#!/bin/bash
# Start nginx in the background
echo "[start-nginx] Starting nginx reverse proxy..."
nginx -g 'daemon off;' &
echo "[start-nginx] Nginx started on port 8080"
