#!/bin/sh

# You may need steam installed on your system and Script is used for rust user in linux system
echo "Wiping server is 5 seconds"
sleep 5

TITLE="Rusty Square US 10X|QUAD|PVP|KIT+|NoBPs|BUILD|RAID|Weekly"
SERVER="/home/rust/server"
STEAM="/home/rust/Steam/steamcmd.sh"
PASSWORD="mybestrusty2xpassword"
WEBSITE="https://rustysquare.com"
####################
PORT=28015
QUERY=28016
RCON=28017
APPPORT=28017
MAX_PLAYERS=120
####################
MAP=3500
SEED=$(shuf -i 0-2147483647 -n 1)

echo "##########################################################"
echo "Exporting New Starter file with seed and map size e.t.c"
echo "#########################################################"
sleep 3

#############################################################################################
cat > $SERVER/start_server.sh <<EOF
#!/bin/sh
while :
do
 TERM=roxterm
 echo "Starting Server..."
 sleep 3

 $STEAM \+force_install_dir $SERVER \+login anonymous \+app_update 258550 \+quit

 echo "Updating Oxide..."
 sleep 3

 wget -c --inet4-only https://umod.org/games/rust/download/develop -O UmodUpdate.zip
 unzip -o UmodUpdate.zip
 rm UmodUpdate.zip

 echo "Starting.."
 sleep 3
 ./RustDedicated -batchmode -nographics -server.ip 0.0.0.0 -server.port $PORT -server.queryport $QUERY -rcon.ip 0.0.0.0 -rcon.port $RCON -rcon.password "$PASSWORD" -server.maxplayers $MAX_PLAYERS -server.level "Procedural Map" -server.seed $SEED -server.worldsize $MAP -server.hostname "$TITLE" -server.identity "my_server_identity" -server.saveinterval 300 -app.publicip 0.0.0.0 -app.port $APPPORT -server.globalchat true -server.url "$WEBSITE"
 echo "\nRestarting server...\n"
done
EOF

#############################################################################################
echo "Deleting server map file."
sleep 3
cd $SERVER/server/my_server_identity && rm procedural*

#############################################################################################
echo "Server wiped! New Seeds: $SEED and map Size $MAP | Server will come online shortly"
