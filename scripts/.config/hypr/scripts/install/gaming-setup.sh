#!/bin/bash

# Define the relevant configuration files
PACMAN_CONF="/etc/pacman.conf"
HYPR_CONF="$HOME/.config/hypr/hyprland.conf"

# Check if the file exist
if [[ ! -f "$PACMAN_CONF" ]]; then
  echo "Error: $PACMAN_CONF not found."
  exit 1
fi

# Check if the file is writable
if [[ ! -w "$PACMAN_CONF" ]]; then
  echo "Error: Cannot write to $PACMAN_CONF. Run with sudo."
  exit 1
fi

# Check if [multilib] is commented (starts with #)
if grep -qE '^\s*#\s*\[multilib\]' "$PACMAN_CONF"; then
  echo "Multilib repository is currently disabled."
  # Uncomment the [multilib] line and the line immediately following it
  sed -i -e '/^\s*#\s*\[multilib\]/,+1s/^#//' "$PACMAN_CONF"
  echo "Multilib repository has been enabled."
else
  echo "Multilib is already enabled."
fi

# Update package database and install gaming
sudo pacman -Syu --needed --noconfirm lib32-mesa wine-staging winetricks \
  vkd3d lib32-vkd3d vulkan-radeon lib32-vulkan-radeon \
  vulkan-icd-loader lib32-vulkan-icd-loader \
  linux-headers dkms steam lutris gamescope

yay -S --needed --noconfirm protonplus

echo "Gaming packages have been installed. After reboot you have to do the following steps:"
echo "1. Start Steam to initialize its configuration. Then close Steam."
echo "2. Start ProtonPlus and install latest version of ProtonGE."
echo "3. Start Steam again, go to Setting->Compatibility: enable Steamplay, and select the installed ProtonGE from the list."
echo "4. Start Lutris. In wine runners section configure the installed ProtonGE as the default runner."

# Ensure that $USER is in input group
if ! id -nG "$USER" | grep -qw "input"; then
  echo "Adding $USER to input group..."
  sudo gpasswd -a "$USER" input
fi

# Install and configure Xbox Series X/S wireless controller
git clone https://github.com/atar-axis/xpadneo.git "$HOME"/xpadneo
cd "$HOME"/xpadneo
sudo ./install.sh
cd ..
rm -rf xpadneo
echo "Xbox Series X/S controller driver installed."
echo "Configuring Bluetooth for Xbox Series X/S..."
echo -e "[General]\nPrivacy = device\nJustWorksRepairing = always\nClass = 0x000100\nFastConnectable = true\n\n[LE]\nMinConnectionInterval=7\nMaxConnectionInterval=9\nConnectionLatency=0" | sudo tee -a /etc/bluetooth/main.conf
echo -e "[Input]\nUserspaceHID=true" | sudo tee -a /etc/subuidluetooth/input.conf
echo "Configure Xbox Series X/S driver to start at boot..."
sudo modprobe hid_xpadneo
echo -e "hid_xpadneo" | sudo tee -a /etc/modules-load.d/xpadneo.conf
echo "Xbox Series X/S controller driver configured. Please do pairing after reboot!"

# Create necessary environment variables
echo "Create necessary environment variables..."
# Backup the original config (if not already backed up)
if [[ ! -f "$HYPR_CONF.bak" ]]; then
  cp "$HYPR_CONF" "$HYPR_CONF.bak"
  echo "Backup created: $HYPR_CONF.bak"
fi

# List of environment variables to add
ENV_VARS=(
  "env = QT_QPA_PLATFORM,wayland"
  "env = QT_QPA_PLATFORMTHEME,qt6ct"
  "env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
  "env = GDK_BACKEND,wayland,x11"
  "env = SDL_VIDEODRIVER,wayland,x11"
  "env = WLR_NO_HARDWARE_CURSORS,1"
  "env = XDG_SESSION_TYPE,wayland"
  "env = XDG_SESSION_DESKTOP,Hyprland"
  "env = XDG_CURRENT_DESKTOP,Hyprland"
  "env = WINEPREFIX,\$HOME/.wine"
  "env = WINEARCH,win64"
  "env = PROTON_ENABLE_WAYLAND,1"
  "env = PROTON_ENABLE_HDR,1"
  "env = WAYLANDDRV_PRIMARY_MONITOR,DP-1"
  "env = DXVK_HUD,0"
  "env = DXVK_HDR,1"
)

# Add each variable if not already present
for var in "${ENV_VARS[@]}"; do
  if ! grep -qF "$var" "$HYPR_CONF"; then
    echo "$var" >>"$HYPR_CONF"
  else
    echo "Already exists: $var"
  fi
done

echo "Environment variables setup complete."
