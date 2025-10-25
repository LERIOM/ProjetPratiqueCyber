FROM debian:12


RUN apt-get update && \
    apt-get install -y openssh-server syslog-ng curl && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd

RUN sed -ri 's/^#?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -ri 's/^#?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN useradd -m testuser && echo "testuser:password123" | chpasswd

COPY ./config/syslog-ng-client.conf /etc/syslog-ng/syslog-ng.conf

CMD syslog-ng && /usr/sbin/sshd -D