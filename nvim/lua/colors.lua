local vim = vim

local M = {}

function M.get_color(hlgroup, attr)
  return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(hlgroup)), attr, 'gui')
end

vim.opt.background = "dark"

function M.overrides()
    local severity = vim.diagnostic.severity

    vim.diagnostic.config({
        signs = {
            text = {
                [severity.ERROR] = "",
                [severity.WARN] = "",
                [severity.INFO] = "",
                [severity.HINT] = "",
            },
        },
    })
end

return M
