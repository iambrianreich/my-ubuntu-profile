# my-ubuntu-profile

Shell scripts and config files for provisioning my preferred Ubuntu development environment.

## Usage

```bash
./profile.sh
```

Requires sudo privileges. Installs packages via `apt` and `snap`, copies config files into `~/.config`, and near the end offers to sync a full user profile from another server onto this machine.

## What it installs

**`profile.sh`**
- git, gh, neovim, vim, tmux, alacritty
- VSCode (snap), Ghostty (snap) + its config
- FiraCode Nerd Font
- Starship prompt (Catppuccin Frappe theme) + `.bashrc` init
- rpi-imager

**`scripts/install-apps.sh`** (called automatically by `profile.sh`)
- apt: Google Chrome, Signal Desktop, Node.js (NodeSource), Apache/PHP/MySQL stack, Composer, Python (pip/pipenv), rclone, sqlite3, VLC, OBS Studio, OpenJDK 11, glabels, alien
- snap: Docker, Firefox, DataGrip, Obsidian, GIMP, Inkscape, LibreOffice, KeePassXC, Remmina, Telegram, Zoom, mpv, FreeCAD, Fusion 360, OpenRA
- upstream install scripts: Ollama, AWS CLI v2, signal-cli
- global npm/pip tool installs
- Bitwarden browser extension force-installed via Chrome/Firefox enterprise policy

## Profile sync

`profile.sh` will ask if you want to sync a user's full home directory from another server onto this machine (owner/permissions preserved). You'll be prompted for the source user, source server, and destination user (defaults to the current user).

Can also be run directly:

```bash
./scripts/sync-profile.sh --source-user USER --source-server HOST [--dest-user USER]
```

Requires SSH access from this machine to the source server, and sudo on both ends.

## Repository structure

- `profile.sh` — main provisioning script
- `scripts/install-apps.sh` — additional application/tool installs
- `scripts/sync-profile.sh` — remote home directory sync
- `.config/` — config files copied to `~/.config` (Ghostty, Starship)
