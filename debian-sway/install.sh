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

apt update
apt upgrade -y

apt install nala git -y
nala install shotwell kitty picom lxpolkit x11-xserver-utils unzip wget curl pulseaudio pavucontrol build-essential libx11-dev libxft-dev libxinerama-dev
nala install light sway swaybg swayidle swayimg swaylock waybar wofi fonts-font-awesome -y
nala install dolphin -y

cd $builddir

mkdir -p /home/$username/.fonts
mkdir -p /home/$username/.themes
mkdir -p /home/$username/GitHub
cd GitHub
git clone https://github.com/AngelosGian/varioussettings.git
git clone https://github.com/EliverLara/Sweet.git

#rename the default bashrc file
mv /home/$username/.bashrc /home/$username/bashrc.bak

#copying the configuration file for sway and the bashrc
cp -r variousettings/debian-sway/.config /home/$username/
cp -r variousettings/debian-sway/.bashrc /home/$username/
cp -r Sweet/ /home/$username/.themes/


echo "done"


