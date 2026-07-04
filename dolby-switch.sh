#!/bin/bash

CONF_DIR="$HOME/.config/pipewire/pipewire.conf.d"

if [ -f "$CONF_DIR/99-dolby-music.conf" ]; then
    echo "Switching to Movie Preset..."
    mv "$CONF_DIR/99-dolby-music.conf" "$CONF_DIR/99-dolby-music.conf.disabled"
    mv "$CONF_DIR/99-dolby-movie.conf.disabled" "$CONF_DIR/99-dolby-movie.conf" 2>/dev/null
else
    echo "Switching to Music Preset..."
    mv "$CONF_DIR/99-dolby-movie.conf" "$CONF_DIR/99-dolby-movie.conf.disabled"
    mv "$CONF_DIR/99-dolby-music.conf.disabled" "$CONF_DIR/99-dolby-music.conf" 2>/dev/null
fi

systemctl --user restart pipewire pipewire-pulse wireplumber
echo "Dolby Profile Swapped!"
