#!/usr/bin/env bash
set -euo pipefail

for _ in $(seq 1 30); do
  if curl -fsS http://127.0.0.1:3000/health >/dev/null 2>&1; then
    exit 0
  fi
  sleep 2
done

systemctl status portfolio-app --no-pager --lines=40 || true
curl -i http://127.0.0.1:3000/health || true
exit 1

