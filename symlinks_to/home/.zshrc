export KEYTIMEOUT=1

export ZSH="$HOME/.oh-my-zsh"

HYPHEN_INSENSITIVE="true"
HIST_STAMPS="yyyy-mm-dd"

plugins=(
    fzf-tab
    zsh-autosuggestions
    zsh-syntax-highlighting
    direnv
)

source $ZSH/oh-my-zsh.sh

# Docker CLI 
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
# already done by oh-my-zsh
fpath=(/Users/xiaotianhan/.docker/completions $fpath)
# End of Docker CLI completions

# Load uv env script if installed via official installer (not needed for Homebrew installs)
[[ -f "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"

# uv related
eval "$(uv generate-shell-completion zsh)"

# fd
alias fd='fd \
    --hidden \
    --exclude .git \
    --exclude node_modules \
    --exclude __pycache__ \
    --exclude venv'
alias f='fd'

# ripgrep
alias rg='rg \
    --color=always \
    --line-number \
    --smart-case'

# btop
alias btop='btop \
    --force-utf'

# bat
if grep -qiE "microsoft|wsl" /proc/version &> /dev/null; then
    alias bat='batcat' 
fi
alias cat='bat \
    --style=full \
    --paging=never'

# eza
alias la='eza \
    --all \
    --long \
    --git \
    --group-directories-first \
    --color=always \
    --icons=always \
    --time-style=iso'
alias l='la --no-user --no-permissions'
alias ls='l'
alias lt='l --tree --level=2 | head -100'

alias cld='claude'

# fzf
# Add fzf if used as a git pager
if [[ -d "$HOME/.fzf/bin" ]]; then
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi
source <(fzf --zsh)
# fzf 统一的 fd 基础命令
FZF_FD_OPTS='--hidden --exclude .git --exclude node_modules --exclude __pycache__ --exclude .venv'
# fzf 命令配置
export FZF_DEFAULT_COMMAND="fd $FZF_FD_OPTS"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d" 

# fzf ** 补全函数
_fzf_compgen_path() {
    eval "fd $FZF_FD_OPTS . \"$1\""
}
_fzf_compgen_dir() {
  eval "fd --type=d $FZF_FD_OPTS . \"$1\""
}

# fzf 选项配置
export FZF_PREVIEW_OPTS='[ -d {} ] && eza --tree --color=always --level=3 {} | head -200 || bat --style=numbers --color=always --line-range :500 {} 2>/dev/null || echo "Cannot preview: {}"'
export FZF_STYLE_OPTS='--height=40% --layout=reverse --border'
export FZF_DEFAULT_OPTS="$FZF_STYLE_OPTS --preview='$FZF_PREVIEW_OPTS'"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$FZF_PREVIEW_OPTS" "$@" ;;
  esac
}

# 让 fzf-tab 使用 FZF_DEFAULT_OPTS 的设置
zstyle ':fzf-tab:*' fzf-flags ${(z)FZF_STYLE_OPTS}
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --style=numbers --color=always --line-range :500 $realpath 2>/dev/null || eza --tree --color=always --level=2 $realpath 2>/dev/null'

# disable auto update for claude, used homebrew to update
export DISABLE_AUTOUPDATER=1


eval "$(starship init zsh)"

# custom functions
cl() {
    builtin cd "$@";
    ls -lah
}

rmds() {
    # remove .DS_Store files or current directory
    rm -f .DS_Store
}

link_envrc() {
    ln -s ~/.config/direnv/.envrc ./.envrc
}

c() {
    if [ -z "$1" ]; then
        echo "project name cannot be empty"
        return 1
    fi
    code "$DEV_DIR/$1"
}

nv() {
    if [ -z "$1" ]; then
        echo "project name cannot be empty"
        return 1
    fi
    nvim "$DEV_DIR/$1"
}

# 为 c 函数添加自动补全
_dev_project_completion() {
    local -a projects
    projects=(${(f)"$(ls -1 $DEV_DIR/)"})
    _describe 'projects' projects
}

compdef _dev_project_completion c
compdef _dev_project_completion nv

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



# enable vi mode in zsh/conflict with fzf ** implementation
bindkey -v

# cursor shape: block in normal mode, bar in insert mode
zle-keymap-select() {
  if [[ $KEYMAP == vicmd ]]; then
    printf '\e[2 q'
  else
    printf '\e[6 q'
  fi
}
zle -N zle-keymap-select

# load this script to have some local alias/functions
source ~/.config/zsh/.localrc

# zoxide
eval "$(zoxide init zsh)"
alias cd='z'

# reset to bar cursor (insert mode) before each prompt
add-zsh-hook precmd _set_bar_cursor
_set_bar_cursor() { printf '\e[6 q' }

pkg_update_daily

if [[ -o interactive ]]; then
    clear
    fastfetch
fi

