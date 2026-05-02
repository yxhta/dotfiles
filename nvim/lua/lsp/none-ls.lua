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

local function exe(name)
    return vim.fn.executable(name) == 1
end

local sources = {}
local function add_if(cond, src)
    if cond then
        table.insert(sources, src)
    end
end

if has_biome_config() then
    add_if(exe("biome"), null_ls.builtins.formatting.biome)
elseif exe("prettierd") then
    add_if(true, null_ls.builtins.formatting.prettierd)
else
    add_if(exe("prettier"), null_ls.builtins.formatting.prettier)
end

add_if(exe("goimports"), null_ls.builtins.formatting.goimports)
add_if(exe("gofmt"), null_ls.builtins.formatting.gofmt)
add_if(exe("golangci-lint"), null_ls.builtins.diagnostics.golangci_lint)
add_if(exe("staticcheck"), null_ls.builtins.diagnostics.staticcheck)

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
        if client:supports_method("textDocument/formatting") then
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
