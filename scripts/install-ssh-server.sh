#!/bin/sh

# Installs and enables the OpenSSH server, and opens it on ufw if present.

if ! command -v sshd > /dev/null 2>&1; then
    sudo apt install -y openssh-server
fi

sudo systemctl enable --now ssh

if command -v ufw > /dev/null 2>&1; then
    sudo ufw allow OpenSSH
fi
