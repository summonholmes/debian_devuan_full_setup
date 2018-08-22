#!/bin/sh

### Enable backports and add firewall
/usr/bin/apt-get update
/usr/bin/apt-get -t stretch-backports dist-upgrade -y
/usr/bin/apt-get -t stretch-backports install ufw -y
/usr/sbin/ufw enable
