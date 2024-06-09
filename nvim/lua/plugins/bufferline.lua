require("bufferline").setup({
  options = {
    numbers = function(opts)
      return opts.id .. "."
    end,
    max_name_length = 30,
    right_mouse_command = "vertical sbuffer %d",
    show_close_icon = false,
    diagnostics = false,
    always_show_bufferline = true,
    modified_icon = "[+]",
    left_trunc_marker = "<",
    right_trunc_marker = ">",
    separator_style = "slant",
    offsets = { { filetype = "NvimTree" }, { filetype = "Vista" } },
    diagnostics_indicator = function(_, _, diagnostics_dict)
      local s = " "
      for e, n in pairs(diagnostics_dict) do
        local sym = e == "error" and " " or (e == "warning" and " " or "")
        s = s .. sym .. n
      end
      return s
    end,
  },
  highlights = {
    fill = { bg = { attribute = 'bg', highlight = 'Normal' } },
    separator = { fg = { attribute = "bg", highlight = 'Normal' } },
    separator_selected = { fg = { attribute = "bg", highlight = 'Normal' } },
    separator_visible = { fg = { attribute = "bg", highlight = 'Normal' } },
  }
})

vim.cmd [[
nnoremap <S-l> :BufferLineCycleNext<CR>
nnoremap <S-h> :BufferLineCyclePrev<CR>
]]
