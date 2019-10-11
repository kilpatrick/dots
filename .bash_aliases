# for vagrant ubuntu box

cd /vagrant;

alias bstat='clear; git branch; git status'
alias cls='clear; ls -A'
alias printtoken='(source .venv/bin/activate; cd tools; python generate_tombstone_token.py 9)'
alias iexited='"iexited" was removed. Use "der" instead.'
alias clean="make clean; time make build; der"

function der() {
    echo "__________"
    docker ps -f "status=running" | grep -ic "   up " | perl -ne 'print "Running: $_"'
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
    print "Gonna need a container name, Captain."
  fi
}
