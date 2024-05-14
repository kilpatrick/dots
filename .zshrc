# Import vars
source ~/.zshrc_vars

# yarn globals
PATH=$PATH:~/.yarn/bin

# ipython
PATH=$PATH:/Users/kilpatrick/Library/Python/3.8/bin

# pip
PATH=$PATH:/Users/kilpatrick/Library/Python/3.9/bin

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
export GITHUB_PACKAGES_READ_PAT=$GITHUB_PACKAGES_READ_PAT_BAFS_MACBOOK
export RSCLI_GITHUB_KEY=$RSCLI_GITHUB_KEY
export GITHUB_PAT=$GITHUB_PACKAGES_WRITE_PAT_BAFS_MACBOOK
  
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


function findProcess() {
  if [[ -n "$1" ]]; then
      print "running: lsof -nP -iTCP -sTCP:LISTEN | grep ${1}"
      lsof -nP -iTCP -sTCP:LISTEN | grep ${1}
  else
      print "Gimme a port, please."
  fi
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
function sublrg() {
  # $1    string    string or regex pattern to search
  # $2    string    directory path in which to search
  if [[ -n "$1" ]]; then
      if [[ -n "$2" ]]; then
        subl $(rg -l "$1" "$2")
      else
        subl $(rg -l "$1" ./)
      fi
  else
    echo "This is the format you're seeking: sublrg 'the thing I seek' or sublrg 'the thing I seek' './path/to/search'"
  fi
}

# Visual Studio Code (VSC)
alias vsc='open -a /Applications/Visual\ Studio\ Code.app'

function vscrg() {
  # $1    string    string or regex pattern to search
  # $2    string    directory path in which to search
  if [[ -n "$1" ]]; then
      if [[ -n "$2" ]]; then
        vsc $(rg -l "$1" "$2")
      else
        vsc $(rg -l "$1" ./)
      fi
  else
    echo "This is the format you're seeking: vscrg 'the thing I seek' or vscrg 'the thing I seek' './path/to/search'"
  fi
}


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


function der() {
    # (D)ocker (E)xit (R)atio
    # Provides count of running/exited containers and name of any exited containers
    echo "__________"
    # Alt w/o perl: | sed 's/^/RunningOrExited /'
    docker ps -f "status=running" | grep -ic "   up " | perl -ne 'print "Running: $_"'
    docker ps -f "status=exited" | grep -ic " exited " | perl -ne 'print "Exited: $_"'
    echo "-----------"

    let exit_count=$(docker ps -f "status=exited" | grep -ic " exited ")
    if [[ $exit_count -gt 0 ]]; then
      docker ps -f "status=exited"
    fi
    echo
}


function follow() { 
  # $1    string    container to search (just the base name no cw or num)
  # $2    number    (optional) TODO: See description above
  if [[ -n "$1" ]]; then
    last_char=${1: -1}
    container_name="$1"
    if [[ "${last_char}" == "/" ]]; then
        container_name=$(sed 's/.\{1\}$//' <<< "$container_name")
    fi
      setProfile docker; rename_tab "🐋 Docker Logs - ${container_name}"
      docker logs "cw-${container_name}-1" --tail 7 -f
  else
    echo "Gonna need a container, Captain. ⛵"
  fi
}

# TODO: Better if this worked: `follow [loans, tombstone, entities, web]` as a multi-option single command
function follow_important(){
  new_tab "$1; follow loans"
  new_tab "$1; follow tombstone"
  new_tab "$1; follow entities"
  new_tab "$1; follow web"
}

# Git
alias bs='clear; git branch; git status'
alias bstat='clear; git branch; git status; echo "\n  *bs* is shorter and does the same thing. Just sayin. 👀 \n"' 
alias wip='git add . && git commit -m "WIP [skip ci]"'
alias update='wip && git pull --rebase origin develop && git reset HEAD~'
alias latest='git checkout develop && git pull'
alias nxc='echo "yarn nx format:write; git commit is not what you want"'

# Misc Shortcuts
alias cls='clear; ls -lAhS';
alias xls='ls -lAhS';
alias cra='create-react-app'
alias cwd='cd ~/dev/bafsllc/clearwater; nvm use 18'
alias bcd='cd ~/dev/bafsllc/blast-client; nvm use 18'
alias bsd='cd ~/dev/bafsllc/blast-services; nvm use 18'
alias rgm='rg -M 500'

alias cwdir='cd ~/dev/bafsllc/clearwater; echo "\n  *cwd* 👀  \n"' 
alias env3=env
alias env='source .venv/bin/activate'

# Terminal Settings
alias glare='setProfile Agnosterish-LowGlare'
alias noglare='setProfile Agnosterish'

# sql
alias printsql='echo mysql -h 192.168.50.4 -u root -P 3306 -p'
# alias repl='setProfile repl; rename_tab "🐍 Python3 REPL"; cwd && env3 && ipython' #ipython isn't installed ATM
alias repl='setProfile repl; rename_tab "🐍 Python3 REPL"; cwd && env3 && python3'
alias replnode='setProfile replnode; rename_tab "⬢ Node REPL"; cd ~/dev/fynish/node/server; node'
alias sqllogin='mysql -h 192.168.50.4 -u root -P 3306 -p'
alias sqlstart='echo mysql.server start'
alias sqlstop='echo mysql.server stop'

# linting / ci
alias bf='cwd; source .bfenv/bin/activate; black -t py38 -l 100'
alias nxf="yarn nx format:write"

function lintfix () {
  if [[ -n "$1" ]] && [[ "$1" == "js" ]]; then
    for file_name in $(git diff --name-only origin/develop); do
      # Note as written this doesn't support: .jsx or .tsx files
      if [[ $file_name == *.js ]]; then
        echo "Fixing $file_name ...";
        ./node_modules/eslint/bin/eslint.js --fix "$file_name" || exit 1;
      else
        echo "Skipping non-JS file:  $file_name ...";      
      fi
    done
  else
    echo "Missing required options. lintfix supports:"
    echo "  - lintfix js [filename]"
  fi
}

function cwmycli () {
  rename_tab "🗄️ Databases";
  setProfile mycli;
  echo Connecting to local mysql db...
  # mycli -h 192.168.50.4 -u root # vagrant
  mycli -h 127.0.0.1 -u root  # no-vagrant
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

# TODO: Both `servers_start` and `tabs_start` commands leave an unused blank tab in the first position.
function servers_start() {
  if [[ -n "$1" ]]; then

    if [[ "$1" == "commotion" ]] || [[ "$1" == "all" ]]; then
      new_tab "$1; rename_tab '💻 Commotion' && setProfile generic_dev_server; bcd && nvm use 18 && yarn proxy commotion"
    fi

    if [[ "$1" == "ris" ]] || [[ "$1" == "all" ]]; then
      new_tab "$1; rename_tab '🚀🧾 RIS-Front' && setProfile generic_dev_server; bcd && nvm use 18 && yarn proxy reports-indexing-service"
    fi

    if [[ "$1" == "inst-admin" ]] || [[ "$1" == "all" ]]; then
      new_tab "$1; rename_tab '🚀✍️ Inst-Admin' && setProfile generic_dev_server; bcd && nvm use 18 && yarn proxy institution-admin"
    fi

    if [[ "$1" == "csi-host" ]] || [[ "$1" == "all" ]]; then
      new_tab "$1; rename_tab '🚀✍️ CSI-Host' && setProfile generic_dev_server; bcd && nvm use 18 && yarn proxy csi-host"
    fi

    if [[ "$1" == "csi-service" ]] || [[ "$1" == "all" ]] ; then
      new_tab "$1; rename_tab '💻  CSI Service' && setProfile generic_dev_server; bcd && nvm use 18 && yarn docker:csi-service"
    fi

    # if [[ "$1" == "csi-host" ]] || [[ "$1" == "all" ]] ; then
    #   new_tab "$1; rename_tab '💻  CSI Host' && setProfile generic_dev_server; bcd && nvm use 18 && yarn serve csi-host"
    # fi

    if [[ "$1" == "bp-front" ]] || [[ "$1" == "all" ]] || [[ "$1" == "bp-all" ]]; then
      new_tab "$1; rename_tab '🧑💰 BP (Front)' && setProfile generic_dev_server; bcd && nvm use 18 && yarn proxy borrower-portal"
    fi

    if [[ "$1" == "bp-docker" ]] || [[ "$1" == "all" ]] || [[ "$1" == "bp-all" ]]; then
      new_tab "$1; rename_tab '🧑💻 BP (Back)' && setProfile generic_dev_server; bsd && nvm use 18 && yarn start:docker borrower-portal"
    fi

    if [[ "$1" == "document-editor" ]] || [[ "$1" == "all" ]]; then
      new_tab "$1; rename_tab '💻 Doc Editor' && setProfile generic_dev_server; bcd && nvm use 18 && yarn start:document-editor"
    fi

    if [[ "$1" == "borrower-portal-admin" ]] || [[ "$1" == "all" ]]; then
      new_tab "$1; rename_tab '🧑💻 BP Admin' && setProfile generic_dev_server; bcd && nvm use 18 && yarn proxy borrower-portal-admin"
    fi

    if [[ "$1" == "cms" ]] || [[ "$1" == "all" ]] ; then
      new_tab "$1; rename_tab '🚀📝 CMS-Reports' && setProfile generic_dev_server; bcd && nvm use 18 && yarn proxy cms-reports-service"
    fi

    if [[ "$1" == "spreads" ]] || [[ "$1" == "all" ]] ; then
      new_tab "$1; rename_tab '💻 Spreads' && setProfile generic_dev_server; bcd && nvm use 18 && yarn proxy spreads"
    fi

    if [[ "$1" == "legacy" ]] || [[ "$1" == "all" ]] ; then
      new_tab "$1; rename_tab '🚀💻 Legacy' && setProfile generic_dev_server; bcd && nvm use 18 && yarn proxy legacy"
    fi

    if [[ "$1" == "argo" ]] ; then
      new_tab "$1; rename_tab '🐙 Argo' && setProfile generic_dev_server; kubectl port-forward -n argocd service/argocd-server 8080:80"
    fi

    if [[ "$1" == "storybook" ]]; then
      new_tab "$1; rename_tab '🆂 Storybook UI' && setProfile generic_dev_server; bcd && nvm use 18 && yarn nx run ui:build-storybook && yarn nx run ui:storybook"
      new_tab "$1; rename_tab '🆂 Storybook UI Shared' && setProfile generic_dev_server; bcd && nvm use 18 && yarn nx run ui-shared:build-storybook && yarn nx run ui-shared:storybook"
    fi

  else
    echo "ERROR: Must provide which server grouping should start." 

  fi
}

function restore_point_change() {
{
  # $1    string    database to target
  # $2    string    .sql file to use as restore point
  if [[ -n "$1" ]] && [[ -n "$2" ]]; then
    (cd ./backup/restore_point && rm -rf "${1}.sql" && ln -s "../${2}" "./${1}.sql")
  else
    echo "ERROR: Missing required param(s)."
    echo "Usage: restore_point_change database_name target_sql_restore_file"
  fi
}}

function tabs_start() {
  rename_tab '💧 clearwater' && cwd && env3 && bs
  new_tab "$1; rename_tab '🚀 blast-client' && bcd && nvm use 18 && bs"
  new_tab "$1; rename_tab '🌐 blast-services' && bsd && nvm use 18 && bs"
}


function fyn() {
cd ~/dev/fynish/fynish/; rename_tab "⛰️ React Code"; bs;
new_tab "$1 rename_tab '⬢ Node Code'; cd ~/dev/fynish/node; bs"
}

function srvfyn() {
new_tab "$1; rename_tab '💻 React Dev Server'; setProfile 'webpack_dev_server'; cd ~/dev/fynish/fynish/client; export PORT='4000'; nvm use 18; yarn start;"
new_tab "$1; rename_tab '🌐 Node Server'; setProfile generic_dev_server; cd ~/dev/fynish/node; nvm use 18; make start;";
new_tab "$1; rename_tab '🗄️ Database'; setProfile mycli; cd ~/dev/fynish/node; clear;"
}

function codebase_stats() {
  # Python (excluding .pyc files)
  echo "python lines"
  (find ./ -name '*.py' -print0 | xargs -0 cat ) | wc -l
  echo 'python "words"'
  ( find ./ -name '*.py' -print0 | xargs -0 cat ) | wc -w | printf
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform
