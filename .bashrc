#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# GitResetUpstreamMaster
# Resets the local master branch to "upstream/master"
grum () {
    git status >/dev/null # Make sure we are in a git repo
    if [ "$?" -eq "128" ]; then
        return
    fi

    if [ "$(git symbolic-ref --short HEAD)" = "master" ]; then
         git fetch upstream && git checkout -B master upstream/master --no-track
    else
         git fetch upstream master:master
    fi
}

# Prompt
function __prompt_command () {
    local exitcode=$?
    local virtual_env=$(basename ${VIRTUAL_ENV:-""})
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

    PS1="${blue}\h${lgrey}${virtual_env:+" $virtual_env"}${lblue} \w${reset}${git_ps1:+" $git_ps1"}\n($cexit)\$ "
}

# source git prompt if git is installed
if [ -e /usr/share/git/git-prompt.sh ]; then
    . /usr/share/git/git-prompt.sh
fi

export PROMPT_COMMAND=__prompt_command
# don't log duplicate commands or commands starting with spaces
export HISTCONTROL=ignoreboth
export HISTSIZE=50000
export PATH=${HOME}/bin:${PATH}
export EDITOR=vi

# add compose key
export XKB_DEFAULT_OPTIONS=compose:ralt

# aliases
alias ls='ls --color=auto'
alias ll="ls -l"
alias gg="git grep"
alias gs="git status"
alias vi=vim
if [ "$(which nvim 2> /dev/null)" ]; then
    alias vim=nvim
fi

# include system specific settings if available
if [ -e ~/.bashrc_custom ]; then
    . ~/.bashrc_custom
fi
