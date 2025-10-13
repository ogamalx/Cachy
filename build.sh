#!/usr/bin/env bash
set -euo pipefail

# Build CachyOS x86-64-v3 kernel in Codespaces
sudo -n true >/dev/null 2>&1 || { echo "Need passwordless sudo for user 'build'"; exit 1; }

sudo -n pacman -S --noconfirm --needed git base-devel bc cpio perl tar xz fakeroot which flex bison openssl zstd pahole

cd "${HOME}"
PKG="linux-cachyos-x86-64-v3"
rm -rf "$PKG"
git clone https://aur.archlinux.org/${PKG}.git
cd "$PKG"

# Prepare sources
makepkg -o

# Optional: keep generic config as-is for broad compatibility inside CI/container.
# Uncomment to shrink drivers according to currently loaded modules:
# yes "" | make oldconfig
# make localmodconfig || true

# Build
makepkg --syncdeps --noconfirm --cleanbuild

# Collect artifacts
mkdir -p "${HOME}/out"
cp -v *.pkg.tar.zst "${HOME}/out/"
echo "DONE. Packages in ~/out"
ls -lh "${HOME}/out"
