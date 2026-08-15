#!/usr/bin/env bash
set -euo pipefail

mkdir -p /opt/portfolio-app
chown -R root:root /opt/portfolio-app
chmod 755 /opt/portfolio-app

if [ -f /opt/portfolio-app/package.json ]; then
  cd /opt/portfolio-app
  npm install --omit=dev --no-fund --no-audit || npm install --no-fund --no-audit || true
fi

cat >/etc/systemd/system/portfolio-app.service <<'SERVICE'
[Unit]
Description=AWS portfolio application
After=network.target

[Service]
Type=simple
WorkingDirectory=/opt/portfolio-app
Environment=PORT=3000
Environment=APP_VERSION=1.0.0
ExecStart=/usr/bin/node /opt/portfolio-app/server.js
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable portfolio-app || true
systemctl restart portfolio-app || true
