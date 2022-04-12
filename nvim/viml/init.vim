set encoding=utf-8

" NVIM settings
let $XDG_VIM_HOME = $HOME.'/.config/vim'

set runtimepath+=$XDG_VIM_HOME
set runtimepath+=$XDG_VIM_HOME/after
set runtimepath+=$HOME/.fzf

" let g:python2_host_prog = '/usr/local/bin/python'
let g:python3_host_prog = '/usr/bin/python3'

" Leader
let mapleader = " "

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

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
" if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
"   syntax on
" endif

"if filereadable(expand("~/.vimrc.bundles"))
"  source ~/.vimrc.bundles
"endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
" if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
"   runtime! macros/matchit.vim
" endif

filetype plugin indent on

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd!
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
  autocmd BufRead,BufNewFile aliases.local,zshrc.local,*/zsh/configs/* set filetype=sh
  autocmd BufRead,BufNewFile gitconfig.local set filetype=gitconfig
  autocmd BufRead,BufNewFile tmux.conf.local set filetype=tmux
  autocmd BufRead,BufNewFile vimrc.local set filetype=vim
  autocmd BufRead,BufNewFile *.tsx set filetype=typescript.tsx
  " autocmd BufRead,BufNewFile *.jsx set filetype=javascript.jsx
augroup END

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

" Switch between the last two files
nnoremap <Leader><Leader> <C-^>

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Quicker window movement
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k
" nnoremap <C-h> <C-w>h
" nnoremap <C-l> <C-w>l

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

" fzf
" nnoremap <leader>o :Files<CR>
" nnoremap <leader>b :Buffer<CR>
" nnoremap <leader>h :History<CR>

" clipboard
" set clipboard+=unnamedplus
