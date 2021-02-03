" —— General setting —————————————————————————————————————————————————————————
inoremap <silent> <Esc> <Esc>`^
set hidden
set nocompatible
set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME
syntax on
set encoding=utf8
let mapleader=","
let g:mapleader = ","
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
set backspace=indent,eol,start
set showmode
set noswapfile
set nobackup
set nowb

" —— CoC extensions
let g:coc_global_extensions = ['coc-tsserver', 'coc-tailwindcss']

" —— Fatser redrawing
set ttyfast

" —— Setup indentation
set tabstop=4
set shiftwidth=4

" -- Yank into the regular clipboard
set clipboard=unnamed

" —— VIm tabs
nmap <leader>T :enew<cr>
nmap <leader>l :bnext<CR>
nmap <leader>h :bprevious<CR>
nmap <leader>w :bp <BAR> bd #<CR>
nmap <leader>bl :ls<CR>

" —— Load plugins ———————————————————————————————————————————————————————————
if filereadable(expand("$DOTFILES_DIR/vim/vundles.vim"))
  source $DOTFILES_DIR/vim/vundles.vim
endif

" —— Ignores ————————————————————————————————————————————————————————————————
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
set hlsearch
set ignorecase

" —— Delete trailing white space on save ————————————————————————————————————
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()

" —— Spell checking —————————————————————————————————————————————————————————
map <leader>ss :setlocal spell!<cr>

" —— Pluginsettings —————————————————————————————————————————————————————————
" —— Prettier
let g:prettier#autoformat = 1
let g:prettier#config#use_tabs = 'true'
let g:prettier#config#single_quote = 'true'
let g:prettier#config#arrow_parens = 'always'
let g:prettier#config#trailing_comma = 'all'
let g:prettier#config#bracket_spacing = 'true'
let g:prettier#config#jsx_bracket_same_line = 'false'

" —— delimitMate
imap <C-c> <CR><Esc>O

" —— tComment ———————————————————————————————————————————————————————————————
map <leader>m <c-_><c-_>

" —— UtilSnips
let g:UltiSnipsExpandTrigger="<tab>"                                            
let g:UltiSnipsJumpForwardTrigger="<tab>"                                       
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsSnippetDirectories = [$HOME.'/.vim/my-snippets/Ultisnips', $DOTFILES_DIR.'/vim/UltiSnips/', 'UltiSnips']

let g:UltiSnipsEditSplit="vertical"

	" + Hyperstyle
	let g:hyperstyle_use_colon=0

" —— vim-jsx
let g:jsx_ext_required = 0

" —— airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_theme='hybrid'

" –— Colorscheme 
set background=dark
colorscheme hybrid_material
let g:enable_bold_font = 1
let g:enable_italic_font = 1
let g:hybrid_transparent_background = 1

" —— syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_loc_list_height = 5
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_error_symbol = '⊗'
let g:syntastic_style_error_symbol = '⊛'
let g:syntastic_warning_symbol = '⦾'
let g:syntastic_style_warning_symbol = '⦿'

highlight link SyntasticErrorSign SignColumn
highlight link SyntasticWarningSign SignColumn
highlight link SyntasticStyleErrorSign SignColumn
highlight link SyntasticStyleWarningSign SignColumn

" —— NERDTree
nmap <leader>tt :NERDTreeToggle<cr>
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
nnoremap <C-g> :Ag<Cr>
let g:fzf_preview_window = ['right:50%', 'ctrl-p']
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

	" -- Vim Closetag
" filenames like *.xml, *.html, *.xhtml, ...
" These are the file extensions where this plugin is enabled.
"
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.tsx,*.js,*.jsx'

" filenames like *.xml, *.xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.tsx,*.js,*.jsx'

" filetypes like xml, html, xhtml, ...
" These are the file types where this plugin is enabled.
"
let g:closetag_filetypes = 'html,xhtml,phtml,*.tsx,*.js,*.jsx'

" filetypes like xml, xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filetypes = 'xhtml,jsx,*.tsx,*.js,*.jsx'

" integer value [0|1]
" This will make the list of non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
"
let g:closetag_emptyTags_caseSensitive = 1

" dict
" Disables auto-close if not in a "valid" region (based on filetype)
"
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ }

" Shortcut for closing tags, default is '>'
"
let g:closetag_shortcut = '>'

" Add > at current position without closing the current tag, default is ''
"
let g:closetag_close_shortcut = '<leader>>'

