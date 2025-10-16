FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        snort \
        iproute2 \
        iputils-ping \
        procps \
        tzdata && \
    rm -rf /var/lib/apt/lists/*

# Prépare les dossiers
RUN mkdir -p /etc/snort/rules /var/log/snort && chmod 755 /var/log/snort

# Copie les fichiers de configuration
COPY config/ /etc/snort/

# Copie le script d’exécution
COPY configure_and_run.sh /usr/local/bin/configure_and_run.sh
RUN chmod +x /usr/local/bin/configure_and_run.sh

CMD ["/usr/local/bin/configure_and_run.sh"]
