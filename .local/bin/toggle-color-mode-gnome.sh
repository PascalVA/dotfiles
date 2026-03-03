#!/bin/sh
#
# This script toggles the gnome color scheme settings between 'prefer-light' and 'prefer-dark'
# The alacritty terminal is also updated to toggle the light and dark theme

color_scheme=$(gsettings get org.gnome.desktop.interface color-scheme)

echo color_scheme: $color_scheme

if [ "$color_scheme" = "'prefer-light'" ]; then
  echo "toggle dark"
  gsettings set org.gnome.desktop.interface color-scheme prefer-dark
  cat ~/.config/alacritty/alacritty.config.toml ~/.config/alacritty/alacritty.dark.toml >~/.config/alacritty/alacritty.toml
  # my neovim listens for SIGUSR1 and reloads the colorscheme based on gsettings
  pgrep nvim | xargs kill -USR1
  sed -i 's/\(theme\) .*/\1 "iceberg-dark"/' ~/.config/zellij/config.kdl
  git config --global delta.dark true
  git config --global delta.light false
else
  echo "toggle light"
  gsettings set org.gnome.desktop.interface color-scheme prefer-light
  cat ~/.config/alacritty/alacritty.config.toml ~/.config/alacritty/alacritty.light.toml >~/.config/alacritty/alacritty.toml
  # my neovim listens for SIGUSR1 and reloads the colorscheme based on gsettings
  pgrep nvim | xargs kill -USR1
  sed -i 's/\(theme\) .*/\1 "catppuccin-latte"/' ~/.config/zellij/config.kdl
  git config --global delta.dark false
  git config --global delta.light true
fi
