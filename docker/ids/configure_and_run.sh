#!/bin/bash
set -euo pipefail

SNORT_CONF="/etc/snort/snort.conf"
LOCAL_RULES="/etc/snort/rules/local.rules"

# Syslog distant (défaut : conteneur 'syslog')
SYSLOG_HOST="${SYSLOG_HOST:-syslog}"
SYSLOG_PORT="${SYSLOG_PORT:-5514}"

# Interface réseau (priorité : non-loopback sinon lo)
INTERFACE=$(ip -o link show up | awk -F': ' '$2 != "lo" {print $2; exit}' || true)
INTERFACE=${INTERFACE:-lo}

# Détection réseau
HOME_NET=$(ip -o -f inet addr show "${INTERFACE}" 2>/dev/null | awk '{print $4}' || true)
HOME_NET=${HOME_NET:-127.0.0.1/8}
EXTERNAL_NET="!${HOME_NET}"

echo "=== Initialisation Snort IDS ==="
echo "Interface détectée : ${INTERFACE}"
echo "HOME_NET  : ${HOME_NET}"
echo "EXTERNAL_NET : ${EXTERNAL_NET}"
echo "Syslog : ${SYSLOG_HOST}:${SYSLOG_PORT}"
echo

# Préparation des répertoires
mkdir -p /var/log/snort
chmod 755 /var/log/snort || true

# Vérifie que snort.conf existe
if [ ! -f "${SNORT_CONF}" ]; then
  echo "ERREUR : ${SNORT_CONF} introuvable."
  exit 1
fi

# Met à jour les variables réseau
sed -i "s|^ipvar HOME_NET .*|ipvar HOME_NET ${HOME_NET}|" "${SNORT_CONF}"
sed -i "s|^ipvar EXTERNAL_NET .*|ipvar EXTERNAL_NET ${EXTERNAL_NET}|" "${SNORT_CONF}"

# Nettoyage des anciennes sorties
sed -i '/^output alert_syslog/d' "${SNORT_CONF}" || true
sed -i '/^output alert_fast/d' "${SNORT_CONF}" || true

# Ajoute les sorties désirées
echo "output alert_syslog: LOG_LOCAL0 LOG_ALERT" >> "${SNORT_CONF}"
echo "output alert_fast: /var/log/snort/alert" >> "${SNORT_CONF}"
echo "Sorties de log ajoutées à snort.conf"

# Test de la configuration Snort
echo "Test de configuration Snort..."
/usr/sbin/snort -T -c "${SNORT_CONF}" -i "${INTERFACE}"

echo "Lancement de Snort IDS..."
exec /usr/sbin/snort -q -i "${INTERFACE}" -c "${SNORT_CONF}"
