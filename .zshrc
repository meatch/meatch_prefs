# Enable or disable startup time logging
ENABLE_STARTUP_LOGGING=true
HIST_STAMPS="%Y.%m.%d.%H:%M"

# Record the start time
if [ "$ENABLE_STARTUP_LOGGING" = true ]; then
    ZSH_START_TIME=$(date +%s%N)
fi

# VS Code code command
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin:/opt/homebrew/bin"

# --------------------------------------------------------------
# PATH Management (Consolidated)
# --------------------------------------------------------------
export PATH="/opt/homebrew/bin:/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$HOME/.local/bin:$HOME/Library/Python/3.9/bin:$PATH"

# Ensure Homebrew environment is set (Apple Silicon)
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# --------------------------------------------------------------
# Homebrew Shell Completion :: https://docs.brew.sh/Shell-Completion
# --------------------------------------------------------------
if type brew &>/dev/null
then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    autoload -Uz compinit
    compinit
fi

# --------------------------------------------------------------
# NVM Support
# --------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
if command -v brew >/dev/null 2>&1; then
    NVM_SH="$(brew --prefix nvm 2>/dev/null)/nvm.sh"
    [ -s "$NVM_SH" ] && . "$NVM_SH"
fi

# --------------------------------------------------------------
# TNP: Node v20 :: This apparently is needed for Storybook to work in Node v20
# Already added to package.json for the storybook commands, so this should no longer be necessary.
# --------------------------------------------------------------
# export NODE_OPTIONS=--openssl-legacy-provider

# --------------------------------------------------------------
# Python Initialization
# --------------------------------------------------------------
# Native installed Python homebrew
# export PATH=/opt/homebrew/opt/python@3.11/libexec/bin:$PATH
# Using pyenv to allow us to switch between versions - this initializes it
if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init - zsh)"
fi

# When python 2 is called, we actually want to call installed version of python
alias python2="python"

# --------------------------------------------------------------
# bash Scripts :: Custom Methods and Aliases
# --------------------------------------------------------------
source "$HOME/meatch_prefs/.bash_scripts"

# --------------------------------------------------------------
# Startup Time Logging
# --------------------------------------------------------------
if [ "$ENABLE_STARTUP_LOGGING" = true ]; then
    ZSH_END_TIME=$(date +%s%N)
    ZSH_STARTUP_DURATION=$(( (ZSH_END_TIME - ZSH_START_TIME) / 1000000 )) # Convert nanoseconds to milliseconds
    echo "[Startup Time]: $((ZSH_STARTUP_DURATION / 1000)).$((ZSH_STARTUP_DURATION % 1000)) seconds"
fi

# --------------------------------------------------------------
# Oh My Zsh Configuration
# --------------------------------------------------------------
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git docker docker-compose node npm vscode fzf z history-substring-search zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# source /Users/meatch/.docker/init-zsh.sh || true # Added by Docker Desktop


# --------------------------------------------------------------
# NVMRC: This little ditty will run nvm use and change to Node Version of choice
# assuming there is an .nvmrc file in root of project that speifies node version (e.g v20)
# --------------------------------------------------------------
if command -v nvm >/dev/null 2>&1; then
autoload -U add-zsh-hook
load-nvmrc() {
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
        local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

        if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
        elif [ "$nvmrc_node_version" != "$node_version" ]; then
        nvm use
        fi
    elif [ "$node_version" != "$(nvm version default)" ]; then
        echo "Reverting to nvm default version"
        nvm use default
    fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
fi

# --------------------------------------------------------------
# Python Path
# --------------------------------------------------------------
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/Library/Python/3.9/bin:$PATH"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# --------------------------------------------------------------
# Zsh PLugins
# --------------------------------------------------------------
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
