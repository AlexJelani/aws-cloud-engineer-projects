#!/usr/bin/env bash
set -euxo pipefail

if ! command -v docker >/dev/null 2>&1; then
  dnf update -y
  dnf install -y docker || yum install -y docker
  systemctl enable --now docker
fi

if ! systemctl list-unit-files --type=service | grep -q '^codedeploy-agent.service'; then
  cd /tmp
  wget "https://aws-codedeploy-${region}.s3.${region}.amazonaws.com/latest/install" -O codedeploy-install.sh
  chmod +x codedeploy-install.sh
  ./codedeploy-install.sh auto
fi

systemctl enable --now codedeploy-agent || true

mkdir -p /opt/portfolio-app
chmod 755 /opt/portfolio-app

if [ -f /opt/portfolio-app/Dockerfile ]; then
  cd /opt/portfolio-app
  docker build -t portfolio-app:latest .
fi

if docker ps -a --format '{{.Names}}' | grep -qx 'portfolio-app'; then
  docker rm -f portfolio-app || true
fi

docker run -d --name portfolio-app \
  --restart unless-stopped \
  -p 3000:3000 \
  -e PORT=3000 \
  -e APP_VERSION=1.0.0 \
  portfolio-app:latest

for i in $(seq 1 30); do
  if curl -fsS http://127.0.0.1:3000/health >/dev/null 2>&1; then
    exit 0
  fi
  sleep 2
done

docker ps --format 'table {{.Names}}\t{{.Status}}'
curl -i http://127.0.0.1:3000/health || true
exit 1

