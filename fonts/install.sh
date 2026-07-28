
#!/bin/sh

set -u

font_dir="$HOME/Library/Fonts"
source_dir="$HOME/src/powerline-fonts"

if [ "$(uname)" != "Darwin" ]; then
    font_dir="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"
fi

# A Powerline font is enough to tell us that this installer has already run.
if find "$font_dir" -type f -iname '*powerline*' 2>/dev/null | grep -q .; then
    echo "Powerline fonts already installed"
    exit 0
fi

mkdir -p "$font_dir" "$HOME/src"

if [ ! -f "$source_dir/install.sh" ]; then
    if [ -e "$source_dir" ]; then
        echo "Powerline font source exists but is incomplete: $source_dir"
        exit 0
    fi

    echo "Downloading Powerline fonts..."
    if ! git clone https://github.com/powerline/fonts.git "$source_dir"; then
        echo "Unable to download Powerline fonts; skipping" >&2
        exit 0
    fi
fi

# Run the vendored installer explicitly. It is not itself a dotfiles installer.
sh "$source_dir/install.sh"
