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

echo "Lancement des services: ${services[*]}"

docker compose up -d "${services[@]}"

echo
echo "État actuel:"
docker ps

echo
echo "Le conteneur d'attaque (ssh_bruteforce) N'A PAS été lancé."
echo "   Pour lancer l'attaque plus tard:"
echo "   docker compose up --build ssh_bruteforce"
