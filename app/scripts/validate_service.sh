#!/usr/bin/env bash
set -euo pipefail

for _ in {1..30}; do
  if curl -fsS http://127.0.0.1:3000/health >/dev/null; then
    exit 0
  fi
  sleep 2
done

systemctl status portfolio-app --no-pager
exit 1

