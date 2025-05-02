#!/usr/bin/env bash

# store the parent directory path of this script so we
# can use it for symlinking files later
SCRIPT_DIR=$(dirname $(readlink -e ${BASH_SOURCE[0]}))

# install kubectl aliasses
if [ ! -d "${HOME}/github.com/ahmetb/kubectl-aliases" ]; then
  git clone https://github.com/ahmetb/kubectl-aliases ${HOME}/github.com/ahmetb/kubectl-aliases
fi

# install alias completions
if [ ! -d "${HOME}/github.com/cykerway/complete-alias" ]; then
  git clone https://github.com/cykerway/complete-alias ${HOME}/github.com/cykerway/complete-alias
fi

# install custom packages
sudo apt install build-essential git libfuse2 pkg-config libfontconfig-dev direnv

# install rust and cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# install cargo apps
cargo install alacritty
cargo install zellij

# install azure-cli
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# create custom directories in the user home directory
mkdir -p ${HOME}/{.bashrc.d,.bash_completion.d}
mkdir -p ${HOME}/.config/{alacritty,nvim}
mkdir -p ${HOME}/.local/share/icons

# symlink configuration files
for _filename in .aliasses .bashrc .inputrc .profile ; do
  ln -sf "${SCRIPT_DIR}/$_filename" "${HOME}/$_filename"
done

# copy and configure light-mode/dark-mode switcher
ln -sf ${SCRIPT_DIR}/.local/bin/toggle-color-mode-gnome.sh ${HOME}/.local/bin/toggle-color-mode-gnome.sh

# configure alacritty
ln -sf ${SCRIPT_DIR}/.config/alacritty/alacritty.config.toml ${HOME}/.config/alacritty/alacritty.config.toml
ln -sf ${SCRIPT_DIR}/.config/alacritty/alacritty.dark.toml ${HOME}/.config/alacritty/alacritty.dark.toml
ln -sf ${SCRIPT_DIR}/.config/alacritty/alacritty.light.toml ${HOME}/.config/alacritty/alacritty.light.toml
cat ${HOME}/.config/alacritty/alacritty.config.toml ${HOME}/.config/alacritty/alacritty.dark.toml >${HOME}/.config/alacritty/alacritty.toml

#
# configure gnome custom shortcuts
# (to read use: dconf dump /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/)
#

if [ -n "${DISPLAY}" ]; then
  # create config keys to hold custom shortcuts
  gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"

  # alacrtitty (Super + Return)
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'terminal'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'env -u WAYLAND_DIPSLAY alacritty'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super>Return'

  # toggle dark/light mode (Super + F11)
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'toggle-theme'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'toggle-color-mode-gnome.sh'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Super>F11'
fi
