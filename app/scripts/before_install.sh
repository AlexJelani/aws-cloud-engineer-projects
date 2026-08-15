#!/usr/bin/env bash
set -euo pipefail

if ! command -v docker >/dev/null 2>&1; then
  dnf install -y docker || yum install -y docker
  systemctl enable --now docker
fi

mkdir -p /opt/portfolio-app
chmod 755 /opt/portfolio-app

