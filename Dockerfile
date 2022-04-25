FROM alpine:latest

# ssh-keygen -A generates all necessary host keys (rsa, dsa, ecdsa, ed25519) at default location.
RUN    apk update \
    && apk add openssh rsync bash

COPY ./sshd_config /etc/ssh/sshd_config

RUN addgroup -S user && adduser -S user -G user -s /bin/bash -h /home/user && passwd -d -u user

RUN addgroup -S tunnel && adduser -S tunnel -G tunnel -s /bin/false -h /home/tunnel && passwd -d -u tunnel

USER user
WORKDIR /home/user
RUN mkdir -p .ssh && touch .ssh/authorized_keys && chmod 644 .ssh/authorized_keys

USER tunnel
WORKDIR /home/tunnel
RUN mkdir -p .ssh && touch .ssh/authorized_keys && chmod 644 .ssh/authorized_keys

USER root

COPY docker-entrypoint.sh /

EXPOSE 22

ENTRYPOINT ["/docker-entrypoint.sh"]

# -D in CMD below prevents sshd from becoming a daemon. -e is to log everything to stderr.
CMD ["/usr/sbin/sshd", "-D", "-e"]


