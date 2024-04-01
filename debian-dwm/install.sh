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
nala install neofetch build-essential libx11-dev libxft-dev libxinerama-dev kitty bat feh wget curl unzip fonts-font-awesome -y

# Run neofetch immediately after its installation
neofetch

cd $builddir

# directories=("home/$username/.suckless", "home/$username/Downloads", "home/$username/.config", "home/$username/.fonts", "home/$username/Pictures", "home/$username/.themes" )
directories=("$ΗΟΜΕ/.suckless", "$ΗΟΜΕ/Downloads", "$ΗΟΜΕ/.config", "$ΗΟΜΕ/.fonts", "$ΗΟΜΕ/Pictures", "$ΗΟΜΕ/Pictures/backgrounds", "$ΗΟΜΕ/.themes" )
for dir in "${directories[@]}"; do
    if [ -d "$dir"]; then
        echo "${YELLOW}Directory "$dir" exists"
    else
        echo "${GREEN}Directory "$dir" does not exist, creating it"
        mkdir -p "$dir"
    fi
done

mv "$HOME/.bashrc" "$HOME/bashrc.bak"
cp "$HOME/variousettings/.bashrc" "$HOME"
source "$HOME/.bashrc"

cp "$HOME/variousettings/evangelion-unit-01-4k-pc-1920x1080.jpg" "$HOME/Pictures/backgrounds"
cp "$HOME/variousettings/starship.toml" "$HOME/.config"
#change the ownership of the home directory
chown -R $username:$username .



toClone=("https://git.suckless.org/dwm" "https://git.suckless.org/st" "https://git.suckless.org/dmenu")

for clone in "${toClone[@]}"; do
    # Extract the name of the repo from the URL to use as the folder name
    repoName=$(basename "$clone")
    targetDir="$ΗΟΜΕ/.suckless/$repoName"
    
    if [ -d "$targetDir" ]; then
        echo "${YELLOW}Repository $repoName already cloned."
    else
        echo "${GREEN}Cloning $repoName into $targetDir"
        git clone "$clone" "$targetDir"
        cd $targetDir
        make; make clean install
        cd ..
    fi
done

cd "$HOME"

#installing fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip
unzip FiraCode.zip
rm FiraCode.zip
mv FiraCode "$HOME/.fonts"

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip
unzip Hack.zip
rm Hack.zip
mv Hack "$HOME/.fonts"

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Meslo.zip
unzip Meslo.zip
rm Meslo.zip
mv Meslo "$HOME/.fonts"

