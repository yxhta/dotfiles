vim.loader.enable()

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Leader must be set before lazy.nvim loads
vim.g.mapleader = " "

require("core.compat")

require("core")

require("plugins")

require("core.keymaps")
