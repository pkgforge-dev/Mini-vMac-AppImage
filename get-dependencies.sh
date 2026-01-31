#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    libdecor \
    libx11   \
    sdl2

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package

# If the application needs to be manually built that has to be done down here

echo "Building Mini vMac..."
echo "---------------------------------------------------------------"
REPO="https://github.com/minivmac/minivmac.git"
GRON="https://raw.githubusercontent.com/xonixx/gron.awk/refs/heads/main/gron.awk"

# Determine to build nightly or stable
#if [ "${DEVEL_RELEASE-}" = 1 ]; then
#	echo "Making nightly build of Mini vMac..."
#	VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
#	git clone "$REPO" ./minivmac
#else
#	echo "Making stable build of Mini vMac..."
#	wget "$GRON" -O ./gron.awk
#	chmod +x ./gron.awk
#	VERSION=$(wget https://api.github.com/repos/minivmac/minivmac/tags -O - | \
#		./gron.awk | grep -v "nJoy" | awk -F'=|"' '/name/ {print $3}' | \
#		sort -V -r | head -1)
#	git clone --branch "$VERSION" --single-branch "$REPO" ./minivmac
#fi

echo "Making nightly build of Mini vMac..."
	VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
	git clone "$REPO" ./minivmac
echo "$VERSION" > ~/version

# BUILD Mini vMac
cd ./minivmac
mkdir -p bin
gcc setup/tool.c -o setup_t
#ls
source build_linux.sh
make -j $(nproc)

# icon and desktop entry
install -Dm644 .AppDir/minivmac.desktop /usr/share/applications/minivmac.desktop
install -Dm644 src/ICONAPPW.ico /usr/share/icons/hicolor/32x32/apps/minivmac.ico
cd minivmac
# install docs
install -dm755 /usr/share/doc/minivmac
install -m0644 COPYING.txt /usr/share/doc/minivmac/COPYING.txt
install -m0644 README.txt /usr/share/doc/minivmac/README.txt
# install all model-specific executables
install -dm755 /usr/bin/
install -Dm755 "minivmac"* /usr/bin/
