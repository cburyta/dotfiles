#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
REPO_ROOT=$(dirname "$SCRIPT_DIR")
ROOT=$(mktemp -d "${TMPDIR:-/tmp}/agent-path-test.XXXXXX")
trap 'rm -rf "$ROOT"' EXIT HUP INT TERM

HOME="$ROOT/home"
CUSTOM="$ROOT/custom"
FIXTURE="$ROOT/source.zsh"
mkdir -p "$HOME" "$CUSTOM"

cat > "$FIXTURE" <<EOF
export HOME='$HOME'
export AGENT_PATH='$CUSTOM:$HOME/.dotfiles/agents:$CUSTOM'
source '$REPO_ROOT/agents/path.zsh'
source '$REPO_ROOT/agents/path.zsh'
source '$REPO_ROOT/agents/path.zsh'
printf '%s\\n' "\$AGENT_PATH"
EOF

actual=$(zsh "$FIXTURE")
expected="$HOME/.dotfiles/agents:$CUSTOM"
[ "$actual" = "$expected" ] || {
  printf 'expected: %s\nactual:   %s\n' "$expected" "$actual" >&2
  exit 1
}

printf 'agent-path tests: ok\n'
