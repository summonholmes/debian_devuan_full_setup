#!/bin/sh

### Enable backports and add firewall
/usr/bin/apt-get update
/usr/bin/apt-get dist-upgrade -y
/usr/bin/apt-get install ufw -y
/usr/bin/apt-get install amd64-microcode firmware-realtek -y
# /usr/bin/apt-get -t stretch-backports install amd64-microcode intel-microcode firmware-realtek -y
/usr/bin/apt-get -t stretch-backports install linux-image-amd64 -y
# /usr/bin/apt-get 
/usr/sbin/ufw enable
