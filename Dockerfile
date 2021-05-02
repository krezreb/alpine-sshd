FROM alpine:latest

# ssh-keygen -A generates all necessary host keys (rsa, dsa, ecdsa, ed25519) at default location.
RUN    apk update \
    && apk add openssh \
    && mkdir /root/.ssh \
    && chmod 0700 /root/.ssh \
    && ssh-keygen -A 

COPY ./sshd_config /etc/ssh/sshd_config

RUN addgroup -S user && adduser -S user -G user  -s /bin/ash -h /home/user && passwd -d -u user

USER user
WORKDIR /home/user
RUN mkdir -p /home/user/.ssh && touch /home/user/.ssh/authorized_keys && chmod 644 /home/user/.ssh/authorized_keys

USER root
# This image expects AUTHORIZED_KEYS environment variable to contain your ssh public key.

COPY docker-entrypoint.sh /

EXPOSE 22

ENTRYPOINT ["/docker-entrypoint.sh"]

# -D in CMD below prevents sshd from becoming a daemon. -e is to log everything to stderr.
CMD ["/usr/sbin/sshd", "-D", "-e"]


