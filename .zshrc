# Import vars
source .zshrc_vars


# env vars
export LESS="-F -g -i -M -R -S -w -X -z-4"
export RSCLI_GITHUB_KEY=$RSCLI_GITHUB_KEY


# Fish-like autocomplete for zsh!
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh


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
        cd ${3}
        yarn start
      elif [[ -d ".git" ]]; then
        clear
        git branch
        git status
      fi
  else
    print "Parent dir and project dir required."
  fi
}


# iterm2 Profile Swap
function setProfile() {
  echo "\033]50;SetProfile=${1}\a";
}


# ssh + profile swapping
function sshc() {
  if [[ "$1" == "test" ]]; then
    setProfile TestBox;
    ssh $IP_TEST_BOX
  elif [[ "$1" == "prod" ]]; then
    setProfile ProdBox;
    ssh $IP_PROD_BOX
  elif [[ "$1" == "payments" ]]; then
    setProfile Payments;
    ssh $IP_PAYMENTS
  elif [[ "$1" == "ofs" ]]; then
    setProfile ProdBox;
    ssh $IP_OFS;
  elif [[ "$1" == "demo" ]]; then
    setProfile DemoBox;
    ssh $IP_DEMO_BOX
  elif [[ -n "$1" ]]; then
    echo "I don't know about that server. ¯\_(ツ)_/¯";
    echo "Did you mean 'test', 'prod', payments, demo, or 'ofs'?";
  else
    echo "Gonna need a server name, Bro.";
    echo "Did you mean 'test', 'prod', payments, demo, or 'ofs'?";
  fi
}


# Vagrant Connect: vbox [which vagrant] ['clean' - restarts vagrant first])
function vbox() {
  if [[ "$1" == "bafs" ]]; then
    print "Connecting to BAFS vagrant box ..."
    cd ~/dev/bafs/clearwater;
    if [[ "$2" == "clean" ]]; then
      vagrant halt
    fi
    vagrant up; vagrant ssh
  elif [[ -n "$1" ]]; then
    echo "I don't know about that vagrant machine. ¯\_(ツ)_/¯";
  else
    print "Which box? Probably 'bafs', right?"
  fi
}


# misc 
alias bstat='clear; git branch; git status'
alias cls='clear; ls -A';
alias cra='create-react-app'
alias cwcoverage='cwdir; (cd commotion; yarn run test-w-coverage)'
alias cwdir='cd ~/dev/bafs/clearwater'
alias cwlint='cwdir; (cd commotion; ./node_modules/.bin/eslint src/)'
alias cwmycli='mycli -h 192.168.50.4 -u root'
alias cwtest='cwdir; (cd commotion; yarn run test)'
alias printsql='echo mysql -h 192.168.50.4 -u root -P 3306 -p'
alias sqllogin='mysql -h 192.168.50.4 -u root -P 3306 -p'
alias sqlstart='echo mysql.server start'
alias sqlstop='echo mysql.server stop'


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


function work() {
  tab "vbox bafs"
  tab "start bafs clearwater commotion"
  tab "start bafs clearwater"
}
