#!/usr/bin/env bash
set -euo pipefail

mkdir -p /opt/portfolio-app
chown -R root:root /opt/portfolio-app
chmod 755 /opt/portfolio-app

cd /opt/portfolio-app
if [ -f Dockerfile ] && [ -f package.json ]; then
  docker build -t portfolio-app:latest .
fi

cat >/etc/systemd/system/portfolio-app.service <<'SERVICE'
[Unit]
Description=Portfolio app container
After=docker.service network.target
Wants=docker.service network.target

[Service]
Type=simple
Restart=always
RestartSec=5
Environment=PORT=3000
Environment=APP_VERSION=1.0.0
ExecStart=/usr/bin/docker run --rm --name portfolio-app -p 3000:3000 -e PORT=3000 -e APP_VERSION=1.0.0 portfolio-app:latest
ExecStop=/usr/bin/docker stop portfolio-app || true

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable portfolio-app || true
systemctl restart portfolio-app || true
