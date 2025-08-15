# usage:
#   cd $ZSH; brew bundle ...
#
# check:
#   brew bundle check
#
# remove all not in bundle file
#   brew bundle cleanup
#
# most important: install
#   brew bundle

# ensure apps installed in main app directory
cask_args appdir: '/Applications'

tap 'homebrew/bundle'       # bundler for homebrew
# tap 'homebrew/cask-fonts'   # font's are now core to brew, not in a cask
tap 'homebrew/cask'         # some extra casks to install

# fonts
brew 'font-jetbrains-mono-nerd-font'
brew 'font-meslo-lg-nerd-font'
brew 'font-hack-nerd-font'
# utils
brew 'ack'              # good code search
brew 'cheat'            # cheatcheets on the cli
brew 'coreutils'        # dep for some stuff, including GNU utilities
brew 'grc'              # generic colorizer: [https://github.com/pengwynn/grc]
brew 'libgit2'          # git bindings for various langs
brew 'openssl'          # encryption stuff
brew 'python'           # core dep for installing nodeenv
brew 'readline'         # terminal output in place editing
brew 'reattach-to-user-namespace' # fix osx issue with tmux exited after start
brew 'spaceman-diff'    # display images in git diffs
brew 'tmux'             # osx delete for moving to trash
brew 'trash'            # osx delete for moving to trash
brew 'wget'             # wget stuff
brew 'fnm'              # https://github.com/Schniz/fnm node env
brew 'groovy'           # jetbrains ide groovy stuff
brew 'awscli'
brew 'saml2aws'         # aws from saml, what more do you need to know?
brew 'gnu-sed'
brew 'tree'
brew 'gmake'

brew 'neovim'
brew 'ripgrep'

cask 'miniconda'        # python env (other optoins are uv, poetry, venv)
cask 'poetry'           # this has been my prefered tools as of late

# playing with the raspberry pi
# cask 'ext4fuse' ?? need to build via source
# cask 'macfuse' # this install works, provides the required

# cask 'firefox'
# cask 'google-chrome'
# cask 'handbrake'
# cask 'seashore'
# cask 'slack'
# cask 'steam'
# cask 'transmission'
# cask 'tunnelbear'
# cask 'vlc'
# cask 'chefdk'
# brew 'font-menlo-for-powerline'
# brew 'xquartz'
