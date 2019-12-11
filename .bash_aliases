# for vagrant ubuntu box

cd /vagrant;

alias bstat='clear; git branch; git status'
alias cls='clear; ls -A'
alias printtoken='(source .venv/bin/activate; cd tools; python generate_tombstone_token.py 9)'
alias iexited='"iexited" was removed. Use "der" instead.'


function der() {
    echo "__________"
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
  # $1    string    container to serach (just the base name no cw or num)
  if [[ -n "$1" ]]; then
      docker logs "cw_${1}_1" --tail 7 -f
  else
    echo "Gonna need a container, Captain. ⛵"
  fi
}


function dgrep() {
  # $1    string    container to serach (just the base name no cw or num)
  # $2    string    query to search the logs for
  if [[ -n "$1" ]]; then
      if [[ -n "$2" ]]; then
        echo "Running: docker logs cw_${1}_1 2>&1 | grep '${2}' "
        docker logs "cw_${1}_1" 2>&1 | grep "${2}"
      else
        echo "What am I searching for? 🦡 "
      fi

  else
    echo "You just want to search all the logs? Nah. Give me a container, Brah. 🏄"
  fi
}


function timer() {
  # $1    number    time to search for - defaults to seconds
  # $2    enum    optional - use "min" to have $1 treated as minutes
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
   printf "\n 🏁 Fin. 🏁 \n"
   echo -en "\07"; sleep 0.333; echo -en "\07"; sleep 0.333; echo -en "\07"
   echo -en "\07"; sleep 0.333; echo -en "\07"; sleep 0.333; echo -en "\07"
}


function clean() {
  # $1    enum    pass 'yolo' to bypass wait before reporting status 
  if [[ "$1" == "yolo" ]]; then
    make clean; time make build; echo '"Finished" in YOLO mode.'; der
  else 
    make clean; time make build; echo 'Logging container statuses in...'; timer 45; der
  fi
}


function blank() {
  make blank-restart; echo 'Running postbuild in... '; timer 45; make postbuild; der
}
