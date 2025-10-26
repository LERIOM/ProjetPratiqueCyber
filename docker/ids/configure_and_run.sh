#!/bin/bash
set -euo pipefail

SNORT_CONF="/etc/snort/snort.conf"
SNORT_TEMPLATE="/etc/snort/snort.conf.template"

# --- CONFIGURATION RÉSEAU (Mode Host) ---
# 'eth0' est l'interface réelle de l'hôte (corrige l'erreur DLT 113)
# 'any' permet de tester les attaques locales
INTERFACE="eth0" 
HOME_NET="any" 
EXTERNAL_NET="any"
# --------------------------------------------------------------------------------

echo "=== Initialisation Snort IDS ==="
echo "Interface : ${INTERFACE}"
echo "HOME_NET  : ${HOME_NET}"
echo "EXTERNAL_NET : ${EXTERNAL_NET}"
echo

# Préparation des répertoires
mkdir -p /var/log/snort
chmod 777 /var/log/snort || true # Droits permissifs pour éviter les problèmes d'écriture

# --- 1. Création de snort.conf à partir du template ---
if [ ! -f "${SNORT_TEMPLATE}" ]; then
  echo "ERREUR : ${SNORT_TEMPLATE} introuvable."
  exit 1
fi

cp "${SNORT_TEMPLATE}" "${SNORT_CONF}"

# Met à jour les variables réseau dans le snort.conf final
sed -i "s|^ipvar HOME_NET any|ipvar HOME_NET ${HOME_NET}|" "${SNORT_CONF}"
sed -i "s|^ipvar EXTERNAL_NET any|ipvar EXTERNAL_NET ${EXTERNAL_NET}|" "${SNORT_CONF}"

# --- 2. Configuration de la sortie fichier (Syslog lit ce fichier) ---
echo "output alert_fast: /var/log/snort/alert" >> "${SNORT_CONF}"
echo "Sortie 'alert_fast' ajoutée à snort.conf"

# --- 3. Validation et Lancement ---
echo "Test de configuration Snort..."
/usr/sbin/snort -T -c "${SNORT_CONF}" -i "${INTERFACE}"

echo "Lancement de Snort IDS..."
exec /usr/sbin/snort -q -i "${INTERFACE}" -c "${SNORT_CONF}"
