 #!/bin/sh

### Install correct video and input drivers
/usr/bin/apt-get install xserver-xorg-input-libinput -y
/usr/bin/apt-get install xserver-xorg-video-nouveau -y

### Install fonts
/usr/bin/apt-get install powerline fonts-firacode fonts-roboto fonts-liberation -y

## Install plugins
/usr/bin/apt-get install bash-completion vim zip unzip unrar p7zip zsh build-essential git curl htop dirmngr screenfetch -y

### Fully install KDE
/usr/bin/apt-get install plasma-desktop plasma-nm sddm sddm-theme-breeze network-manager-openvpn kio-mtp plasma-applet-redshift-control -y

### More KDE apps
/usr/bin/apt-get install dolphin konsole kmail kate amarok gwenview ark kde-spectacle okular ffmpegthumbs -y

### Install Devuan-native apps
/usr/bin/apt-get install libreoffice libreoffice-kde smplayer smplayer-themes keepassx transmission-qt imagemagick -y
/usr/bin/apt-get install gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly -y

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
/usr/bin/apt-get install papirus-icon-theme adapta-kde -y
/usr/bin/git clone https://github.com/mustafaozhan/Breeze-Adapta.git && cd Breeze-Adapta && chmod +x install.sh && sh install.sh
cd /tmp
/usr/bin/wget -O adapta-gtk.deb "https://launchpad.net/~tista/+archive/ubuntu/adapta/+build/14213155/+files/adapta-gtk-theme_3.93.0.11-0ubuntu1~xenial1_all.deb"
/usr/bin/dpkg -i adapta-gtk.deb
/usr/bin/apt-get install -f -y

### Install Data Science
cd /tmp
wget -O atom.deb https://atom.io/download/deb
/usr/bin/dpkg -i atom.deb
/usr/bin/apt-get install -f -y
/usr/bin/apt-get install r-recommended yapf3 python3-biopython jupyter-notebook python3-pandas python3-keyring python3-seaborn python3-sklearn -y
cd /tmp
/usr/bin/wget -O rstudio.deb https://download1.rstudio.org/rstudio-xenial-1.1.456-amd64.deb
/usr/bin/dpkg -i rstudio.deb
/usr/bin/apt-get install -f -y

### Install Dropbox
cd /tmp
/usr/bin/wget -O dropbox.deb "https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.10.28_amd64.deb"
/usr/bin/dpkg -i dropbox.deb
/usr/bin/apt-get install -f -y

### Post install tasks
# Fix annoying systemd & pulseaudio defaults
/bin/echo "DefaultTimeoutStartSec=10s
DefaultTimeoutStopSec=10s" >> /etc/systemd/system.conf
/bin/echo "flat-volumes = no" >> /etc/pulse/daemon.conf

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

### Set sddm hidpi settings
/bin/echo "xrandr --output DVI-I-1 --dpi 144x144" >> /usr/share/sddm/scripts/Xsetup

# Add plymouth theme
/usr/bin/apt-get install plymouth plymouth-themes -y
/bin/echo "drm
nouveau modeset=1" >> /etc/initramfs-tools/modules
/usr/sbin/plymouth-set-default-theme -R solar

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
/usr/bin/apt-get autoremove -y
