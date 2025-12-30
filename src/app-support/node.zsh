#===================================
#
# Node
#
#===================================*/

# --------------------------------------------------------------
# NVM Support - Lazy Loading for faster shell startup
# NVM will auto-load the first time you use: node, npm, npx, or nvm
# --------------------------------------------------------------
# tells NVM where its installation directory is located.
export NVM_DIR="$HOME/.nvm"

# --------------------------------------------------------------
# NVM Support - Lazy Loading for faster shell startup
# NVM will auto-load the first time you use: node, npm, npx, or nvm
# --------------------------------------------------------------
nvm() {
    unset -f nvm node npm npx
    if command -v brew >/dev/null 2>&1; then
        NVM_SH="$(brew --prefix nvm 2>/dev/null)/nvm.sh"
        [ -s "$NVM_SH" ] && . "$NVM_SH"
    fi
    nvm "$@"
}

node() {
    unset -f nvm node npm npx
    if command -v brew >/dev/null 2>&1; then
        NVM_SH="$(brew --prefix nvm 2>/dev/null)/nvm.sh"
        [ -s "$NVM_SH" ] && . "$NVM_SH"
    fi
    node "$@"
}

npm() {
    unset -f nvm node npm npx
    if command -v brew >/dev/null 2>&1; then
        NVM_SH="$(brew --prefix nvm 2>/dev/null)/nvm.sh"
        [ -s "$NVM_SH" ] && . "$NVM_SH"
    fi
    npm "$@"
}

npx() {
    unset -f nvm node npm npx
    if command -v brew >/dev/null 2>&1; then
        NVM_SH="$(brew --prefix nvm 2>/dev/null)/nvm.sh"
        [ -s "$NVM_SH" ] && . "$NVM_SH"
    fi
    npx "$@"
}