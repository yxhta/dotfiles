-- Startup
-- require("impatient")
vim.loader.enable()

-- Disable netrw at the very start of your init.lua for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Leader must be set before lazy.nvim loads
vim.g.mapleader = " "

-- Core settings
require("core")

-- Plugins
require("plugins")

-- Key mappings (after plugins to ensure plugin modules are available)
require("core.keymaps")
