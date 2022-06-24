#!/bin/sh

#Simply Install Apache2 7 configure in firewall
sudo apt-get install apache2 ufw net-tools -y
sudo ufw enable
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow "Apache Full"

echo "Apache 2 Has been Installed & Configured in Firewiall"
systemctl status apache2 --no-pager