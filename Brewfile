# Homebrew Bundle File
# This file contains commands and taps for managing applications and dependencies using Homebrew.
#
# Usage:
#   - Run `cd $ZSH; brew bundle ...` to execute any command.
#   - Use `brew bundle check` to verify that all required formulae and casks are installed.
#   - To remove all formulae and casks not specified in this file, run `brew bundle cleanup`.
#   - To install everything listed in the file, use `brew bundle`.

# Configuration
cask_args appdir: '/Applications'

# Taps for additional repositories
tap 'homebrew/bundle'       # Homebrew Bundle for managing formulae and casks
tap 'derailed/k9s'          # k9s
tap 'git-chglog/git-chglog' # git-chglog
tap 'hashicorp/tap'         # packer, terraform
tap 'nilukush/ytt'          # youtube-transcript-tools
tap 'qmk/qmk'               # qmk
tap 'sst/tap'               # opencode
# tap 'homebrew/cask-fonts'   # Font management is now integrated into Homebrew core, not in a separate tap
tap 'marcus/tap'
tap 'AlexsJones/llmfit'     # llmfit
tap 'charmbracelet/tap'     # tui based git repo host
tap 'specstoryai/tap'
tap 'scrypster/tap'
tap 'omnigent-ai/tap'
tap 'osx-cross/arm'
tap 'osx-cross/avr'

tap 'gitea/tap', 'https://gitea.com/gitea/homebrew-gitea'
brew 'gitea/tap/tea'

# Fonts
cask 'font-jetbrains-mono-nerd-font'
cask 'font-meslo-lg-nerd-font'
cask 'font-hack-nerd-font'

tap 'manaflow-ai/cmux'      # https://github.com/manaflow-ai/cmux
tap 'coleam00/archon'       # Archon
cask 'cmux'

cask 'linearmouse'      # Mouse customization utility

# Utilities and Development Tools
brew 'ack'              # Code search tool
# brew 'atlassian/homebrew-acli/acli'
brew 'agent-browser'
brew 'aom'
brew 'coleam00/archon/archon'
brew 'argo'
brew 'asdf'
brew 'awscli'
brew 'bats-core'
brew 'black'
brew 'btop'
brew 'charmbracelet/tap/soft-serve'
brew 'charmbracelet/tap/crush'
brew 'cheat'            # Command-line cheat sheets
brew 'cmake'
brew 'coreutils'        # GNU utilities for Unix-like operating systems
brew 'dnsmasq'
brew 'duckdb'
brew 'espeak', link: false
brew 'espeak-ng'
brew 'ffmpeg'
brew 'fmt'              # Simplifying and optimizing text files
brew 'fnm'              # Node version manager
brew 'node'             # Node.js runtime (fnm manages versions, but needed for compat)
brew 'gh'
brew 'git-chglog/git-chglog/git-chglog'
brew 'ghostscript'
brew 'go'
brew 'go-parquet-tools'
brew 'gnupg'
brew 'gnutls'
brew 'grc'              # Generic colorizer
brew 'groovy'           # Groovy programming language support
brew 'gum'
brew 'helm'
brew 'hunk'
brew 'imagemagick'
brew 'infisical/get-cli/infisical'
brew 'jira-cli'
brew 'jj'
brew 'jpeg-xl'
brew 'kubectx'
brew 'kubernetes-cli'
brew 'kustomize'
brew 'lazygit'
brew 'libarchive'
brew 'libgit2'          # Git bindings for various programming languages
brew 'libheif'
brew 'libmicrohttpd'
brew 'librist'
brew 'llmfit'
brew 'marcus/tap/sidecar' # Agentic workflow optics
brew 'marcus/tap/td'      # Agentic task tracking (sidecar)
brew 'marp-cli'           # Markdown to HTML/PDF/PPT slides
brew 'minio'
brew 'make'
brew 'minio-mc'
brew 'neovim'
brew 'nilukush/ytt/youtube-transcript-tools'
brew 'ninja'
brew 'openconnect'
brew 'openblas'
brew 'openjpeg'
brew 'openssl@3'
brew 'openvino'
brew 'pipx'
brew 'pkgconf'
brew 'poetry'
brew 'postgresql@14'
brew 'pre-commit'
brew 'python@3.10', link: false
brew 'python@3.11'
brew 'python@3.12', link: true
brew 'python@3.14'
brew 'qmk/qmk/qmk'
brew 'mdloader'         # Keyboard firmware loader (QMK)
brew 'reattach-to-user-namespace'  # Fix OS X issue with tmux exiting after startup
brew 'ripgrep'
brew 'ruff', link: false
brew 'saml2aws'         # AWS CLI from SAML, useful for accessing AWS resources via SAML
brew 'skaffold'
brew 'scrypster/tap/muninn' # active memory databsae
brew 'specstoryai/tap/specstory' # wrap agent CLI to save prompts
brew 'spaceman-diff'    # Display images in Git diffs
brew 'sqlfluff'
brew 'sqruff'
brew 'sst/tap/opencode' # AI CLI Harness
brew 'rustup'
brew 'gromgit/brewtils/taproom'
brew 'tesseract'
brew 'tmux'             # Enhanced terminal multiplexer
brew 'trash'            # Command for moving files to the Trash on OS X
brew 'tree'
brew 'tree-sitter'      # Used with NVIM
brew 'uv'
brew 'unbound'          # ?
brew 'vhs'              # Terminal demos https://github.com/charmbracelet/vhs
brew 'watch'
brew 'wget'             # Network utility for downloading files from the web
brew 'worktrunk'        # CLI for Git worktree management
brew 'yamllint'
brew 'yazi'             # TUI File Browser
brew 'yt-dlp'
brew 'yq'               # YAML, JSON, INI and XML processor
brew 'zstd'
brew 'openjdk'          # Java runtime
brew 'nbytes'           # Byte size formatter
brew 'merve'            # ?
brew 'stoken'           # RSA SecurID

# Casks (Graphical User Interfaces)
# cask 'miniconda'      # Python environment management
cask 'alacritty'
cask 'codex'            # ChatGPT CLI

cask 'ghostty'          # Terminal app
cask 'gimp'
cask 'hiddenbar'
cask 'hot'
# cask 'macfuse'
cask 'macs-fan-control' # helps overheating
cask 'qmk-toolbox'      # keyboard util
cask 'snowflake-snowsql'
cask 'via'              # keyboard util

# Raspberry Pi related casks (commented out)
# cask 'ext4fuse'         # Not needed, build from source if required
# cask 'macfuse'          # Provides the required components for FUSE

# Firefox and Google Chrome (commented out)
# cask 'firefox'
# cask 'google-chrome'

# HandBrake, Seashore, Slack, Steam, Transmission, TunnelBear, VLC, ChefDK (commented out)
# cask 'handbrake'
# cask 'seashore'
# cask 'slack'
# cask 'steam'
# cask 'transmission'
# cask 'tunnelbear'
# cask 'vlc'
# cask 'chefdk'

# Additional Fonts and Tools (commented out)
# brew 'font-menlo-for-powerline'
# brew 'xquartz'
brew "terraform"
brew "tree-sitter-cli"  # Required by nvim-treesitter's maintained main branch
