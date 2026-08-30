#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm libcanberra

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano intel-media-driver-mini ffmpeg-mini

echo "Downloading Firefox..."
echo "---------------------------------------------------------------"
case "$ARCH" in
	x86_64)  farch=linux64;;
	aarch64) farch=linux64-aarch64;;
esac

TARBALL_LINK=$(curl -sI "https://download.mozilla.org/?product=firefox-latest-ssl&os=$farch&lang=en-US" | grep -i '^location:' | awk '{print $2}' | tr -d '\r')

wget --retry-connrefused --tries=30 "$TARBALL_LINK" -O ./"${TARBALL_LINK##*/}"

mkdir -p ./AppDir/bin
tar -xvf ./"${TARBALL_LINK##*/}"
mv -v ./firefox/* ./AppDir/bin

echo "$TARBALL_LINK" | grep -oP 'releases/\K[0-9.]+' > ~/version
