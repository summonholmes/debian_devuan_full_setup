#!/bin/sh

### First, modify some files
# Create a tmpfs
/bin/echo "tmpfs /tmp tmpfs rw,nosuid,noatime,nodev,size=4G,mode=1777 0 0" >> /etc/fstab

# Reduce swappiness
/bin/echo "vm.swappiness=1" >> /etc/sysctl.d/80-local.conf

# Enable backports
/bin/echo "deb http://us.deb.devuan.org/merged ascii-backports main non-free contrib" >> /etc/apt/sources.list 

# Disable pcspkr
/bin/echo "blacklist pcspkr" > /etc/modprobe.d/pcspkr.conf
