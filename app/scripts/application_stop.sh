#!/usr/bin/env bash
set -euo pipefail

if systemctl is-active --quiet portfolio-app; then
  systemctl stop portfolio-app
fi

if systemctl is-enabled --quiet portfolio-app; then
  systemctl disable portfolio-app
fi

rm -rf /opt/portfolio-app
