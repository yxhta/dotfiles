local M = {}

local function notify(msg, level)
    vim.notify(msg, level or vim.log.levels.INFO)
end

function M.copy_git_relative_path()
    local filepath = vim.api.nvim_buf_get_name(0)
    if filepath == "" then
        notify("No file associated with this buffer", vim.log.levels.WARN)
        return
    end

    local file_dir = vim.fn.fnamemodify(filepath, ":h")
    local git_root_cmd = string.format("git -C %s rev-parse --show-toplevel", vim.fn.shellescape(file_dir))
    local git_root_output = vim.fn.systemlist(git_root_cmd)

    if vim.v.shell_error ~= 0 or not git_root_output[1] or git_root_output[1] == "" then
        notify("Unable to find git root", vim.log.levels.ERROR)
        return
    end

    local prefix_cmd = string.format("git -C %s rev-parse --show-prefix", vim.fn.shellescape(file_dir))
    local prefix_output = vim.fn.systemlist(prefix_cmd)

    if vim.v.shell_error ~= 0 or prefix_output == nil then
        notify("Unable to resolve git-relative path", vim.log.levels.ERROR)
        return
    end

    local relative_dir = prefix_output[1] or ""
    local filename = vim.fn.fnamemodify(filepath, ":t")
    local relative_path = relative_dir ~= "" and (relative_dir .. filename) or filename

    vim.fn.setreg('+', relative_path)
    vim.fn.setreg('*', relative_path)
    notify("Copied git-relative path: " .. relative_path)
end

return M
