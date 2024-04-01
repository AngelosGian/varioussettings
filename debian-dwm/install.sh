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
nala install neofetch build-essential libx11-dev libxft-dev libxinerama-dev kitty bat feh wget curl unzip fonts-font-awesome lightdm thunar -y

# Run neofetch immediately after its installation
neofetch

cd $builddir

directories=(".suckless" "Downloads" ".config" ".fonts" "Pictures" ".themes" )
for dir in "${directories[@]}"; do
    if [ -d "$dir"]; then
        echo "Directory "$dir" exists"
    else
        echo "Directory "$dir" does not exist, creating it"
        mkdir -p "$dir"
    fi
done

mv home/$username/.bashrc home/$username/bashrc.bak
cp home/$username/variousettings/.bashrc home/$username/
source home/$username/.bashrc

cp home/$username/variousettings/evangelion-unit-01-4k-pc-1920x1080.jpg home/$username/Pictures/backgrounds
cp home/$username/variousettings/starship.toml home/$username/.config
#change the ownership of the home directory
chown -R $username:$username .

cd $builddir

toClone=("https://git.suckless.org/dwm" "https://git.suckless.org/st" "https://git.suckless.org/dmenu")

for clone in "${toClone[@]}"; do
    # Extract the name of the repo from the URL to use as the folder name
    repoName=$(basename "$clone")
    targetDir="home/$username/.suckless/$repoName"
    
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
unzip -o -d FiraCode.zip home/$username/.fonts

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip
unzip -o -d Hack.zip home/$username/.fonts

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Meslo.zip
unzip -o -d Meslo.zip home/$username/.fonts

chown -R $username:$username home/$username/.fonts/*

# Reloading Font
fc-cache -vf
# Removing zip Files
rm -rf ./Meslo.zip ./Hack.zip ./FiraCode.zip

#installing Sweet theme package
cd /home/$username/.themes
git clone https://github.com/EliverLara/Sweet

# Enable graphical login and change target from CLI to GUI
systemctl enable lightdm
systemctl set-default graphical.target

echo "Installation complete, enjoy your new dwm setup!"


