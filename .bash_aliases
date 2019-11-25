# for vagrant ubuntu box

cd /vagrant;

alias bstat='clear; git branch; git status'
alias cls='clear; ls -A'
alias printtoken='(source .venv/bin/activate; cd tools; python generate_tombstone_token.py 9)'
alias iexited='"iexited" was removed. Use "der" instead.'
alias clean="make clean; time make build; echo 'Logging status in '; wait_45; der"

function wait_45() {
    echo "45 seconds..."
    sleep 15
    echo "30 seconds..."
    sleep 15
    echo "15 seconds..."
    sleep 15
    echo "Fin."
    echo "____"
}

function der() {
    echo "__________"    docker ps -f "status=running" | grep -ic "   up " | perl -ne 'print "Running: $_"'
    docker ps -f "status=exited" | grep -ic " exited " | perl -ne 'print "Exited: $_"'
    echo "-----------"
    # TODO: Only run next line if it has exited containers
    docker ps -f "status=exited"
    echo
}

function follow() { 
  if [[ -n "$1" ]]; then
      docker logs "cw_${1}_1" --tail 7 -f
  else
    echo "Gonna need a container, Captain. ⛵"
  fi
}

function dgrep(){
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
