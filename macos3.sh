#!/bin/zsh

# check and isntall direnv
if ! command -v direnv &> /dev/null; then
    brew install direnv

    mkdir -p ~/.config/direnv
    touch ~/.config/direnv/direnv.toml

    echo "[global]" >> ~/.config/direnv/direnv.toml
    echo "load_dotenv = true" >> ~/.config/direnv/direnv.toml
fi

# check and install pyenv
# if ! command -v pyenv &> /dev/null; then
#    brew install pyenv
#     brew install pyenv-virtualenv
# fi

# for dependency reasons
if ! command -v xz &> /dev/null; then
    brew install xz
fi

# create symlinks for those files
mkdir -p "$HOME/Library/Application Support/Code/User/"

touch ~/.localrc

BASEDIR="$(cd "$(dirname "$0")" && pwd)"

typeset -A dirs_to_repos
dirs_to_repos=(
    ["$HOME/.zsh"]=".zsh"
    ["$HOME/.zshrc"]=".zshrc"
    ["$HOME/.zprofile"]=".zprofile"
    ["$HOME/.vimrc"]=".vimrc"
    ["$HOME/Library/Application Support/Code/User/settings.json"]="./vscode/settings.json"
    ["$HOME/Library/Application Support/Code/User/keybindings.json"]="./vscode/keybindings.json"
)

for dir repo in ${(kv)dirs_to_repos}; do
	# echo ${BASEDIR} $repo $dir
    if  [ -f "$dir" ] || [ -L "$dir" ];then
        rm -rf "$dir"
    fi
    ln -s "${BASEDIR}"/"$repo" "$dir"
done

# macos setting
defaults write NSGlobalDomain ApplePressAndHoldEnabled -boolean false # press and hold disable
