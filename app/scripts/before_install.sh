#!/usr/bin/env bash
set -euo pipefail

dnf install -y nodejs npm || yum install -y nodejs npm
mkdir -p /opt/portfolio-app

