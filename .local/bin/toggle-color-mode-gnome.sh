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
  for nvim_server in $(ls /run/user/1000/nvim.*); do
    # nvim --server "$nvim_server" --remote-send ":colorscheme nightfox<CR>"
    nvim --server "$nvim_server" --remote-send ":lua require('onedark').setup({ style = \"cool\", }) require('onedark').load()<CR>"
  done
  # sed -i 's/\(colorscheme =\) "[^"]\+"/\1 "nightfox"/' ~/.config/nvim/lua/plugins/colorscheme.lua
  sed -i 's/\(style =\) "[^"]\+"/\1 "cool"/' ~/.config/nvim/lua/plugins/colorscheme.lua
  sed -i 's/\(theme\) .*/\1 "iceberg-dark"/' ~/.config/zellij/config.kdl
else
  echo "toggle light"
  gsettings set org.gnome.desktop.interface color-scheme prefer-light
  cat ~/.config/alacritty/alacritty.config.toml ~/.config/alacritty/alacritty.light.toml >~/.config/alacritty/alacritty.toml
  for nvim_server in $(ls /run/user/1000/nvim.*); do
    # nvim --server "$nvim_server" --remote-send ":colorscheme dayfox<CR>"
    nvim --server "$nvim_server" --remote-send ":lua require('onedark').setup({ style = \"light\", }) require('onedark').load()<CR>"
  done
  # sed -i 's/\(colorscheme =\) "[^"]\+"/\1 "dayfox"/' ~/.config/nvim/lua/plugins/colorscheme.lua
  sed -i 's/\(style =\) "[^"]\+"/\1 "light"/' ~/.config/nvim/lua/plugins/colorscheme.lua
  sed -i 's/\(theme\) .*/\1 "catppuccin-latte"/' ~/.config/zellij/config.kdl
fi
