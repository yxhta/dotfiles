local lspconfig = require("lspconfig")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

-----------------------
-- Handlers --
-----------------------
local handlers = {
  function(server_name) -- default handler
    require("lspconfig")[server_name].setup({})
  end,

  ["rust_analyzer"] = function()
    lspconfig.rust_analyzer.setup({
      settings = {
        ["rust-analyzer"] = {
          check = {
            command = "clippy",
          },
        },
      },
    })
  end,

  ["lua_ls"] = function()
    lspconfig.lua_ls.setup({
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    })
  end,
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

--------------
-- Mason --
--------------
mason.setup()
mason_lspconfig.setup({
  ensure_installed = { "lua_ls", "ts_ls" },
  handlers = handlers,
})
