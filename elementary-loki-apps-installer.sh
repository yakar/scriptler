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
# binwalk hping3 ngrep nikto nmap rarcrack sqlmap tshark volatility wireshark burpsuite metasploit
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



# root check
if [ "$(id -u)" != "0" ]; then echo "Run with sudo: sudo $0"; exit 1; fi


# update & upgrade
apt-get update && apt-get upgrade && apt-get dist-upgrade


# extra repositories
echo 'deb http://ppa.launchpad.net/maarten-baert/simplescreenrecorder/ubuntu xenial main' > /etc/apt/sources.list.d/maarten-baert-ubuntu-simplescreenrecorder-xenial.list
echo 'deb https://deb.opera.com/opera-stable/ stable non-free' > /etc/apt/sources.list.d/opera-stable.list
echo 'deb http://ppa.launchpad.net/danielrichter2007/grub-customizer/ubuntu xenial main' > /etc/apt/sources.list.d/danielrichter2007-ubuntu-grub-customizer-xenial.list
echo 'deb http://ppa.launchpad.net/philip.scott/elementary-tweaks/ubuntu xenial main' > /etc/apt/sources.list.d/philip_scott-ubuntu-elementary-tweaks-xenial.list
echo 'deb https://packagecloud.io/slacktechnologies/slack/debian/ jessie main' > /etc/apt/sources.list.d/slack.list
echo 'deb http://ppa.launchpad.net/numix/ppa/ubuntu xenial main' > /etc/apt/sources.list.d/numix-ubuntu-ppa-xenial.list
apt-get update


# general apps
apt-get install chromium-browser dkms filezilla gimp git grub-customizer guake keepassx libreoffice libreoffice-gtk libreoffice-style-sifr mail-notification meld numix-icon-theme-circle opera-stable rdesktop simplescreenrecorder slack-desktop sqliteman sublime-text wine1.6 winetricks vim vlc

# security/pentest/forensics apps
apt-get install binwalk hping3 ngrep nikto nmap rarcrack sqlmap tshark volatility wireshark 

# burp suite free
wget 'https://portswigger.net/burp/releases/download?product=free&version=1.7.26&type=linux' -O /tmp/burpsuite.sh
sudo -u $USER sh /tmp/burpsuite.sh

# metasploit
sudo -u $USER curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
chmod 755 msfinstall && \
./msfinstall

# Archive Formats and Restricted Extras
apt-get install unace rar unrar p7zip-rar p7zip sharutils uudeview mpack arj cabextract lzip lunzip

# sublime text 3 packages
sudo -u $USER wget --no-check-certificate https://github.com/yakar/scriptler/raw/master/ubuntu-extra/Git.sublime-package -O ~/.config/sublime-text-3/Installed\ Packages/Git.sublime-package
sudo -u $USER wget --no-check-certificate https://github.com/yakar/scriptler/raw/master/ubuntu-extra/Package%20Control.sublime-package -O ~/.config/sublime-text-3/Installed\ Packages/Package\ Control.sublime-package

# guake autostart
cp /usr/share/applications/guake.desktop /etc/xdg/autostart/

# grub-customizer theme
wget --no-check-certificate https://github.com/yakar/scriptler/raw/master/ubuntu-extra/Aurora-Penguinis-GRUB2.tar.gz -O /tmp/Aurora-Penguinis-GRUB2.tar.gz
tar -zxvf /tmp/Aurora-Penguinis-GRUB2.tar.gz
mv -f Aurora-Penguinis-GRUB2 /boot/grub/themes/


# gimp to photoshop :)
sudo -u $USER sh -c "$(wget https://raw.githubusercontent.com/doctormo/GimpPs/master/tools/install.sh -O -)"


# Telegram
sudo -u $USER wget --no-check-certificate https://telegram.org/dl/desktop/linux -O /tmp/telegram.tar.gz
tar -xvf /tmp/telegram.tar.gz
mv -f Telegram ~/Telegram
sudo -u $USER wget --no-check-certificate https://github.com/yakar/scriptler/raw/master/ubuntu-extra/telegram.png -O ~/Telegram/icon.png
echo '
[Desktop Entry]
Encoding=UTF-8
Name=Telegram
Exec=~/Telegram/Telegram
Icon=~/Telegram/icon.png
Type=Application
Categories=Network;
' > ~/.local/share/applications/telegram.desktop
cp ~/.local/share/applications/telegram.desktop /etc/xdg/autostart/


# PyCharm ( https://www.jetbrains.com/pycharm/download/download-thanks.html?platform=linux&code=PCC && )
sudo -u $USER wget --no-check-certificate https://download.jetbrains.com/python/pycharm-community-2017.2.1.tar.gz -O /tmp/pycharm-community-2017.2.1.tar.gz
tar -zxf /tmp/pycharm-community-2017.2.1.tar.gz
mv pycharm-community-2017.2.1 ~/pycharm-community
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
' > /usr/share/applications/jetbrains-pycharm.desktop


# Dropbox
wget --no-check-certificate https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2015.10.28_amd64.deb -O /tmp/dropbox_2015.10.28_amd64.deb
dpkg -i /tmp/dropbox_2015.10.28_amd64.deb
apt-get -f install


# f.lux
sudo apt-get install git python-appindicator python-xdg python-pexpect python-gconf python-gtk2 python-glade2 libxxf86vm1
(
cd /tmp
git clone "https://github.com/xflux-gui/xflux-gui.git"
cd xflux-gui
python download-xflux.py
python setup.py install
python setup.py install --user
)


# Samsung SCX, Samsung M2070 driver
wget --no-check-certificate https://github.com/yakar/scriptler/raw/master/ubuntu-extra/ULD_v1.00.29.tar.gz -O /tmp/ULD_v1.00.29.tar.gz
(
cd /tmp
tar -zxvf ULD_v1.00.29.tar.gz
sh uld/install.sh
)
