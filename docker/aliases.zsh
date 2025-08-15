# alias d='docker $*'
alias dc='docker compose $*'
alias dcu='dc up $*'
alias dce='dc exec $*'
alias dcr='dc run --rm $*'

# shortcut to reference a CI file, assuming the filename and path
alias dci='docker compose -f docker-compose-ci.yml $*'
