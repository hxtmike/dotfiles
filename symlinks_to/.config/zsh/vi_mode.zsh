# vi mode — must be sourced after fzf to let bindkey -v take precedence
bindkey -v

zle-keymap-select() {
    if [[ $KEYMAP == vicmd ]]; then
        printf '\e[2 q'
    else
        printf '\e[6 q'
    fi
}
zle -N zle-keymap-select

_set_bar_cursor() { printf '\e[6 q' }
add-zsh-hook precmd _set_bar_cursor
