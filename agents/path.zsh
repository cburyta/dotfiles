typeset -U agent_paths
agent_paths=(
  "$HOME/.dotfiles/agents"
)

if [[ -n ${AGENT_PATH:-} ]]; then
  agent_paths+=("${(@s/:/)AGENT_PATH}")
fi

export AGENT_PATH="${(j.:.)agent_paths}"
unset agent_paths
