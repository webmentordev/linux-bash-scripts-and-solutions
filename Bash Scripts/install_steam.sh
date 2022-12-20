#!/bin/bash

sudo apt-get install lib32gcc-s1
mkdir steam
cd steam
sudo apt-get install curl
curl -sql "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
sudo apt-get install tmux screen -y
