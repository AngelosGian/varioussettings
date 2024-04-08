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
apt update;apt upgrade -y


#install some basic packages
apt install nala -y 

#Configure the best mirrors
nala fetch
#using nala
nala install xorg neofetch build-essential libx11-dev libxft-dev libxinerama-dev kitty bat feh wget curl unzip rofi fonts-font-awesome neovim -y
# nala install git neofetch build-essential libx11-dev libxft-dev libxinerama-dev kitty bat feh wget curl unzip rofi fonts-font-awesome -y

# Run neofetch immediately after its installation
neofetch

cd $builddir
#creating the directories in home/$username
directories=(".suckless" "Downloads" ".config" ".fonts" "Pictures" ".themes" "Pictures/backgrounds")
for dir in "${directories[@]}"; do
    if [ -d "$dir"]; then
        echo "Directory "$dir" exists"
    else
        echo "Directory "$dir" does not exist, creating it"
        mkdir -p "$dir"
    fi
done

cd $builddir

# Define the home directory for clarity and reuse
user_home="/home/$username"

# Check if the original .bashrc exists before moving
if [ -f "$user_home/.bashrc" ]; then
    mv "$user_home/.bashrc" "$user_home/bashrc.bak"
else
    echo "No original .bashrc found, proceeding without backup."
fi

cd $builddir
# Ensure the source .bashrc exists
if [ -f "$user_home/variousettings/debian-dwm/.bashrc" ]; then
    cp "$user_home/variousettings/debian-dwm/.bashrc" "$user_home/"
    cp "$user_home/variousettings/debian-dwm/.xinitrc" "$user_home/"
else
    echo "Source .bashrc not found, cannot copy."
fi

if [ -f "$user_home/variousettings/debian-dwm/.xinitrc" ]; then
    cp "$user_home/variousettings/debian-dwm/.xinitrc" "$user_home/"
else
    echo "Source .xinitrc not found, cannot copy."
fi

if [ -f "$user_home/variousettings/debian-dwm/starship.toml" ]; then
    cp "$user_home/variousettings/debian-dwm/starship.toml" "$user_home/.config"
else
    echo "Source starship.toml not found, cannot copy."
fi
if [ -f "$user_home/variousettings/debian-dwm/evangelion-unit-01-4k-pc-1920x1080.jpg" ]; then
    cp "$user_home/variousettings/debian-dwm/evangelion-unit-01-4k-pc-1920x1080.jpg" "$user_home/Pictures/backgrounds"
else
    echo "Source evangelion-unit-01-4k-pc-1920x1080.jpg not found, cannot copy."
fi

#loading the new bashrc file
source home/$username/.bashrc


#change the ownership of the home directory
chown -R $username:$username .

cd $builddir
#clone the repository
# toClone=("https://git.suckless.org/dwm" "https://git.suckless.org/st" "https://git.suckless.org/dmenu")
toClone=("https://git.suckless.org/dwm" "https://git.suckless.org/dmenu")

for clone in "${toClone[@]}"; do
    # Extract the name of the repo from the URL to use as the folder name
    repoName=$(basename "$clone")
    targetDir=".suckless/$repoName"
    
    if [ -d "$targetDir" ]; then
        echo "Repository $repoName already cloned."
    else
        echo "Cloning $repoName into $targetDir"
        git clone "$clone" "$targetDir"
        cd $targetDir
        make; make clean install
        cd ..
    fi
done

cd $builddir

#installing fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip
unzip -o -d FiraCode.zip .fonts

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip
unzip -o -d Hack.zip .fonts

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Meslo.zip
unzip -o -d Meslo.zip .fonts

chown -R $username:$username .fonts/*

# Reloading Font
fc-cache -vf
# Removing zip Files
rm -rf ./Meslo.zip ./Hack.zip ./FiraCode.zip

#installing Sweet theme package
cd /home/$username/.themes
git clone https://github.com/EliverLara/Sweet

# Enable graphical login and change target from CLI to GUI
# systemctl enable lightdm
# systemctl set-default graphical.target

echo "Installation complete, enjoy your new dwm setup!"