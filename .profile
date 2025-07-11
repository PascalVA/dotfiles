# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
  # include .bashrc if it exists
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi

# set PATH so it includes the golang installation if it exists
if [ -d "/usr/local/go/bin" ]; then
  PATH="/usr/local/go/bin:$PATH"
fi

# set PATH so it includes user's private go bin if it exists
if [ -d "$HOME/go/bin" ]; then
  PATH="$HOME/go/bin:$PATH"
fi

# set PATH so it includes user's private local go bin if it exists
if [ -d "$HOME/.local/go/bin" ]; then
  PATH="$HOME/.local/go/bin:$PATH"
fi

# add cargo bin
if [ -d "$HOME/.cargo/bin" ]; then
  PATH="$PATH:$HOME/.cargo/bin"
fi

# load asdf
if [ -d "${HOME}/.asdf" ]; then
  PATH="$HOME/.asdf/bin:$PATH"
  export ASDF_DATA_DIR="${HOME}/.asdf"
  export PATH="$ASDF_DATA_DIR/shims:$PATH"
fi

# source custom aliasses
if [ -f "${HOME}/.aliasses" ]; then
    source ${HOME}/.aliasses
fi
