#!/bin/bash
#
# Aydin Yakar
# https://github.com/yakar/scriptler/elementary-loki-apps-installer.sh
# 22 August 2017
#
# APPS:
# chromium-browser dkms filezilla gimp git grub-customizer guake keepassx libreoffice libreoffice-gtk libreoffice-style-sifr mail-notification meld
# numix-icon-theme-circle opera-stable rdesktop simplescreenrecorder slack-desktop sqliteman sublime-text wine1.6 winetricks vim vlc
#
# binwalk hping3 ngrep nikto nmap rarcrack sqlmap tshark volatility wireshark burpsuite
#
# unace rar unrar p7zip-rar p7zip sharutils uudeview mpack arj cabextract lzip lunzip
#
# Sublime Text 3 Packages: Package Control & Git Package
#
# grub-customizer theme: Aurora Penguinis (Grub 2)
#
# Gimp 2 Photostop extention
#
# Telegram, PyCharm Community, Dropbox, f.lux
#
# Driver: Samsung SCX, Samsung M2070 Printers

set -e


# root check
if [ "$(id -u)" != "0" ]; then echo "Run with sudo: sudo $0"; exit 1; fi


# update & upgrade
apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade


# extra repositories
apt-get -y install software-properties-common
add-apt-repository -y ppa:danielrichter2007/grub-customizer
add-apt-repository -y ppa:maarten-baert/simplescreenrecorder
add-apt-repository -y ppa:philip.scott/elementary-tweaks
apt-add-repository -y ppa:numix/ppa
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
apt-get update


# general apps
apt-get -y install chromium-browser dkms elementary-tweaks filezilla gimp git grub-customizer guake keepassx libreoffice libreoffice-gtk libreoffice-style-sifr mail-notification meld numix-icon-theme-circle rdesktop simplescreenrecorder slack-desktop sqliteman sublime-text wine1.6 winetricks vim vlc

# security/pentest/forensics apps
apt-get -y install binwalk hping3 ngrep nikto nmap rarcrack sqlmap tshark volatility wireshark 

# burp suite free
if [ ! -f "/usr/share/applications/Burp Suite Free Edition-0.desktop" ]; then
    wget 'https://portswigger.net/burp/releases/download?product=free&version=1.7.26&type=linux' -O /tmp/burpsuite.sh
    sudo -u $SUDO_USER sh /tmp/burpsuite.sh
fi

# metasploit
if [ ! -f /usr/bin/msfconsole ]; then
    sudo -u $SUDO_USER curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
    chmod 755 msfinstall && \
    ./msfinstall
fi

# Archive Formats and Restricted Extras
apt-get -y install unace rar unrar p7zip-rar p7zip sharutils uudeview mpack arj cabextract lzip lunzip


# sublime text 3 packages
if [ ! -d '~/.config/sublime-text-3/Installed Packages/' ]; then
    mkdir -p ~/.config/sublime-text-3/Installed\ Packages/
    wget --no-check-certificate https://github.com/yakar/scriptler/raw/master/ubuntu-extra/Git.sublime-package -O ~/.config/sublime-text-3/Installed\ Packages/Git.sublime-package
    chown $SUDO_USER:$SUDO_USER -R ~/.config/sublime-text-3/Installed\ Packages/Git.sublime-package
    wget --no-check-certificate https://github.com/yakar/scriptler/raw/master/ubuntu-extra/Package%20Control.sublime-package -O ~/.config/sublime-text-3/Installed\ Packages/Package\ Control.sublime-package
    chown $SUDO_USER:$SUDO_USER -R ~/.config/sublime-text-3/Installed\ Packages/Package\ Control.sublime-package
fi


# guake autostart
cp /usr/share/applications/guake.desktop /etc/xdg/autostart/


# grub-customizer theme
if [ ! -d /boot/grub/themes/Aurora-Penguinis-GRUB2 ]; then
    wget --no-check-certificate https://github.com/yakar/scriptler/raw/master/ubuntu-extra/Aurora-Penguinis-GRUB2.tar.gz -O /tmp/Aurora-Penguinis-GRUB2.tar.gz
    tar -zxf /tmp/Aurora-Penguinis-GRUB2.tar.gz
    mv -f Aurora-Penguinis-GRUB2 /boot/grub/themes/
fi

# Opera Stable
if [ ! -f /usr/bin/opera ]; then
    wget --no-check-certificate 'http://www.opera.com/download/get/?id=41989&amp;location=414&amp;nothanks=yes&amp;sub=marine&utm_browser=safari&utm_ver=11.0&utm_os=linux' -O /tmp/opera-stable.deb
    dpkg -i /tmp/opera-stable.deb
fi


# Slack
if [ ! -f /usr/bin/slack ]; then
    wget --no-check-certificate https://downloads.slack-edge.com/linux_releases/slack-desktop-2.7.1-amd64.deb -O /tmp/slack-desktop-2.7.1-amd64.deb
    dpkg -i /tmp/slack-desktop-2.7.1-amd64.deb
fi

# gimp to photoshop :)
sudo -u $SUDO_USER sh -c "$(wget https://raw.githubusercontent.com/doctormo/GimpPs/master/tools/install.sh -O -)"


# Telegram
if [ ! -d ~/Telegram ]; then
    sudo -u $SUDO_USER wget --no-check-certificate https://telegram.org/dl/desktop/linux -O /tmp/telegram.tar.gz
    tar -xf /tmp/telegram.tar.gz
    mv -f Telegram ~/Telegram
    sudo -u $SUDO_USER wget --no-check-certificate https://github.com/yakar/scriptler/raw/master/ubuntu-extra/telegram.png -O ~/Telegram/icon.png
    echo '
    [Desktop Entry]
    Encoding=UTF-8
    Name=Telegram
    Exec=~/Telegram/Telegram
    Icon=~/Telegram/icon.png
    Type=Application
    Categories=Network;
    ' | tee /usr/share/applications/telegram.desktop
    cp /usr/share/applications/telegram.desktop /etc/xdg/autostart/
fi

# PyCharm ( https://www.jetbrains.com/pycharm/download/download-thanks.html?platform=linux&code=PCC && )
if [ ! -d ~/pycharm-community ]; then
    sudo -u $SUDO_USER wget --no-check-certificate https://download.jetbrains.com/python/pycharm-community-2017.2.1.tar.gz -O /tmp/pycharm-community-2017.2.1.tar.gz
    tar -zxf /tmp/pycharm-community-2017.2.1.tar.gz
    mv pycharm-community-2017.2.1 ~/pycharm-community
    chown $SUDO_USER:$SUDO_USER -R ~/pycharm-community
    echo '
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=PyCharm
    Icon=~/pycharm-community/bin/pycharm.png
    Exec="~/pycharm-community/bin/pycharm.sh" %f
    Comment=Develop with pleasure!
    Categories=Development;IDE;
    Terminal=false
    StartupWMClass=jetbrains-pycharm
    ' | tee /usr/share/applications/jetbrains-pycharm.desktop
fi


# Dropbox
if [ ! -f /usr/bin/dropbox ]; then
    wget --no-check-certificate https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.10.28_amd64.deb -O /tmp/dropbox_2015.10.28_amd64.deb
    dpkg -i /tmp/dropbox_2015.10.28_amd64.deb
    apt-get -f install
fi


# f.lux
if [ ! -f /usr/local/bin/fluxgui ]; then
    apt-get -y install git python-appindicator python-xdg python-pexpect python-gconf python-gtk2 python-glade2 libxxf86vm1
    (
    cd /tmp
    git clone "https://github.com/xflux-gui/xflux-gui.git"
    cd xflux-gui
    python download-xflux.py
    python setup.py install
    python setup.py install --user
    )
fi


# Samsung SCX, Samsung M2070 driver
wget --no-check-certificate https://github.com/yakar/scriptler/raw/master/ubuntu-extra/ULD_v1.00.29.tar.gz -O /tmp/ULD_v1.00.29.tar.gz
(
cd /tmp
tar -zxf ULD_v1.00.29.tar.gz
sh uld/install.sh
)