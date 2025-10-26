#!/bin/bash

TARGET_HOST=server
TARGET_PORT=22
TARGET_USER=testuser

# on envoie volontairement un mauvais mot de passe plusieurs fois
for i in $(seq 1 10); do
  sshpass -p "1234567" ssh -o StrictHostKeyChecking=no -p $TARGET_PORT ${TARGET_USER}@${TARGET_HOST} "exit" || true
  sleep 0.1
done

echo "Tentatives terminées."