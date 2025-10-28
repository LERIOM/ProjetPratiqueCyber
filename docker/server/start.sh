#!/bin/bash
set -euo pipefail
syslog-ng
python3 /usr/local/bin/miniweb.py &
exec /usr/sbin/sshd -D

