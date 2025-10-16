ES_HOST="localhost"
ES_PORT="9200"
INDEX_PREFIX="syslog-ng"

timestamp() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}
index_doc() {
  local index="$1"
  local doc="$2"
  curl -s -X POST "http://${ES_HOST}:${ES_PORT}/${index}/_doc" -H "Content-Type: application/json" -d "${doc}"
  echo
}
echo "Starting injection of sample logs into http://${ES_HOST}:${ES_PORT} ..."

# SCN1 SQL Injection
doc_sql=$(cat <<'JSON'
{
  "timestamp": "`date -u +%Y-%m-%dT%H:%M:%SZ`",
  "host": "webserver-01",
  "program": "apache",
  "log": "192.168.10.5 - - [15/Oct/2025:12:05:22 +0000] \"GET /products.php?id=1 UNION SELECT username,password FROM users HTTP/1.1\" 200 4521",
  "src_ip": "192.168.10.5",
  "dst_ip": "192.168.10.20",
  "dst_port": 80,
  "method": "GET",
  "uri": "/products.php?id=1 UNION SELECT username,password FROM users",
  "threat_type": "sql_injection",
  "detection": {
    "engine": "snort",
    "rule_id": 1000001,
    "priority": 1
  }
}
JSON
)
index_doc "${INDEX_PREFIX}-$(date +%Y.%m.%d)" "${doc_sql}"

# SCN2 Webshell upload
doc_upload=$(cat <<'JSON'
{
  "timestamp":"`date -u +%Y-%m-%dT%H:%M:%SZ`",
  "host":"webserver-01",
  "program":"apache",
  "method":"POST",
  "uri":"/upload.php",
  "src_ip":"10.0.0.12",
  "file_name":"shell.php",
  "content_type":"multipart/form-data",
  "detection":{"engine":"snort","rule_id":1000002,"priority":1},
  "threat_type":"webshell_upload"
}
JSON
)
index_doc "${INDEX_PREFIX}-$(date +%Y.%m.%d)" "${doc_upload}"

# SCN3 SSH brute-force
doc_ssh=$(cat <<'JSON'
{
  "timestamp":"`date -u +%Y-%m-%dT%H:%M:%SZ`",
  "host":"host-ssh",
  "program":"sshd",
  "message":"Failed password for root from 203.0.113.45 port 52312 ssh2",
  "src_ip":"203.0.113.45",
  "dst_port":22,
  "event":"auth_failed",
  "threat_type":"ssh_bruteforce"
}
JSON
)
index_doc "${INDEX_PREFIX}-$(date +%Y.%m.%d)" "${doc_ssh}"

# SCN4 SYN flood (firewall)
doc_syn=$(cat <<'JSON'
{
  "timestamp":"`date -u +%Y-%m-%dT%H:%M:%SZ`",
  "host":"firewall-01",
  "program":"kernel",
  "message":"UFW BLOCK SRC=198.51.100.200 DST=10.0.0.20 PROTO=TCP SPT=40001 DPT=80 FLAGS=SYN",
  "src_ip":"198.51.100.200",
  "dst_ip":"10.0.0.20",
  "threat_type":"syn_flood",
  "detection":{"engine":"snort","rule_id":1000004}
}
JSON
)
index_doc "${INDEX_PREFIX}-$(date +%Y.%m.%d)" "${doc_syn}"

# SCN5 SMB lateral movement (Windows)
doc_smb=$(cat <<'JSON'
{
  "timestamp":"`date -u +%Y-%m-%dT%H:%M:%SZ`",
  "host":"dc-01",
  "event_id":4624,
  "account":"svc_backup",
  "logon_type":3,
  "src_ip":"10.0.0.45",
  "threat_type":"lateral_movement",
  "notes":"svc_backup logged on from workstation not seen before"
}
JSON
)
index_doc "${INDEX_PREFIX}-$(date +%Y.%m.%d)" "${doc_smb}"

