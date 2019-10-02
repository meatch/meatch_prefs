# #########################
# #########################
# .bash_profile
# #########################
# #########################


# #########################
# Environment Variables.
# @TODO confirm -  bash_startup lets me change environment, defauls to Meatchbook. See CTM Dev
# #########################
whichSystem="Meatchbook";
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
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

### General
alias zshreload="source ~/.zshrc; echo 'reloaded ZSH and Bash'"
alias ch2b="chsh -s /bin/bash"
alias ch2z="chsh -s /bin/zsh"

# #########################
# Meatchbook Specific
# #########################
if [ $whichSystem = "Meatchbook" ]; then
    alias subl="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl";
    alias phpunit="vendor/bin/phpunit"

    function lama { cd "/Users/meatch/MeatchPod/_CLIENTS/LAMA/lamodern.com-responsive2017";     git status; }
    function ensp { cd "/Users/meatch/MeatchPod/_PERSONAL/Enspyred/enspyred.com";               git status; }

    function rhcdep {
        echo '<<<< Start RHC Deploy to dev.enspyred.com'; 
        echo '<<<< Start rsync'; 
        rsync -azP  --no-perms --no-owner --no-group "/Users/meatch/MeatchPod/WEBWORKS/DOCKER-NGINX/Sites/local.configurator.robinsonheli.com" --exclude '.env' --exclude 'storage' --exclude '.git' --exclude 'node_modules' --exclude 'package.json' --exclude 'package-lock.json' "meatch@104.248.71.31:/var/www/dev.enspyred.com/current/";
        echo '<<<< Start permissions'; 
        ssh meatch@enspyred.com chmod -R 777 "/var/www/dev.enspyred.com/current/public/img";
        echo '<<<< Start npm run production'; 
        ssh meatch@enspyred.com npm run --prefix "/var/www/dev.enspyred.com/current" production;
        echo '<<<< END RHC Deploy to dev.enspyred.com';
    }
fi


# #########################
# CTM/Montrose
# #########################
if [ $whichSystem = "CTM" ]; then
    ### Misc
    function cdlogs { cd "/home/meatch/Project/logs"; }
    function tlogs { cdlogs; tail -f ./*/*log* }
    function navicat { "/home/meatch/Apps/navicat120_mysql_en_x64/start_navicat"; }
    
    ### Docker
    # elasticdock. does not care what dir you are in.
    function elasticdock { docker run -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:5.4.1; }
    # function ctmdock { cd "/home/meatch/Project/"; docker-compose up --build; } DID NOT WORK
    function ctmdock { cd "/home/meatch/Project/"; docker-compose up; }

    ### LTR
    function cdnf   { cd "/home/meatch/Project/Sites/ltr-front-end";           git status; }
    function cdnp   { cd "/home/meatch/Project/Sites/ltr-platform";            git status; }

    function swphp5   { 
        echo '<<<< Start Change Navigator to PHP 5.6';                           
        "~/Project/tools/switch-php ltr-platform.conf --php56";  
        "~/Project/tools/switch-php ltr-front-end.conf --php56";                             
        echo '<<<< Fin Change Navigator to PHP 5.6';                           
    }
    function swphp7   { 
        echo '<<<< Start Change Navigator to PHP 7.1';                           
        "~/Project/tools/switch-php ltr-platform.conf --php71";  
        "~/Project/tools/switch-php ltr-front-end.conf --php71";  
        echo '<<<< Fin Change Navigator to PHP 7.1';                           
        echo '<<<< Start Generate Navigator Key';                           
        cdnf;
        "php artisan key:generate";
        echo '<<<< End Generate Navigator Key';                           
    }

    ### Wells
    function cdwf   { cd "/home/meatch/Project/Sites/wells-fargo-front-end";   git status; }
    function cdwb   { cd "/home/meatch/Project/Sites/wells-fargo-back-end";    git status; }
    function cdwp   { cd "/home/meatch/Project/Sites/wf-platform";             git status; }

    ### PNC
    function cdpnf   { cd "/home/meatch/Project/Sites/pncpoints-front-end";    git status; }
    function cdpnb   { cd "/home/meatch/Project/Sites/pncpoints-back-end";     git status; }

    ### LTR Legacy
    function cdlegf   { cd "/home/meatch/Project/Sites/loyalty-front-end";    git status; }
    function cdlegb   { cd "/home/meatch/Project/Sites/loyalty-back-end";     git status; }

    ### QuickRez
    function cdqrf   { cd "/home/meatch/Project/Sites/montrose-agent-front-end";    git status; }
    function cdqrb   { cd "/home/meatch/Project/Sites/montrose-agent-back-end";     git status; }
fi

# #########################
# Git Commands
# #########################
alias gst="git status"
alias gbv="git branch -vva"
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

### Yarn
alias yin="yarn install"
alias yang="yarn watch"
alias yinyang="yin && yang"