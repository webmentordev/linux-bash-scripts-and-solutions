#!/bin/sh

#Download, Install and Update NodeJS 16.15.0
sudo apt-get install nodejs curl xz-utils tar wget -y
wget "https://nodejs.org/dist/v16.15.0/node-v16.15.0-linux-x64.tar.xz"
sudo tar -xf node-v16.15.0-linux-x64.tar.xz
sleep 3
#sudo cp -R node-v16.15.0-linux-x64/{bin,include,lib,share} /usr/
cd node-v16.15.0-linux-x64
sudo cp -r bin /usr/
sudo cp -r lib /usr/
sudo cp -r include /usr/
sudo cp -r share /usr/
echo "Node JS Downloaded, Installed and Updated to v16.15.0"
node -v
cd ..
sudo rm -r node-v16.15.0-linux-x64
rm node-v16.15.0-linux-x64.tar.xz