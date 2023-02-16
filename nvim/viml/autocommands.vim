augroup AutoCommands
  " autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  " autocmd BufReadPost *
  "   \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
  "   \   exe "normal g`\"" |
  "   \ endif

  " Set syntax highlighting for specific file types
  " autocmd!
  " autocmd BufRead,BufNewFile *.md set filetype=markdown
  " autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
  " autocmd BufRead,BufNewFile aliases.local,zshrc.local,*/zsh/configs/* set filetype=sh
  " autocmd BufRead,BufNewFile gitconfig.local set filetype=gitconfig
  " autocmd BufRead,BufNewFile tmux.conf.local set filetype=tmux
  " autocmd BufRead,BufNewFile vimrc.local set filetype=vim
  " autocmd BufRead,BufNewFile *.tsx set filetype=typescript.tsx
  " autocmd BufRead,BufNewFile *.jsx set filetype=javascript.jsx
augroup END
