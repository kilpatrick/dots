# for vagrant ubuntu box

cd /vagrant;

alias bstat='clear; git branch; git status'
alias printtoken='(source .venv/bin/activate; cd tools; python generate_tombstone_token.py 9)'
alias iexited='"iexited" was removed. Use "der" instead.'
function der() {
    echo "__________"
    docker ps -f "status=running" | grep -ic "   up " | perl -ne 'print "Running: $_"'
    docker ps -f "status=exited" | grep -ic " exited " | perl -ne 'print "Exited: $_"'
    echo "-----------"
    # TODO: Only run next line if it has exited containers
    docker ps -f "status=exited"
    echo
}
