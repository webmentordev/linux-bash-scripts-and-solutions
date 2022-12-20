#!/bin/bash

# First we will make a directory rust_server in Downloads folder then install Rust server in it

#Chaneg Directory to Downloads
cd /home/*username*/Downloads

# make Directory
mkdir rust_server

#Download Rust Server in rust_server directory then auto quit aftr it
/home/*username*/Downloads/steam/steamcmd.sh \+force_install_dir /home/*username*/Downloads/rust_server/ \+login anonymous \+app_update 258550 \+quit

echo "Server Downloaded Successfully"
