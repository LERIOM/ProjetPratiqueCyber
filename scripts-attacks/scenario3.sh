#!/bin/bash

echo "Début du scénario 3 : Attaque par Force Brute sur SSH ".

for i in {1..10}
do
    ssh -p 2222 testuser@localhost 'exit' || true
done

echo "Scénario 3 terminé".