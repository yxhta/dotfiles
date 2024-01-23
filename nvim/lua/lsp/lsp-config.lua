local lspconfig = require("lspconfig")
-- local configs = require("lsp.servers")
local navic = require("nvim-navic")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

local borders = {
    { "🭽", "FloatBorder" },
    { "▔",  "FloatBorder" },
    { "🭾", "FloatBorder" },
    { "▕",  "FloatBorder" },
    { "🭿", "FloatBorder" },
    { "▁",  "FloatBorder" },
    { "🭼", "FloatBorder" },
    { "▏",  "FloatBorder" },
}

-----------------------
-- Handlers --
-----------------------
local handlers = {
    function(server_name) -- default handler
        require("lspconfig")[server_name].setup {}
    end,

    ["rust_analyzer"] = function()
        require("rust-tools").setup {}
    end,
    ["lua_ls"] = function()
        lspconfig.lua_ls.setup {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" }
                    }
                }
            }
        }
    end,
}

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    silent = true,
    max_height = "10",
    border = borders,
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = borders,
})

vim.lsp.util.close_preview_autocmd = function(events, winnr)
    events = vim.tbl_filter(function(v)
        return v ~= "CursorMovedI" and v ~= "BufLeave"
    end, events)
    vim.api.nvim_command(
        "autocmd "
        .. table.concat(events, ",")
        .. " <buffer> ++once lua pcall(vim.api.nvim_win_close, "
        .. winnr
        .. ", true)"
    )
end

------------------
-- Capabilities --
------------------
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

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

------------------
-- Formatting --
------------------
local lsp_formatting = function(bufnr)
    vim.lsp.buf.format({
        filter = function(client)
            return client.name ~= "tsserver"-- or client.name ~= "eslint"
        end,
        bufnr = bufnr,
    })
end

-- formatting on save
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

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
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.format { async = true }<CR>", opts)

    -- Formatting
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        -- vim.api.nvim_clear_autocmds({ buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                lsp_formatting(bufnr)
            end,
        })
    end

    -- Setup nvim-navic
    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end
end

-- for server, config in pairs(configs) do
--     config.capabilities = capabilities
--     config.on_attach = on_attach
--     lspconfig[server].setup(config)
-- end

--------------
-- Mason --
--------------
mason.setup()
mason_lspconfig.setup({
    ensure_installed = { "lua_ls", "tsserver" },
    handlers = handlers,
})

M = {}
M.on_attach = on_attach
M.capabilites = capabilities
M.borders = borders
return M
