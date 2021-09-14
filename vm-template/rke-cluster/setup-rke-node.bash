#!/bin/bash

TIMESTAMP=$(date "+%Y%m%d-%T")
echo "${TIMESTAMP}" > "last-build-on-${TIMESTAMP}.txt"
ls -lrt

USER=${ADMIN}

echo "${PASSWORD}" | sudo -S ls -lrt

sudo apt-get -y update

#sudo snap install docker # Using snap will not work with RKE

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

sudo groupadd docker
sudo usermod -aG docker ${USER}

sudo apt install unzip

#NTP here
sudo apt-get -y install ntpdate
sudo ntpdate time.navy.mi.th prefer
sudo timedatectl set-ntp off
sudo apt-get -y install ntp

NTP_CFG=/etc/ntp.conf
sudo chmod 666 ${NTP_CFG}
sudo echo "server time.navy.mi.th prefer iburst" >> ${NTP_CFG}
sudo chmod 444 ${NTP_CFG}
sudo service ntp restart
