# Import vars
source ~/.zshrc_vars

# yarn globals
PATH=$PATH:~/.yarn/bin

# nvm
source ~/dev/lukechilds/zsh-nvm/zsh-nvm.plugin.zsh

# zsh nvm auto-switching by Alejandro AR
# kinduff.com/2016/09/14/automatic-version-switch-for-nvm
# autoload -U add-zsh-hook
# load-nvmrc() {
#   if [[ -f .nvmrc && -r .nvmrc ]]; then
#     nvm use
#   elif [[ $(nvm version) != $(nvm version default)  ]]; then
#     echo "Reverting to nvm default version"
#     nvm use default
#   fi
# }
# add-zsh-hook chpwd load-nvmrc
# load-nvmrc


# Fish-like autocomplete for zsh!
source ~/dev/zsh-user/zsh-autosuggestions/zsh-autosuggestions.zsh

# env vars
export LESS="-F -g -i -M -R -S -w -X -z-4"
export RSCLI_GITHUB_KEY=$RSCLI_GITHUB_KEY

# Source Prezto. (Sorin Ionescu - sorin.ionescu@gmail.com)
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi


# Jump to Project Directory - takes proj. parent and proj. name
function start() {
  if [[ -n "$1" && -n "$2" ]]; then
      print "${1}: ${2}"
      cd ~/dev/${1}/${2} || print "Error: Project Not Found";
      if [[ -d ${2} ]]; then
        cd ${2}
      fi
      if [[ -n "$3" ]]; then
        cd ${3};
        nvm use;
        setProfile Agnosterish-Brown;
        yarn start;
      elif [[ -d ".git" ]]; then
        clear
        git branch
        git status
      fi
  else
    print "Parent dir and project dir required. 💫 T.M.Y.K."
  fi
}


# iterm2 Profile Swap
function setProfile() {
  echo "\033]50;SetProfile=${1}\a";
}


# ssh + profile swapping
# 'MigrationBox' is an availablbe, but currently unused color profile
function sshc() {
  if [[ "$1" == "test" ]] || [[ "$1" == "dev" ]]; then
    setProfile TestBox;
    if [[ "$1" == "test" ]] then
      echo "Some people like to call this 'Dev'? 🥔 🍅"
    fi
    echo "Connecting to Dev at ${IP_TEST_BOX} ..."
    ssh $USER_TEST_BOX@$IP_TEST_BOX
  elif [[ "$1" == "prod" ]]; then
    setProfile ProdBox;
    echo "Connecting to Prod at ${IP_PROD_BOX} ..."
    ssh $USER_PROD_BOX@$IP_PROD_BOX;
  elif [[ "$1" == "payments" ]]; then
    setProfile Payments;
    echo "Connecting to Payments at ${IP_PAYMENTS} ..."
    ssh $USER_PAYMENTS@$IP_PAYMENTS
  elif [[ "$1" == "ofs" ]]; then
    setProfile ProdBox;
    echo "Connecting to OFS at ${IP_OFS} ..."
    ssh $USER_OFS@$IP_OFS;
  elif [[ "$1" == "demo" ]]; then
    setProfile DemoBox;
    echo "Connecting to Demo at ${IP_DEMO_BOX} ..."
    ssh $USER_DEMO_BOX@$IP_DEMO_BOX;
  elif [[ "$1" == "fyn" ]]; then
    setProfile FynProdBox;
    echo "Connecting to Fyn Prod at ${IP_FYN_PROD} with user '${USER_FYN_PROD}'..."
    ssh $USER_FYN_PROD@$IP_FYN_PROD;
  elif [[ -n "$1" ]]; then
    echo "I don't know about that server. ¯\_(ツ)_/¯";
    echo "Did you mean 'test', 'prod', 'payments', 'demo', 'other', or 'ofs'?";
  else
    echo "Gonna need a server name, Bro. 😎";
    echo "Did you mean 'test', 'prod', 'payments', 'demo', 'other', or 'ofs'?";
  fi
}


# TODO: Write subl search open func for  subl $(rg -l SomeSearchQuery ./some_dir)


# Vagrant Connect: vbox [which vagrant] ['clean' - restarts vagrant first])
function vbox() {
  if [[ "$1" == "bafs" ]]; then
    print "Connecting to 'bafs' vagrant box ..."
    cd ~/dev/bafsllc/clearwater;
    if [[ "$2" == "clean" ]]; then
      vagrant halt
    fi
    vagrant up; vagrant ssh
  elif [[ -n "$1" ]]; then
    echo "I don't know about that vagrant machine. ¯\_(ツ)_/¯";
  else
    print "Which box? Probably, 'bafs', right? 🏢🏦"
  fi
}

# Git
alias bs='clear; git branch; git status'
alias bstat='clear; git branch; git status; echo "\n  *bs* is shorter and does the same thing. Just sayin. 👀 \n"' 
alias wip='git add . && git commit -m "WIP [skip ci]"'
alias update='wip && git pull --rebase origin master && git reset HEAD~'

# Misc Shortcuts
alias cls='clear; ls -A';
alias cra='create-react-app'
alias cwd='cd ~/dev/bafsllc/clearwater'
alias cwdir='cd ~/dev/bafsllc/clearwater; echo "\n  *cwd* 👀  \n"' 
alias env3='source .venv3/bin/activate'
alias env2='source .venv2/bin/activate'

# Terminal Settings
alias glare='setProfile Agnosterish-LowGlare'
alias noglare='setProfile Agnosterish'
alias brown='setProfile Agnosterish-Brown'
alias greenay='setProfile Agnosterish-Greenay'

# sql
alias printsql='echo mysql -h 192.168.50.4 -u root -P 3306 -p'
alias repl='greenay; cwd && env3 && ipython'
alias sqllogin='mysql -h 192.168.50.4 -u root -P 3306 -p'
alias sqlstart='echo mysql.server start'
alias sqlstop='echo mysql.server stop'

# linting / ci
alias bf='black -t py38 -l 100'


function cwmycli () {
  setProfile Agnosterish-Greenay;
  echo Connecting to local mysql db...
  mycli -h 192.168.50.4 -u root
}


# Lock the screen (when going AFK) <- Negative impact on wake w/ external display
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"


# Open new Terminal tabs from the command line
# Original Author: Justin Hileman @bobthecow
# Adapted by: Jack Coy @Jackman3005
[ `uname -s` != "Darwin" ] && return
function tab () {
    local cdto="$PWD"
    local args="$@"

    if [ -d "$1" ]; then
        cdto=`cd "$1"; pwd`
        args="${@:2}"
    fi

    osascript -i <<EOF
        tell application "iTerm2"
                tell current window
                        create tab with default profile
                        tell the current session
                                write text "cd \"$cdto\" && $args"
                        end tell
                end tell
        end tell
EOF
}


# TODO: Should do nothing if not given at least some seconds
function timer() {
   if [[ "$2" == "min" ]]; then
     let START_COUNT="$1*60"
     let SECONDS_REMAINING="$1*60"
     if [[ -n "$3" ]]; then
      let SECONDS_REMAINING=SECONDS_REMAINING+$3
     fi
   else
     START_COUNT=$1
     SECONDS_REMAINING=$1
  fi
   while [  $SECONDS_REMAINING -gt 0 ]; do
       if [[ SECONDS_REMAINING -eq START_COUNT ]]; then
         printf "\n ⏲️   $SECONDS_REMAINING"
       else
        printf -- "-$SECONDS_REMAINING"
       fi
       sleep 1
       let SECONDS_REMAINING=SECONDS_REMAINING-1 
   done
   printf "\n 🏁 Fin. 🏁 \n"
   echo -en "\07"; sleep 0.333; echo -en "\07"; sleep 0.333; echo -en "\07"
   echo -en "\07"; sleep 0.333; echo -en "\07"; sleep 0.333; echo -en "\07"
}


function work() {
  tab "$1; vbox bafs"
  tab "$1; start bafs clearwater commotion"
  tab "$1; start bafs clearwater"
}


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform
