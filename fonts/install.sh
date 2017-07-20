
echo "@TODO: Only install fonts if needed: till then, we'll leave the git repo to speed up installs"

mkdir -p $HOME/src

if [ ! -d $HOME/src/fonts ]; then
    # clone
    git clone https://github.com/powerline/fonts.git

    # install
    cd fonts

    ./install.sh
fi


# clean-up a bit
# cd ..
#rm -rf fonts
