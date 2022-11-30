" —— General setting ——————————————————————————————————————————————————————————
set hidden
set nocompatible
set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME
syntax on
set encoding=utf8
set number
set so=7
set cmdheight=2
set showmatch
set mat=2
set noerrorbells
set novisualbell
set t_vb=
set tm=500
set nowrap
set linebreak
set relativenumber
set nohlsearch
set backspace=indent,eol,start
set showmode
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set updatetime=300
set nowb
set signcolumn=yes
set smartcase
set colorcolumn=80

" —— Fatser redrawing
set ttyfast

" —— Setup indentation
set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set smartindent

" —— Remaps
noremap <silent> <C-s> :update<CR>
vnoremap <silent> <C-s> <C-C>:update<CR>
inoremap <silent> <C-s> <C-O>:update<CR>
inoremap <silent> <Esc> <Esc>`^
nnoremap <silent> <Esc> :nohl<CR>

" —— Leader
let mapleader=" "
let g:mapleader = " "

" —— VIm tabs
nmap <leader>t :enew<cr>
nmap <leader>l :bnext<CR>
nmap <leader>h :bprevious<CR>
nmap <leader>w :bp <BAR> bd #<CR>
nmap <leader>bl :ls<CR>

" —— Ignores ——————————————————————————————————————————————————————————————————
set wildmode=list:longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*/codemetrics/*
set wildignore+=*/target/*
set wildignore+=*/node_modules/*
set wildignore+=*/node/*
set wildignore+=*/.git/*
set wildignore+=*/.next/*
set wildignore+=*/.tmp/*
set incsearch
set scrolloff=8
set hlsearch
set ignorecase

" —— Delete trailing white space on save ——————————————————————————————————————
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite * :call DeleteTrailingWS()

" —— Spell checking ———————————————————————————————————————————————————————————
map <leader>ss :setlocal spell!<cr>

" —— Load closetag config —————————————————————————————————————————————————————
if filereadable(expand("$DOTFILES_DIR/vim/colsetag.vim"))
  source $DOTFILES_DIR/vim/colsetag.vim
endif

" —— Load COC config ——————————————————————————————————————————————————————————
if filereadable(expand("$DOTFILES_DIR/vim/coc.vim"))
  source $DOTFILES_DIR/vim/coc.vim
endif

" —— Load plugins —————————————————————————————————————————————————————————————
if filereadable(expand("$DOTFILES_DIR/vim/plugins.vim"))
  source $DOTFILES_DIR/vim/plugins.vim
endif

" —— Make sure syntax highlighting works well on large t/js(x) files ——————————
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

" —— Pluginsettings ———————————————————————————————————————————————————————————
" —— Prettier
let g:prettier#autoformat = 1
let g:prettier#config#use_tabs = 'true'
let g:prettier#config#single_quote = 'true'
let g:prettier#config#arrow_parens = 'always'
let g:prettier#config#trailing_comma = 'all'
let g:prettier#config#bracket_spacing = 'true'
let g:prettier#config#jsx_bracket_same_line = 'false'

" —— ALE
let g:ale_fix_on_save = 1

" —— delimitMate
imap <C-c> <CR><Esc>O

" —— tComment
map <leader>m <c-_><c-_>

" —— UtilSnips
let g:UltiSnipsExpandTrigger="<nop>"
let g:UltiSnipsJumpForwardTrigger="<nop>"
let g:UltiSnipsJumpBackwardTrigger="<nop>"
let g:UltiSnipsSnippetDirectories = [
\  $HOME.'/.vim/my-snippets/Ultisnips',
\  $DOTFILES_DIR.'/vim/UltiSnips/',
\  'UltiSnips'
\ ]

let g:UltiSnipsEditSplit="vertical"

" —— Hyperstyle
let g:hyperstyle_use_colon=0

" —— vim-jsx
let g:jsx_ext_required = 0
let g:vim_jsx_pretty_colorful_config = 1

" —— airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_theme='hybrid'

" —— NERDTree
nmap <leader>tt :NERDTreeToggle<cr>
nmap <leader>ff :NERDTreeFind<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let NERDTreeShowHidden=1
let NERDTreeRespectWildIgnore=0

" —— Vim Devicons
set guifont=3270MediumNerdFontC-Medium
let g:airline_powerline_fonts = 1

" —— Vim Markdown
autocmd BufNewFile,BufReadPost *.md set filetype=markdown wrap spell!

" -- FZF
set rtp+=user/local/opt/fzf
nnoremap <expr> <C-p> (len(system('git rev-parse')) ? ':Files' : ':GFiles --exclude-standard --others --cached')."\<cr>"
nnoremap <silent> <Leader>b :Buffers<CR>
nnoremap <silent> <Leader>F:Files<CR>
nnoremap <silent> <Leader>f :Ag<CR>
nnoremap <silent> <Leader>/ :BLines<CR>
nnoremap <silent> <Leader>' :Marks<CR>
nnoremap <silent> <Leader>g :Commits<CR>
nnoremap <silent> <Leader>H :Helptags<CR>
nnoremap <silent> <Leader>hh :History<CR>
nnoremap <silent> <Leader>h: :History:<CR>
nnoremap <silent> <Leader>h/ :History/<CR>
let g:fzf_preview_window = ['right:52%', 'ctrl-p']
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
let g:fzf_history_dir = '~/.local/share/fzf-history'
if has('nvim') && !exists('g:fzf_layout')
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
endif

" -- ack.vim
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
let g:ackprg = 'ag --nogroup --nocolor --column'

" –— Colorscheme ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
set t_Co=256
set cursorline
colorscheme gruvbox
let g:airline_theme='gruvbox'
let g:lightline = { 'colorscheme': 'gruvbox' }
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" –– Plugins runtimepath ––––––––––––––––––––––––––––––––––––––––––––––––––––––
" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall

" –– Helptags –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL

