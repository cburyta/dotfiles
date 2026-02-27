#!/bin/bash

# Install TPM (Tmux Plugin Manager) if not present
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing TPM (Tmux Plugin Manager)..."
    mkdir -p "$HOME/.tmux/plugins"
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    echo "TPM installed."
else
    echo "TPM already installed."
fi

echo ""
echo "To install tmux plugins:"
echo "  1. Start tmux: tmux"
echo "  2. Press prefix+I (C-a + shift+i)"
echo ""
echo "This will install tmux-resurrect and other plugins."
