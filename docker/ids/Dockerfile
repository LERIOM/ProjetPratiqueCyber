FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        snort \
        iproute2 \
        iputils-ping \
        procps \
        netcat-openbsd \
        tzdata \
        dos2unix && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/snort/rules /var/log/snort && chmod 755 /var/log/snort

COPY configure_and_run.sh /usr/local/bin/configure_and_run.sh
RUN chmod +x /usr/local/bin/configure_and_run.sh
RUN dos2unix /usr/local/bin/configure_and_run.sh

CMD ["/usr/local/bin/configure_and_run.sh"]
