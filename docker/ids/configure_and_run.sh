#!/bin/bash
set -euo pipefail

SNORT_CONF="/etc/snort/snort.conf"
SNORT_TEMPLATE="/etc/snort/snort.conf.template"
LOCAL_RULES="/etc/snort/rules/local.rules"

# Syslog distant (défaut : conteneur 'syslog')
SYSLOG_HOST="${SYSLOG_HOST:-syslog}"
SYSLOG_PORT="${SYSLOG_PORT:-5514}"

# ------------------- ADAPTATION POUR TEST INTERNE (LOOPBACK) -------------------
# Fixe l'interface et le réseau au mode Loopback pour garantir la détection sous WSL2
INTERFACE="lo" 
HOME_NET="127.0.0.1/8" 
EXTERNAL_NET="!${HOME_NET}"
# --------------------------------------------------------------------------------

echo "=== Initialisation Snort IDS ==="
echo "Interface détectée : ${INTERFACE} (Mode Loopback)"
echo "HOME_NET  : ${HOME_NET}"
echo "EXTERNAL_NET : ${EXTERNAL_NET}"
echo "Syslog : ${SYSLOG_HOST}:${SYSLOG_PORT}"
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
# Ajoute les sorties désirées (Syslog pour la collecte, fast pour le debug)
echo "output alert_syslog: LOG_LOCAL0 LOG_ALERT" >> "${SNORT_CONF}"
echo "output alert_fast: /var/log/snort/alert" >> "${SNORT_CONF}"
echo "Sorties de log ajoutées à snort.conf"

# --- 3. Validation et Lancement ---
echo "Test de configuration Snort..."
/usr/sbin/snort -T -c "${SNORT_CONF}" -i "${INTERFACE}"

echo "Lancement de Snort IDS..."
# Lancement en mode Premier Plan (sans -D) pour voir les alertes dans docker logs -f ids
exec /usr/sbin/snort -q -i "${INTERFACE}" -c "${SNORT_CONF}"