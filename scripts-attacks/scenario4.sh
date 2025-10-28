#!/bin/bash
sudo apt install hping3

echo "Début du scénario 4 : Ping Flood ".

timeout 10s sudo hping3 -p 22 --flood -1 172.18.0.5

echo "Scénario 4 terminé".

