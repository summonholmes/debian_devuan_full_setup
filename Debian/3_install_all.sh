#!/bin/sh
# Run as root

# Ensure the PATH variable is correct or else this could fail
source /etc/profile

# Install correct video and input drivers
apt-get install xserver-xorg-input-libinput xserver-xorg-video-intel -y

# Install fonts
apt-get install powerline fonts-firacode fonts-roboto fonts-liberation -y

# Install lower level utils
apt-get install bash-completion vim zip unzip unrar p7zip zsh build-essential \
    git curl htop dirmngr screenfetch tlp -y

# Instll audio codecs
apt-get install gstreamer1.0-plugins-good gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly -y

# Install KDE desktop
apt-get install plasma-desktop plasma-nm sddm sddm-theme-breeze \
    network-manager-openvpn kio-mtp plasma-applet-redshift-control -y

# More KDE apps
apt-get install dolphin konsole kate amarok gwenview ark kde-spectacle \
    okular ffmpegthumbs -y

# Non KDE apps
apt-get install libreoffice libreoffice-kde smplayer smplayer-themes keepassx \
    transmission-qt imagemagick firefox-esr thunderbird -y

# Install miniconda3
cd /tmp
wget -O miniconda.sh "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
runuser -l summonholmes -c './miniconda.sh -b -p /home/summonholmes/.local/miniconda3'

# Install Dropbox
cd /tmp
wget -O dropbox.deb "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.10.28_amd64.deb"
apt install ./dropbox.deb -y

# Flat icons
cd /tmp
git clone https://github.com/daniruiz/flat-remix
mv flat-remix/Flat-Remix* /usr/share/icons/

# Fix annoying systemd & pulseaudio defaults
echo "DefaultTimeoutStartSec=10s
DefaultTimeoutStopSec=10s" >> /etc/systemd/system.conf
echo "flat-volumes = no" >> /etc/pulse/daemon.conf

# Create full upgrade service
/bin/echo "[Unit]
Description=Run aptdistupgrade

[Service]
Type=oneshot
ExecStart=/etc/systemd/system/aptdistupgrade.sh
" > /etc/systemd/system/aptdistupgrade.service

# Create full upgrade timer
echo "[Unit]
Description=Run aptdistupgrade on boot

[Timer]
OnBootSec=2min
OnUnitActiveSec=1h
Persistent=true

[Install]
WantedBy=timers.target
" > /etc/systemd/system/aptdistupgrade.timer

# Create full upgrade shell script
echo "#!/bin/sh
echo \`date\` > /var/log/aptdistupgrade.log 2>&1
apt-get update >> /var/log/aptdistupgrade.log 2>&1
apt-get dist-upgrade -y >> /var/log/aptdistupgrade.log 2>&1
" > /etc/systemd/system/aptdistupgrade.sh
chmod +x /etc/systemd/system/aptdistupgrade.sh

# Enable to upgrade timer
systemctl enable aptdistupgrade.timer

# Let NetworkManager handle networking
sed -e '/iface e\|allow/ s/^#*/#/' -i /etc/network/interfaces

# Set sddm hidpi settings
echo "xrandr --output eDP-1 --dpi 240x240" >> /usr/share/sddm/scripts/Xsetup

# Enable plymouth
apt-get install plymouth plymouth-themes -y
echo "intel_agp
drm
i915 modeset=1" >> /etc/initramfs-tools/modules
plymouth-set-default-theme -R solar

# Grub configuration
cd /tmp
git clone https://github.com/summonholmes/unix-shell-scripting.git
cp unix-shell-scripting/GNULinux/Debian\ Grub/10_linux /etc/grub.d/11_linux
cp unix-shell-scripting/GNULinux/Debian\ Grub/30_os-prober /etc/grub.d/10_os-prober
cp unix-shell-scripting/GNULinux/Debian\ Grub/future.png /boot/grub/
cp unix-shell-scripting/GNULinux/Debian\ Grub/fira.pf2 /boot/grub/
chmod -x /etc/grub.d/10_linux
chmod -x /etc/grub.d/30_os-prober
chmod -x /etc/grub.d/30_uefi-firmware
chmod +x /etc/grub.d/11_linux
chmod +x /etc/grub.d/10_os-prober

# Grub defaults
echo "GRUB_GFXMODE=3840x2160" >> /etc/default/grub
echo "GRUB_BACKGROUND=/boot/grub/future.png" >> /etc/default/grub
echo "GRUB_FONT=/boot/grub/fira.pf2" >> /etc/default/grub
sed -i '/GRUB_CMDLINE_LINUX_/c\GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"' \
    /etc/default/grub
update-grub

# Copy Firefox and Thunderbird preferences to home
cp unix-shell-scripting/GNULinux/firefox_prefs.js ~
cp unix-shell-scripting/GNULinux/thunderbird_prefs.js ~

### Disable unneeded services
systemctl disable accounts-daemon.service
systemctl disable apparmor.service
systemctl disable apt-daily.timer
systemctl disable apt-daily-upgrade.timer
systemctl disable autovt@.service
systemctl disable avahi-daemon.service
systemctl disable bluetooth.service
systemctl disable console-setup.service
systemctl disable irqbalance.service
systemctl disable getty@.service
systemctl disable keyboard-setup.service
systemctl disable minissdpd.service
systemctl disable ModemManager.service
systemctl disable networking.service
systemctl disable NetworkManager-wait-online.service
systemctl disable openvpn.service
systemctl disable pcscd.socket
systemctl disable pppd-dns.service
systemctl disable remote-fs.target
systemctl disable rsync.service
systemctl disable rtkit-daemon.service
systemctl disable unattended-upgrades.service
systemctl disable uuidd.socket

# Clean unused packages
apt-get autoremove -y

# Reboot
reboot