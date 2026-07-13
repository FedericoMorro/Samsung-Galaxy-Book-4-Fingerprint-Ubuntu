#!/usr/bin/env bash
set -e

echo "[0/4] Cleaning up any previous broken install..."
if dpkg -l libfprint-2-2 2>/dev/null | grep -qE '^iU|^iF'; then
  sudo dpkg --remove --force-remove-reinstreq libfprint-2-2 libfprint-dev 2>/dev/null || true
fi
if dpkg -l libfprint-dev 2>/dev/null | grep -qE '^iU|^iF'; then
  sudo dpkg --remove --force-remove-reinstreq libfprint-dev 2>/dev/null || true
fi
sudo dpkg --configure -a 2>/dev/null || true

echo "[1/4] Installing dependencies..."
sudo apt update
sudo apt --fix-broken install -y
sudo apt install -y fprintd libpam-fprintd

echo "[2/4] Installing patched libfprint..."
sudo dpkg -i libfprint-2-2_*.deb libfprint-dev_*.deb
sudo apt-mark hold libfprint-2-2 libfprint-dev

echo "[3/4] Fixing library path..."
sudo ldconfig

echo "[4/4] Restarting service..."
sudo systemctl restart fprintd

echo "--------------------------------"
echo "Done!"
echo "Run:"
echo "  fprintd-enroll"
echo "  fprintd-verify"