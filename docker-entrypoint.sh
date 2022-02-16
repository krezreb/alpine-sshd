#!/bin/sh

if [ -d /server_keys ] ; then
  mkdir -p /server_keys/etc/ssh/ | true
  ssh-keygen -A -f /server_keys/
fi 

if [ -z "${AUTHORIZED_KEYS}" ]; then
  echo "AUTHORIZED_KEYS env variable not set."
else
  echo "Populating authorized_keys with the value from AUTHORIZED_KEYS env variable ..."
  echo "${AUTHORIZED_KEYS}" > /home/user/.ssh/authorized_keys
fi

exec "$@"

