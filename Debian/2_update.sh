#!/bin/sh
# Run as root

# Switch to backports kernel, get latest firmware, and install firewall
apt-get update
apt-get -t stretch-backports install intel-microcode \
    firmware-realtek linux-image-amd64 ufw -y
# apt-get -t stretch-backports install firmware-iwlwifi -y
apt-get -t stretch-backports dist-upgrade -y
ufw enable
