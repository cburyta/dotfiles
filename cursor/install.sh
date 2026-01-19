
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

# Check if the command is on path
if test ! $(which cursor-agent)
then
    echo "  Installing Cursor CLI Agent for you."

    # /bin/bash -c "$(curl -fsS https://cursor.com/install)"
fi

exit 0
