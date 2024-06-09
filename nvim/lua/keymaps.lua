local vim = vim
local g = vim.g
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
local copts = { noremap = true }

g.mapleader = " "

-- LSP
keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.format { async = true }<CR>", opts)

-- NvimTree
keymap("n", "<leader>n", "<cmd>NvimTreeToggle<CR>", copts)
keymap("n", "<leader>nf", "<cmd>NvimTreeFindFile<CR>", copts)

-- Telescope
local builtin = require('telescope.builtin')
keymap('n', '<leader>ff', builtin.find_files, { desc = "Telescope: Find files" })
vim.api.nvim_set_keymap("n", "<leader>f.", "<cmd>lua require'telescope'.extensions.file_browser.file_browser()<CR>",
    copts)
keymap("n", "<leader>fl", "<cmd>Telescope current_buffer_fuzzy_find<CR>", copts)
keymap("n", "<leader>fq", "<cmd>Telescope quickfix<CR>", copts)
keymap("n", "<leader>fh", "<cmd>Telescope oldfiles<CR>", copts)
keymap("n", "<leader>fr", "<cmd>Telescope frecency<CR>", copts)
keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", copts)
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", copts)
keymap("n", "<leader>fc", "<cmd>Telescope commands<CR>", copts)
keymap("n", "<leader>fc", builtin.commands, copts)
keymap("n", "<leader>ft", "<cmd>Telescope treesitter<CR>", copts)
keymap("n", "<leader>fj", "<cmd>Telescope jumplist<CR>", copts)
keymap("n", "<leader>T", "<cmd>Telescope<CR>", copts)
keymap("n", "<leader>z", "<cmd>Telescope spell_suggest<CR>", copts)
keymap("n", "<leader>fm", "<cmd>Telescope marks<CR>", copts)
keymap("n", '<leader>t"', "<cmd>Telescope registers<CR>", copts)

-- Trouble
keymap('n', '<leader>xt', '<cmd>Trouble<CR>', copts)
keymap("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>")
-- keymap("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>")
keymap('n', '<leader>xD', '<cmd>Trouble workspace_diagnostics<CR>', copts)
keymap('n', '<leader>xd', '<cmd>Trouble document_diagnostics<CR>', copts)
keymap('n', '<leader>xc', '<cmd>Trouble quickfix<CR>', copts)
keymap('n', '<leader>xl', '<cmd>Trouble loclist<CR>', copts)
keymap('n', '<leader>xr', '<cmd>Trouble lsp_references<CR>', copts)
keymap('n', '<leader>xn', '<cmd>lua pcall(require("trouble").next, {skip_groups = true, jump = true})<CR>', copts)
keymap('n', '<leader>xp', '<cmd>lua pcall(require("trouble").previous, {skip_groups = true, jump = true})<CR>', copts)
