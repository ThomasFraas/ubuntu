#!/bin/bash

echo "===> setup German...:" `date +%H:%M:%S.%N`

# switch to German keyboard layout
# sudo sed -i 's/"XKBLAYOUT"//g' /etc/default/keyboard
cat <<LAYOUT | sudo tee /etc/default/keyboard
XKBMODEL="pc105"
XKBLAYOUT="de"
XKBVARIANT="nodeadkeys"
XKBOPTIONS="terminate:ctrl_alt_bksp"
BACKSPACE="guess"
LAYOUT

# switch Ubuntu download mirror to German server
sudo sed -i 's,http://us.archive.ubuntu.com/ubuntu/,http://ftp.fau.de/ubuntu/,' /etc/apt/sources.list
sudo sed -i 's,http://security.ubuntu.com/ubuntu,http://ftp.fau.de/ubuntu,' /etc/apt/sources.list
sudo apt-get update -y

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y console-common
sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure keyboard-configuration
sudo install-keymap de

# set to UTF8 locale for later powerline
sudo update-locale LANG=en_US.utf8 LC_ALL=en_US.utf8

# set timezone to German timezone
echo "Europe/Berlin" | sudo tee /etc/timezone
sudo dpkg-reconfigure -f noninteractive tzdata

echo "===> End german.sh..:" `date +%H:%M:%S.%N`
