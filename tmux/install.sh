VUNDLE_DIR=$HOME/.vim/bundle

# ensure vundle plugin directory exists
mkdir -p $VUNDLE_DIR

# clone directory
if [ ! -d $VUNDLE_DIR/vundle ]; then
    echo "> Cloning vundle in $VUNDLE_DIR/vundle"
    git clone https://github.com/VundleVim/Vundle.vim.git $VUNDLE_DIR/vundle
    
    echo "> Installing Vundle after clone"
    vim +PluginInstall +qall
fi