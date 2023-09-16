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
      -server.queryport 28016 \
      -rcon.ip 0.0.0.0 \
      -rcon.port 28017 \
      -rcon.password "pleaseletmein" \
      -server.maxplayers 250 \
      -server.hostname "My Rust Server" \
      -server.identity "rust" \
      -server.level "Procedural Map" \
      -server.seed 12345 \
      -server.worldsize 3500 \
      -server.saveinterval 150 \
      -server.globalchat true \
      -app.publicip 0.0.0.0 \
      -app.port 28018 \
      -server.url "https://youtube.com/c/matred97"
    echo "\nRestarting server...\n"
	sleep 5
done