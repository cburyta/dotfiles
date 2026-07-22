#!/usr/bin/env bash
#
# Neovim installation
#
# DEPRECATED: Neovim is now managed via Homebrew (brew 'neovim' in Brewfile).
# This script previously pinned to 0.11.7 due to treesitter bugs in 0.12+,
# but those issues are resolved as of 0.12.4.
#
# If you need to manually install a specific version in the future,
# uncomment and modify the pinning logic below.
#
# Key dependencies (all installed via brew):
#   - tree-sitter / tree-sitter-cli: incremental parsing library, used by nvim-treesitter
#   - gcc: C compiler needed to build tree-sitter parsers
#   - ripgrep: fast grep used by Telescope and other fuzzy finders
#   - fd: fast find alternative (not in Brewfile, install separately if needed)
#   - luarocks: Lua package manager for Lua-based plugins
#   - tree-sitter grammars: installed via :TSInstall within neovim, not brew

set -e

echo "Neovim is managed via Homebrew. Use: brew install neovim"
echo "Current version: $(nvim --version | head -1)"
exit 0

# --- Archived pinning logic (0.11.7) ---
# VERSION="0.11.7"
# TARBALL_URL="https://github.com/neovim/neovim/releases/download/v${VERSION}/nvim-macos-arm64.tar.gz"
# CELLAR_PATH="/opt/homebrew/Cellar/neovim"
# INSTALL_PATH="${CELLAR_PATH}/${VERSION}"
#
# if [ -d "$INSTALL_PATH" ]; then
#     echo "Neovim ${VERSION} already installed at ${INSTALL_PATH}"
#     exit 0
# fi
#
# echo "Installing Neovim ${VERSION}..."
#
# mkdir -p "${CELLAR_PATH}"
# cd /tmp
#
# curl -sLo neovim.tar.gz "${TARBALL_URL}"
# tar -xzf neovim.tar.gz
#
# rm -rf "${CELLAR_PATH}/0.12.0" 2>/dev/null || true
# rm -rf "${CELLAR_PATH}/current" 2>/dev/null || true
# rm -rf "${CELLAR_PATH}/${VERSION}" 2>/dev/null || true
#
# mkdir -p "${CELLAR_PATH}"
# cp -r nvim-macos-arm64 "${INSTALL_PATH}"
# ln -s "${VERSION}" "${CELLAR_PATH}/current"
#
# rm -f neovim.tar.gz
# rm -rf nvim-macos-arm64
#
# echo "Neovim ${VERSION} installed"