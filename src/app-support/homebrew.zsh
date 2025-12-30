# --------------------------------------------------------------
# Homebrew
# --------------------------------------------------------------
# Homebrew binaries (must be early for system tools like python, node, etc.)
export PATH="/opt/homebrew/bin:$PATH"

# Ensure Homebrew environment is set (Apple Silicon)
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Homebrew Shell Completion :: https://docs.brew.sh/Shell-Completion
if type brew &>/dev/null
then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    autoload -Uz compinit
    compinit
fi
