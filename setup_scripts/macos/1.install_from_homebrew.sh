#!/bin/zsh

set -e  # Exit on error

SCRIPT_DIR="${0:A:h}"  # Get script directory
echo "🚀 Starting macOS setup..."

# Install Rosetta for Apple Silicon
if [[ $(uname -p) == "arm" ]]; then
    echo "📦 Installing Rosetta 2..."
    softwareupdate --install-rosetta --agree-to-license
fi

# Check and install Homebrew
if ! command -v brew &> /dev/null; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Setup Homebrew dependencies
echo "🔧 Setting up Homebrew dependencies..."
sudo mkdir -p /usr/local/include /usr/local/lib
brew update

# Install packages from Brewfile
echo "📦 Installing packages from Brewfile..."
brew bundle --file="$SCRIPT_DIR/Brewfile"

# Setup LazyVim
echo "⚙️  Setting up LazyVim..."
NVIM_CONFIG_DIR="$HOME/.config/nvim"
if [ ! -f "$NVIM_CONFIG_DIR/init.lua" ] || ! grep -q "LazyVim" "$NVIM_CONFIG_DIR/init.lua" 2>/dev/null; then
    if [ -d "$NVIM_CONFIG_DIR" ]; then
        echo "📁 Backing up existing neovim config..."
        mv "$NVIM_CONFIG_DIR" "$NVIM_CONFIG_DIR.bak.$(date +%Y%m%d%H%M%S)"
    fi
    echo "📥 Cloning LazyVim starter..."
    git clone https://github.com/LazyVim/starter "$NVIM_CONFIG_DIR"
    rm -rf "$NVIM_CONFIG_DIR/.git"
fi

echo "✅ Setup complete!"

# sudo ln -s /opt/homebrew/bin/claude ~/.local/bin/claude
