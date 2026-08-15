#!/usr/bin/env bash
set -euo pipefail

if docker ps -a --format '{{.Names}}' | grep -qx 'portfolio-app'; then
  docker stop portfolio-app || true
  docker rm -f portfolio-app || true
fi

mkdir -p /opt/portfolio-app
chmod 755 /opt/portfolio-app
