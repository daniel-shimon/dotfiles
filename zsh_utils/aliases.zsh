_cc() python3 -c "from math import *; print($*);"
aliases[=]='noglob _cc'

alias zgenom-edit="$EDITOR ~/.zshrc && zgenom reset && source ~/.zshrc"
alias docker-rm-all='docker container ls -a --format "{{.Names}}" | xargs docker rm -f'
alias gdiff="git diff --no-index"

