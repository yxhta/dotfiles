local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
local copts = { noremap = true }
local clipboard_utils = require('utils.clipboard')

local function telescope_ext_call(ext, fn)
  local ok, telescope = pcall(require, 'telescope')
  if not ok then
    return
  end
  local extensions = telescope.extensions or {}
  if extensions[ext] and extensions[ext][fn] then
    extensions[ext][fn]()
  end
end


-- LSP
keymap("n", "gD", vim.lsp.buf.declaration, opts)
keymap("n", "gd", vim.lsp.buf.definition, opts)
keymap("n", "K", vim.lsp.buf.hover, opts)
keymap("n", "gi", vim.lsp.buf.implementation, opts)
keymap("n", "<C-k>", vim.lsp.buf.signature_help, opts)
keymap("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
keymap("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
keymap("n", "<space>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
keymap("n", "<space>D", vim.lsp.buf.type_definition, opts)
keymap("n", "<space>rn", vim.lsp.buf.rename, opts)
keymap("n", "<space>ca", vim.lsp.buf.code_action, opts)
keymap("n", "gr", vim.lsp.buf.references, opts)
keymap("n", "<space>e", vim.diagnostic.open_float, opts)
keymap("n", "[d", vim.diagnostic.goto_prev, opts)
keymap("n", "]d", vim.diagnostic.goto_next, opts)
keymap("n", "<space>q", vim.diagnostic.setloclist, opts)
keymap("n", "<space>f", function() vim.lsp.buf.format { async = true } end, opts)

-- NvimTree
keymap("n", "<leader>n", "<cmd>NvimTreeToggle<CR>", copts)
keymap("n", "<leader>nf", "<cmd>NvimTreeFindFile<CR>", copts)

-- Telescope
local builtin = require('telescope.builtin')
keymap('n', '<leader>ff', builtin.find_files, { desc = "Telescope: Find files" })
keymap('n', '<leader>f.', function() telescope_ext_call('file_browser', 'file_browser') end, copts)
keymap("n", "<leader>fl", clipboard_utils.copy_git_relative_path, { desc = "Copy git-relative path" })
keymap("n", "<leader>fq", builtin.quickfix, copts)
keymap("n", "<leader>fh", builtin.oldfiles, copts)
keymap("n", "<leader>fr", function()
  local ok, telescope = pcall(require, 'telescope')
  if ok and telescope.extensions and telescope.extensions.frecency then
    telescope.extensions.frecency.frecency()
  else
    builtin.oldfiles()
  end
end, copts)
keymap("n", "<leader>fb", builtin.buffers, copts)
keymap("n", "<leader>fg", builtin.live_grep, copts)
keymap("n", "<leader>fc", builtin.commands, copts)
keymap("n", "<leader>ft", builtin.treesitter, copts)
keymap("n", "<leader>fj", builtin.jumplist, copts)
keymap("n", "<leader>T", builtin.builtin, copts)
keymap("n", "<leader>z", builtin.spell_suggest, copts)
keymap("n", "<leader>fm", builtin.marks, copts)
keymap("n", '<leader>t"', builtin.registers, copts)

-- Trouble
keymap('n', '<leader>xt', '<cmd>Trouble<CR>', copts)
keymap("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>")
keymap('n', '<leader>xD', '<cmd>Trouble workspace_diagnostics<CR>', copts)
keymap('n', '<leader>xd', '<cmd>Trouble document_diagnostics<CR>', copts)
keymap('n', '<leader>xc', '<cmd>Trouble quickfix<CR>', copts)
keymap('n', '<leader>xl', '<cmd>Trouble loclist<CR>', copts)
keymap('n', '<leader>xr', '<cmd>Trouble lsp_references<CR>', copts)
keymap('n', '<leader>xn', '<cmd>lua pcall(require("trouble").next, {skip_groups = true, jump = true})<CR>', copts)
keymap('n', '<leader>xp', '<cmd>lua pcall(require("trouble").previous, {skip_groups = true, jump = true})<CR>', copts)

-- DAP
keymap("n", "<F5>", ":lua require'dap'.continue()<CR>", { silent = true })
keymap("n", "<F10>", ":lua require'dap'.step_over()<CR>", { silent = true })
keymap("n", "<F11>", ":lua require'dap'.step_into()<CR>", { silent = true })
keymap("n", "<F12>", ":lua require'dap'.step_out()<CR>", { silent = true })
keymap("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>", { silent = true })
keymap("n", "<leader>bc", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", { silent = true })
keymap("n", "<leader>l", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", { silent = true })

-- dap-ui key map
keymap("n", "<leader>d", ":lua require'dapui'.toggle()<CR>", { silent = true })
keymap("n", "<leader><leader>df", ":lua require'dapui'.eval()<CR>", { silent = true })

-- dap-go key map
keymap("n", "<leader>td", ":lua require'dap-go'.debug_test()<CR>", { silent = true })
