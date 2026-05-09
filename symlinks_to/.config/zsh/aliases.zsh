alias fd='fd \
    --hidden \
    --exclude .git \
    --exclude node_modules \
    --exclude __pycache__ \
    --exclude venv'
alias f='fd'

alias rg='rg \
    --color=always \
    --line-number \
    --smart-case'

alias btop='btop \
    --force-utf'

if grep -qiE "microsoft|wsl" /proc/version &> /dev/null; then
    alias bat='batcat'
fi
alias cat='bat \
    --style=full \
    --paging=never'

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

alias cd='z'
alias cld='claude'
