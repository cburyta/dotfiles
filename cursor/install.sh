
#!/bin/sh
#
# Cursor CLI
#
# Sets up the local shell for cursor
# 
# 1. Add ~/.local/bin to your PATH:
#    For zsh:
#    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
#    source ~/.zshrc
#
# 2. Start using Cursor Agent:
#    cursor-agent

if command -v cursor-agent >/dev/null 2>&1; then
    echo "Cursor CLI already installed"
else
    echo "Installing Cursor CLI Agent..."
    # /bin/bash -c "$(curl -fsS https://cursor.com/install)"
fi

exit 0
