FROM alpine:3.20
RUN apk add --no-cache syslog-ng curl jq && mkdir -p /etc/syslog-ng
CMD ["syslog-ng", "-F", "-f", "/etc/syslog-ng/syslog-ng.conf"]