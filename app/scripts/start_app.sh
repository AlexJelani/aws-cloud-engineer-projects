#!/usr/bin/env bash
set -euo pipefail

cd /opt/portfolio-app
npm ci --omit=dev

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
