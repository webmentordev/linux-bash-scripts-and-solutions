#!/bin/bash

sudo apt-get install openssh-server -y

sudo ufw enable
sudo ufw allow 22

echo "OpenSSH Server Successfully Installed & Configured in Firewall"