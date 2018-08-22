#!/bin/sh

### Enable backports and add firewall
/usr/bin/apt-get update
/usr/bin/apt-get -t ascii-backports dist-upgrade -y
/usr/bin/apt-get -t ascii-backports install ufw -y
/usr/sbin/ufw enable
