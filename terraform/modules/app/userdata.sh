#!/usr/bin/env bash
set -euxo pipefail

dnf update -y

dnf install -y ruby wget curl nodejs npm

cd /tmp
wget "https://aws-codedeploy-${region}.s3.${region}.amazonaws.com/latest/install"
chmod +x ./install
./install auto
systemctl enable --now codedeploy-agent

mkdir -p /opt/portfolio-app/app
cat >/opt/portfolio-app/app/server.js <<'APP'
const http = require("http");
const port = process.env.PORT || 3000;
const version = process.env.APP_VERSION || "1.0.0";

function sendJson(res, statusCode, payload) {
  res.writeHead(statusCode, { "Content-Type": "application/json" });
  res.end(JSON.stringify(payload));
}

function requestHandler(req, res) {
  if (req.url === "/health") {
    sendJson(res, 200, { status: "healthy", version });
    return;
  }

  if (req.url === "/") {
    sendJson(res, 200, {
      service: "aws-cloud-engineer-portfolio-app",
      status: "ok",
      version,
      message: "Served from an Auto Scaling group behind an Application Load Balancer."
    });
    return;
  }

  sendJson(res, 404, { error: "not_found" });
}

const app = http.createServer(requestHandler);

if (require.main === module) {
  app.listen(port, () => {
    console.log(`Portfolio app listening on port ${port}`);
  });
}

module.exports = { app, requestHandler };
APP

cat >/etc/systemd/system/portfolio-app.service <<'SERVICE'
[Unit]
Description=Portfolio app
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
WorkingDirectory=/opt/portfolio-app/app
ExecStart=/usr/bin/node /opt/portfolio-app/app/server.js
Restart=always
RestartSec=5
Environment=PORT=3000
Environment=APP_VERSION=1.0.0

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable --now portfolio-app
systemctl status portfolio-app --no-pager --lines=20 || true
curl -fsS http://localhost:3000/health || true

