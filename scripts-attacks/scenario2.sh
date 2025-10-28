#!/bin/bash

# ==============================================================================
# SCRIPT POUR SCANNER LES PORTS LOCAUX AVEC NMAP
# Cible: localhost (127.0.0.1)
# ==============================================================================

echo "Ce script va utiliser nmap pour scanner les 100 ports TCP les plus courants sur votre propre machine."
echo "Ceci est une opération de diagnostic standard."
echo ""

# Vérification de l'installation de nmap
if ! command -v nmap &> /dev/null
then
    echo "nmap n'est pas installé. Installation en cours..."
    sudo apt-get update && sudo apt-get install nmap -y
fi

echo "Lancement du scan sur localhost (127.0.0.1)..."
echo "------------------------------------------------"

# Exécution de la commande nmap
nmap -sV 127.0.0.1

echo "------------------------------------------------"
echo "Scan terminé. ✅"