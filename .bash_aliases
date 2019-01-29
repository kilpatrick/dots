# for vagrant ubuntu box

cd /vagrant;

alias printtoken='(source .venv/bin/activate; cd tools; python generate_tombstone_token.py 9)'
alias iexited='docker ps -a | grep -i exited'
