#!/bin/sh

# This script provisions my preferred applications, configuration, and settings on Ubuntu.
# Author: Brian Reich
# Created: May 14, 2024

if command -v git > /dev/null 2>&1; then
    echo "git installed"
else
    sudo apt install -y git
fi

if command -v gh > /dev/null 2>&1; then
    echo "gh installed"
else
    sudo apt install -y gh
fi

if command -v nvim > /dev/null 2>&1; then
    echo "neovim installed"
else
    sudo apt install -y neovim
fi

if command -v vim > /dev/null 2>&1; then
    echo "vim installed"
else
    sudo apt install -y vim
fi

sudo apt install -y tmux
sudo apt install -y alacritty

# Install VSCode
sudo snap install code --classic

# Install FiraCode Nerd Font
FONT_DIR="$HOME/.local/share/fonts"
if [ -d "$FONT_DIR/FiraCodeNerdFont" ]; then
    echo "FiraCode Nerd Font installed"
else
    echo "Installing FiraCode Nerd Font..."
    mkdir -p "$FONT_DIR/FiraCodeNerdFont"
    FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
    curl -fsSL "$FONT_URL" -o /tmp/FiraCode.zip
    unzip -o /tmp/FiraCode.zip -d "$FONT_DIR/FiraCodeNerdFont"
    rm /tmp/FiraCode.zip
    fc-cache -fv
fi

# Install Ghostty
sudo snap install ghostty --classic
mkdir -p ~/.config/ghostty
cp "$(dirname "$0")/.config/ghostty/config" ~/.config/ghostty/config

# Install Starship prompt
sudo apt install -y starship

# Configure Starship with Catppuccin Frappe theme
mkdir -p ~/.config
cp "$(dirname "$0")/.config/starship.toml" ~/.config/starship.toml

# Add starship init to .bashrc if not already present
if ! grep -q 'eval "$(starship init bash)"' ~/.bashrc; then
    echo '' >> ~/.bashrc
    echo '# Initialize Starship prompt' >> ~/.bashrc
    echo 'eval "$(starship init bash)"' >> ~/.bashrc
fi

sudo apt install -y rpi-imager

# Install additional applications and developer tools
sh "$(dirname "$0")/scripts/install-apps.sh"

# Install and enable the SSH server, opened on the firewall
sh "$(dirname "$0")/scripts/install-ssh-server.sh"

# Optionally sync a user profile from another server
printf "Sync a user profile from another server? [y/N] "
read -r SYNC_PROFILE
case "$SYNC_PROFILE" in
    [Yy]*)
        printf "Source user: "
        read -r SOURCE_USER
        printf "Source server: "
        read -r SOURCE_SERVER
        printf "Destination user [%s]: " "$(whoami)"
        read -r DEST_USER
        DEST_USER="${DEST_USER:-$(whoami)}"
        sh "$(dirname "$0")/scripts/sync-profile.sh" \
            --source-user "$SOURCE_USER" \
            --source-server "$SOURCE_SERVER" \
            --dest-user "$DEST_USER"
        ;;
esac
