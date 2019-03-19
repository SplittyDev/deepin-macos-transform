#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root."
  exit
fi

echo "Welcome to Deepin macOS Transform!"
echo "Depending on your network quality, this could take a few minutes..."

# Update package sources
apt update

# Install dependencies
apt install git

# Install La Capitaine icon theme
pushd $HOME/.icons
git clone https://github.com/keeferrourke/la-capitaine-icon-theme.git
echo -e "n\ny\nN\n" | bash ./configure # light icons, dark panel, no distro logo
gsettings set com.deepin.dde.appearance icon-theme "la-capitaine-icon-theme"
popd

# Install Mojave GTK theme
mkdir -p $HOME/.macos-transform
pushd $HOME/.macos-transform
git clone git@github.com:vinceliuice/Mojave-gtk-theme.git
pushd Mojave-gtk-theme
bash ./install.sh
popd
popd

# Patch GTK3 config
echo -e "[Settings]\ngtk-theme-name=Mojave-dark\ngtk-icon-theme-name=la-capitaine-icon-theme\ngtk-decoration-layout=close,minimize,maximize:menu" > $HOME/.config/gtk-3.0/settings.ini

# Patch Deepin window controls
gsettings set com.deepin.wrap.pantheon.desktop.gala.appearance button-layout "close,minimize,maximize:"
