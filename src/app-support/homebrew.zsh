# --------------------------------------------------------------
# Homebrew
# --------------------------------------------------------------
# Homebrew binaries (must be early for system tools like python, node, etc.)
export PATH="/opt/homebrew/bin:$PATH"

# Ensure Homebrew environment is set (Apple Silicon)
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Homebrew completions are handled by Oh My Zsh
# Just add the FPATH - Oh My Zsh will call compinit for us
if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi
