chmod +x docker/scripts/build_all.sh \
          docker/scripts/start_all.sh \
          docker/scripts/stop_all.sh



# tout lancer
./docker/scripts/build_all.sh
./docker/scripts/start_all.sh

# lancer un nmap pour attaque 2

nmap -sV -p 2222 localhost


# attaque 

for i in {1..15}; do                                             
  ssh -p 2222 testuser@localhost 'exit' || true
done


