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

-----------------------------------
-- File watching (workspace/didChangeWatchedFiles) --
-----------------------------------
-- LSP サーバーが要求するファイル監視はワークスペース全体を再帰監視する。Neovim の
-- 既定の除外は .git/objects と node_modules/*/ だけなので、巨大リポジトリではビルド
-- 生成物や git 操作のイベントが大量にメインループへ流れ込み、体感が悪化する。
-- 監視しても意味のないディレクトリを除外する。private API なので pcall で保護する。
pcall(function()
  local watchfiles = require("vim.lsp._watchfiles")
  local glob = require("vim.glob")

  local excluded = {
    ".git",
    ".mypy_cache",
    ".next",
    ".pytest_cache",
    ".venv",
    "build",
    "dist",
    "node_modules",
    "target",
    "vendor",
  }

  local pattern = watchfiles._poll_exclude_pattern
  for _, dir in ipairs(excluded) do
    pattern = pattern + glob.to_lpeg("**/" .. dir .. "/**")
  end
  watchfiles._poll_exclude_pattern = pattern
end)

--------------
-- Mason --
--------------
mason.setup()
mason_lspconfig.setup({
  ensure_installed = { "lua_ls", "ts_ls" },
  handlers = handlers,
})
