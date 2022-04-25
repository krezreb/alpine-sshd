#!/bin/bash


if [ -d /server_keys ] ; then
  mkdir -p /server_keys/etc/ssh/ | true
  ssh-keygen -A -f /server_keys/

  for l in $(ls /server_keys/etc/ssh/) ; do
        ln -s /server_keys/etc/ssh/$l /etc/ssh/ | true
  done
fi 

# in case some other script has come along after the fact to 
# mess up permissions, set them back to be correct
chmod -R 0600 /server_keys/etc/ssh

USER_HOME=/home/user

mkdir ${USER_HOME}/.ssh/ || true

echo "" > ${USER_HOME}/.ssh/authorized_keys

# for all ENV VARS that start with SSH_PUBKEY, dump to authorized_keys
for k in $(printenv | grep ^SSH_PUBKEY | cut -d"=" -f1); do
    echo $(printf '%s\n' "${!k}") >> ${USER_HOME}/.ssh/authorized_keys
done

chown ${UID}:${GID} ${USER_HOME}/.ssh/authorized_keys
chmod 0600 ${USER_HOME}/.ssh/authorized_keys


USER_HOME=/home/tunnel_user

mkdir ${USER_HOME}/.ssh/ || true

echo "" > ${USER_HOME}/.ssh/authorized_keys

# for all ENV VARS that start with SSH_PUBKEY, dump to authorized_keys
for k in $(printenv | grep ^TUNNEL_SSH_PUBKEY | cut -d"=" -f1); do
    echo $(printf '%s\n' "${!k}") >> ${USER_HOME}/.ssh/authorized_keys
done

chown 1001:1001 ${USER_HOME}/.ssh/authorized_keys
chmod 0600 ${USER_HOME}/.ssh/authorized_keys


exec "$@"

