if [[ "$(uname)" == "Darwin" ]]; then
    pkg_update() {
        echo "🍺 Updating Homebrew..."
        brew update
        echo "⬆️ Upgrading packages..."
        brew upgrade
        echo "📦 Upgrading cask apps..."
        brew upgrade --cask --greedy
        echo "🧹 Cleaning up..."
        brew cleanup
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
    local today=$(date +%Y-%m-%d)

    if [[ -f "$stamp" ]]; then
        local last_date=$(cat "$stamp")
        if [[ "$last_date" == "$today" ]]; then
            echo "Already updated today"
            return
        fi
    fi

    # Mark as run upfront so interruptions don't trigger a retry the same day
    echo "$today" > "$stamp"
    pkg_update
}
