FROM alpine:latest

# ssh-keygen -A generates all necessary host keys (rsa, dsa, ecdsa, ed25519) at default location.
RUN    apk update \
    && apk add openssh rsync bash

COPY ./sshd_config /etc/ssh/sshd_config

ENV UID=1000
ENV GID=1000

RUN addgroup -S user -g $GID && adduser -S user -G user --uid $UID -s /bin/bash -h /home/user && passwd -d -u user

ENV UID=1001
ENV GID=1001

RUN addgroup -S tunnel_user -g $GID && adduser -S tunnel_user -G tunnel_user --uid $UID -s /bin/false -h /home/tunnel_user && passwd -d -u tunnel_user

USER user
WORKDIR /home/user
RUN mkdir -p .ssh && touch .ssh/authorized_keys && chmod 644 .ssh/authorized_keys

USER tunnel_user
WORKDIR /home/tunnel_user
RUN mkdir -p .ssh && touch .ssh/authorized_keys && chmod 644 .ssh/authorized_keys

USER root

COPY docker-entrypoint.sh /

EXPOSE 22

ENTRYPOINT ["/docker-entrypoint.sh"]

# -D in CMD below prevents sshd from becoming a daemon. -e is to log everything to stderr.
CMD ["/usr/sbin/sshd", "-D", "-e"]


