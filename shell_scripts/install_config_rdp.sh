#!/bin/sh

#Install RDP and Configure
sudo apt-get install xrdp -y
sudo adduser xrdp ssl-cert
sudo systemctl restart xrdp
sudo ufw allow 3389

echo "RDP has been Installed & Configured. Available On Port 3389"