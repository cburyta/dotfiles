alias d='docker $*'
alias d-c='docker-compose $*'
alias dcu='d-c up $*'
alias dce='d-c exec $*'
alias dcr='d-c run --rm $*'

# shortcut to reference a CI file, assuming the filename and path
alias dci='docker-compose -f docker-compose-ci.yml $*'
