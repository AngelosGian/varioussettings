#!/bin/bash

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

# Install nala
apt install nala -y

# Making .config and Moving config files and background to Pictures
cd $builddir
mkdir -p /home/$username/.config
mkdir -p /home/$username/.fonts
mkdir -p /home/$username/Pictures
mkdir -p /home/$username/Pictures/backgrounds

chown -R $username:$username /home/$username

# Installing Essential Programs 
nala install git shotwell kitty picom lxpolkit x11-xserver-utils unzip wget pulseaudio pavucontrol build-essential libx11-dev libxft-dev libxinerama-dev -y
# Installing Other less important Programs
nala install neofetch flameshot psmisc mangohud vim lxappearance papirus-icon-theme fonts-noto-color-emoji -y

# Download Nordic Theme
cd /usr/share/themes/
git clone https://github.com/EliverLara/Sweet.git

# Installing fonts
cd $builddir 
nala install fonts-font-awesome -y
#wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.1/FiraCode.zip
unzip FiraCode.zip -d /home/$username/.fonts
#wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.1/Meslo.zip
unzip Meslo.zip -d /home/$username/.fonts

chown $username:$username /home/$username/.fonts/*
#https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip
# Reloading Font
fc-cache -vf
# Removing zip Files
rm ./FiraCode.zip ./Meslo.zip

# Install brave-browser
nala install apt-transport-https curl -y
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list
nala update
nala install brave-browser -y


# Beautiful bash
cd ~/Downloads
git clone https://github.com/ChrisTitusTech/mybash
cd mybash
bash setup.sh
cd $builddir

# Use nala
#bash scripts/usenala