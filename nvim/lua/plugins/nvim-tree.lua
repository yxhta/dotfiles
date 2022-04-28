local copts = { noremap = true }

require("nvim-tree").setup({})

-- vim.api.nvim_set_keymap("n", "<leader>n", "<cmd>NvimTreeOpen<CR>", copts)
vim.api.nvim_set_keymap("n", "<leader>n", "<cmd>NvimTreeToggle<CR>", copts)
vim.api.nvim_set_keymap("n", "<leader>nf", "<cmd>NvimTreeFindFile<CR>", copts)
