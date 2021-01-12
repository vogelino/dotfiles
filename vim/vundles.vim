
filetype off

set rtp+=$HOME/.vim/bundle/Vundle.vim
call vundle#begin("$HOME/.vim/bundle")

Plugin 'VundleVim/Vundle.vim'

" Colorscheme
Plugin 'kristijanhusak/vim-hybrid-material'			" Colorscheme

" Status bar enhancement
Plugin 'vim-airline/vim-airline'					" Shows additional informations in the status bar
Plugin 'vim-airline/vim-airline-themes'				" Use specific themes for the enhanced status bar

" Syntax highlighting
Plugin 'scrooloose/syntastic'						" Main syntax highlighting plugin
Plugin 'mtscout6/syntastic-local-eslint.vim'		" Enables use of local eslint
Plugin 'othree/yajs.vim'							" Enhances javascript syntax
Plugin 'chemzqm/vim-jsx-improve'					" Additional javascript highlighting
Plugin 'othree/es.next.syntax.vim'					" es2015 highlighting
Plugin 'elzr/vim-json'								" JSON highlighting
Plugin 'othree/javascript-libraries-syntax.vim'		" Special highligh of known libraries
Plugin 'wavded/vim-stylus'							" Syntax highlighting for stylus
Plugin 'leafgarland/typescript-vim'

" Formatting
Plugin 'prettier/vim-prettier'						" Automatically format code based on rules

" Snippets
Plugin 'SirVer/ultisnips'							" Main snippets plugin
Plugin 'honza/vim-snippets'							" ultisnips plugins
Plugin 'epilande/vim-es2015-snippets'				" es2015
Plugin 'epilande/vim-react-snippets'				" React
Plugin 'rstacruz/vim-hyperstyle'					" Autocomplition for CSS
Plugin 'joaohkfaria/vim-jest-snippets'				" Snippets for styled components
Plugin 'cristianoliveira/vim-react-html-snippets'	" html plugins for react

" Utilities
Plugin 'tpope/vim-sensible'							" Universal set of default for vim
Plugin 'tpope/vim-surround'							" Easier replacement of surrounding brackets and braces
Plugin 'PeterRincker/vim-argumentative'				" Allows changing the order of function arguments
Plugin 'easymotion/vim-easymotion'					" Easy and powerful motions for VIM
Plugin 'tomtom/tlib_vim'							" Some utility functions for VIM
Plugin 'Raimondi/delimitMate'						" Auto add ending quotes/brackets/ets
Plugin 'ctrlpvim/ctrlp.vim'							" Advanced fuzy file finder
Plugin 'tComment'									" Helps commenting in and out
Plugin 'terryma/vim-multiple-cursors'				" Enables mutiple cursors into 
Plugin 'Galooshi/vim-import-js'						" Auto import javascript files

" Markdown
Plugin 'suan/vim-instant-markdown'					" Live markdown preview for markdown in vim

" NERDTree
Plugin 'scrooloose/nerdtree'						" File structure tree/explorer
Plugin 'jistr/vim-nerdtree-tabs'					" Enables NERDTree in all tabs
Plugin 'Xuyuanp/nerdtree-git-plugin'				" Add Git status to the nerd tree

" Git
Plugin 'airblade/vim-gitgutter'						" Shows added/edited/removed lines of git
Plugin 'tpope/vim-fugitive'							" Allows git management from within vim

" Icons
Plugin 'ryanoasis/vim-devicons'						" Adds octicons where possible
Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'	" Adds colors to the icons

call vundle#end()
filetype plugin indent on
