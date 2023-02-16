set encoding=utf-8

" NVIM settings
let $XDG_VIM_HOME = $HOME.'/.config/vim'

set runtimepath+=$XDG_VIM_HOME
set runtimepath+=$XDG_VIM_HOME/after
set runtimepath+=$HOME/.fzf

" let g:python2_host_prog = '/usr/local/bin/python'
let g:python_host_prog = '/usr/local/bin/python3'
let g:python3_host_prog = '/usr/local/bin/python3'

set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=1000
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands
set tw=0

"
" Vimrc
"
if &compatible
  set nocompatible
end

filetype plugin indent on

" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Use one space, not two, after punctuation.
set nojoinspaces
set colorcolumn=+1

" Numbers
set number
set numberwidth=4

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Always use vertical diffs
set diffopt+=vertical

" Color scheme
if (has('termguicolors'))
  set termguicolors
endif
" set background=light
" colorscheme kanagawa
" hi Normal guibg=NONE ctermbg=NONE
" hi LineNr ctermbg=NONE guibg=NONE

" Mute beep sound
set belloff=all

" NERDTree keymap
" nmap <leader>n :NERDTreeToggle<CR>
" let g:NERDTreeWinPos="right"

" Enable undo
if has('persistent_undo')
  set undodir=~/.vim/undo
  set undofile
endif

" clipboard
" set clipboard+=unnamedplus

