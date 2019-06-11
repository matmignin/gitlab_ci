#!/bin/bash

timedatectl set-timezone UTC
apt-get update && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
apt-get install -yqq python python3

...   # setup default admin user accounts

# setup user 'mataform'
useradd -m -p "[PASSWORD_HASH]" -s /bin/bash -G sudo mataform
mkdir -p /home/mataform/.ssh
chown mataform:mataform /home/mataform/.ssh
chmod 0700 /home/mataform/.ssh
echo "[PUBLIC_KEY]" > /home/mataform/.ssh/authorized_keys
chmod 0644 /home/mataform/.ssh/authorized_keys

deluser --remove-home ubuntu
