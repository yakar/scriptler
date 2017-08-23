#!/bin/bash
#
# Aydin Yakar
# https://github.com/scriptler/google-authentication-installer.sh
# 23 August 2017
#
# 2FA with Google Authenticator

# install pam library
set -e

# root check
if [ "$(id -u)" != "0" ]; then echo "Run with sudo: sudo $0"; exit 1; fi

apt-get -y install libpam-google-authenticator

if [ grep -vq "Enable MFA using Google Authenticator PAM" /etc/pam.d/sshd ]; then
	echo -e '\n# Enable MFA using Google Authenticator PAM\nauth required pam_google_authenticator.so nullok' >> /etc/pam.d/sshd

	sed -i "s/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g" /etc/ssh/sshd_config

	service ssh restart

	read -p "Do yo want to enable 2FA to the local login? y/n " cevap
	case $cevap in
		[yY]* )
			echo -e '\n# Enable MFA using Google Authenticator PAM\nauth required pam_google_authenticator.so nullok' >> /etc/pam.d/login
			;;
	esac

	google-authenticator
fi