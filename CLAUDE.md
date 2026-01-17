# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository contains shell scripts and configuration files for provisioning a preferred Ubuntu development environment.

## Usage

Run the provisioning script to install applications and copy configuration files:

```bash
./profile.sh
```

The script requires sudo privileges and installs packages via apt and snap.

## Repository Structure

- `profile.sh` - Main provisioning script that installs applications (git, neovim, vim, tmux, alacritty, VSCode, Ghostty, rpi-imager) and copies configuration files
- `.config/` - Application configuration files that get copied to `~/.config/`
  - `ghostty/config` - Ghostty terminal configuration (uses Catppuccin Frappe theme)
