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
if [ ! -d "${HOME}/github/ahmetb/kubectl-aliases" ]; then
    git clone https://github.com/ahmetb/kubectl-aliases ${HOME}/github/ahmetb/kubectl-aliases
fi

# install alias completions
if [ ! -d "${HOME}/github/cykerway/complete-alias" ]; then
    git clone https://github.com/cykerway/complete-alias ${HOME}/github/cykerway/complete-alias
fi

# install asdf
if [ ! -d "${HOME}/.asdf" ]; then
    git clone https://github.com/asdf-vm/asdf.git ${HOME}/.asdf --branch v0.11.2
fi

# symlink configuration files
for _filename in .bashrc .profile .inputrc .tmux.conf .vimrc; do
    ln -sf ${THIS_REAL_DIR}/$_filename ${HOME}/$_filename
done

# symlink the nvim config file
if [ ! -d "${HOME}/.config/nvim" ]; then
     ${HOME}/.config/nvim
fi
ln -sf ${THIS_REAL_DIR}/.vimrc ${HOME}/.config/nvim/init.vim

# symlink alacritty config file
if [ ! -d "${HOME}/.config/alacritty" ]; then
    mkdir ${HOME}/.config/alacritty
fi
ln -sf ${THIS_REAL_DIR}/alacritty.yml ${HOME}/.config/alacritty/alacritty.yml
