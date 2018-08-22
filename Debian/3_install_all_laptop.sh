#!/bin/sh

### Install correct video and input drivers
/usr/bin/apt-get -t stretch-backports install intel-microcode -y
/usr/bin/apt-get -t stretch-backports install xserver-xorg-input-libinput -y
/usr/bin/apt-get -t stretch-backports install xserver-xorg-video-intel -y
/usr/bin/apt-get -t stretch-backports install xserver-xorg-input-wacom -y 

### Install fonts
/usr/bin/apt-get -t stretch-backports install powerline fonts-firacode fonts-roboto fonts-liberation -y

## Install plugins
/usr/bin/apt-get -t stretch-backports install bash-completion vim zip unzip unrar p7zip zsh build-essential git curl dirmngr screenfetch -y

### Fully install KDE
/usr/bin/apt-get -t stretch-backports install plasma-desktop plasma-nm sddm sddm-theme-breeze network-manager-openvpn kio-mtp plasma-applet-redshift-control -y

### More KDE apps
/usr/bin/apt-get -t stretch-backports install dolphin konsole kmail kate amarok gwenview ark kde-spectacle okular ffmpegthumbs -y

### Install Devuan-native apps
/usr/bin/apt-get -t stretch-backports install libreoffice libreoffice-kde smplayer smplayer-themes keepassx transmission-qt imagemagick -y
/usr/bin/apt-get -t stretch-backports install gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly -y
/usr/bin/dpkg --add-architecture i386
/usr/bin/apt-get update
/usr/bin/apt-get -t stretch-backports install steam wine -y
# /usr/bin/apt-get -t stretch-backports qemu virt-manager -y
/usr/bin/apt-get -t stretch-backports install tlp tp-smapi-dkms -y

### Install Latest Firefox
cd /tmp
/usr/bin/wget -O FirefoxSetup.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"
/bin/tar jxvf FirefoxSetup.tar.bz2
/bin/mv firefox /opt/firefox
/bin/echo "[Desktop Entry]
Version=1.0
Name=Firefox
GenericName=Web Browser
Exec=/opt/firefox/firefox %u
Icon=firefox
Terminal=false
Type=Application
MimeType=text/html;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;text/mml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
Categories=Network;WebBrowser;
Keywords=web;browser;internet;
Actions=new-window;new-private-window;
[Desktop Action new-window]
Name=New Window
Exec=/opt/firefox/firefox --new-window %u
[Desktop Action new-private-window]
Name=New Private Window
Exec=/opt/firefox/firefox --private-window %u" > /usr/share/applications/firefox.desktop

### Install Papirus Icon theme & Adapta KDE
/bin/echo 'deb http://ppa.launchpad.net/papirus/papirus/ubuntu xenial main' > /etc/apt/sources.list.d/papirus-ppa.list
/usr/bin/apt-key adv --recv-keys --keyserver keyserver.ubuntu.com E58A9D36647CAE7F
/usr/bin/apt-get update
/usr/bin/apt-get -t stretch-backports install papirus-icon-theme adapta-kde -y
/usr/bin/git clone https://github.com/mustafaozhan/Breeze-Adapta.git && cd Breeze-Adapta && chmod +x install.sh && sh install.sh
/usr/bin/wget -O adapta-gtk.deb "https://launchpad.net/~tista/+archive/ubuntu/adapta/+build/14213155/+files/adapta-gtk-theme_3.93.0.11-0ubuntu1~xenial1_all.deb"
/usr/bin/dpkg -i adapta-gtk.deb
/usr/bin/apt-get -t stretch-backports install -f -y

### Install Miniconda
# Let user install later
/usr/bin/wget -O miniconda3.sh "https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh"

### Install Dropbox
/usr/bin/wget -O dropbox.deb "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.10.28_amd64.deb"
/usr/bin/dpkg -i dropbox.deb
/usr/bin/apt-get -t stretch-backports install -f -y

### Post install tasks
/bin/echo "flat-volumes = no" >> /etc/pulse/daemon.conf
/bin/echo "DefaultTimeoutStartSec=10s
DefaultTimeoutStopSec=10s" >> /etc/systemd/system.conf

# Create full upgrade service
/bin/echo "[Unit]
Description=Run aptdistupgrade

[Service]
Type=oneshot
ExecStart=/etc/systemd/system/aptdistupgrade.sh" > /etc/systemd/system/aptdistupgrade.service

# Create full upgrade timer
/bin/echo "[Unit]
Description=Run aptdistupgrade on boot

[Timer]
OnBootSec=2min

[Install]
WantedBy=timers.target" > /etc/systemd/system/aptdistupgrade.timer

# Create full upgrade shell script
/bin/echo "#!/bin/sh
echo 2018/08/19 > /var/log/aptdistupgrade.log 2>&1
echo 04:27:17 >> /var/log/aptdistupgrade.log 2>&1
apt-get update >> /var/log/aptdistupgrade.log 2>&1
apt-get dist-upgrade -y >> /var/log/aptdistupgrade.log 2>&1" > /etc/systemd/system/aptdistupgrade.sh
/bin/chmod +x /etc/systemd/system/aptdistupgrade.sh
systemctl enable aptdistupgrade.timer

# Let NetworkManager handle networking
/bin/sed -e '/iface e\|allow/ s/^#*/#/' -i /etc/network/interfaces

# Add plymouth theme
/usr/bin/apt-get -t stretch-backports install plymouth plymouth-themes
/bin/echo "intel_agp
drm
i915 modeset=1" >> /etc/initramfs-tools/modules
/usr/sbin/plymouth-set-default-theme -R solar

### Disable unneeded services
systemctl disable accounts-daemon.service
systemctl disable apparmor.service
systemctl disable apt-daily.timer
systemctl disable apt-daily-upgrade.timer
systemctl disable autovt@.service
systemctl disable avahi-daemon.service
systemctl disable avahi-daemon.socket
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
systemctl disable rtkit-daemon.service
systemctl disable unattended-upgrades.service
systemctl disable uuidd.socket