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
for bash_source in $(find ${THIS_REAL_DIR}/.bashrc.d/ -type f); do
    source ${bash_source}
done

if [ -d  "${HOME}/.bashrc.d/" ]; then
    for bash_source in $(find ${HOME}/.bashrc.d/ -type f); do
        source ${bash_source}
    done
fi

# source bash_completion
if [ -e /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
fi

# source custom bash completion dir
if [ -d ~/.bash_completion.d ]; then
    for comp_file in $(find ~/.bash_completion.d -type f); do
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

    PS1="${PS1_HOST_COLOR:-}\h${reset}$(__kube_ps1)$(__venv_ps1)${lblue}$(__pwd_ps1)${reset}${git_ps1:+" $git_ps1"}\n($cexit)\$ "
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

# append to the history file, don't overwrite it
shopt -s histappend

#
# ENVIRONMENT SETUP
#

export TERM=alacritty
export EDITOR=vim
export KUBE_EDITOR=vim

# no cows in my shell
export ANSIBLE_NOCOWS=1

# configure fzf fuzzy finder
export FZF_DEFAULT_OPTS="--layout=reverse"

# add compose key
export XKB_DEFAULT_OPTIONS=compose:ralt

#
# ALIASES
#
alias ls='ls --color=auto'
alias ll="ls -l"
alias master='cd ~/gitlab/p.vanacker/sys-infrastructure && source .venvs/master.sh'
alias av='ansible-vault'
alias ap='ansible-playbook'
alias apc='ansible-playbook cluster_deployment.yml'
alias apd='ansible-playbook domain_deployment.yml'
alias kn='kubens'

# source kubectl command aliases
source ~/github/ahmetb/kubectl-aliases/.kubectl_aliases

# dockerized apps
alias az='docker run --rm -ti --log-driver=none --user $UID --workdir=/workdir -v $(pwd):/workdir -v ~/.azure:/.azure mcr.microsoft.com/azure-cli az'

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

# source alias completions
source ~/github/cykerway/complete-alias/complete_alias
