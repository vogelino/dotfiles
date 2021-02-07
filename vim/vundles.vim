
filetype off

set rtp+=$HOME/.vim/bundle/Vundle.vim
call vundle#begin("$HOME/.vim/bundle")

Plugin 'VundleVim/Vundle.vim'

" Colorscheme
Plugin 'sonph/onehalf', { 'rtp': 'vim' }			" Colorscheme

" Color utils
Plugin 'chrisbra/Colorizer'							" Color hex codes and color names

" Status bar enhancement
Plugin 'vim-airline/vim-airline'					" Shows additional informations in the status bar
Plugin 'vim-airline/vim-airline-themes'				" Use specific themes for the enhanced status bar

" Syntax highlighting
Plugin 'scrooloose/syntastic'						" Main syntax highlighting plugin
Plugin 'mtscout6/syntastic-local-eslint.vim'		" Enables use of local eslint
" Plugin 'othree/yajs.vim'							" Enhances javascript syntax
Plugin 'chemzqm/vim-jsx-improve'					" Additional javascript highlighting
" Plugin 'othree/es.next.syntax.vim'					" es2015 highlighting
Plugin 'elzr/vim-json'								" JSON highlighting
Plugin 'othree/javascript-libraries-syntax.vim'		" Special highligh of known libraries
Plugin 'wavded/vim-stylus'							" Syntax highlighting for stylus
Plugin 'pangloss/vim-javascript'					" Syntax highlighting for javascript
Plugin 'leafgarland/typescript-vim'					" Syntax highlighting for typescript
Plugin 'maxmellon/vim-jsx-pretty'					" Syntax highlighting for jsx
Plugin 'jparise/vim-graphql'						" Syntax highlighting for graphql

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
Plugin 'alvan/vim-closetag'							" Auto close the tags
Plugin 'tComment'									" Helps commenting in and out
Plugin 'Galooshi/vim-import-js'						" Auto import javascript files
Plugin 'mileszs/ack.vim'							" Search within files

" Fuzzy Search
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'

" Intellisense
Plugin 'neoclide/coc.nvim', {'branch': 'release'}	" Suggestions
Plugin 'iamcco/coc-tailwindcss',  {'do': 'yarn install --frozen-lockfile && yarn run build'}

" NERDTree
Plugin 'scrooloose/nerdtree'						" File structure tree/explorer
Plugin 'jistr/vim-nerdtree-tabs'					" Enables NERDTree in all tabs
Plugin 'vim-ctrlspace/vim-ctrlspace'				" Manages buffers
Plugin 'Xuyuanp/nerdtree-git-plugin'				" Add Git status to the nerd tree

" Git
Plugin 'airblade/vim-gitgutter'						" Shows added/edited/removed lines of git
Plugin 'tpope/vim-fugitive'							" Allows git management from within vim

" Icons
Plugin 'ryanoasis/vim-devicons'						" Adds octicons where possible
Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'	" Adds colors to the icons

call vundle#end()
filetype plugin indent on
