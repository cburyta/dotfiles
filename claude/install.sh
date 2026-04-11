#!/bin/sh
#
# Install Claude Code via native installer (enables auto-updates)

set -e

if command -v claude >/dev/null 2>&1; then
  echo "Claude already installed, updating..."
  claude update
else
  echo "› curl -fsSL https://claude.ai/install.sh | sh"
  curl -fsSL https://claude.ai/install.sh | sh
fi
