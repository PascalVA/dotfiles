#
# ~/.bashrc
#

#
# CONFIG
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# real script path and parent directory name
THIS_REAL_FILE=$(readlink -e ${BASH_SOURCE[0]})
THIS_REAL_DIR=$(dirname ${THIS_REAL_FILE})

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

#
# INCLUDE SOURCE FILES
#

# source local bashrc files
if [ -d  "${HOME}/.bashrc.d/" ]; then
    for bash_source in $(find -L ${HOME}/.bashrc.d/ -type f); do
        source ${bash_source}
    done
fi

# source program specific source files from dotfiles
if [ -d  "${THIS_REAL_DIR}/.bashrc.d/" ]; then
    for bash_source in $(find -L ${THIS_REAL_DIR}/.bashrc.d/ -type f); do
        source ${bash_source}
    done
fi

# source asdf configurations
if [ -d "${HOME}/.asdf" ]; then
    source ${HOME}/.asdf/asdf.sh
    source ${HOME}/.asdf/completions/asdf.bash
fi

# source bash_completion
if [ -e /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
fi

# source custom bash completion dir
if [ -d ~/.bash_completion.d ]; then
    for comp_file in $(find -L ~/.bash_completion.d -type f); do
        . $comp_file
    done
fi

# source command completions
if [ "$(which kind 2> /dev/null)" ]; then
    source <(kind completion bash)
fi

if [ "$(which kubectl 2> /dev/null)" ]; then
    source <(kubectl completion bash)
fi


#
# HELPER FUNCTIONS
#

#
# PROMPT
#

# displays kubernetes cluster and namespace if a kubectl context is find
function __kube_ps1 () {
    kubectl config view --minify > /dev/null 2> /dev/null
    if [ "$?" == "0" ]; then
        _kube_ps1_cluster=$(kubectl config view --minify --output 'jsonpath={.contexts[].context.cluster}')
        _kube_ps1_namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}')
        _kube_ps1_namespace=${_kube_ps1_namespace:-default}

        echo " 🔧 [$_kube_ps1_cluster:$_kube_ps1_namespace]"
    fi
}

# prints python virtual_env infromation if defined
function __venv_ps1 () {
    echo ${virtual_env:+" 🚀 $virtual_env"}
}

# prints the current and parent directory of the pwd
function __pwd_ps1 () {
    echo " [${PWD#"${PWD%/*/*}/"}]"
}

# setup dynamic prompt command
function __prompt_command () {
    local exitcode=$?
    local virtual_env=$(basename ${VIRTUAL_ENV:-""})
    local black="\[\e[00;90m\]"
    local lgrey="\[\e[00;37m\]"
    local lred="\[\e[00;31m\]"
    local red="\[\e[00;91m\]"
    local lgreen="\[\e[00;32m\]"
    local green="\[\e[00;92m\]"
    local lyellow="\[\e[00;33m\]"
    local yellow="\[\e[00;93m\]"
    local lblue="\[\e[00;34m\]"
    local blue="\[\e[00;94m\]"
    local lpurple="\[\e[00;35m\]"
    local purple="\[\e[00;95m\]"
    local lcyan="\[\e[00;36m\]"
    local cyan="\[\e[00;96m\]"
    local reset="\[\e[0m\]"

    local git_ps1=""
    if [ "$(type __git_ps1 2> /dev/null)" ]; then
         local git_ps1=$(__git_ps1 '(%s)')
    fi

    local cexit=$exitcode
    if [ "$exitcode" -ne "0" ]; then
        local cexit="${lred}$exitcode${reset}"
    fi

    if [ -n "$PS1_HOST_COLOR" ]; then
        PS1_HOST_COLOR_EXPANDED=${!PS1_HOST_COLOR}
    fi

    PS1="${PS1_HOST_COLOR_EXPANDED:-}\h${reset}$(__kube_ps1)$(__venv_ps1)${lblue}$(__pwd_ps1)${reset}${git_ps1:+" $git_ps1"}\n($cexit)\$ "
}

# source git prompt if git is installed
if [ -e /usr/share/git/git-prompt.sh ]; then
    . /usr/share/git/git-prompt.sh
elif [ /usr/lib/git-core/git-sh-prompt ]; then
    . /usr/lib/git-core/git-sh-prompt
fi

PROMPT_COMMAND=__prompt_command


#
# SHELL CONFIG
#

HISTCONTROL=ignoreboth  # don't log duplicate commands or commands starting with spaces
HISTTIMEFORMAT="%d/%m/%y %T "
HISTSIZE=-1
HISTFILESIZE=-1

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command, if necessary,
# update the values of LINES and COLUMNS
shopt -s checkwinsize

#
# ENVIRONMENT SETUP
#

export EDITOR=vi
export KUBE_EDITOR=vi

# no cows in my shell
export ANSIBLE_NOCOWS=1

# configure fzf fuzzy finder
export FZF_DEFAULT_OPTS="--layout=reverse"

# add compose key
export XKB_DEFAULT_OPTIONS=compose:ralt

#
# ALIASES
#
alias ls='LC_COLLATE=C ls --color -h --group-directories-first --sort=extension'
alias la='ls -a'
alias ll='ls -alF'
alias l='ls -CF'
alias ac='ansible-console'
alias av='ansible-vault'
alias ap='ansible-playbook'

alias docuserver='docker run -ti --rm -v $(pwd)/:/usr/src/app/ --workdir /usr/src/app/ --network host --entrypoint bash node -c "npm install; npm run start"'

# source kubectl command aliases
if [ -f "${HOME}/github/ahmetb/kubectl-aliases/.kubectl_aliases" ]; then
    source ${HOME}/github/ahmetb/kubectl-aliases/.kubectl_aliases
fi

# dockerized apps
if [ "$(which az 2>&1 > /dev/null; echo $?)" -ne "0" ]; then
    alias az='docker run --rm -ti --log-driver=none --user $UID --workdir=/workdir -v $(pwd):/workdir -v ~/.azure:/.azure mcr.microsoft.com/azure-cli az'
fi

# fix mosh locale warnings for mosh
alias mosh="LC_ALL=en_US.UTF-8 mosh"

# allow alias expansion with watch command
alias watch='watch '

# use vim if installed
if [ "$(which vim 2> /dev/null)" ]; then
    alias vi=vim
fi

# use nvim if installed
if [ "$(which nvim 2> /dev/null)" ]; then
    alias vi=nvim
    alias vim=nvim
fi

# allow for alias expansion with watch
alias watch='watch '

alias argocd='argocd --grpc-web'

# kubernetes context switcher
source <($HOME/bin/switcher init bash)
alias s=switch
complete -o default -F _switcher s

# source alias completions
if [ -f "${HOME}/github/cykerway/complete-alias/complete_alias" ]; then
    source ${HOME}/github/cykerway/complete-alias/complete_alias
fi
