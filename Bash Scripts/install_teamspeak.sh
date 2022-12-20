#!/bin/bash

###############################################################################################
# Run this file as Root so it can setup Users & Services
# Following script will Create New User with username of name of your chooice
# Download Latest Teamspeak, Set Script as a Service and Opn Port
# By Default, this script does not turn on/off firewall but add ports only
# You will have to provide password for the yout-user so stick to complete it
# This script does not set password on Teamspeak
# TreamSpeak Server is free so only 32 Users can connect at the same time
# You will have to purchase license to increase Users limit
# Press CTRL + C to Exit Status at the end
# For Token, type cat /home/*username-you-choose*/teamspeak3-server_linux_amd64/logs/ts3server_*
###################################################################################################

read -p "New User Username (lowercase) : " USERNAME

# Install Necessary Packages
# sudo apt update && sudo apt upgrade -y
apt install sudo
sudo apt install wget zip unzip -y

# Create New Teamspeak User with Password
sudo adduser $USERNAME


# Downloading Latest Teamspeak 3 Server
sleep 2
cd /home/$USERNAME
wget https://files.teamspeak-services.com/releases/server/3.13.7/teamspeak3-server_linux_amd64-3.13.7.tar.bz2
tar xvfj teamspeak3-server_linux_amd64-3.13.7.tar.bz2

# Create License File
sleep 2
cd /home/$USERNAME/teamspeak3-server_linux_amd64
touch .ts3server_license_accepted

sleep 2
cat > /lib/systemd/system/ts3server.service << EOF
[Unit]
Description=Teamspeak3 Server
Wants=network.target

[Service]
WorkingDirectory=/home/$USERNAME/teamspeak3-server_linux_amd64
ExecStart=/home/$USERNAME/teamspeak3-server_linux_amd64/ts3server_minimal_runscript.sh start
ExecStop=/home/$USERNAME/teamspeak3-server_linux_amd64/ts3server_startscript.sh stop
ExecReload=/home/$USERNAME/teamspeak3-server_linux_amd64/ts3server_startscript.sh restart
Restart=always
RestartSec=15

[Install]
WantedBy=multi-user.target
EOF

# Changing Teamspeak files Permissions to Execute
chmod +x /home/$USERNAME/teamspeak3-server_linux_amd64/ts3server_minimal_runscript.sh
chmod +x /home/$USERNAME/teamspeak3-server_linux_amd64/ts3server_startscript.sh
chmod +x /home/$USERNAME/teamspeak3-server_linux_amd64/ts3server_startscript.sh

# Enable & Restart Services
echo "Daemon Reload"
systemctl daemon-reload
echo "Enable Server"
systemctl enable ts3server
echo "Start Server"
systemctl start ts3server


# Show your API Key for First time connection
echo "Wait service is starting...!"
sleep 8
systemctl status ts3server

echo "Your Key is given above. If you can't see it then Run systemctl status ts3server"