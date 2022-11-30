if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" –– Learn Vim ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
Plug 'ThePrimeagen/vim-be-good'

" –– Colorscheme ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
Plug 'gruvbox-community/gruvbox'   						    " Colorscheme

" –– Color utils ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
Plug 'chrisbra/Colorizer'					    		      " Color hex codes and color names

" –– Status bar enhancement –––––––––––––––––––––––––––––––––––––––––––––––––––
Plug 'vim-airline/vim-airline'				  	      " Shows additional informations in the status bar
Plug 'vim-airline/vim-airline-themes'		        " Use specific themes for the enhanced status bar

" –– Syntax highlighting ––––––––––––––––––––––––––––––––––––––––––––––––––––––
Plug 'othree/yajs.vim'							            " Enhances javascript syntax
Plug 'dense-analysis/ale' 						          " Syntax highlighting
Plug 'chemzqm/vim-jsx-improve'	  				      " Additional javascript highlighting
Plug 'elzr/vim-json'							            	" JSON highlighting
Plug 'othree/javascript-libraries-syntax.vim'		" Special highligh of known libraries
Plug 'pangloss/vim-javascript'					        " Syntax highlighting for javascript
Plug 'leafgarland/typescript-vim'					      " Syntax highlighting for typescript
Plug 'maxmellon/vim-jsx-pretty'	        				" Syntax highlighting for jsx
Plug 'rajasegar/vim-astro'						          " Syntax highlighting for astro
Plug 'styled-components/vim-styled-components'  " Syntax highlighting for styles-components

" –– Formatting –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
Plug 'prettier/vim-prettier'						        " Automatically format code based on rules

" –– Snippets –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
Plug 'SirVer/ultisnips'							            " Main snippets Plug
Plug 'honza/vim-snippets'							          " ultisnips plugins
Plug 'epilande/vim-es2015-snippets'				      " es2015
Plug 'epilande/vim-react-snippets'				      " React
Plug 'rstacruz/vim-hyperstyle'					        " Autocomplition for CSS
Plug 'joaohkfaria/vim-jest-snippets'				    " Snippets for styled components
Plug 'cristianoliveira/vim-react-html-snippets'	" html plugins for react
Plug 'adriaanzon/vim-emmet-ultisnips'				    " emmet Plug for ultispins

" –– Utilities ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
Plug 'tpope/vim-sensible'							          " Universal set of default for vim
Plug 'tpope/vim-surround'							          " Easier replacement of surrounding brackets and braces
Plug 'PeterRincker/vim-argumentative'				    " Allows changing the order of function arguments
Plug 'easymotion/vim-easymotion'					      " Easy and powerful motions for VIM
Plug 'Raimondi/delimitMate'						          " Auto add ending quotes/brackets/ets
Plug 'alvan/vim-closetag'							          " Auto close the tags
Plug 'tomtom/tcomment_vim'			                " Helps commenting in and out
Plug 'Galooshi/vim-import-js'						        " Auto import javascript files
Plug 'mileszs/ack.vim'			            				" Search within files

" –– Fuzzy Search –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" –– Intellisense –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
Plug 'neoclide/coc.nvim', { 'branch': 'release' }	" Suggestions
Plug 'iamcco/coc-tailwindcss',  {'do': 'yarn install --frozen-lockfile && yarn run build'}

" –– NERDTree –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
Plug 'scrooloose/nerdtree'						          " File structure tree/explorer
Plug 'jistr/vim-nerdtree-tabs'					        " Enables NERDTree in all tabs
Plug 'vim-ctrlspace/vim-ctrlspace'				      " Manages buffers
Plug 'Xuyuanp/nerdtree-git-plugin'	      			" Add Git status to the nerd tree

" –– Git ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
Plug 'airblade/vim-gitgutter'						        " Shows added/edited/removed lines of git
Plug 'tpope/vim-fugitive'							          " Allows git management from within vim

" –– Icons ––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
Plug 'ryanoasis/vim-devicons'						        " Adds octicons where possible
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'	" Adds colors to the icons

call plug#end()

