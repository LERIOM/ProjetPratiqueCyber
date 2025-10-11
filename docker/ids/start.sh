#!/usr/bin/env bash
set -euo pipefail
# Snort en mode lecture de pcap si fourni, sinon il sort au 1er plan en attente (facile à tester)
PCAP="${TEST_PCAP:-}"
CONF="/etc/snort/snort.conf"

if [[ -n "${PCAP}" && -f "${PCAP}" ]]; then
  echo "[*] Running snort on PCAP: ${PCAP}"
  # -A console pour voir quelque chose, ET alert_syslog activé dans conf
  exec snort -c "$CONF" -A console -r "$PCAP" -l /var/log/snort
else
  echo "[*] No PCAP provided. Exiting after config test."
  snort -T -c "$CONF"  # test de conf
  tail -f /dev/null
fi