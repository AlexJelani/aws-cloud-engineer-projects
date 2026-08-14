#!/usr/bin/env bash
set -euo pipefail

dnf update -y
dnf install -y ruby wget curl
cd /tmp
wget "https://aws-codedeploy-${region}.s3.${region}.amazonaws.com/latest/install"
chmod +x ./install
./install auto
systemctl enable codedeploy-agent
systemctl start codedeploy-agent

mkdir -p /opt/portfolio-app/app
cat >/opt/portfolio-app/app/server.js <<'APP'
const http = require("http");
const server = http.createServer((req, res) => {
  const body = JSON.stringify({ status: "healthy", bootstrap: true });
  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(body);
});
server.listen(3000);
APP

dnf install -y nodejs npm
cat >/etc/systemd/system/portfolio-app.service <<'SERVICE'
[Unit]
Description=Bootstrap portfolio app
After=network.target

[Service]
Type=simple
WorkingDirectory=/opt/portfolio-app/app
ExecStart=/usr/bin/node server.js
Restart=always

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable portfolio-app
systemctl start portfolio-app

