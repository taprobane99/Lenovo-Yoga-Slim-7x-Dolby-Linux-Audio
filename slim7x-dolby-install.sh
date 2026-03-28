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

# 3. System-level IRS files (Requires sudo)
IRS_DIR="/usr/share/dolby-audio"
echo "Preparing to install system-level IRS files..."

# Create the destination directory if it doesn't exist
sudo mkdir -p "$IRS_DIR"

# Loop through and install all necessary IRS files
for irs_file in "Dolby-Music-Balanced.irs" "Dolby-Movie-Balanced.irs"; do
    if [ -f "$irs_file" ]; then
        echo "Installing $irs_file to $IRS_DIR/$irs_file..."
        sudo cp "$irs_file" "$IRS_DIR/$irs_file"
    else
        echo "Warning: Source file '$irs_file' not found in current directory. Skipping."
    fi
done

echo "-------------------------------------"
echo "Installation complete!"
echo "To apply changes, restart PipeWire and WirePlumber using:"
echo "systemctl --user restart pipewire wireplumber"
