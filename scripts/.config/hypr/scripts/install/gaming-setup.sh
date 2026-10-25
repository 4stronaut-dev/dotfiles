#!/bin/bash

# Define the relevant configuration files
PACMAN_CONF="/etc/pacman.conf"
HYPRLAND_CONF="$HOME/.config/hypr/hyprland.lua"

# Check if [multilib] is commented (starts with #)
if ! grep -q '^\[multilib\]' "$PACMAN_CONF"; then
  sudo cp "$PACMAN_CONF" "$PACMAN_CONF.bak"
  echo "> Backup created: $PACMAN_CONF.bak"
  line=$(grep -n '^\s*#\s*\[multilib\]' "$PACMAN_CONF" | head -1 | cut -d: -f1)
  sed -i -e "${line}s/^#//" -e "$((line + 1))s/^#//" "$PACMAN_CONF"
  echo "###> Multilib repository has been enabled."
else
  echo "###> Multilib is already enabled."
fi

# Update package database to include 32bit packages as well.
sudo pacman -Syu --noconfirm --needed

# Install gaming packages
sudo pacman -S --needed --noconfirm mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon \
  gamemode lib32-gamemode mangohud lib32-mangohud gamescope steam lutris

# Install Proton-CachyOS (it is maintained by yay, no manual update needed via ProtonPlus)
yay -S --needed --noconfirm proton-cachyos-slr

# Notification for the user about the needed manual steps
echo "###> Gaming packages have been installed. After reboot you have to do the following steps:"
echo "> 1. Start Steam to initialize its configuration. Then close Steam."
echo "> 2. Start Steam again, go to Setting->Compatibility: enable Steamplay, and select Proton-CachyOS from the list."
echo "> 3. Start Lutris. In wine runners section configure Proton-CahcyOS as the default runner."
echo "> 4.(optional) In Lutris the runner have a system tab, here check the default game install folder, enable and configure gamemode, gamescope, mangohud."

# Ensure that $USER is in input group
if ! id -nG "$USER" | grep -qw "input"; then
  echo "Adding $USER to input group..."
  sudo gpasswd -a "$USER" input
fi

# Install and configure Xbox Series X/S wireless controller
# Install dependencies for xpadneo-dkms version of the driver -> dkms version needed to proper bluetooth pairing.
sudo pacman -S --needed --noconfirm dkms linux-headers
# Install xpadneo-dkms driver
yay -S --needed --noconfirm xpadneo-dkms
echo "Xbox Series X/S controller driver installed."
echo "Configuring Bluetooth for Xbox Series X/S..."
echo -e "[General]\nPrivacy = device\nJustWorksRepairing = always\nClass = 0x000100\nFastConnectable = true\n\n[LE]\nMinConnectionInterval=7\nMaxConnectionInterval=9\nConnectionLatency=0" | sudo tee -a /etc/bluetooth/main.conf
echo -e "[Input]\nUserspaceHID=true" | sudo tee -a /etc/bluetooth/input.conf
echo "Configure Xbox Series X/S driver to start at boot..."
sudo modprobe hid_xpadneo
echo -e "hid_xpadneo" | sudo tee -a /etc/modules-load.d/xpadneo.conf
echo "Xbox Series X/S controller driver configured. Please reboot then do the pairing after reboot!"

# Install Logitech Gamer Keyboard and Mouse handler application: Solaar
sudo pacman -S --needed --noconfirm solaar
# Apply device rules installed by Solaar to make the Logitech receiver accessible
sudo udevadm control --reload-rules

echo "###> Gaming setup installation completed!"
