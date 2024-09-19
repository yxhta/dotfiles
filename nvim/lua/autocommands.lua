-- Create a new augroup
local augroup = vim.api.nvim_create_augroup("AutoCommands", { clear = true })

-- Set syntax highlighting for specific file types
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup,
  pattern = "*.xml.golden",
  command = "set filetype=xml"
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup,
  pattern = "*.json.golden",
  command = "set filetype=json"
})

-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--   group = autoCommandsGroup,
--   pattern = "*.md",
--   command = "set filetype=markdown"
-- })
--
-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--   group = autoCommandsGroup,
--   pattern = ".{jscs,jshint,eslint}rc",
--   command = "set filetype=json"
-- })
--
-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--   group = autoCommandsGroup,
--   pattern = "aliases.local,zshrc.local,*/zsh/configs/*",
--   command = "set filetype=sh"
-- })
--
-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--   group = autoCommandsGroup,
--   pattern = "gitconfig.local",
--   command = "set filetype=gitconfig"
-- })
--
-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--   group = autoCommandsGroup,
--   pattern = "tmux.conf.local",
--   command = "set filetype=tmux"
-- })
--
-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--   group = autoCommandsGroup,
--   pattern = "vimrc.local",
--   command = "set filetype=vim"
-- })
--
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup,
  pattern = "*.tsx",
  command = "set filetype=typescript.tsx"
})
--
-- vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
--   group = autoCommandsGroup,
--   pattern = "*.jsx",
--   command = "set filetype=javascript.jsx"
-- })
