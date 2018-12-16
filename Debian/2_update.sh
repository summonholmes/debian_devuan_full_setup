#!/bin/sh
# Run as root

# Ensure the PATH variable is correct or else this could fail
source /etc/profile

# Switch to backports kernel, get latest firmware, and install firewall
apt-get update
apt-get -t stretch-backports install intel-microcode \
    firmware-realtek linux-image-amd64 ufw -y
apt-get dist-upgrade -y
ufw enable
