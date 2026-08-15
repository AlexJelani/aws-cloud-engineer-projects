#!/usr/bin/env bash
set -euo pipefail

# Stop any prior service instance without deleting the deployed app files.
if systemctl list-unit-files --type=service | grep -q '^portfolio-app.service'; then
  systemctl stop portfolio-app || true
  systemctl disable portfolio-app || true
fi

mkdir -p /opt/portfolio-app
chmod 755 /opt/portfolio-app
