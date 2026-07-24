#!/bin/sh

# Installs additional applications and developer tools found on this machine
# that aren't covered by the base packages in profile.sh.

BITWARDEN_SERVER_URL="https://vault.ccglabs.net"

# --- APT repositories ---

curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --yes --dearmor -o /usr/share/keyrings/google-chrome.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list > /dev/null
sudo apt update
sudo apt install -y google-chrome-stable

# Force-install Bitwarden extension for Chrome, pointed at our self-hosted server
sudo mkdir -p /etc/opt/chrome/policies/managed
sudo tee /etc/opt/chrome/policies/managed/bitwarden.json > /dev/null <<EOF
{
    "ExtensionInstallForcelist": [
        "nngceckbapebfimnlniiiahkandclblb;https://clients2.google.com/service/update2/crx"
    ],
    "3rdparty": {
        "extensions": {
            "nngceckbapebfimnlniiiahkandclblb": {
                "environment": {
                    "base": "${BITWARDEN_SERVER_URL}"
                }
            }
        }
    }
}
EOF

if ! command -v signal-desktop > /dev/null 2>&1; then
    curl -fsSL https://updates.signal.org/desktop/apt/keys.asc | sudo gpg --dearmor -o /usr/share/keyrings/signal-desktop-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main" | sudo tee /etc/apt/sources.list.d/signal-xenial.list > /dev/null
    sudo apt update
    sudo apt install -y signal-desktop
fi

if ! command -v node > /dev/null 2>&1; then
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
    sudo apt install -y nodejs
fi

# --- APT packages ---

sudo apt install -y \
    apache2 libapache2-mod-php \
    mysql-server \
    php php-cli php-mysql \
    composer \
    python3-pip pipenv \
    rclone \
    sqlite3 \
    vlc vlc-plugin-access-extra \
    obs-studio \
    openjdk-11-jre \
    glabels \
    alien

# --- Snaps ---

sudo snap install docker
sudo snap install firefox

# Force-install Bitwarden extension for Firefox, pointed at our self-hosted server
sudo mkdir -p /etc/firefox/policies
sudo tee /etc/firefox/policies/policies.json > /dev/null <<EOF
{
    "policies": {
        "ExtensionSettings": {
            "{446900e4-71c2-419f-a6a7-df9c091e268b}": {
                "install_url": "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi",
                "installation_mode": "force_installed"
            }
        },
        "3rdparty": {
            "Extensions": {
                "{446900e4-71c2-419f-a6a7-df9c091e268b}": {
                    "environment": {
                        "base": "${BITWARDEN_SERVER_URL}"
                    }
                }
            }
        }
    }
}
EOF
sudo snap install datagrip --classic
sudo snap install obsidian --classic
sudo snap install gimp
sudo snap install inkscape
sudo snap install libreoffice
sudo snap install keepassxc
sudo snap install remmina
sudo snap install telegram-desktop
sudo snap install zoom-client
sudo snap install mpv
sudo snap install freecad
sudo snap install fusion360 --edge --devmode
sudo snap install openra

# --- Tools installed via upstream install scripts ---

if ! command -v ollama > /dev/null 2>&1; then
    curl -fsSL https://ollama.com/install.sh | sh
fi

if ! command -v aws > /dev/null 2>&1; then
    curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
    unzip -o /tmp/awscliv2.zip -d /tmp
    sudo /tmp/aws/install
    rm -rf /tmp/awscliv2.zip /tmp/aws
fi

if ! command -v signal-cli > /dev/null 2>&1; then
    SIGNAL_CLI_VERSION=$(curl -fsSL https://api.github.com/repos/AsamK/signal-cli/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
    curl -fsSL "https://github.com/AsamK/signal-cli/releases/download/${SIGNAL_CLI_VERSION}/signal-cli-${SIGNAL_CLI_VERSION#v}.tar.gz" -o /tmp/signal-cli.tar.gz
    sudo tar xf /tmp/signal-cli.tar.gz -C /opt
    sudo ln -sf "/opt/signal-cli-${SIGNAL_CLI_VERSION#v}/bin/signal-cli" /usr/local/bin/signal-cli
    rm /tmp/signal-cli.tar.gz
fi

if command -v npm > /dev/null 2>&1; then
    sudo npm install -g @anthropic-ai/claude-code opencode-ai @mariozechner/pi-coding-agent openclaw
fi

if command -v pip3 > /dev/null 2>&1; then
    pip3 install --user python-dotenv fastapi httpx uvicorn
fi
