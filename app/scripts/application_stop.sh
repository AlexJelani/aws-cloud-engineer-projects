#!/usr/bin/env bash
set -euo pipefail

if systemctl is-active --quiet portfolio-app; then
  systemctl stop portfolio-app || true
fi

if systemctl is-enabled --quiet portfolio-app; then
  systemctl disable portfolio-app || true
fi

mkdir -p /opt/portfolio-app
