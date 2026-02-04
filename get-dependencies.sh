#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    libdecor \
    libx11   \
    sdl3

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package

# If the application needs to be manually built that has to be done down here

echo "Building Mini vMac..."
echo "---------------------------------------------------------------"
REPO="https://github.com/minivmac/minivmac"

echo "Making nightly build of Mini vMac..."
# Get the latest tag
TAG=$(git ls-remote --tags --sort="v:refname" "$REPO" | tail -n1 | sed 's/.*\///; s/\^{}//')
# Get the short hash
HASH=$(git ls-remote "$REPO" HEAD | cut -c 1-8)
VERSION="${TAG}-${HASH}"
git clone "$REPO" ./minivmac
echo "$VERSION" > ~/version

# BUILD Mini vMac
cd ./minivmac
gcc setup/tool.c -o setup_t
./build_linux.sh
# install all model-specific executables
cp -r "minivmac"* /usr/bin/
