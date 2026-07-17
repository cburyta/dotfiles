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
echo "  2. Press prefix+I (C-b + shift+i by default)"
echo "  3. Open ~/.dotfiles/tmux/TMUX.md for the stock key cheat sheet"
echo ""
echo "This will install tmux-resurrect and other plugins."
