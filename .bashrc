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

    PS1="${blue}\h${lgrey}${virtual_env:+" $virtual_env"}${lblue} \w${reset}${git_ps1:+" $git_ps1"}\n($cexit)\$ "
}

# source git prompt if git is installed
if [ -e /usr/share/git/git-prompt.sh ]; then
    . /usr/share/git/git-prompt.sh
fi

export PROMPT_COMMAND=__prompt_command
export HISTCONTROL=ignoreboth  # don't log duplicate commands or commands starting with spaces
export HISTSIZE=-1

export PATH=${HOME}/bin:${PATH}
export EDITOR=vim
export KUBE_EDITOR=vim

# add compose key
export XKB_DEFAULT_OPTIONS=compose:ralt

# aliases
alias ls='ls --color=auto'
alias ll="ls -l"

alias gc="git commit"
alias gd="git diff"
alias gds="git diff --staged"
alias gco="git checkout"
alias gg="git grep"
alias gr="git reset"
alias grh="git reset --hard"
alias gs="git status"
alias gwa="git worktree add"
alias gwl="git worktree list"
alias gwr="git worktree remove"
alias vi="vim"
alias gti=git

# nvim if installed
if [ "$(which nvim 2> /dev/null)" ]; then
    alias vim=nvim
fi

# source custom bash completion dir
for comp_file in $(find ~/.bash_completion.d -type f); do
    . $comp_file
done

# include system specific settings if available
if [ -e ~/.bashrc_custom ]; then
    . ~/.bashrc_custom
fi

# easy completion search
bind '\C-n:menu-complete'
bind '\C-p:menu-complete-backward'

# Base16 Shell (required for NVM base16 colorschemes
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"
