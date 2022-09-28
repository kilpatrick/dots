# Import vars
source ~/.zshrc_vars

# yarn globals
PATH=$PATH:~/.yarn/bin

# ipython
PATH=$PATH:/Users/kilpatrick/Library/Python/3.8/bin

# nvm
source ~/dev/lukechilds/zsh-nvm/zsh-nvm.plugin.zsh

# zsh nvm auto-switching by Alejandro AR
# kinduff.com/2016/09/14/automatic-version-switch-for-nvm
#
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


# zsh nvm auto-switching by github.com/nvm-sh/nvm
#
# autoload -U add-zsh-hook
# load-nvmrc() {
#   local node_version="$(nvm version)"
#   local nvmrc_path="$(nvm_find_nvmrc)"
#
#   if [ -n "$nvmrc_path" ]; then
#     local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
#
#     if [ "$nvmrc_node_version" = "N/A" ]; then
#       nvm install
#     elif [ "$nvmrc_node_version" != "$node_version" ]; then
#       nvm use
#     fi
#   elif [ "$node_version" != "$(nvm version default)" ]; then
#     echo "Reverting to nvm default version"
#     nvm use default
#   fi
# }
# add-zsh-hook chpwd load-nvmrc
# load-nvmrc


# Fish-like autocomplete for zsh!
source ~/dev/zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh

# env vars
export LESS="-F -g -i -M -R -S -w -X -z-4"
export GITHUB_PACKAGES_READ_PAT=$GITHUB_PACKAGES_READ_PAT
export RSCLI_GITHUB_KEY=$RSCLI_GITHUB_KEY
export GITHUB_PAT=$GITHUB_PAT
  
# Source Prezto. (Sorin Ionescu - sorin.ionescu@gmail.com)
echo "looking here: "
echo "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
echo "   "
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
        setProfile webpack_dev_server;
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


function pingRange() {
  base="172.20.10."
  let ENDING="1"
  while [  $ENDING -lt 31 ]; do
     ping ${base}${ENDING}
     sleep 1
     let ENDING=ENDING+1 
  done
}

function oupi() {
    echo "Everything:"
    arp -na
    echo ""
    echo "Just the Pi ma'am:"
    arp -na | grep -i "E4.5F"
}

# iterm2 Profile Swap
function setProfile() {
  echo "\033]50;SetProfile=${1}\a";
}


# ssh + profile swapping
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
  elif [[ "$1" == "cloud-prod" ]]; then
    setProfile CloudProd;
    echo "Connecting to Cloud Prod at ${IP_CLOUD_PROD} ..."
    ssh $USER_CLOUD_PROD@$IP_CLOUD_PROD;
  elif [[ "$1" == "cloud-test" ]]; then
    setProfile CloudTest;
    echo "Connecting to Cloud Test at ${IP_CLOUD_TEST} ..."
    ssh $USER_CLOUD_TEST@$IP_CLOUD_TEST;
  elif [[ "$1" == "sam" ]]; then
    setProfile sam;
    echo "Connecting to S.A.M. at ${IP_SAM} ..."
    ssh $USER_SAM@$IP_SAM;
  elif [[ "$1" == "v" ]]; then
    setProfile vagrant;
    cd ~/dev/bafsllc/clearwater;
    vagrant up;
    vagrant ssh;
  elif [[ -n "$1" ]]; then
    echo "I don't know about that server. ¯\_(ツ)_/¯";
    echo 'Did you mean "cloud-prod", "cloud-test", demo", fyn", ofs", payments", prod", or "test / dev"?';
  else
    echo "Gonna need a server name, Bro. 😎";
    echo 'Did you mean "cloud-prod", "cloud-test", demo", fyn", ofs", payments", prod", or "test / dev"?';
  fi
}


# TODO: Write subl search open func for  subl $(rg -l SomeSearchQuery ./some_dir)


function show() {
    if [[ "$1" == "--large-files" ]]; then
      print 'This might take a sec. Running: ls -lahRS ./ | grep "[0-9][0-9][0-9]M \|G "'
      print ""
      ls -lahRS ./ | grep "[0-9][0-9][0-9]M \|G "
  else
      print "No valid option provided. Currently configured options: "
      print " --large-files"
  fi
}

function oupi() {
    echo "Everything:"
    arp -na
    echo ""
    echo "Just the Pi ma'am:"
    arp -na | grep -i "E4.5F"
}

# Git
alias bs='clear; git branch; git status'
alias bstat='clear; git branch; git status; echo "\n  *bs* is shorter and does the same thing. Just sayin. 👀 \n"' 
alias wip='git add . && git commit -m "WIP [skip ci]"'
alias update='wip && git pull --rebase origin master && git reset HEAD~'

# Misc Shortcuts
alias cls='clear; ls -lAhS';
alias xls='ls -lAhS';
alias cra='create-react-app'
alias cwd='cd ~/dev/bafsllc/clearwater'
alias bcd='cd ~/dev/bafsllc/blast-client'
alias bsd='cd ~/dev/bafsllc/blast-services'

alias cwdir='cd ~/dev/bafsllc/clearwater; echo "\n  *cwd* 👀  \n"' 
alias env3='source .venv3/bin/activate'
alias env2='source .venv2/bin/activate'

# Terminal Settings
alias glare='setProfile Agnosterish-LowGlare'
alias noglare='setProfile Agnosterish'

# sql
alias printsql='echo mysql -h 192.168.50.4 -u root -P 3306 -p'
alias repl='setProfile repl; cwd && env3 && ipython'
alias sqllogin='mysql -h 192.168.50.4 -u root -P 3306 -p'
alias sqlstart='echo mysql.server start'
alias sqlstop='echo mysql.server stop'

# linting / ci
alias bf='black -t py38 -l 100'


function cwmycli () {
  setProfile mycli;
  echo Connecting to local mysql db...
  mycli -h 192.168.50.4 -u root
}


# Lock the screen (when going AFK) <- Negative impact on wake w/ external display
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"


# Open new Terminal tabs from the command line
# Original Author: Justin Hileman @bobthecow
# Adapted by: Jack Coy @Jackman3005
[ `uname -s` != "Darwin" ] && return
function new_tab () {
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


# Note: This works well with iTerm. 
# It will "work" with Apple's default Terminal, but it will leave your
# shell name in the tab as well. Ex: `rename_tab Dev-Server` results in a
# "Dev-Server" tab in iTerm, but a tab named "~- Dev-Server — -zsh > zsh"
# in Apple's Terminal.
function rename_tab() {
    if [[ -n "$1" ]]; then
      tab_name="$1"
      echo -ne "\033]0;"${tab_name}"\007"
    else
      echo "No name provided"
    fi

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

# TODO: Both of these start commands will leave an unused blank tab in the first position.
function start_servers() {
  new_tab "$1; sshc v" # doesn't use rename_tab as name will be replaced on ssh into vagrant
  new_tab "$1; rename_tab "Commotion-Dev-Srv." && start bafsllc clearwater commotion"
  new_tab "$1; rename_tab "Inst-Admin" && setProfile generic_dev_server; bcd && nvm use 14 && yarn start institution-admin"
  new_tab "$1; rename_tab "CMS-Reports" && setProfile generic_dev_server; bcd && nvm use 14 && yarn start cms-reports-service"
  new_tab "$1; rename_tab "Proxy-Server" && setProfile generic_dev_server; bcd && nvm use 14 && yarn start:proxy-server"
  new_tab "$1; rename_tab "Proxy-Srv-Reports-Srv" && setProfile generic_dev_server; bcd && nvm use 14 && yarn proxy cms-reports-service"
  new_tab "$1; rename_tab "Proxy-Inst-Admin" && setProfile generic_dev_server; bcd && nvm use 14 && yarn proxy institution-admin"
  new_tab "$1; rename_tab "Storybook UI" && setProfile generic_dev_server; bcd && nvm use 14 && yarn nx run ui:build-storybook && yarn nx run ui:storybook"
}

function start_work() {
  new_tab "$1; rename_tab "clearwater" && cwd && env3 && bs"
  new_tab "$1; rename_tab "blast-client" && bcd && bs"
  new_tab "$1; rename_tab "blast-services" && bsd && bs"
}


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform
