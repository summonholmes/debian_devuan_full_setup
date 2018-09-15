 #!/bin/sh

### Install correct video and input drivers
/usr/bin/apt-get install libpolkit-backend-elogind-1-0 -y
/usr/bin/apt-get install sysv-rc-conf -y
/usr/bin/apt-get install intel-microcode -y
/usr/bin/apt-get install xserver-xorg-input-libinput -y
/usr/bin/apt-get install xserver-xorg-video-intel -y
/usr/bin/apt-get install xserver-xorg-input-wacom -y

### Install fonts
/usr/bin/apt-get install powerline fonts-firacode fonts-roboto fonts-liberation -y

## Install plugin
/usr/bin/apt-get install ntp bash-completion vim zip unzip unrar p7zip zsh build-essential git curl htop dirmngr screenfetch -y

### Fully install KDE
/usr/bin/apt-get install plasma-desktop plasma-nm sddm sddm-theme-breeze network-manager-openvpn kio-mtp plasma-applet-redshift-control -y

### More KDE apps
/usr/bin/apt-get install dolphin konsole kmail kate amarok gwenview ark kde-spectacle okular ffmpegthumbs -y

### Install Devuan-native apps
/usr/bin/apt-get install libreoffice libreoffice-kde smplayer smplayer-themes keepassx transmission-qt imagemagick -y
/usr/bin/apt-get install gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly -y
/usr/bin/dpkg --add-architecture i386
/usr/bin/apt-get update
/usr/bin/apt-get install wine -y
# /usr/bin/apt-get -t ascii-backports qemu virt-manager -y
/usr/bin/apt-get install tlp tp-smapi-dkms -y

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

### Install Atom & Data Science environment
cd /tmp
wget -O atom.deb https://atom.io/download/deb
/usr/bin/dpkg -i atom.deb
/usr/bin/apt-get install -f -y
/usr/bin/apt-get install r-recommended yapf3 python3-biopython jupyter-notebook python3-pandas python3-keyring python3-seaborn python3-sklearn -y flake8
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
# Change pulseaudio defaults
/bin/echo "flat-volumes = no" >> /etc/pulse/daemon.conf

# Let NetworkManager handle networking
/bin/sed -e '/iface e\|allow/ s/^#*/#/' -i /etc/network/interfaces

# Disable unneeded services
/usr/sbin/update-rc.d apparmor remove
/usr/sbin/update-rc.d avahi-daemon remove
/usr/sbin/update-rc.d bluetooth remove
/usr/sbin/update-rc.d irqbalance remove
/usr/sbin/update-rc.d minissdpd remove
/usr/sbin/update-rc.d networking remove
/usr/sbin/update-rc.d ntp remove
/usr/sbin/update-rc.d openvpn remove
/usr/sbin/update-rc.d pcscd remove
/usr/sbin/update-rc.d pppd-dns remove
/usr/sbin/update-rc.d saned remove
/usr/sbin/update-rc.d sddm remove
/usr/sbin/update-rc.d unattended-upgrades remove
/usr/sbin/update-rc.d uuidd remove
/usr/sbin/update-rc.d x11-common remove
#/sbin/poweroff
### Remove obsolete
/usr/bin/apt-get autoremove -y
