#!/usr/bin/env bash
set -euxo pipefail

if ! command -v node >/dev/null 2>&1; then
  dnf update -y
  dnf install -y ruby wget curl nodejs npm || yum install -y ruby wget curl nodejs npm
fi

mkdir -p /opt/portfolio-app
chmod 755 /opt/portfolio-app

if command -v systemctl >/dev/null 2>&1; then
  if ! systemctl list-unit-files --type=service | grep -q '^codedeploy-agent.service'; then
    cd /tmp
    wget "https://aws-codedeploy-${region}.s3.${region}.amazonaws.com/latest/install" -O codedeploy-install.sh
    chmod +x codedeploy-install.sh
    ./codedeploy-install.sh auto
  fi

  systemctl enable --now codedeploy-agent || true
fi

if [ ! -f /opt/portfolio-app/server.js ]; then
  cat >/opt/portfolio-app/server.js <<'APP'
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
fi

if [ -f /opt/portfolio-app/package.json ]; then
  cd /opt/portfolio-app
  npm install --omit=dev --no-fund --no-audit || npm install --no-fund --no-audit || true
fi

cat >/etc/systemd/system/portfolio-app.service <<'SERVICE'
[Unit]
Description=Portfolio app
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
WorkingDirectory=/opt/portfolio-app
ExecStart=/usr/bin/node /opt/portfolio-app/server.js
Restart=always
RestartSec=5
Environment=PORT=3000
Environment=APP_VERSION=1.0.0

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable --now portfolio-app || true

for i in $(seq 1 30); do
  if curl -fsS http://127.0.0.1:3000/health >/dev/null 2>&1; then
    exit 0
  fi
  sleep 2
done

systemctl status portfolio-app --no-pager --lines=40 || true
curl -i http://127.0.0.1:3000/health || true
exit 1
