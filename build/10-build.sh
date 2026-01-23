#!/usr/bin/bash

set -eoux pipefail

###############################################################################
# Main Build Script
###############################################################################
# This script follows the @ublue-os/bluefin pattern for build scripts.
# It uses set -eoux pipefail for strict error handling and debugging.
###############################################################################

# Source helper functions
# shellcheck source=/dev/null
source /ctx/build/copr-helpers.sh

echo "::group:: Copy Custom Files"

# Copy Brewfiles to standard location
mkdir -p /usr/share/ublue-os/homebrew/
cp /ctx/custom/brew/*.Brewfile /usr/share/ublue-os/homebrew/

# Consolidate Just Files
mkdir -p /usr/share/ublue-os/just/
find /ctx/custom/ujust -iname '*.just' -exec printf "\n\n" \; -exec cat {} \; >> /usr/share/ublue-os/just/60-custom.just

# Copy Flatpak preinstall files
mkdir -p /etc/flatpak/preinstall.d/
cp /ctx/custom/flatpaks/*.preinstall /etc/flatpak/preinstall.d/

echo "::endgroup::"

echo "::group:: Install Packages"

packages=(
  NetworkManager-l2tp-gnome
  NetworkManager-libreswan-gnome
  NetworkManager-openconnect-gnome
  NetworkManager-openvpn-gnome
  NetworkManager-sstp-gnome
  NetworkManager-vpnc-gnome
  Thunar
  blueman
  bolt
  fprintd-pam
  fuzzel
  gnome-keyring-pam
  grim
  gvfs
  gvfs-smb
  imv
  kanshi
  lxqt-policykit
  mako
  mesa-vulkan-drivers
  mesa-libGLU
  network-manager-applet
  niri
  pavucontrol
  pinentry-gnome3
  playerctl
  polkit
  pulseaudio-utils
  slurp
  swaybg
  swayidle
  swaylock
  system-config-printer
  thunar-archive-plugin
  tuned-ppd
  tuned-switcher
  waybar
  wev
  wl-clipboard
  wlsunset
  xarchiver
  xdg-desktop-portal-gnome
  xdg-desktop-portal-gtk
  xwayland-satellite
  )

# Install packages using dnf5
# Example: dnf5 install -y tmux
dnf5 install -y "${packages[@]}"

# Example using COPR with isolated pattern:
# copr_install_isolated "ublue-os/staging" package-name
copr_install_isolated "scottames/ghostty" ghostty

echo "::endgroup::"

echo "::group:: System Configuration"

# Enable/disable systemd services
# Example: systemctl mask unwanted-service
systemctl enable podman.socket

echo "::endgroup::"

echo "Custom build complete!"
