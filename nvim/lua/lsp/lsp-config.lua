local lspconfig = require("lspconfig")
local navic = require("nvim-navic")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

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
-- Handlers --
-----------------------
local handlers = {
    function(server_name) -- default handler
        require("lspconfig")[server_name].setup {}
    end,

    ["rust_analyzer"] = function()
        lspconfig.rust_analyzer.setup {
            settings = {
                ["rust-analyzer"] = {
                    check = {
                        command = "clippy",
                    },
                },
            },
        }
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

local signature_help_config = {
    silent = true,
    max_height = 10,
    border = borders,
}

local hover_config = {
    border = borders,
}

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

---------------
-- On Attach --
---------------
local on_attach = function(client, bufnr)
    -- Setup nvim-navic
    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end
end

--------------
-- Mason --
--------------
mason.setup()
mason_lspconfig.setup({
    ensure_installed = { "lua_ls", "ts_ls" },
    handlers = handlers,
})

local M = {}
M.on_attach = on_attach
M.capabilities = capabilities
M.borders = borders
M.hover_config = hover_config
M.signature_help_config = signature_help_config
return M
