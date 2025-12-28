#!/bin/zsh

# check and install devtools
sudo apt install build-essential
sudo apt install libssl-dev libffi-dev libncurses5-dev liblzma-dev zlib1g zlib1g-dev libreadline-dev libbz2-dev libsqlite3-dev make gcc tk-dev

# trash command is unusable in linux, so skip that part

# cli tools installation
# bat, better cat
if ! command -v bat &> /dev/null; then
    sudo apt install bat
fi

# eza, better ls
if ! command -v eza &> /dev/null; then
    sudo apt install eza
fi

# zoxide, better cd
if ! command -v zoxide &> /dev/null; then
    sudo apt install zoxide
fi

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

# fastfetch, better neofetch
if ! command -v fastfetch &> /dev/null; then
    sudo add-apt-repository ppa:zhangsongcui3371/fastfetch
    sudo apt update
    sudo apt install fastfetch
fi

# fzf, fuzzy finder
if ! command -v fzf &> /dev/null; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
fi

# development tools

# uv
if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# ruff, python linter
if ! command -v ruff &> /dev/null; then
    sudo uv tool install ruff
fi

if ! command -v direnv &> /dev/null; then
    sudo apt install direnv
fi

# tmux
if ! command -v tmux &> /dev/null; then
    sudo apt install tmux
fi

# rust
if ! command -v rust &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# neovim related
if ! command -v nvim &> /dev/null; then
    sudo add-apt-repository ppa:neovim-ppa/unstable
    sudo apt update
    sudo apt install neovim
fi

# lazygit
if ! command -v lazygit &> /dev/null; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit -D -t /usr/local/bin/
fi

# tree-sitter-cli
if ! command -v tree-sitter &> /dev/null; then
    sudo apt install tree-sitter-cli
fi

touch ~/.localrc
