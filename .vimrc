" Core

imap jj <Esc>
syntax enable
set incsearch
set number
set autoread " Auto-reload changed files
set ignorecase " ignore case in search
set smartcase " honor case if capital present
set noswapfile " Disable .swp files
set tabstop=2 " show existing tab with 2 spaces width
set shiftwidth=2 " when indenting with '>', use 2 spaces width
"set nofoldenable " Enables code folding
"set foldmethod=syntax
"set foldlevel=1

let mapleader = ","
nmap <Leader>e :e %:h<CR>


" Plugins

" plug
call plug#begin()
Plug 'elixir-editors/vim-elixir' " Elixir support for vim
Plug 'slashmili/alchemist.vim' " Elixir support for vim
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " fzf
Plug 'junegunn/fzf.vim' " fzf
Plug 'morhetz/gruvbox' " gruvbox colorscheme
call plug#end()

" Theme
set termguicolors
colorscheme gruvbox
set background=dark    " Setting dark mode

" alchemist
" let g:alchemist#elixir_erlang_src = "/usr/local/share/src"

" """""
" FZF
" """""
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -l ""'
" Default options are --nogroup --column --color
let s:ag_options = ' --hidden '
noremap <leader>t :Files<CR>
noremap <leader>r :Ag<CR>
noremap ; :Buffers<CR>

let g:fzf_history_dir = '~/.local/share/fzf-history'

" Customize fzf colors to match your color scheme
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

command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)

" Likewise, Files command with preview window
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
