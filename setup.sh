#!/usr/bin/env bash

# store the parent directory path of this script so we
# can use it for symlinking files later
SCRIPT_DIR=$(dirname $(readlink -e ${BASH_SOURCE[0]}))
FZF_VERSION=$(basename $(curl -Ls -o /dev/null -w %{url_effective} https://github.com/junegunn/fzf/releases/latest | tr -d v))
GOLANG_VERSION=1.24.4
SETUP_TARGET=$1

case $SETUP_TARGET in
server) ;;
desktop) ;;
*)
  echo "Usage: ./setup.sh server|desktop"
  exit 1
  ;;
esac

echo "intalling extra packages"
sudo apt update && sudo apt install -y \
  build-essential \
  direnv \
  fd-find \
  git \
  libfontconfig-dev \
  libfuse2 \
  pkg-config \
  python-is-python3 \
  python3-venv \
  ranger \
  ripgrep \
  tree \
  unzip

echo "creating home directory structure"
mkdir -p ${HOME}/.local/share/{fonts,icons}

echo "symlinking configuration files"
for _filename in .aliasses .bashrc .bashrc.d .bash_completion.d .config/zellij .inputrc .profile .gitignore .config/nvim; do
  if [ ! -e "${HOME}/$_filename" ]; then
    ln -sf "${SCRIPT_DIR}/$_filename" "${HOME}/$_filename"
  fi
done

echo "installing nerd fonts"
if [ ! "${HOME}/.local/share/fonts/NotoMonoNerdFont-Regular.ttf" ]; then
  curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Noto.zip
  unzip -d ${HOME}/.local/share/fonts Noto.zip
  rm Noto.zip
fi

echo "installing kubectl aliasses"
if [ ! -d "${HOME}/github.com/ahmetb/kubectl-aliases" ]; then
  git clone https://github.com/ahmetb/kubectl-aliases ${HOME}/github.com/ahmetb/kubectl-aliases
fi

echo "installing alias completions"
if [ ! -d "${HOME}/github.com/cykerway/complete-alias" ]; then
  git clone https://github.com/cykerway/complete-alias ${HOME}/github.com/cykerway/complete-alias
fi

echo "installing rust and cargo"
if [ ! -d "${HOME}/.cargo" ]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

echo "installing zellij"
if [ ! "$(which zellij)" ]; then
  cargo install zellij
fi

echo "installing fzf"
mkdir -p ${HOME}/.local/share/doc/fzf/examples/
if [ ! "$(which fzf)" ]; then
  curl -sLo - https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tar.gz | tar -C ${HOME}/.local/bin/ -xzf -
fi
${HOME}/.local/bin/fzf --bash >${HOME}/.local/share/doc/fzf/examples/key-bindings.bash

echo "installing golang"
if [ ! "$(which go)" ]; then
  curl -sLo - https://go.dev/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz | sudo tar -C /usr/local/bin/ -xzf -
fi

echo "installing azure-cli"
if [ ! "$(which az)" ]; then
  curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
fi

echo "configuring global gitignore"
git config --global core.excludesFile '~/.gitignore'

# Install and configure GUI features only on desktops
if [ "$SETUP_TARGET" == "desktop" ]; then

  echo "DESKTOP SETUP"
  exit 0

  # copy and configure light-mode/dark-mode switcher
  ln -sf ${SCRIPT_DIR}/.local/bin/toggle-color-mode-gnome.sh ${HOME}/.local/bin/toggle-color-mode-gnome.sh

  # install wl-clipboard tools
  sudo apt install -y \
    wl-clipboard \
    xclip

  # install alacritty terminal emulator
  if [ -n "${DISPLAY}" ]; then
    cargo install alacritty
  fi

  # configure alacritty
  mkdir -p ${HOME}/.config/alacritty
  ln -sf ${SCRIPT_DIR}/.config/alacritty/alacritty.config.toml ${HOME}/.config/alacritty/alacritty.config.toml
  ln -sf ${SCRIPT_DIR}/.config/alacritty/alacritty.dark.toml ${HOME}/.config/alacritty/alacritty.dark.toml
  ln -sf ${SCRIPT_DIR}/.config/alacritty/alacritty.light.toml ${HOME}/.config/alacritty/alacritty.light.toml
  cat ${HOME}/.config/alacritty/alacritty.config.toml ${HOME}/.config/alacritty/alacritty.dark.toml >${HOME}/.config/alacritty/alacritty.toml

  #
  # configure gnome custom shortcuts
  # (to read use: dconf dump /org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/)
  #

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
