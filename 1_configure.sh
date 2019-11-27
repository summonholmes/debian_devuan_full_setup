#!/bin/sh
#*************
# Run as root!
#*************
################
# Create a tmpfs
################
cp /usr/share/systemd/tmp.mount /etc/systemd/system/
systemctl enable tmp.mount
systemctl enable fstrim.timer

###################
# Reduce swappiness
###################
echo "vm.swappiness=1" >> /etc/sysctl.d/99-sysctl.conf

#############################
# Enable contrib and non-free
#############################
sed -i '/^deb/ s/$/ contrib non-free/' /etc/apt/sources.list

##################
# Enable backports
##################
awk '/^deb/' /etc/apt/sources.list | head -n 1 | \
    sed -r 's/buster/buster-backports/g' >> /etc/apt/sources.list

###############################
# Disable printk & enable sysrq
###############################
sed -i '/kernel.printk/s/^#//g' /etc/sysctl.conf
sed -i '/kernel.sysrq/s/^#//g' /etc/sysctl.conf

############################################
# Fix annoying systemd & pulseaudio defaults
############################################
echo "DefaultTimeoutStartSec=10s
DefaultTimeoutStopSec=10s" >> /etc/systemd/system.conf
echo "flat-volumes = no" >> /etc/pulse/daemon.conf

##########################################
# Disable nouveau - for optimus and NVIDIA
##########################################
echo "blacklist nouveau" > /etc/modprobe.d/nouveau.conf

####################################
# Restart for changes to take effect
####################################
# reboot
