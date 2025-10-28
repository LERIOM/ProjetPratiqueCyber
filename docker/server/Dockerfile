FROM debian:12

RUN apt-get update && \
    apt-get install -y openssh-server syslog-ng curl python3 && \
    rm -rf /var/lib/apt/lists/*

# sshd setup
RUN mkdir /var/run/sshd
RUN sed -ri 's/^#?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -ri 's/^#?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config

# user de test
RUN useradd -m testuser && echo "testuser:password123" | chpasswd

# config syslog-ng client
COPY ./config/syslog-ng-client.conf /etc/syslog-ng/syslog-ng.conf

# notre mini serveur web et le script de démarrage
COPY ./miniweb.py /usr/local/bin/miniweb.py
COPY ./start.sh   /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

EXPOSE 22
EXPOSE 80

CMD ["/usr/local/bin/start.sh"]