# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
export KEYTIMEOUT=1

# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"


# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    fzf-tab
    zsh-autosuggestions
    zsh-syntax-highlighting
    git 
    direnv 
)

source $ZSH/oh-my-zsh.sh

# open directory using file manager in different OS
if [[ "$(uname)" == "Darwin" ]]; then
    plugins+=(macos)
elif grep -qiE "microsoft|wsl" /proc/version &> /dev/null; then
    alias ofd="explorer.exe ."
fi


# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Docker CLI 
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
# already done by oh-my-zsh
fpath=(/Users/xiaotianhan/.docker/completions $fpath)
# End of Docker CLI completions

# Load env if available
source "$HOME/.local/bin/env"

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

# zoxide
eval "$(zoxide init zsh)"
alias cd='z'

# fzf
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


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# custom functions
cl() {
    builtin cd "$@";
    ls -lah
}

rmds() {
    # remove .DS_Store files or current directory
    rm -f .DS_Store
}

updates_all() {
  local stamp="$HOME/.last_update"
  local today=$(date +%Y-%m-%d)

  if [[ -f "$stamp" ]]; then
    local last_date=$(cat -pp "$stamp")
    if [[ "$last_date" == "$today" ]]; then
      echo "🍺 Homebrew already updated today"
      return
    fi
  fi

  echo "🍺 Updating Homebrew..."
  brew update
  echo "⬆️ Upgrading packages..."
  brew upgrade
  echo "🧹 Cleaning up..."
  brew cleanup
  echo "$today" > "$stamp"
  echo "✅ done"
}


# enable vi mode in zsh/conflict with fzf ** implementation
# bindkey -v

# load this script to have some local alias/functions
source ~/.localrc

updates_all

if [[ -o interactive ]]; then
    clear
    fastfetch
fi
