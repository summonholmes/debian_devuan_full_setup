#!/bin/sh
#*************
# Run as root!
#*************
####################################
# Grab all required packages at once
####################################
# apt-get -t buster-backports install \
# xserver-xorg-input-libinput \
# xserver-xorg-video-nouveau -y # For AMD machine temporarily
apt-get -t buster-backports install xserver-xorg-input-libinput xserver-xorg-video-intel \
fonts-firacode fonts-roboto fonts-liberation bash-completion vim zip unzip unrar p7zip zsh \ 
build-essential git curl htop screenfetch gstreamer1.0-plugins-good gstreamer1.0-plugins-bad \
gstreamer1.0-plugins-ugly plasma-desktop plasma-nm sddm sddm-theme-breeze \
network-manager-openvpn kio-extras plasma-applet-redshift-control dolphin konsole \
kate clementine gwenview ark kde-spectacle okular ffmpegthumbs libreoffice libreoffice-kde5 \
smplayer smplayer-themes keepassxc transmission-qt imagemagick firefox-esr thunderbird \
bleachbit plymouth plymouth-themes plymouth-theme-breeze -y

####################
# Install miniconda3
####################
cd /tmp
wget -O /tmp/miniconda.sh "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
su -c "sh ./miniconda.sh -b -p $HOME/.local/miniconda3" -s \
    /bin/bash summonholmes  # Your username replaces 'summonholmes'
su -c "$HOME/.local/miniconda3/bin/conda install pandas flake8 jupyter termcolor \\\
    scikit-learn scipy yapf virtualenv plotly && conda update --all -y && \\\
    conda clean --all -y" -s \
    /bin/bash summonholmes

#################
# Install Dropbox
#################
cd /tmp
wget -O dropbox.deb "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.10.28_amd64.deb"
apt install ./dropbox.deb -y

################
# Install VSCode
################
cd /tmp
wget -O code.deb "https://go.microsoft.com/fwlink/?LinkID=760868"
apt install ./code.deb -y

############################################
# Fix annoying systemd & pulseaudio defaults
############################################
echo "DefaultTimeoutStartSec=10s
DefaultTimeoutStopSec=10s" >> /etc/systemd/system.conf
echo "flat-volumes = no" >> /etc/pulse/daemon.conf

######################################################
# Create full upgrade service, timer, and shell script
######################################################
# Service
echo "[Unit]
Description=Run aptdistupgrade

[Service]
Type=oneshot
ExecStart=/etc/systemd/system/aptdistupgrade.sh" > /etc/systemd/system/aptdistupgrade.service

# Timer
echo "[Unit]
Description=Run aptdistupgrade on boot

[Timer]
OnBootSec=5min

[Install]
WantedBy=timers.target" > /etc/systemd/system/aptdistupgrade.timer

# Shell script
echo "#!/bin/sh
echo \`date\` > /var/log/aptdistupgrade.log 2>&1
apt-get update >> /var/log/aptdistupgrade.log 2>&1
apt-get dist-upgrade -y >> /var/log/aptdistupgrade.log 2>&1" > /etc/systemd/system/aptdistupgrade.sh
chmod +x /etc/systemd/system/aptdistupgrade.sh

###################################
# Create powertop service and timer
###################################
# Service
echo "[Unit]
Description=Run powertop

[Service]
Type=oneshot
ExecStart=/usr/sbin/powertop --auto-tune
" > /etc/systemd/system/powertop.service

# Timer
echo "[Unit]
Description=Run powertop regularly

[Timer]
OnUnitActiveSec=2min

[Install]
WantedBy=timers.target" > /etc/systemd/system/powertop.timer

################################
# Enable to upgrade timers above
################################
systemctl enable aptdistupgrade.timer
# systemctl enable powertop.timer

######################################
# Let NetworkManager handle networking
######################################
sed -e '/iface e\|allow/ s/^#*/#/' -i /etc/network/interfaces

#########################
# Set sddm hidpi settings
#########################
echo "xrandr --dpi 240" >> /usr/share/sddm/scripts/Xsetup

####################
# Grub configuration
####################
cd /tmp
git clone https://github.com/summonholmes/config-dump.git
cp config-dump/GNULinux/Grub/10_linux /etc/grub.d/11_linux
cp config-dump/GNULinux/Grub/30_os-prober /etc/grub.d/31_os-prober
chmod -x /etc/grub.d/10_linux
chmod -x /etc/grub.d/30_os-prober
chmod -x /etc/grub.d/30_uefi-firmware
chmod +x /etc/grub.d/11_linux
chmod +x /etc/grub.d/31_os-prober

###############
# Grub defaults
###############
echo "GRUB_GFXMODE=3840x2160" >> /etc/default/grub
sed -i '/GRUB_CMDLINE_LINUX_/c\GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=0 \\\
    vga=current vt.global_cursor_default=0 splash"' \
    /etc/default/grub

########################
# Use fallout grub theme
########################
wget -O - https://github.com/shvchk/fallout-grub-theme/raw/master/install.sh | bash

################
# Plymouth setup
################
echo 'intel_agp
drm
i915 modeset=1' >> /etc/initramfs-tools/modules
plymouth-set-default-theme -R breeze

##################################################
# Copy Firefox and Thunderbird preferences to home
##################################################
cd /tmp
cp config-dump/FirefoxThunderbird/firefox_prefs.js /home/summonholmes/
cp config-dump/FirefoxThunderbird/thunderbird_prefs.js /home/summonholmes/

######################################
# One more big upgrade try and cleanup
######################################
apt-get -t buster-backports dist-upgrade -y
apt-get autoremove -y

###########################
# Disable unneeded services
###########################
systemctl disable accounts-daemon.service
systemctl disable apparmor.service
systemctl disable apt-daily.timer
systemctl disable apt-daily-upgrade.timer
systemctl disable autovt@.service
systemctl disable avahi-daemon.service
systemctl disable console-setup.service
systemctl disable e2scrub_all.timer
systemctl disable e2scrub_reap.service
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
systemctl disable rtkit-daemon.service
systemctl disable udisks2.service
systemctl disable unattended-upgrades.service
systemctl disable uuidd.socket
systemctl disable wpa_supplicant.service

##################################################
# Reboot only when everything is confirmed working
##################################################
# reboot
