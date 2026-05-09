cl() {
    builtin cd "$@"
    ls -lah
}

rmds() {
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

_dev_project_completion() {
    local -a projects
    projects=(${(f)"$(ls -1 $DEV_DIR/)"})
    _describe 'projects' projects
}

compdef _dev_project_completion c
compdef _dev_project_completion nv
