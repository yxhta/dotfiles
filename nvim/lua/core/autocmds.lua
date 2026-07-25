local augroup = vim.api.nvim_create_augroup("UserAutoCommands", { clear = true })

-- Auto-read files when they are changed externally
--
-- 引数なしの :checktime は開いている全バッファを stat するため、巨大リポジトリで
-- バッファが増えるとカーソルを止めるたびに stat が大量発生する。アイドル時は
-- カレントバッファだけを確認し、全体の再確認はフォーカス復帰時に限定する。
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
