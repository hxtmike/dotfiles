if [[ "$(uname)" == "Darwin" ]]; then
    pkg_update() {
        echo "🍺 Updating Homebrew..."
        brew update
        echo "⬆️ Upgrading packages..."
        brew upgrade
        echo "📦 Upgrading cask apps..."
        brew upgrade --cask --greedy
        echo "🧹 Cleaning up..."
        brew cleanup --prune=all
        if command -v uv &> /dev/null; then
            echo "🐍 Upgrading uv tools..."
            uv tool upgrade --all
        fi
        echo "✅ done"
    }
elif grep -qiE "microsoft|wsl" /proc/version &> /dev/null; then
    pkg_update() {
        echo "📦 Updating APT cache..."
        sudo apt update
        echo "⬆️ Upgrading packages..."
        sudo apt upgrade -y
        echo "🧹 Cleaning up..."
        sudo apt autoremove -y
        sudo apt autoclean -y
        if command -v uv &> /dev/null; then
            echo "🐍 Upgrading uv tools..."
            uv tool upgrade --all
        fi
        echo "✅ done"
    }
fi

# Weekly, at shell startup (see run_every.zsh)
zsh_periodic+=("168 pkg_update")
