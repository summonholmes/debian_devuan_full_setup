#!/bin/sh
#*************
# Run as root!
#*************
#######################################################################
# Switch to backports kernel, get latest firmware, and install firewall
#######################################################################
apt-get update
# apt-get -t buster-backports install amd64-microcode \
#    firmware-realtek ufw -y  # For my AMD machine
apt-get -t stretch-backports install intel-microcode \
    firmware-iwlwifi firmware-realtek ufw -y # For the laptop
apt-get -t buster-backports dist-upgrade -y
ufw enable

####################################
# Restart for changes to take effect
####################################
# reboot
