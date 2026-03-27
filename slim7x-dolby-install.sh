#!/bin/bash

# Get the current username and home directory
USER_NAME=$(whoami)
USER_HOME=$HOME

echo "--- Audio Configuration Installer ---"
echo "Targeting user: $USER_NAME"
echo "Targeting home: $USER_HOME"
echo "-------------------------------------"

# Function to copy files and create directories
install_file() {
    local src=$1
    local dest=$2

    if [ -f "$src" ]; then
        echo "Installing $src to $dest..."
        mkdir -p "$(dirname "$dest")"
        cp "$src" "$dest"
    else
        echo "Warning: Source file '$src' not found in current directory. Skipping."
    fi
}

# 1. User-level PipeWire Configs
install_file "50-upmix.conf" "$USER_HOME/.config/pipewire/pipewire.conf.d/50-upmix.conf"
install_file "99-dolby-music.conf" "$USER_HOME/.config/pipewire/pipewire.conf.d/99-dolby-music.conf"
install_file "50-upmix.conf" "$USER_HOME/.config/pipewire/pipewire-pulse.conf.d/50-upmix.conf"
install_file "50-upmix.conf" "$USER_HOME/.config/pipewire/client.conf.d/50-upmix.conf"

# 2. User-level WirePlumber Config
install_file "51-speaker-softmixer.conf" "$USER_HOME/.config/wireplumber/wireplumber.conf.d/51-speaker-softmixer.conf"

# 3. System-level IRS file (Requires sudo)
IRS_SRC="Dolby-Music-Balanced.irs"
IRS_DEST="/usr/share/dolby-audio/Dolby-Music-Balanced.irs"

if [ -f "$IRS_SRC" ]; then
    echo "Installing $IRS_SRC to system directory (sudo required)..."
    sudo mkdir -p "/usr/share/dolby-audio/"
    sudo cp "$IRS_SRC" "$IRS_DEST"
    sudo chmod 644 "$IRS_DEST"
else
    echo "Warning: Source file '$IRS_SRC' not found. Skipping system install."
fi

echo "-------------------------------------"
echo "Installation complete."
echo "To apply changes, it is recommended to restart PipeWire and WirePlumber:"
echo "systemctl --user restart pipewire pipewire-pulse wireplumber"
