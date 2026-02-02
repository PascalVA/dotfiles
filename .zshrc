# ============================================================================
# ZSH Configuration File
# ============================================================================

# ----------------------------------------------------------------------------
# History Configuration
# ----------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=100000000
SAVEHIST=100000000

autoload history-beginning-search-forward
autoload history-beginning-search-backward

# History options
setopt HIST_IGNORE_ALL_DUPS    # Don't record duplicate entries
setopt HIST_FIND_NO_DUPS       # Don't display duplicates when searching
setopt HIST_IGNORE_SPACE       # Don't record commands starting with space
setopt HIST_SAVE_NO_DUPS       # Don't write duplicate entries to history file
setopt SHARE_HISTORY           # Share history between all sessions
setopt APPEND_HISTORY          # Append to history file, don't overwrite
setopt INC_APPEND_HISTORY      # Write to history file immediately
setopt EXTENDED_HISTORY        # Write timestamp to history file

# ----------------------------------------------------------------------------
# Directory Navigation
# ----------------------------------------------------------------------------
setopt AUTO_CD                 # Auto change to a directory without typing cd
setopt AUTO_PUSHD              # Push directories onto the directory stack
setopt PUSHD_IGNORE_DUPS       # Don't push duplicate directories
setopt PUSHD_SILENT            # Don't print directory stack after pushd/popd

# ----------------------------------------------------------------------------
# Completion System
# ----------------------------------------------------------------------------
autoload -Uz compinit
compinit

# Completion options
setopt COMPLETE_IN_WORD        # Complete from both ends of a word
setopt ALWAYS_TO_END           # Move cursor to end of word after completion
setopt AUTO_MENU               # Show completion menu on successive tab press
setopt AUTO_LIST               # Automatically list choices on ambiguous completion
setopt MENU_COMPLETE           # Insert first match immediately

# Completion styling
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Enable colors in completion
if command -v dircolors &> /dev/null; then
    eval "$(dircolors -b)"
    zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
fi

# ----------------------------------------------------------------------------
# Key Bindings
# ----------------------------------------------------------------------------
# Use emacs keybindings
bindkey -e

# Additional useful keybindings
bindkey '^[[A' history-beginning-search-backward  # Up arrow
bindkey '^[[B' history-beginning-search-forward   # Down arrow
bindkey '^[[H' beginning-of-line                  # Home
bindkey '^[[F' end-of-line                        # End
bindkey '^[[3~' delete-char                       # Delete

# ----------------------------------------------------------------------------
# Aliases
# ----------------------------------------------------------------------------
# ls aliases
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -lAh'
alias l='ls -CF'

# Safety aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Grep with color
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Disk usage
alias du='du -h'
alias df='df -h'

# Process management
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'

# Network
alias ports='netstat -tulanp'

# Git shortcuts (if git is installed)
if command -v git &> /dev/null; then
    alias gs='git status'
    alias ga='git add'
    alias gc='git commit'
    alias gp='git push'
    alias gl='git log --oneline --graph --decorate'
    alias gd='git diff'
    alias gg=' git grep'
fi

# ----------------------------------------------------------------------------
# Environment Variables
# ----------------------------------------------------------------------------
# Set default editor
export EDITOR='nvim'
export VISUAL='nvim'

# Set language
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Less options
export LESS='-R -M -i'

export FZF_DEFAULT_OPTS="--layout=reverse"
export XKB_DEFAULT_OPTIONS=compose:ralt


# ----------------------------------------------------------------------------
# PATH Configuration
# ----------------------------------------------------------------------------
# Add local bin to PATH if it exists
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
[[ -d "$HOME/bin" ]] && export PATH="$HOME/bin:$PATH"

# ----------------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------------
# Create a directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Find and cd to a directory
fcd() {
    local dir
    dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

# kubernetes cluster and namespace in prompt
kube_prompt() {
  kubectl config view --minify >/dev/null 2>/dev/null
  if [ "$?" -eq "0" ]; then
    _kube_ps1_cluster=$(kubectl config view --minify --output 'jsonpath={.contexts[].context.cluster}')
    _kube_ps1_namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}')
    _kube_ps1_namespace=${_kube_ps1_namespace:-default}

    echo "📡 $_kube_ps1_cluster:$_kube_ps1_namespace "
  fi
}

# ----------------------------------------------------------------------------
# Miscellaneous Options
# ----------------------------------------------------------------------------
setopt INTERACTIVE_COMMENTS    # Allow comments in interactive shell
setopt EXTENDED_GLOB           # Use extended globbing syntax
setopt NO_BEEP                 # Don't beep on errors
setopt CORRECT                 # Suggest corrections for commands
setopt NUMERIC_GLOB_SORT       # Sort filenames numerically when it makes sense

# ----------------------------------------------------------------------------
# Custom Configurations
# ----------------------------------------------------------------------------
# Source local configuration if it exists
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Load asdf version manager if installed
[[ -f ~/.asdf/asdf.sh ]] && source ~/.asdf/asdf.sh

# Load nvm if installed
[[ -s "$HOME/.nvm/nvm.sh" ]] && source "$HOME/.nvm/nvm.sh"

# Load .zshrc.local if it exists
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Load kubernetes context switcher if installed
SWITCHER_EXECUTABLE=$(which switcher 2>/dev/null)
if [ "$SWITCHER_EXECUTABLE" ]; then
  source <($SWITCHER_EXECUTABLE init zsh)
fi

# Source kubectl command aliases
if [ -f "${HOME}/github.com/ahmetb/kubectl-aliases/.kubectl_aliases" ]; then
  source "${HOME}/github.com/ahmetb/kubectl-aliases/.kubectl_aliases"
fi

# Load kubectl completions
KUBECTL_EXECUTABLE=$(which kubectl 2>/dev/null)
if [ "$KUBECTL_EXECUTABLE" ]; then
  source <($KUBECTL_EXECUTABLE completion zsh)
fi

# zsh magic to get currently executing script name, see `man zshexpn` and `man zshmisc` for details
# (%):-   will execute prompt expansion on the following word (in this case %x)
# %x      will be subsituted by the name of the currently executing script (not following symlinks)
SCRIPT_SOURCE=${(%):-%x}

# get the real directory of the script to source .zshrc.d dotfiles
SCRIPT_SOURCE_REAL_DIR=$(dirname $(realpath $SCRIPT_SOURCE))

# source program specific source files from dotfiles
if [ -d "${SCRIPT_SOURCE_REAL_DIR}/.zshrc.d/" ]; then
  for zsh_source in $(find -L ${SCRIPT_SOURCE_REAL_DIR}/.zshrc.d/ -type f); do
    source ${zsh_source}
  done
fi

