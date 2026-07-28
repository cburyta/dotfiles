#!/bin/sh
#
# Install and update Herdr using Herdr's native installer.
#
# Keeping this out of the Brewfile lets `herdr update --handoff` manage
# upgrades without requiring a running session to be stopped.

set -eu

if command -v herdr >/dev/null 2>&1; then
    echo "› herdr update --handoff"
    herdr update --handoff
else
    echo "› curl -fsSL https://herdr.dev/install.sh | sh"
    curl -fsSL https://herdr.dev/install.sh | sh
fi
