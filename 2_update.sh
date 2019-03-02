#!/bin/sh
# Run as root

# Switch to backports kernel, get latest firmware, and install firewall
apt-get update
apt-get -t stretch-backports install amd64-microcode firmware-realtek ufw -y
# apt-get -t stretch-backports install intel-microcode firmware-iwlwifi -y
apt-get -t stretch-backports dist-upgrade -y
ufw enable
