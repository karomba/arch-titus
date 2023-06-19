#!/bin/bash

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

# Update packages list and update system
pacman -Syu -y

# Making .config and Moving config files and background to Pictures
cd $builddir
mkdir -p /home/$username/.config
mkdir -p /home/$username/.fonts
mkdir -p /home/$username/Pictures
cp -R dotconfig/* /home/$username/.config/
cp bg.jpg /home/$username/Pictures/
mv user-dirs.dirs /home/$username/.config
chown -R $username:$username /home/$username

# Installing Essential Programs 
pacman -S feh kitty rofi picom thunar nitrogen lxsession x11-xserver-utils unzip wget pulseaudio pavucontrol 
# Installing Other less important Programs
pacman -S neofetch flameshot psmisc mangohud vim lxappearance fonts-noto-color-emoji -y

# Download Nordic Theme
cd /usr/share/themes/
git clone https://github.com/EliverLara/Nordic.git

# Installing fonts
cd $builddir 
pacman -S ttf-font-awesome
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
unzip FiraCode.zip -d /home/$username/.fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
unzip Meslo.zip -d /home/$username/.fonts
mv dotfonts/fontawesome/otfs/*.otf /home/$username/.fonts/
chown $username:$username /home/$username/.fonts/*

# Reloading Font
fc-cache -vf
# Removing zip Files
rm ./FiraCode.zip ./Meslo.zip

# Install Nordzy cursor
git clone https://github.com/alvatip/Nordzy-cursors
cd Nordzy-cursors
./install.sh
cd $builddir
rm -rf Nordzy-cursors

# Install brave-browser
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay -S brave-bin


# Beautiful bash
git clone https://github.com/ChrisTitusTech/mybash
cd mybash
bash setup.sh
cd $builddir

# Install dwm titus
git clone https://github/christitustech/dwm-titus
cd dwm-titus
make
sudo make clean install 

# Use startx for dwm
cp .xinitrc ~/
cp ~/.xprofile
