#!/bin/sh

# This script provisions my preferred applications, configuration, and settings on Ubuntu.
# Author: Brian Reich
# Created: May 14, 2024

if command -v git &>/dev/null; then
    echo "git installed"
else
    sudo apt install -y git
fi

if command -v nvim &>/dev/null; then
    echo "neovim installed"
else
    sudo apt install -y neovim
fi

if command -v vim &>/dev/null; then
    echo "vim installed"
else
    sudo apt install -y vim 
fi

sudo apt install -y tmux
sudo apt install -y alacritty

# Install VSCode
sudo snap install code --classic

# Install Ghostty
sudo snap install ghostty --classic
mkdir -p ~/.config/ghostty
cp "$(dirname "$0")/.config/ghostty/config" ~/.config/ghostty/config

sudo apt install -y rpi-imager
