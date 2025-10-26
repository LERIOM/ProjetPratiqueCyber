#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/../.."


services=(
  elasticsearch
  kibana
  syslog
  ids
  server
)

echo " Build des services: ${services[*]}"

docker compose build "${services[@]}"

echo "Build terminé."