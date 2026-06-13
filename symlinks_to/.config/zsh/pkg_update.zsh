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
        echo "✅ done"
    }
fi

pkg_update_daily() {
    local stamp="$HOME/.last_update_ts"
    local now=$(date +%s)
    local interval=$((7 * 24 * 60 * 60))

    if [[ -f "$stamp" ]]; then
        local last_ts=$(cat "$stamp")
        if (( now - last_ts < interval )); then
            echo "Updated within the last 7 days"
            return
        fi
    fi

    # Mark as run upfront so interruptions don't trigger a retry within the interval
    echo "$now" > "$stamp"
    pkg_update
}
