#!/bin/sh
# Run as root

# Ensure the PATH variable is correct or else this could fail
source /etc/profile

# Create a tmpfs
cp /usr/share/systemd/tmp.mount /etc/systemd/system/
cp /usr/share/doc/util-linux/examples/fstrim.* /etc/systemd/system/
systemctl enable tmp.mount
systemctl enable fstrim.timer

# Reduce swappiness
echo "vm.swappiness=1" >> /etc/sysctl.d/80-local.conf

# Enable contrib and non-free
sed -i '/^deb/ s/$/ contrib non-free/' /etc/apt/sources.list

# Enable backports
awk '/^deb/' /etc/apt/sources.list | head -n 1 | \
    sed -r 's/stretch/stretch-backports/g' >> /etc/apt/sources.list

# Disable printk & enable sysrq
sed -i '/kernel.printk/s/^#//g' /etc/sysctl.conf
sed -i '/kernel.sysrq/s/^#//g' /etc/sysctl.conf

# Disable pcspkr
echo "blacklist pcspkr" > /etc/modprobe.d/pcspkr.conf

# Disable nouveau
echo "blacklist nouveau" > /etc/modprobe.d/nouveau.conf

# Reboot
reboot
