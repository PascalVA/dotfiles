#!/usr/bin/env bash

# store the parent directory path of this script so we
# can use it for symlinking files later
SCRIPT_DIR=$(dirname $(readlink -e ${BASH_SOURCE[0]}))

# install custom packages
sudo apt update
sudo apt install -y \
  build-essential \
  direnv \
  fd-find \
  fzf \
  git \
  libfontconfig-dev \
  libfuse2 \
  pkg-config \
  ranger \
  ripgrep \
  tree \
  unzip \
  wl-clipboard \
  xclip

# create custom directories in the user home directory
mkdir -p ${HOME}/{.bashrc.d,.bash_completion.d}
mkdir -p ${HOME}/.config/{alacritty,nvim}
mkdir -p ${HOME}/.local/share/{fonts,icons}

# install nerd fonts
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Noto.zip
unzip -d ${HOME}/.local/share/fonts Noto.zip
rm Noto.zip

# install kubectl aliasses
if [ ! -d "${HOME}/github.com/ahmetb/kubectl-aliases" ]; then
  git clone https://github.com/ahmetb/kubectl-aliases ${HOME}/github.com/ahmetb/kubectl-aliases
fi

# install alias completions
if [ ! -d "${HOME}/github.com/cykerway/complete-alias" ]; then
  git clone https://github.com/cykerway/complete-alias ${HOME}/github.com/cykerway/complete-alias
fi

# install lazyvim
if [ ! -d "${HOME}/.config/nvim/lua" ]; then
  git clone https://github.com/LazyVim/starter ${HOME}/.config/nvim
  rm -rf ${HOME}/.config/nvim/.git
fi

# install rust and cargo
if [ ! -d "${HOME}/.cargo" ]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# install cargo apps
cargo install alacritty
cargo install zellij

# install azure-cli
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# symlink configuration files
for _filename in .aliasses .bashrc .inputrc .profile .gitignore; do
  ln -sf "${SCRIPT_DIR}/$_filename" "${HOME}/$_filename"
done

# copy and configure light-mode/dark-mode switcher
ln -sf ${SCRIPT_DIR}/.local/bin/toggle-color-mode-gnome.sh ${HOME}/.local/bin/toggle-color-mode-gnome.sh

# configure alacritty
ln -sf ${SCRIPT_DIR}/.config/alacritty/alacritty.config.toml ${HOME}/.config/alacritty/alacritty.config.toml
ln -sf ${SCRIPT_DIR}/.config/alacritty/alacritty.dark.toml ${HOME}/.config/alacritty/alacritty.dark.toml
ln -sf ${SCRIPT_DIR}/.config/alacritty/alacritty.light.toml ${HOME}/.config/alacritty/alacritty.light.toml
cat ${HOME}/.config/alacritty/alacritty.config.toml ${HOME}/.config/alacritty/alacritty.dark.toml >${HOME}/.config/alacritty/alacritty.toml

# configure zellij
ln -sf ${SCRIPT_DIR}/.config/zellij/config.kdl ${HOME}/.config/zellij/config.kdl
ln -sf ${SCRIPT_DIR}/.config/zellij/config.kdl ${HOME}/.config/zellij/workspace-layout.kdl

# configure global gitignore
git config --global core.excludesFile '~/.gitignore'

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

  # configure static workspaces
  gsettings set org.gnome.mutter dynamic-workspaces false
  gsettings set org.gnome.desktop.wm.preferences num-workspaces 10

  # Removes application hotkeys such as <Super>1 so they can be re-used
  gsettings set org.gnome.shell.keybindings switch-to-application-1 []
  gsettings set org.gnome.shell.keybindings switch-to-application-2 []
  gsettings set org.gnome.shell.keybindings switch-to-application-3 []
  gsettings set org.gnome.shell.keybindings switch-to-application-4 []
  gsettings set org.gnome.shell.keybindings switch-to-application-5 []
  gsettings set org.gnome.shell.keybindings switch-to-application-6 []
  gsettings set org.gnome.shell.keybindings switch-to-application-7 []
  gsettings set org.gnome.shell.keybindings switch-to-application-8 []
  gsettings set org.gnome.shell.keybindings switch-to-application-9 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-hotkey-1 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-hotkey-2 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-hotkey-3 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-hotkey-4 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-hotkey-5 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-hotkey-6 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-hotkey-7 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-hotkey-8 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-hotkey-9 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-hotkey-10 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-shift-hotkey-1 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-shift-hotkey-2 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-shift-hotkey-3 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-shift-hotkey-4 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-shift-hotkey-5 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-shift-hotkey-6 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-shift-hotkey-7 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-shift-hotkey-8 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-shift-hotkey-9 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-shift-hotkey-10 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-ctrl-hotkey-1 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-ctrl-hotkey-2 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-ctrl-hotkey-3 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-ctrl-hotkey-4 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-ctrl-hotkey-5 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-ctrl-hotkey-6 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-ctrl-hotkey-7 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-ctrl-hotkey-8 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-ctrl-hotkey-9 []
  gsettings set org.gnome.shell.extensions.dash-to-dock app-ctrl-hotkey-10 []

  # configure workspace switching hotkeys
  dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-1 "['<Super>1']"
  dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-2 "['<Super>2']"
  dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-3 "['<Super>3']"
  dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-4 "['<Super>4']"
  dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-5 "['<Super>5']"
  dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-6 "['<Super>6']"
  dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-7 "['<Super>7']"
  dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-8 "['<Super>8']"
  dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-9 "['<Super>9']"
  dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-10 "['<Super>0']"

  dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-1 "['<Super><shift>1']"
  dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-2 "['<Super><shift>2']"
  dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-3 "['<Super><shift>3']"
  dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-4 "['<Super><shift>4']"
  dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-5 "['<Super><shift>5']"
  dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-6 "['<Super><shift>6']"
  dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-7 "['<Super><shift>7']"
  dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-8 "['<Super><shift>8']"
  dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-9 "['<Super><shift>9']"
  dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-10 "['<Super><shift>0']"
fi
