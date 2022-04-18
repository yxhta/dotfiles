-- TODO:
-- Try dap plugins

-- Startup
require("impatient")

-- Plugins
require("plugins")

-- Colorscheme
vim.opt.laststatus = 3
require("kanagawa").setup({
  dimInactive = true,
  globalStatus = true
})
vim.cmd("colorscheme kanagawa")
require("colors").overrides()

vim.cmd("set clipboard+=unnamedplus")

require('lualine').setup()

-- general configurations
require("options")

-- Functions, Commands, Autocommands
vim.cmd("source ~/.config/nvim/viml/autocommands.vim")

-- Mappings
vim.cmd("source ~/.config/nvim/viml/mappings.vim")
