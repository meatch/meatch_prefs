#===================================
# 
# .bash_profile
# 
#===================================*/

# --------------------------------------------------------------
# Environment Variables.
# --------------------------------------------------------------
whichSystem="Meatchbook";

# --------------------------------------------------------------
# Start Up
# --------------------------------------------------------------
bash_startup="$HOME/.bash_startup";
test -f $bash_startup && source $bash_startup;

alias php71="php"

# #########################
# PATH MANAGEMENT
# Was duplicting, seems that each new shell triggers this and then adds to it. 
# So on my Mac I added it to ~/.profile which only loads when terminal is first opened.
# This may break CTM work machine? Perhaps add .profile to home folder of work machine?
# #########################
# PATH=$PATH:$HOME/.local/bin:$HOME/bin:/usr/local/sbin
# export PATH
PATH=$HOME/.local/bin:$HOME/.composer/vendor/bin:$HOME/bin:/usr/local/sbin:$PATH

# Deduplicate path variables :: https://unix.stackexchange.com/questions/40749/remove-duplicate-path-entries-with-awk-command/149054#149054
get_var () {
    eval 'printf "%s\n" "${'"$1"'}"'
}
set_var () {
    eval "$1=\"\$2\""
}
dedup_pathvar () {
    pathvar_name="$1"
    pathvar_value="$(get_var "$pathvar_name")"
    deduped_path="$(perl -e 'print join(":",grep { not $seen{$_}++ } split(/:/, $ARGV[0]))' "$pathvar_value")"
    set_var "$pathvar_name" "$deduped_path"
}
dedup_pathvar PATH
dedup_pathvar MANPATH
export PATH

# Is this just my CTM installation?
export NVM_DIR="$HOME/.nvm"
source $(brew --prefix nvm)/nvm.sh
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# --------------------------------------------------------------
# Reloading and Changing ZSH
# --------------------------------------------------------------
alias zshreload="source ~/.zshrc; echo 'reloaded ZSH and Bash'"
alias ch2b="chsh -s /bin/bash"
alias ch2z="chsh -s /bin/zsh"

# --------------------------------------------------------------
# GIT
# --------------------------------------------------------------
alias gst="git status"
alias gbv="git branch -vva"
alias gbvg="git branch -vva | grep -i $1"
alias glo="git log --oneline"
alias glow="git log --oneline --all --graph --decorate"
alias gfp="git fetch -p"
alias gblame="bash ~/git-branches-by-commit-date.sh"
alias gac="git add .; git commit"
alias gamend="git commit --amend --no-edit"

function grhard {
    echo '>>>> Start clean, reset, and checkout'; 
    git clean -df; 
    git reset --hard; 
    git checkout .; 
    echo '<<<< End clean, reset, and checkout';
}

function grebc() {
    git rebase -i HEAD~$1
}

function grib() {
    git rebase -i origin/$1
}

### Yarn
alias yin="yarn install"
alias yang="yarn watch"
alias yinyang="yin && yang"

# --------------------------------------------------------------
# CTM Montrose
# --------------------------------------------------------------
### Misc
function cdlogs { cd "/Users/meatch/MeatchPod/WEBWORKS/Montrose-Loyalty-Docker/logs"; }
function tlogs { cdlogs; tail -f ./*/*log* }

### Docker
function ctmdock    { docker-compose -f "/Users/meatch/MeatchPod/WEBWORKS/Montrose-Loyalty-Docker/docker-compose.yml" up        }
function ctmdockd   { docker-compose -f "/Users/meatch/MeatchPod/WEBWORKS/Montrose-Loyalty-Docker/docker-compose.yml" down      }
function ctmdockdet { docker-compose -f "/Users/meatch/MeatchPod/WEBWORKS/Montrose-Loyalty-Docker/docker-compose.yml" up -d     }
function elasticdock { docker run -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:5.6.3; }

function cdapp {
    cd "/Users/meatch/MeatchPod/WEBWORKS/Montrose-Loyalty-Docker/Sites/$1";
    git fetch -p;
    git status;
}

### LTR
function cdnf   { cdapp "ltr-front-end";                }
function cdnp   { cdapp "ltr-platform";                 }

### Wells
function cdwf   { cdapp "wells-fargo-front-end";        }
function cdwb   { cdapp "wells-fargo-back-end";         }
function cdwp   { cdapp "wf-platform";                  }

### QuickRez
function cdqrf  { cdapp "montrose-agent-front-end";     }
function cdqrb  { cdapp "montrose-agent-back-end";      }
