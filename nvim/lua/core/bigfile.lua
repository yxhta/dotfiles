-- 巨大ファイル対策。
--
-- 巨大リポジトリでは生成コード・ロックファイル・minify 済み JS などを開く機会が多く、
-- treesitter / LSP / indent guide / colorizer が同時に走って固まる。しきい値を超えた
-- バッファは filetype を "bigfile" に倒すことで、filetype ベースで動く仕組み
-- （treesitter、LSP、none-ls、colorizer など）をまとめて無効化する。

local M = {}

-- 1.5MB 超、または先頭付近に 5000 文字を超える行がある（minify 済み）と巨大とみなす。
M.max_size = 1.5 * 1024 * 1024
M.max_line_length = 5000

local uv = vim.uv or vim.loop

local function is_bigfile(path, buf)
  local stat = uv.fs_stat(path)
  if stat and stat.type == "file" and stat.size > M.max_size then
    return true
  end

  for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, 32, false)) do
    if #line > M.max_line_length then
      return true
    end
  end

  return false
end

-- priority を最大にして、拡張子ベースの判定より先に評価させる。
vim.filetype.add({
  pattern = {
    [".*"] = {
      function(path, buf)
        if not path or not buf or not vim.api.nvim_buf_is_valid(buf) then
          return
        end
        if is_bigfile(path, buf) then
          return "bigfile"
        end
      end,
      { priority = math.huge },
    },
  },
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("UserBigFile", { clear = true }),
  pattern = "bigfile",
  callback = function(args)
    local buf = args.buf
    vim.b[buf].bigfile = true

    -- 書き込み系のコストを落とす
    vim.bo[buf].swapfile = false
    vim.bo[buf].undofile = false
    -- syntax は filetype に追随するが "bigfile" 用の syntax ファイルは存在しないため、
    -- 結果として正規表現ハイライトは走らない。

    -- 描画系のコストを落とす
    vim.opt_local.wrap = false
    vim.opt_local.list = false
    vim.opt_local.spell = false
    vim.opt_local.conceallevel = 0
    vim.opt_local.foldmethod = "manual"
    vim.opt_local.cursorline = false

    vim.schedule(function()
      vim.notify(
        ("bigfile: %s はハイライトと LSP を無効化しました"):format(vim.fn.fnamemodify(args.file, ":t")),
        vim.log.levels.WARN
      )
    end)
  end,
})

--- バッファが巨大ファイルとして扱われているか。プラグイン側のガードから使う。
---@param buf integer?
---@return boolean
function M.is_big(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  return vim.b[buf].bigfile == true or vim.bo[buf].filetype == "bigfile"
end

return M
