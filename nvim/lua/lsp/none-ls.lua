local null_ls = require("null-ls")

local function has_biome_config()
    local biome_config_files = { ".biomerc", "biome.config.js", "biome.config.json", "biome.jsonc" }
    for _, file in ipairs(biome_config_files) do
        if vim.fn.filereadable(vim.fn.getcwd() .. "/" .. file) == 1 then
            return true
        end
    end
    return false
end

local sources = {
    has_biome_config() and null_ls.builtins.formatting.biome or null_ls.builtins.formatting.prettier,
    -- null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.formatting.goimports,
    null_ls.builtins.formatting.gofmt,
    null_ls.builtins.diagnostics.golangci_lint,
    null_ls.builtins.diagnostics.staticcheck
}

-- formatting on save
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- Formatter
local lsp_formatting = function()
    vim.lsp.buf.format({
        filter = function(client)
            return client.name == "null-ls"
        end,
        async = false
    })
end

null_ls.setup({
    sources = sources,
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    lsp_formatting(bufnr)
                end
            })
        end
    end,
    debug = false
})
