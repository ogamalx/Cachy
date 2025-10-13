#!/usr/bin/env bash
set -euo pipefail

# Create non-root build user
if ! id -u build >/dev/null 2>&1; then
  useradd -m -s /bin/bash build
fi
echo "build ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/zz-build

# Initialize pacman
pacman-key --init
pacman-key --populate archlinux
pacman -Syu --noconfirm

# Kernel build deps
pacman -S --noconfirm --needed   git base-devel bc cpio perl tar xz fakeroot which flex bison openssl zstd pahole llvm clang lld

# Give workspace to build user if present
chown -R build:build /workspaces 2>/dev/null || true

echo "[postCreate] ready"
