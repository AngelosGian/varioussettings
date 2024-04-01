#!/bin/bash

RC='\e[0m'
RED='\e[31m'
YELLOW='\e[33m'
GREEN='\e[32m'


# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

# Update packages list and update system
apt update
apt upgrade -y


#install some basic packages
apt install nala -y 

#using nala
nala install neofetch build-essential libx11-dev libxft-dev libxinerama-dev kitty


cd $builddir

directories=("~/$username/.suckless", "~/$username/Downloads", "~/$username/.config", "~/$username/.fonts", "~/$username/Pictures", "~/$username/.themes" )
for dir in "${directories[@]}"; do
    if [ -d "$dir"]; then
        echo "Directory "$dir" exists"
    else
        echo "Directory "$dir" does not exist, creating it"
        mkdir -p "$dir"
    fi
done

toClone=("https://github.com/suckless/dwm.git" "https://github.com/suckless/st.git" "https://github.com/suckless/dmenu.git" )

for clone in "${toClone[@]}"; do
    if [ -d "$clone"]; then
        echo "Directory "$clone" exists"
    else
        echo "Directory "$clone" does not exist, creating it"
        mkdir -p "$clone"
    fi
done

