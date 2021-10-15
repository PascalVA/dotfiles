#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# real script path and parent directory name
THIS_REAL_FILE=$(readlink -e ${BASH_SOURCE[0]})
THIS_REAL_DIR=$(dirname ${THIS_REAL_FILE})

#
# INCLUDE SOURCE FILES
#

# source program specific source files
for bash_source in $(find ${THIS_REAL_DIR}/source.bash/ -type f); do
    source ${bash_source}
done

# source system bash completion dir
if [ -d /etc/bash_completion.d ]; then
    for comp_file in $(find /etc/bash_completion.d -type f); do
        . $comp_file
    done
fi

# source custom bash completion dir
if [ -d ~/.bash_completion.d ]; then
    for comp_file in $(find ~/.bash_completion.d -type f); do
        . $comp_file
    done
fi

# include system specific settings if available
if [ -e ~/.bashrc_custom ]; then
    . ~/.bashrc_custom
fi

#
# PROMPT CONFIG
#

function __prompt_command () {
    local exitcode=$?
    local virtual_env=$(basename ${VIRTUAL_ENV:-""})
    local grey="\[\e[00;90m\]"
    local yellow="\[\e[00;33m\]"
    local blue="\[\e[00;34m\]"
    local lblue="\[\e[00;94m\]"
    local lgrey="\[\e[00;37m\]"
    local lred="\[\e[00;91m\]"
    local reset="\[\e[0m\]"

    local git_ps1=""
    if [ "$(type __git_ps1 2> /dev/null)" ]; then
         local git_ps1=$(__git_ps1 '(%s)')
    fi

    local cexit=$exitcode
    if [ "$exitcode" -ne "0" ]; then
        local cexit="${lred}$exitcode${reset}"
    fi

    PS1="${blue}\h${lgrey}${virtual_env:+" 🚀$virtual_env"}${lblue} \w${reset}${git_ps1:+" $git_ps1"}\n($cexit)\$ "
}

# source git prompt if git is installed
if [ -e /usr/share/git/git-prompt.sh ]; then
    . /usr/share/git/git-prompt.sh
elif [ /usr/lib/git-core/git-sh-prompt ]; then
    . /usr/lib/git-core/git-sh-prompt
fi

PROMPT_COMMAND=__prompt_command


#
# HISTORY CONFIG
#

HISTCONTROL=ignoreboth  # don't log duplicate commands or commands starting with spaces
HISTTIMEFORMAT="%d/%m/%y %T "
HISTSIZE=-1
HISTFILESIZE=-1

export PATH=${HOME}/bin:/usr/local/go/bin:${PATH}
export EDITOR=vim
export KUBE_EDITOR=vim

# add compose key
export XKB_DEFAULT_OPTIONS=compose:ralt

# aliases
alias ls='ls --color=auto'
alias ll="ls -l"

# fix mosh locale warnings
alias mosh="LC_ALL=en_US.UTF-8 mosh"

# use vim if installed
if [ "$(which vim 2> /dev/null)" ]; then
    alias vi=vim
fi

# use nvim if installed
if [ "$(which nvim 2> /dev/null)" ]; then
    alias vi=nvim
    alias vim=nvim
fi

# easy completion search
bind '\C-n:menu-complete'
bind '\C-p:menu-complete-backward'

# Base16 Shell (required for NVM base16 colorschemes
#BASE16_SHELL="$HOME/.config/base16-shell/"
#[ -n "$PS1" ] && \
#    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
#        eval "$("$BASE16_SHELL/profile_helper.sh")"
