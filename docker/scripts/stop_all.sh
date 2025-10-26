#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/../.."

services=(
  ssh_bruteforce
  server
  ids
  syslog
  kibana
  elasticsearch
)

echo "Arrêt des services: ${services[*]}"

docker compose stop "${services[@]}" || true
docker compose rm -f "${services[@]}" || true

echo
echo "🧹 Nettoyage des conteneurs zombies orphelins (genre ssh_server vieux, etc.)"
docker container prune -f >/dev/null 2>&1 || true

echo
echo "Tout est arrêté."