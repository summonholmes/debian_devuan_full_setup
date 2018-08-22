#!/bin/sh

### First, modify some files
# Create a tmpfs
/bin/cp /usr/share/systemd/tmp.mount /etc/systemd/system/
/bin/cp /usr/share/doc/util-linux/examples/fstrim.* /etc/systemd/system/
systemctl enable tmp.mount
systemctl enable fstrim.timer

# Reduce swappiness
/bin/echo "vm.swappiness=1" >> /etc/sysctl.d/80-local.conf

# Enable backports, contrib, and non-free
/bin/sed -i '/^deb/ s/$/ contrib non-free/' /etc/apt/sources.list
/usr/bin/awk '/^deb/' /etc/apt/sources.list | /usr/bin/head -n 1 | /bin/sed -r 's/stretch/stretch-backports/g' >> /etc/apt/sources.list

# Disable pcspkr
/bin/echo "blacklist pcspkr" > /etc/modprobe.d/pcspkr.conf
