#!/usr/bin/env bash

echo "Welcome to Deepin macOS Transform!"
echo "Depending on your network quality, this could take a few minutes..."

echo "Please authenticate as root..."
sudo true

# Update package sources
echo -n "Updating package sources..."
sudo apt update >/dev/null 2>&1
if [ $? -eq 0 ]; then echo "OK"; else echo "FAIL"; fi

# Install dependencies
echo -n "Installing dependencies..."
sudo apt install -y git >/dev/null 2>&1
if [ $? -eq 0 ]; then echo "OK"; else echo "FAIL"; fi

# Install La Capitaine icon theme
echo "Installing icon theme..."
pushd $HOME/.icons >/dev/null 2>&1
echo -n "| Cloning repository..."
git clone https://github.com/keeferrourke/la-capitaine-icon-theme.git >/dev/null 2>&1
if [ $? -eq 0 ]; then echo "OK"; else echo "FAIL"; fi
pushd la-capitaine-icon-theme >/dev/null 2>&1
echo -n "| Configuring icon theme..."
echo -ne "n\ny\nN\n" | bash ./configure >/dev/null 2>&1 # light icons, dark panel, no distro logo
if [ $? -eq 0 ]; then echo "OK"; else echo "FAIL"; fi
echo -n "| Setting icon theme as default..."
sudo gsettings set com.deepin.dde.appearance icon-theme "la-capitaine-icon-theme" >/dev/null 2>&1
if [ $? -eq 0 ]; then echo "OK"; else echo "FAIL"; fi
popd >/dev/null 2>&1
popd >/dev/null 2>&1

# Install Mojave GTK theme
echo "Installing UI theme..."
mkdir -p $HOME/.macos-transform >/dev/null 2>&1
pushd $HOME/.macos-transform >/dev/null 2>&1
echo -n "| Cloning repository..."
git clone https://github.com/vinceliuice/Mojave-gtk-theme.git >/dev/null 2>&1
if [ $? -eq 0 ]; then echo "OK"; else echo "FAIL"; fi
pushd Mojave-gtk-theme >/dev/null 2>&1
echo -n "| Installing UI theme..."
bash ./install.sh >/dev/null 2>&1
if [ $? -eq 0 ]; then echo "OK"; else echo "FAIL"; fi
popd >/dev/null 2>&1
popd >/dev/null 2>&1

# Patch GTK3 config
echo -n "Patching GTK3 configuration..."
echo -e "[Settings]\ngtk-theme-name=Mojave-dark\ngtk-icon-theme-name=la-capitaine-icon-theme\ngtk-decoration-layout=close,minimize,maximize:menu" > $HOME/.config/gtk-3.0/settings.ini
if [ $? -eq 0 ]; then echo "OK"; else echo "FAIL"; fi

# Patch Deepin window controls
echo -n "Patching Deepin window button layout..."
sudo gsettings set com.deepin.wrap.pantheon.desktop.gala.appearance button-layout "close,minimize,maximize:" >/dev/null 2>&1
if [ $? -eq 0 ]; then echo "OK"; else echo "FAIL"; fi

echo "That's it! Please log out and in again."
