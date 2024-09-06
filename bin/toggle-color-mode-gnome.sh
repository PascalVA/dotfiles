#!/bin/bash
#
# This script toggles the gnome color scheme settings between 'prefer-light' and 'prefer-dark'
# The alacritty terminal is also updated to toggle the light and dark theme


color_scheme=$(gsettings get org.gnome.desktop.interface color-scheme)

echo color_scheme: $color_scheme

if [ "$color_scheme" == "'prefer-light'" ]; then
    echo "toggle dark"
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark
    cat ~/.config/alacritty/alacritty.config.toml ~/.config/alacritty/alacritty.dark.toml > ~/.config/alacritty/alacritty.toml
    sed -i 's/colorscheme onehalflight/colorscheme onehalfdark/' ~/.config/nvim/init.vim
else
    echo "toggle light"
    gsettings set org.gnome.desktop.interface color-scheme prefer-light
    cat ~/.config/alacritty/alacritty.config.toml ~/.config/alacritty/alacritty.light.toml > ~/.config/alacritty/alacritty.toml
    sed -i 's/colorscheme onehalfdark/colorscheme onehalflight/' ~/.config/nvim/init.vim
fi
