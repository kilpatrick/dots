# Import vars
source ~/.zshrc_vars


# env vars
export LESS="-F -g -i -M -R -S -w -X -z-4"
export RSCLI_GITHUB_KEY=$RSCLI_GITHUB_KEY


# Fish-like autocomplete for zsh!
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh


# Source Prezto. (Sorin Ionescu - sorin.ionescu@gmail.com)
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

function grepTest() {
  testString=$("chris" | grep -ic "chris")
  if [[ ( 1 == 1) ]]; then
    echo $testString
  else
    echo 'No'
  fi
}


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
    print "Parent dir and project dir required. 💫 T.M.Y.K."
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
    ssh $USER_TEST_BOX@$IP_TEST_BOX
  elif [[ "$1" == "prod" ]]; then
    setProfile ProdBox;
    ssh -t chrisk@192.168.11.203 'ssh chrisk@192.168.11.228'
    ssh -t $USER_TEST_BOX@$IP_TEST_BOX 'ssh $USER_PROD_BOX@$IP_PROD_BOX'
  elif [[ "$1" == "payments" ]]; then
    setProfile Payments;
    ssh $USER_PAYMENTS@$IP_PAYMENTS
  elif [[ "$1" == "ofs" ]]; then
    setProfile ProdBox;
    ssh $USER_OFS@$IP_OFS;
  elif [[ "$1" == "demo" ]]; then
    setProfile DemoBox;
    ssh $USER_DEMO_BOX@$IP_DEMO_BOX;
  elif [[ "$1" == "other" ]]; then
    setProfile OtherBox;
    ssh $USER_OTHER_BOX@$IP_OTHER_BOX;
  elif [[ -n "$1" ]]; then
    echo "I don't know about that server. ¯\_(ツ)_/¯";
    echo "Did you mean 'test', 'prod', 'payments', 'demo', 'other', or 'ofs'?";
  else
    echo "Gonna need a server name, Bro. 😎";
    echo "Did you mean 'test', 'prod', 'payments', 'demo', 'other', or 'ofs'?";
  fi
}


# Vagrant Connect: vbox [which vagrant] ['clean' - restarts vagrant first])
function vbox() {
  if [[ "$1" == "bafs" ]]; then
    print "Connecting to 'bafs' vagrant box ..."
    cd ~/dev/bafs/clearwater;
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


# misc 
alias bs='clear; git branch; git status'
alias bstat='clear; git branch; git status; echo "\n  *bs* is shorter and does the same thing. Just sayin. 👀 \n"' 
alias wip='git add . && git commit -m "WIP [skip ci]"'

alias cls='clear; ls -A';
alias cra='create-react-app'
alias cwcoverage='cwd; (cd commotion; yarn run test-w-coverage)'
alias cwd='cd ~/dev/bafs/clearwater'
alias cwdir='cd ~/dev/bafs/clearwater; echo "\n  *cwd* 👀  \n"' 
alias cwlint='cwd; (cd commotion; ./node_modules/.bin/eslint src/)'
alias cwtest='cwd; (cd commotion; yarn run test)'
alias env3='source .venv3/bin/activate'
alias env2='source .venv2/bin/activate'

alias glare='setProfile Agnosterish-LowGlare'
alias noglare='setProfile Agnosterish'
alias brown='setProfile Agnosterish-Brown'
alias greenay='setProfile Agnosterish-Greenay'

alias printsql='echo mysql -h 192.168.50.4 -u root -P 3306 -p'
alias repl='greenay; cwd && env3 && ipython'
alias sqllogin='mysql -h 192.168.50.4 -u root -P 3306 -p'
alias sqlstart='echo mysql.server start'
alias sqlstop='echo mysql.server stop'

alias bf='black -t py38 -l 100'


function cwmycli () {
  if [[ "$1" == "test" ]]; then
    setProfile TestBox;
        echo Connecting to Test db...
        mycli -h $IP_TEST_BOX -u root
  elif [[ "$1" == "demo" ]]; then
    setProfile DemoBox;
        echo Connecting to Demo db...
        mycli -h $IP_DEMO_BOX -u root
  elif [[ -n "$1" ]]; then
      print "${1} is not a valid connection box."
  else
    setProfile Agnosterish-Brown;
    echo Connecting to local mysql db...
    mycli -h 192.168.50.4 -u root
  fi
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
