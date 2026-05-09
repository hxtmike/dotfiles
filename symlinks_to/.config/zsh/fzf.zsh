# Load fzf shell integration (key bindings and completion)
if [[ -d "$HOME/.fzf/bin" ]]; then
    [[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
fi
source <(fzf --zsh)

# Shared fd flags for fzf commands
FZF_FD_OPTS='--hidden --exclude .git --exclude node_modules --exclude __pycache__ --exclude .venv'

export FZF_DEFAULT_COMMAND="fd $FZF_FD_OPTS"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"

# fzf ** completion path generators
_fzf_compgen_path() {
    eval "fd $FZF_FD_OPTS . \"$1\""
}
_fzf_compgen_dir() {
    eval "fd --type=d $FZF_FD_OPTS . \"$1\""
}

export FZF_PREVIEW_OPTS='[ -d {} ] && eza --tree --color=always --level=3 {} | head -200 || bat --style=numbers --color=always --line-range :500 {} 2>/dev/null || echo "Cannot preview: {}"'
export FZF_STYLE_OPTS='--height=40% --layout=reverse --border'
export FZF_DEFAULT_OPTS="$FZF_STYLE_OPTS --preview='$FZF_PREVIEW_OPTS'"

_fzf_comprun() {
    local command=$1
    shift

    case "$command" in
        export|unset) fzf --preview "eval 'echo \$'{}"   "$@" ;;
        ssh)          fzf --preview 'dig {}'              "$@" ;;
        *)            fzf --preview "$FZF_PREVIEW_OPTS"   "$@" ;;
    esac
}

# fzf-tab: inherit style opts and use bat/eza for previews
zstyle ':fzf-tab:*' fzf-flags ${(z)FZF_STYLE_OPTS}
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --style=numbers --color=always --line-range :500 $realpath 2>/dev/null || eza --tree --color=always --level=2 $realpath 2>/dev/null'
