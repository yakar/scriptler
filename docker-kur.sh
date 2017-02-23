#!/bin/bash

#simple Docker Engine installer

# need root auth
if [ "$(id -u)" != "0" ]; then echo -e "[!] Must be run with root auth: sudo bash $0"; exit 1; fi

# update
apt update

# add repo key
apt-get install -y apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

# docker repo
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | tee -a /etc/apt/sources.list.d/docker.list

# update
apt update

apt install -y linux-image-extra-$(uname -r)

apt install -y docker-engine

systemctl start docker
systemctl enable docker.service

docker run hello-world

# allow non root user to run docker
# groupadd docker
# useradd <username>
# usermod -aG docker <username>