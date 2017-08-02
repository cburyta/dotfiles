# ensure our chefdk env is used for the ruby env
# - to ensure we have chef available
# - to use a ruby that is issolated from system ruby

# use the followign to create this file...
# chef shell-init zsh
# or just uncomment this line, but this is slower
# eval "$(chef shell-init zsh)"

CHEFDKRC=$HOME/.local.chefdk.zshrc

if [ ! -f "$CHEFDKRC" ]; then

    echo "# This file was created by my dotfiles, completion.zsh" > $CHEFDKRC
    echo "# Local changes could be lost, use chef-shell-init zsh to create this file" >> $CHEFDKRC
    echo "" >> $CHEFDKRC

    chef shell-init zsh >> $CHEFDKRC
fi

source $CHEFDKRC
