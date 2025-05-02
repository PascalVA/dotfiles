#!/usr/bin/env bash

# real script path and parent directory name
THIS_REAL_FILE=$(readlink -e ${BASH_SOURCE[0]})
THIS_REAL_DIR=$(dirname ${THIS_REAL_FILE})

# add local bashrc.d directory
if [ ! -d "${HOME}/.bashrc.d" ]; then
  mkdir ${HOME}/.bashrc.d
fi

# add local completions directory
if [ ! -d "${HOME}/.bash_completion.d" ]; then
  mkdir ${HOME}/.bash_completion.d
fi

# add vundle plugin manager
if [ ! -d "${HOME}/.vim/bundle/Vundle.vim" ]; then
  git clone https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim
fi

# install kubectl aliasses
if [ ! -d "${HOME}/github.com/ahmetb/kubectl-aliases" ]; then
  git clone https://github.com/ahmetb/kubectl-aliases ${HOME}/github.com/ahmetb/kubectl-aliases
fi

# install alias completions
if [ ! -d "${HOME}/github.com/cykerway/complete-alias" ]; then
  git clone https://github.com/cykerway/complete-alias ${HOME}/github.com/cykerway/complete-alias
fi

# install asdf
if [ ! -d "${HOME}/.asdf" ]; then
  git clone https://github.com/asdf-vm/asdf.git ${HOME}/.asdf --branch v0.11.2
fi

# symlink configuration files
for _filename in .aliasses .bashrc .profile .inputrc .tmux.conf .vimrc; do
  ln -sf ${THIS_REAL_DIR}/$_filename ${HOME}/$_filename
done

# symlink the nvim config file
if [ ! -d "${HOME}/.config/nvim" ]; then
  mkdir -p ${HOME}/.config/nvim
fi
ln -sf ${THIS_REAL_DIR}/.vimrc ${HOME}/.config/nvim/init.vim

# symlink alacritty config file
if [ ! -d "${HOME}/.config/alacritty" ]; then
  mkdir ${HOME}/.config/alacritty
fi

# add user bin dir
if [ ! -d "${HOME}/bin" ]; then
  mkdir ${HOME}/bin
fi

# copy and configure light-mode/dark-mode switcher
ln -sf ${THIS_REAL_DIR}/bin/toggle-color-mode-gnome.sh ${HOME}/bin/toggle-color-mode-gnome.sh

# configure alacritty
ln -sf ${THIS_REAL_DIR}/.config/alacritty/alacritty.config.toml ${HOME}/.config/alacritty/alacritty.config.toml
ln -sf ${THIS_REAL_DIR}/.config/alacritty/alacritty.dark.toml ${HOME}/.config/alacritty/alacritty.dark.toml
ln -sf ${THIS_REAL_DIR}/.config/alacritty/alacritty.light.toml ${HOME}/.config/alacritty/alacritty.light.toml
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
