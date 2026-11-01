local M = {}

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

    vim.bo[buf].swapfile = false
    vim.bo[buf].undofile = false
    vim.bo[buf].syntax = ""

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

---@param buf integer?
---@return boolean
function M.is_big(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  return vim.b[buf].bigfile == true or vim.bo[buf].filetype == "bigfile"
end

return M
