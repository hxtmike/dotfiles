" Basics

syntax on
set nocompatible

    " show mode and command in the bottom
set showmode
set showcmd
    " enable mouse
set mouse=a

set encoding=utf-8  
set fileformat=unix
set t_Co=256

" indentation

set tabstop=4
set shiftwidth=4
    " convert all tab into spaces, since different editors show different indentation of tab
set expandtab
set softtabstop=4

" Appearance

    " Line number

set number

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

    " highline the cursorline
set cursorline

    " autowarp
set textwidth=80
set wrap
        " only warp when space/tab/etc..
set linebreak
set wrapmargin=2

    " scroll to top/bottom
set scrolloff=5

    " show status bar
set laststatus=2
    " show position of the curser
set  ruler


" Search

    " 光标遇到圆括号、方括号、大括号时，自动高亮对应的另一个圆括号、方括号和大括号。
set showmatch

    " 搜索时，高亮显示匹配结果。
set hlsearch

    " 输入搜索模式时，每输入一个字符，就自动跳到第一个匹配的结果。
set incsearch

    " 搜索时忽略大小写。
set ignorecase

" Editing

    " 自动切换工作目录。这主要用在一个 Vim 会话之中打开多个文件的情况，默认的工作目录是打开的第一个文件的目录。该配置可以将工作目录自动切换到，正在编辑的文件的目录。
set autochdir

    " bell
        " 出错时，不要发出响声。
set noerrorbells
        " 出错时，发出视觉提示，通常是屏幕闪烁。
set visualbell

    " Vim 需要记住多少次历史操作。
set history=1000

    " 打开文件监视。如果在编辑过程中文件发生外部改变（比如被别的编辑器编辑了），就会发出提示。
set autoread

    " 如果行尾有多余的空格（包括 Tab 键），该配置将让这些空格显示成可见的小方块。
" set listchars=tab:»■,trail:■
" set list

    " 命令模式下，底部操作指令按下 Tab 键自动补全。第一次按下 Tab，会显示所有匹配的操作指令的清单；第二次按下 Tab，会依次选择各个指令。
set wildmenu
set wildmode=longest:list,full
