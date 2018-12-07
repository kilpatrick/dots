set nocompatible              " be iMproved, required
filetype off                  " required

set mouse=a
set clipboard=unnamed

source ~/.vim/yang.vim
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
"CDK Plugin ':gmarik/Vundle.vim'

Bundle 'tpope/vim-fugitive'
Bundle 'tomasr/molokai'
Bundle 'tpope/vim-repeat'
Bundle 'kien/ctrlp.vim'
Bundle 'plasticboy/vim-markdown'
Bundle 'sjl/gundo.vim'
"Bundle 'Valloric/YouCompleteMe'
Bundle 'scrooloose/syntastic'
Bundle 'altercation/vim-colors-solarized'
Bundle 'wincent/Command-T'
Bundle 'Lokaltog/vim-distinguished'
Bundle 'bling/vim-airline'
Bundle 'scrooloose/nerdtree'
Bundle 'majutsushi/tagbar'
Bundle 'fatih/vim-go'
"Bundle 'Shougo/neocomplete'
Bundle 'jmcantrell/vim-virtualenv'
Bundle 'davidhalter/jedi-vim'
Bundle 'rust-lang/rust.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


""" Basics
syntax on                     " syntax highlighing
filetype on                   " try to detect filetypes
filetype plugin indent on     " enable loading indent file for filetype
set number                    " Display line numbers
set background=dark           " We are using dark background in vim
set title                     " show title in console title bar
set wildmenu                  " Menu completion in command mode on <Tab>
set wildmode=full             " <Tab> cycles between all matching choices.
set t_Co=256

" don't bell or blink
set noerrorbells
set vb t_vb=

" Disable the colorcolumn when switching modes.  Make sure this is the
" first autocmd for the filetype here
"autocmd FileType * setlocal colorcolumn=0

""" Moving Around/Editing
autocmd VimEnter * Tagbar
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

set cursorline              " have a line indicate the cursor location
set ruler                   " show the cursor position all the time
set nostartofline           " Avoid moving cursor to BOL when jumping around
set virtualedit=block       " Let cursor move past the last char in <C-v> mode
set scrolloff=3             " Keep 3 context lines above and below the cursor
set backspace=2             " Allow backspacing over autoindent, EOL, and BOL
set showmatch               " Briefly jump to a paren once it's balanced
set wrap                    " Wrap text
set linebreak               " don't wrap textin the middle of a word
set autoindent              " always set autoindenting on
set smartindent             " use smart indent if there is no indent file
set tabstop=4               " <tab> inserts 4 spaces
set shiftwidth=4            " And an indent level is 4 spaces wide.
set softtabstop=4           " <BS> over an autoindent deletes all spaces.
set expandtab               " Use spaces, not tabs, for autoindent/tab key.
set shiftround              " rounds indent to a multiple of shiftwidth
set formatoptions=tcroql    " Setting text and comment formatting to auto
set textwidth=80            " lines are automatically wrapped after 80 columns
set nofoldenable            " turn off folding
set colorcolumn=80          " highlight column 80 (where words will wrap)

"""" Reading/Writing
set autowriteall            " Don't bother me about changed buffers
set noautoread              " Don't automatically re-read changed files.
set modeline                " Allow vim options to be embedded in files;
set modelines=5             " they must be within the first or last 5 lines.

"""" Messages, Info, Status
set ls=2                    " allways show status line
set vb t_vb=                " Disable all bells.  I hate ringing/flashing.
set showcmd                 " Show incomplete normal mode commands as I type.
set report=0                " : commands always print changed line count.
set shortmess+=a            " Use [+]/[RO]/[w] for modified/readonly/written.
set ruler                   " Show some info, even without statuslines.
set laststatus=2            " Always show statusline, even if only 1 window.

""" Searching and Patterns
set ignorecase              " Default to using case insensitive searches,
set smartcase               " unless uppercase letters are used in the regex.
set hlsearch                " Highlight searches by default.
set incsearch               " Incrementally search while typing a /regex


""" Set color scheme
let g:distinguished_visibility = "high"
let g:distinguished_contrast = "high"
let g:distinguished_termcolors=256
colorscheme distinguished
"let g:solarized_visibility = "high"
""let g:solarized_contrast = "high"
"let g:solarized_termcolors=256
""colorscheme solarized
set background=dark

let NERDTreeQuitOnOpen = 1
map <silent> <C-n> :NERDTreeToggle<CR>


let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
autocmd FileType python setlocal omnifunc=jedi#completions
if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.python = '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
" alternative pattern: '\h\w*\|[^. \t]\.\w*'
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_cursor_hold_i = 1
let g:neocomplete#cursor_hold_i_time = 500 " in msec


let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
    \ }

hi Normal ctermbg=none

" YouCompleteMe
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
