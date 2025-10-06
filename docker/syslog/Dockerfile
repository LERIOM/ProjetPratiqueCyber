FROM alpine:3.20
RUN apk add --no-cache syslog-ng curl jq
# point d’entrée simple: syslog-ng au 1er plan
CMD ["syslog-ng", "-F", "-f", "/etc/syslog-ng/syslog-ng.conf"]