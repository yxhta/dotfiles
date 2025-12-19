local augroup = vim.api.nvim_create_augroup("UserAutoCommands", { clear = true })

-- Auto-read files when they are changed externally
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  group = augroup,
  pattern = '*',
  command = 'checktime',
})
