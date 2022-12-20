#!/bin/bash

/home/ahmerdev/files/steam/steamcmd.sh \+force_install_dir /home/ahmerdev/rust_server \+login anonymous \+app_update 258550 \+quit

wget -c https://umod.org/games/rust/download/develop -O UmodUpdate.zip
unzip -o UmodUpdate.zip
rm UmodUpdate.zip

clear while : do
  exec ./RustDedicated -batchmode -nographics \
  -server.ip 0.0.0.0 \
  -server.port 29015 \
  -rcon.ip 0.0.0.0 \
  -rcon.port 29016 \
  -rcon.password "password" \
  -server.maxplayers 250 \
  -server.hostname "RustyUranium 10x PVE | NPC Raidable Bases | Events" \
  -server.identity "rustyuranium" \
  -server.level "Procedural Map" \
  -server.seed 454545 \
  -server.worldsize 4000 \
  -rcon.web 1 \
  -server.saveinterval 300 \-server.globalchat true \
  -server.description "Description Here" \
  -server.headerimage "https://rustyuranium.online/background.jpg" \
  -server.url "https://rustyuranium.online"
  echo "\nRestarting server...\n" done