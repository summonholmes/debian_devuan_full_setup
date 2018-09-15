#!/bin/sh

### Enable backports and add firewall
/usr/bin/apt-get update
/usr/bin/apt-get dist-upgrade -y
/usr/bin/apt-get -t ascii-backports install linux-image-amd64
/usr/bin/apt-get install ufw -y
/usr/sbin/ufw enable
