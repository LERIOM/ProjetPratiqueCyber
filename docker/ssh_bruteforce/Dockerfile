FROM debian:12

RUN apt-get update && \
    apt-get install -y sshpass openssh-client && \
    rm -rf /var/lib/apt/lists/*


COPY ssh_bruteforce.sh /ssh_bruteforce.sh
RUN chmod +x /ssh_bruteforce.sh

CMD ["/ssh_bruteforce.sh"]