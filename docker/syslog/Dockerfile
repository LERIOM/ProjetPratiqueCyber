FROM alpine:3.20

# Ajout de 'syslog-ng-http' pour le support d'Elasticsearch
RUN apk add --no-cache syslog-ng syslog-ng-http curl jq && \
    mkdir -p /etc/syslog-ng

# La commande CMD reste la même
CMD ["syslog-ng", "-F", "-f", "/etc/syslog-ng/syslog-ng.conf"]