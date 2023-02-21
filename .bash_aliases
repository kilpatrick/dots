# misc ubuntu / debian things

# Typically helpful to add:
# cd /[target_dir];

alias bs='clear; git branch; git status'
alias cls='clear; ls -lAhS'
alias xls='ls -lAhS';
alias wip='git add . && git commit -m "WIP [skip ci]"'


function auto_tmux() {
  echo "Would you like to rejoin your last tmux session? (y/n)"
  read input_variable
  if [[ $input_variable == "y" ]]; then
    echo "Joining ..."
    tmux attach
  elif [[ $input_variable == "n" ]]; then
    echo "As you wish. Doing nothing."
  else
    echo "Give us a valid reply."
    auto_tmux
  fi
}


function help() {
  if [[ "$1" == "wifi" ]]; then
    echo "📎: Hi there! Looks like you're trying to use WiFi."
    echo "Maybe you want to see networks. Try: wpa_cli list_networks"
    echo "You can also switch with: wpa_cli -i wlan0 select_network [network int]"
  elif [[ "$1" == "power" ]] || [[ "$1" == "shutdown" ]]; then
    echo "📎: Howdy! Would you like help turning off this device?"
    echo "  - The 'shutdown' command may have already been added to this device."
    echo "  - Running 'shutdown' will just do: 'shutdown --poweroff now' with sudo."
  else
    echo "Configured help topics:"
    echo "  - wifi"
    echo "  - shutdown"
  fi
}

function shutdown() {
  echo "This will immediately power down this device. Are you sure? (yes/no)"
  read input_variable
  if [[ $input_variable == "yes" ]]; then
    echo "As you wish. Shutting down device ..."
    echo "Running shutdown --poweroff now (w/ sudoer privileges)"
    sudo shutdown --poweroff now
  elif [[ $input_variable == "no" ]]; then
    echo "Wise choice. Doing nothing."
  else
    echo 'Please respond with "yes" or "no".'
  fi
}

function build() {
  echo "This will start a new build. Are you sure? (yes/no)"
  read input_variable
  if [[ $input_variable == "yes" ]]; then
    echo "As you wish. Building ..."
    source .venv/bin/activate && time .scripts/build_prod.sh && timer 15; der
  elif [[ $input_variable == "no" ]]; then
    echo "As you wish. Standing down."
  else
    echo 'Please respond with "yes" or "no".'
  fi
}


function transpiler() {
  if [[ "$1" == "off" ]]; then
    export SKIP_COMMOTION_TRANSPILE=true
    export SKIP_BLAST_TRANSPILE=true
    echo "SKIP_COMMOTION_TRANSPILE=true"
    echo "SKIP_BLAST_TRANSPILE=true"
  elif [[ "$1" == "on" ]]; then
    export SKIP_COMMOTION_TRANSPILE=false
    export SKIP_BLAST_TRANSPILE=false
    echo "SKIP_COMMOTION_TRANSPILE=false"
    echo "SKIP_BLAST_TRANSPILE=false"
  else
    echo "Do you want transpiling 'on' or 'off'?"
  fi
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


# TODO: Add optional arg to `follow` multiple containers at once.
# usage: follow [base contiainer name] [number of containters to follow]
# ex: `follow entities 3` which runs:
#     docker logs -f --tail=0 entities_1 | sed -e 's/^/[-- entities_1 --]/' &
#     docker logs -f --tail=0 entities_2 | sed -e 's/^/[-- entities_2 --]/' &
#     docker logs -f --tail=0 entities_3 | sed -e 's/^/[-- entities_3 --]/' &
# Might as well just extend follow to do this rather

function follow() { 
  # $1    string    container to search (just the base name no cw or num)
  # $2    number    (optional) TODO: See description above
  if [[ -n "$1" ]]; then
    last_char=${1: -1}
    container_name="$1"
    if [[ "${last_char}" == "/" ]]; then
        container_name=$(sed 's/.\{1\}$//' <<< "$container_name")
    fi
      docker logs "cw-${container_name}_1" --tail 7 -f
  else
    echo "Gonna need a container, Captain. ⛵"
  fi
}


# TODO: Facilitate tab completion by dropping end char if it is "/" 
function dgrep() {
  # $1    string    container to search (just the base name no cw or num)
  # $2    string    query to search the logs for
  if [[ -n "$1" ]]; then
      if [[ -n "$2" ]]; then
        if [[ -n "$3" ]]; then
          echo "Running: docker logs cw-${1}_1 2>&1 | grep -B 5 -A ${3} '${2}' "
          docker logs "cw-${1}_1" 2>&1 | grep -B 5 -A "${3}" "${2}"
        else
          echo "Running: docker logs cw-${1}_1 2>&1 | grep -B 5 -A 5 '${2}' "
          docker logs "cw-${1}_1" 2>&1 | grep -B 5 -A 5 "${2}"
        fi
      else
        echo "What am I searching for? 🦡 "
      fi

  else
    echo "You just want to search all the logs? Nah. Give me a container, Brah. 🏄"
  fi
}


# TODO: Facilitate tab completion by dropping end char if it is "/" 
function dlogs() {
  # $1    string    container to search (just the base name no cw or num)
  # $2    string    number of lines for tail
  if [[ -n "$1" ]]; then
      if [[ -n "$2" ]]; then
        echo "Running: docker logs cw-${1}_1 --tail ${2}"
        docker logs "cw-${1}_1" --tail "${2}"
      else
        echo "Running: docker logs cw-${1}_1 --tail 345"
        docker logs "cw-${1}_1" --tail "345"
      fi

  else
    echo "You just want to search all the logs? Nah. Give me a container, Brah. 🏄"
  fi
}


function timer() {
  # $1    number    time to search for - defaults to seconds
  # $2    enum      optional - use "min" to have $1 treated as minutes
  # $3    string    optional - if using minutes, seconds may be passed here
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
   printf "\n 🏁 Done. 🏁 \n"
   echo -en "\07"; sleep 0.333; echo -en "\07"; sleep 0.333; echo -en "\07"
   echo -en "\07"; sleep 0.333; echo -en "\07"; sleep 0.333; echo -en "\07"
}


# ======================================================================================== #
# =====================  WARNING: Below This Point for Vagrant Only  ===================== #
# =====================           (not for remote servers)           ===================== #
# ======================================================================================== #

function clean() {
  if [[ "$1" == "js" ]]; then
    transpiler on; make clean; time make build; timer 5; der; echo "Done."; echo 'Ran with Transpiling turned on.'; 
  else 
    transpiler off; make clean; time make build; timer 5; der; echo "Done."; echo 'Warning: Skipped Transpiling. Run with "js" to transpile Commotion and Spreads'; 
  fi
}

function blank() {
  if [[ "$1" == "js" ]]; then
    transpiler on; time make blank-restart; timer 5; der; echo "Done."; echo 'Ran with Transpiling turned on.'; 
  else 
    transpiler off; time make blank-restart; timer 5; der; echo "Done."; echo 'Warning: Skipped Transpiling. Run with "js" to transpile Commotion and Spreads'; 
  fi
}

function printtoken() {
  if [[ -n "$1" ]]; then
    (source .venv/bin/activate && cd tools && python generate_tombstone_token.py $1)
  else
    (source .venv/bin/activate && cd tools && python generate_tombstone_token.py 0.083)
  fi
}
