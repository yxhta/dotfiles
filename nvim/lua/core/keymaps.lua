local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
local copts = { noremap = true }
local lsp_ui = require("lsp.ui")
local unpack = unpack or table.unpack

local function telescope_ext_call(ext, fn)
  local ok, telescope = pcall(require, "telescope")
  if not ok then
    return
  end
  local extensions = telescope.extensions or {}
  if extensions[ext] and extensions[ext][fn] then
    extensions[ext][fn]()
  end
end

local function lsp_buf_call(fn, ...)
  local args = { ... }
  return function()
    vim.lsp.buf[fn](unpack(args))
  end
end

keymap("n", "gD", lsp_buf_call("declaration"), opts)
keymap("n", "gd", lsp_buf_call("definition"), opts)
keymap("n", "K", function()
  vim.lsp.buf.hover(lsp_ui.hover_config)
end, opts)
keymap("n", "gi", lsp_buf_call("implementation"), opts)
keymap("n", "<C-k>", function()
  vim.lsp.buf.signature_help(lsp_ui.signature_help_config)
end, opts)
keymap("n", "<space>wa", lsp_buf_call("add_workspace_folder"), opts)
keymap("n", "<space>wr", lsp_buf_call("remove_workspace_folder"), opts)
keymap("n", "<space>wl", function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, opts)
keymap("n", "<space>D", lsp_buf_call("type_definition"), opts)
keymap("n", "<space>rn", lsp_buf_call("rename"), opts)
keymap("n", "<space>ca", lsp_buf_call("code_action"), opts)
keymap("n", "gr", lsp_buf_call("references"), opts)
keymap("n", "<space>e", vim.diagnostic.open_float, opts)
keymap("n", "[d", vim.diagnostic.goto_prev, opts)
keymap("n", "]d", vim.diagnostic.goto_next, opts)
keymap("n", "<space>q", vim.diagnostic.setloclist, opts)
keymap("n", "<space>f", function()
  vim.lsp.buf.format({
    async = true,
    filter = function(client)
      return client.name ~= "ts_ls"
    end,
  })
end, opts)

keymap("n", "<leader>n", "<cmd>Neotree toggle<CR>", copts)
keymap("n", "<leader>nf", "<cmd>Neotree reveal<CR>", copts)

keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Telescope: Find files" })
keymap("n", "<leader>f.", function()
  telescope_ext_call("file_browser", "file_browser")
end, copts)
keymap("n", "<leader>fl", function()
  require("utils.clipboard").copy_git_relative_path()
end, { desc = "Copy git-relative path" })
keymap("n", "<leader>fq", "<cmd>Telescope quickfix<CR>", copts)
keymap("n", "<leader>fh", "<cmd>Telescope oldfiles<CR>", copts)
keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", copts)
keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", copts)
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", copts)
keymap("n", "<leader>fc", "<cmd>Telescope commands<CR>", copts)
keymap("n", "<leader>ft", "<cmd>Telescope treesitter<CR>", copts)
keymap("n", "<leader>fj", "<cmd>Telescope jumplist<CR>", copts)
keymap("n", "<leader>T", "<cmd>Telescope builtin<CR>", copts)
keymap("n", "<leader>z", "<cmd>Telescope spell_suggest<CR>", copts)
keymap("n", "<leader>fm", "<cmd>Telescope marks<CR>", copts)
keymap("n", '<leader>t"', "<cmd>Telescope registers<CR>", copts)
