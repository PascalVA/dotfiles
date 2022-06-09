#!/usr/bin/env bash

# real script path and parent directory name
THIS_REAL_FILE=$(readlink -e ${BASH_SOURCE[0]})
THIS_REAL_DIR=$(dirname ${THIS_REAL_FILE})

# symlink configuration files
for _filename in .bashrc .profile .inputrc .tmux.conf; do
    ln -sf ${THIS_REAL_DIR}/$_filename ${HOME}/$_filename
done

# symlink alacritty config file
if [ ! -d "${HOME}/.config/alacritty" ]; then
    mkdir ${HOME}/.config/alacritty
fi
ln -sf ${THIS_REAL_DIR}/alacritty.yml ${HOME}/.config/alacritty/alacritty.yml

# clone handy repositories used in bashrc
git clone https://github.com/ahmetb/kubectl-aliases ~/github/ahmetb/kubectl-aliases
git clone https://github.com/cykerway/complete-alias ~/github/cykerway/complete-alias
