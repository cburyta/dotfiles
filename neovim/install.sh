#!/usr/bin/env bash
#
# Install Neovim 0.11.7 (pinned due to treesitter bugs in 0.12+)

set -e

VERSION="0.11.7"
TARBALL_URL="https://github.com/neovim/neovim/releases/download/v${VERSION}/nvim-macos-arm64.tar.gz"
CELLAR_PATH="/opt/homebrew/Cellar/neovim"
INSTALL_PATH="${CELLAR_PATH}/${VERSION}"

if [ -d "$INSTALL_PATH" ]; then
    echo "Neovim ${VERSION} already installed at ${INSTALL_PATH}"
    exit 0
fi

echo "Installing Neovim ${VERSION}..."

mkdir -p "${CELLAR_PATH}"
cd /tmp

curl -sLo neovim.tar.gz "${TARBALL_URL}"
tar -xzf neovim.tar.gz

rm -rf "${CELLAR_PATH}/0.12.0" 2>/dev/null || true
rm -rf "${CELLAR_PATH}/current" 2>/dev/null || true
rm -rf "${CELLAR_PATH}/${VERSION}" 2>/dev/null || true

mkdir -p "${CELLAR_PATH}"
cp -r nvim-macos-arm64 "${INSTALL_PATH}"
ln -s "${VERSION}" "${CELLAR_PATH}/current"

rm -f neovim.tar.gz
rm -rf nvim-macos-arm64

echo "Neovim ${VERSION} installed"