#!/bin/sh

sudo apt-get install openssh-server -y
sudo ufw enable
sudo allow 22

echo "SSH has been installed and configured"
