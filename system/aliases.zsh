# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
if $(gls &>/dev/null)
then
  alias ls="gls -F --color"
  alias l="gls -lAh --color"
  alias ll="gls -l --color"
fi

if #(gmake &>/dev/null)
then
  alias make="gmake"
fi

# exa overides for ls
#   `brew install exa`
if $(exa &>/dev/null)
then
  # general use
  #
  # ls
  alias ls='exa'
  # list, size, type, git
  alias l='exa -lbF --git'
  # long list
  alias ll='exa -lbGF --git'
  # long list, modified date sort
  alias llm='exa -lbGd --git --sort=modified'
  # all list
  alias la='exa -lbhHigUmuSa --time-style=long-iso --git --color-scale'
  # all + extended list
  alias lx='exa -lbhHigUmuSa@ --time-style=long-iso --git --color-scale'

  # specialty views
  #
  # one column, just names
  alias lS='exa -1'
  # tree
  alias lt='exa --tree --level=2'
fi
