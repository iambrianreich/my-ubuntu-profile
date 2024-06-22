#!/bin/sh

# This script provisions my preferred applications, configuration, and settings on Ubuntu.
# Author: Brian Reich
# Created: May 14, 2024

if command -v git &>/dev/null; then
    echo "git installed"
else
    apt install -y git
fi

if command -v nvim &>/dev/null; then
    echo "neovim installed"
else
    apt install -y neovim
fi

if command -v vim &>/dev/null; then
    echo "vim installed"
else
    apt install -y vim 
fi

apt install -y tmux
apt install -y alacritty

# Install VSCode
sudo snap install code --classic
