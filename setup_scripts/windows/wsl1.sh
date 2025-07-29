#!/bin/zsh

# check and install devtools
sudo apt-get install build-essential
sudo apt-get install libssl-dev libffi-dev libncurses5-dev liblzma-dev zlib1g zlib1g-dev libreadline-dev libbz2-dev libsqlite3-dev make gcc
sudo apt-get install python-tk python3-tk tk-dev

# trash command is unusable in linux, so skip that part

# fd, better find
if ! command -v fd &> /dev/null; then
    sudo apt install fd-find
fi

# ripgrep, better grep
if ! command -v rg &> /dev/null; then
    sudo apt install ripgrep
fi

# btop, better top
if ! command -v btop &> /dev/null; then
    sudo apt install btop
fi

# bat, better cat
if ! command -v bat &> /dev/null; then
    sudo apt install bat
fi

# eza, better ls
if ! command -v eza &> /dev/null; then
    sudo apt install -y gpg
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza
fi

# zoxide, better cd
if ! command -v zoxide &> /dev/null; then
    sudo apt install zoxide
fi

# tmux
if ! command -v tmux &> /dev/null; then
    sudo apt install tmux
fi

# fzf, fuzzy finder
if ! command -v fzf &> /dev/null; then
    sudo apt install fzf
fi

# check and isntall direnv
if ! command -v direnv &> /dev/null; then
    export bin_path=/usr/bin
    curl -sfL https://direnv.net/install.sh | sudo bash
fi

# uv
if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# ruff, python linter
if ! command -v ruff &> /dev/null; then
    sudo uv tool install ruff
fi


touch ~/.localrc
