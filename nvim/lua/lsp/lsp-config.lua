local lspconfig = require("lspconfig")
local configs = require("lsp.servers")

local borders = {
  { "🭽", "FloatBorder" },
  { "▔", "FloatBorder" },
  { "🭾", "FloatBorder" },
  { "▕", "FloatBorder" },
  { "🭿", "FloatBorder" },
  { "▁", "FloatBorder" },
  { "🭼", "FloatBorder" },
  { "▏", "FloatBorder" },
}

-----------------------
-- Handlers override --
-----------------------

-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
--     silent = true,
--     max_height = "10",
--     border = borders,
-- })
--
-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
--     border = borders,
-- })
--
-- vim.lsp.util.close_preview_autocmd = function(events, winnr)
--     events = vim.tbl_filter(function(v)
--         return v ~= "CursorMovedI" and v ~= "BufLeave"
--     end, events)
--     vim.api.nvim_command(
--         "autocmd "
--             .. table.concat(events, ",")
--             .. " <buffer> ++once lua pcall(vim.api.nvim_win_close, "
--             .. winnr
--             .. ", true)"
--     )
-- end

------------------
-- Capabilities --
------------------

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

capabilities.textDocument.codeAction = {
  dynamicRegistration = true,
  codeActionLiteralSupport = {
    codeActionKind = {
      valueSet = (function()
        local res = vim.tbl_values(vim.lsp.protocol.CodeActionKind)
        table.sort(res)
        return res
      end)(),
    },
  },
}

-- capabilities.textDocument.completion.completionItem.workDoneProgress = true
-- capabilities.window.workDoneProgress = true

---------------
-- On Attach --
---------------

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  local opts = { noremap = true, silent = true }
  buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

--------------
-- LSP Installer --
--------------
local lsp_installer = require("nvim-lsp-installer")

-- lsp_installer.settings({
--   ui = {
--     icons = {
--       server_installed = "✓",
--       server_pending = "➜",
--       server_uninstalled = "✗"
--     }
--   },
--   sumneko_lua = {
--     cmd = {
--       "/usr/local/bin/lua-language-server",
--     },
--     settings = {
--       Lua = {
--         runtime = {
--           -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
--           version = "LuaJIT",
--           -- Setup your lua path
--           -- path = runtime_path,
--           path = vim.split(package.path, ';'),
--         },
--         diagnostics = {
--           enable = true,
--           -- Get the language server to recognize the `vim` global
--           globals = { "vim" },
--         },
--         workspace = {
--           -- Make the server aware of Neovim runtime files
--           library = vim.api.nvim_get_runtime_file("", true),
--         },
--         -- Do not send telemetry data containing a randomized but unique identifier
--         telemetry = {
--           enable = false,
--         },
--       },
--     },
--   }
-- })

lsp_installer.on_server_ready(function(server)
  local opts = {}
  opts.on_attach = on_attach

  server:setup(opts)
end)

for server, config in pairs(configs) do
  config.capabilities = capabilities
  config.on_attach = on_attach
  lspconfig[server].setup(config)
end

--------------
-- Commands --
--------------

M = {}
M.on_attach = on_attach
M.capabilites = capabilities
M.borders = borders
return M