#!/bin/zsh

# check and install devtools
sudo apt-get install build-essential
sudo apt-get install libssl-dev libffi-dev libncurses5-dev liblzma-dev zlib1g zlib1g-dev libreadline-dev libbz2-dev libsqlite3-dev make gcc
sudo apt-get install python-tk python3-tk tk-dev

# check and install zsh-autosuggestion
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# check and install zsh-autosuggestion
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# trash command is unusable in linux, so skip that part

# check and isntall direnv
if ! command -v direnv &> /dev/null; then
    export bin_path=/usr/bin
    curl -sfL https://direnv.net/install.sh | sudo bash

    mkdir -p ~/.config/direnv
    touch ~/.config/direnv/direnv.toml

    echo "[global]" >> ~/.config/direnv/direnv.toml
    echo "load_dotenv = true" >> ~/.config/direnv/direnv.toml
fi

# check and install pyenv/pyenv-virtualenv
# if [ ! -d "$HOME/.pyenv/" ]; then
#    curl https://pyenv.run | bash
# fi


# install needed version, e.g. Python 3.10.13 

    # pyenv install <3.10.13>
    # pyenv virtualenv <3.10.13> <my_venv> 
    # Set '.python-version' file
        # pyenv local <version/venv>

touch ~/.localrc

BASEDIR="$(cd "$(dirname "$0")" && pwd)"

typeset -A dirs_to_repos
dirs_to_repos=(
    ["$HOME/.zsh"]=".zsh"
    ["$HOME/.zshrc"]=".zshrc"
    ["$HOME/.zprofile"]=".zprofile"
    ["$HOME/.vimrc"]=".vimrc"
)

for dir repo in ${(kv)dirs_to_repos}; do
	# echo ${BASEDIR} $repo $dir
    if  [ -f "$dir" ] || [ -L "$dir" ];then
        rm -rf "$dir"
    fi
    ln -s "${BASEDIR}"/"$repo" "$dir"
done
