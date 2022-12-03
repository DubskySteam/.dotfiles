"
" -- NVIM CONFIG --
" Dotfiles: https://github.com/DubskySteam/.dotfiles
"
call plug#begin('~/AppData/Local/nvim/plugged')
" INFO BARS
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" THEMES
Plug 'joshdick/onedark.vim'
" File Browser + Icons
Plug 'junegunn/fzf', { 'do': {-> fzf#install() }}
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" GIT TOOLS
Plug 'tpope/vim-fugitive'
Plug 'itchyny/vim-gitbranch'
Plug 'apzelos/blamer.nvim'
Plug 'github/copilot.vim'
" COMPLETION & LANGUAGE SERVERS
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'rust-lang/rust.vim'
call plug#end()

"
" BASE SETTINGS
"
syntax enable
set encoding=UTF-8
filetype plugin indent on

"
" THEME SETTINGS
"
colorscheme onedark

"
" KEY MAPPINGS
"
nnoremap <F5> :tabnew<CR>
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-p> :Files<CR>

"
" PLUGIN SETTINGS
"

" Airline "
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_section_z = '%3p%%'
set t_Co=256

" Airline-Theme "
let g:airline_theme = 'onedark'

" GitLense "
let g:blamer_enabled = 1
