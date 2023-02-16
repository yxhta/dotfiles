-- TODO:
-- Try dap plugins

-- Startup
require("impatient")

-- Disable netrw at the very start of your init.lua for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Plugins
require("plugins")

-- Colorscheme
vim.opt.laststatus = 3
require("kanagawa").setup({
    dimInactive = true,
    globalStatus = true
})
vim.cmd("colorscheme nightfox")
require("colors").overrides()

vim.cmd("set clipboard+=unnamedplus")

require('lualine').setup()

-- General configurations
require("options")

-- Functions, Commands, Autocommands
vim.cmd("source ~/.config/nvim/viml/autocommands.vim")

-- Key mappings
vim.cmd("source ~/.config/nvim/viml/mappings.vim")
