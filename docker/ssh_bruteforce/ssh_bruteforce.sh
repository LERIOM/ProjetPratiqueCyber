#!/bin/bash

TARGET_HOST=server
TARGET_PORT=22
TARGET_USER=testuser

# on envoie volontairement un mauvais mot de passe plusieurs fois
for i in $(seq 1 30); do
  sshpass -p "mauvais_mdp" ssh -o StrictHostKeyChecking=no -p $TARGET_PORT ${TARGET_USER}@${TARGET_HOST} "exit" || true
  sleep 0.2
done

echo "Tentatives terminées."