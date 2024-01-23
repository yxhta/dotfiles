local null_ls = require("null-ls")

local sources = {
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.diagnostics.eslint.with({
        diagnostics_format = '[eslint] #{m}\n(#{c})'
    }),
    -- null_ls.builtins.diagnostics.golangci_lint,
    null_ls.builtins.code_actions.gitsigns,
    -- null_ls.builtins.completion.spell,
}
null_ls.setup({
    sources = sources,
    on_attach = require("lsp.lsp-config").on_attach,
    capabilities = require 'lsp.lsp-config'.capabilities,
    debug = false,
})
