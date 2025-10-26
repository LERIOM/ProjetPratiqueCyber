#!/bin/bash
set -euo pipefail

SNORT_CONF="/etc/snort/snort.conf"
SNORT_TEMPLATE="/etc/snort/snort.conf.template"
LOCAL_RULES="/etc/snort/rules/local.rules"

# ------------------- CONFIGURATION RÉSEAU GÉNÉRIQUE -------------------
INTERFACE="eth0"
HOME_NET="any"
EXTERNAL_NET="any"
# --------------------------------------------------------------------------------

echo "=== Initialisation Snort IDS ==="
echo "Interface détectée : ${INTERFACE}"
echo "HOME_NET  : ${HOME_NET}"
echo "EXTERNAL_NET : ${EXTERNAL_NET}"
echo

# Préparation des répertoires
mkdir -p /var/log/snort
chmod 755 /var/log/snort || true

# --- 1. Création de snort.conf à partir du template (INJECTION DYNAMIQUE) ---
if [ ! -f "${SNORT_TEMPLATE}" ]; then
  echo "ERREUR : ${SNORT_TEMPLATE} introuvable. Le fichier doit être dans le dossier config/."
  exit 1
fi

# Copie et création du fichier de configuration final
cp "${SNORT_TEMPLATE}" "${SNORT_CONF}"

# Met à jour les variables réseau dans le snort.conf final
sed -i "s|^ipvar HOME_NET any|ipvar HOME_NET ${HOME_NET}|" "${SNORT_CONF}"
sed -i "s|^ipvar EXTERNAL_NET any|ipvar EXTERNAL_NET ${EXTERNAL_NET}|" "${SNORT_CONF}"

# --- 2. Configuration des sorties pour la collecte ---
echo "output alert_fast: /var/log/snort/alert" >> "${SNORT_CONF}"
echo "Sortie de log (fichier) ajoutée à snort.conf"

# --- 3. Validation et Lancement ---
echo "Test de configuration Snort..."
/usr/sbin/snort -T -c "${SNORT_CONF}" -i "${INTERFACE}"

echo "Lancement de Snort IDS..."
exec /usr/sbin/snort -q -i "${INTERFACE}" -c "${SNORT_CONF}"

