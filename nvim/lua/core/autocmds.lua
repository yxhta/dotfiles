local augroup = vim.api.nvim_create_augroup("UserAutoCommands", { clear = true })

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  group = augroup,
  pattern = "*",
  command = "checktime",
})

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  group = augroup,
  pattern = "*",
  callback = function(args)
    if vim.bo[args.buf].buftype == "" then
      vim.cmd("checktime " .. args.buf)
    end
  end,
})
