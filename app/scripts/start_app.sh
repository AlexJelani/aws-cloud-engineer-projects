#!/usr/bin/env bash
set -euo pipefail

mkdir -p /opt/portfolio-app
cd /opt/portfolio-app

if [ -f package-lock.json ]; then
  npm ci --omit=dev
fi

cat >/etc/systemd/system/portfolio-app.service <<'SERVICE'
[Unit]
Description=AWS portfolio application
After=network.target

[Service]
Type=simple
WorkingDirectory=/opt/portfolio-app
Environment=PORT=3000
ExecStart=/usr/bin/node server.js
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable portfolio-app
systemctl restart portfolio-app
