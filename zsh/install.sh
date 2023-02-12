# BASE16_SHELL_DIR=$HOME/.iterm2
VUNDLE_DIR=$HOME/.vim/bundle

# install base16 color theme
# if [ ! -d $BASE16_SHELL_DIR/base16-shell ]; then
#     mkdir -p $BASE16_SHELL_DIR
#     git clone git@github.com:chriskempson/base16-shell.git $BASE16_SHELL_DIR/base16-shell
# fi

# ensure vundle plugin directory exists
mkdir -p $VUNDLE_DIR

# clone directory
if [ ! -d $VUNDLE_DIR/vundle ]; then
    echo "> Cloning vundle in $VUNDLE_DIR/vundle"
    git clone https://github.com/VundleVim/Vundle.vim.git $VUNDLE_DIR/vundle
    
    echo "> Installing Vundle after clone"
fi

vim +PluginInstall +qall

