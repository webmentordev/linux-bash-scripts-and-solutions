#!/bin/bash
while :
do
	echo "Starting Server..."
    sleep 2
    /root/Steam/steamcmd.sh \+force_install_dir /home/rust/ \+login anonymous \+app_update 258550 \+quit
    echo "Updating Oxide..."
    sleep 2
    wget -c https://umod.org/games/rust/download/develop -O UmodUpdate.zip
    unzip -o UmodUpdate.zip
    rm UmodUpdate.zip
    echo "Starting.."
    sleep 2
    /home/rust/RustDedicated -batchmode -nographics \
      -server.ip 0.0.0.0 \
      -server.port 28015 \
      -rcon.ip 0.0.0.0 \
      -rcon.port 28016 \
      -rcon.password "pleaseletmein" \
      -server.maxplayers 250 \
      -server.hostname "TestingServer" \
      -server.identity "my_server_identity" \
      -server.level "Procedural Map" \
      -server.seed 12345 \
      -server.worldsize 3500 \
      -server.saveinterval 300 \
      -server.globalchat true \
      -server.url "https://youtube.com/c/matred97"
    echo "\nRestarting server...\n"
	sleep 5
done