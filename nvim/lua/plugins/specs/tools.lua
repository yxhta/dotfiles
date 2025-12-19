return {
  {
    "majutsushi/tagbar",
    cmd = { "TagbarToggle" },
    keys = "<F8>",
    config = function()
      vim.api.nvim_set_keymap("n", "<F8>", "<cmd>TagbarToggle<CR>", { noremap = true })
    end,
  },

  {
    "simnalamburt/vim-mundo",
    cmd = { "MundoToggle" },
    keys = "<leader>mu",
    config = function()
      vim.api.nvim_set_keymap("n", "<leader>mu", "<cmd>MundoToggle<CR>", { noremap = true })
    end,
  },

  {
    "numToStr/FTerm.nvim",
    config = function()
      vim.api.nvim_set_keymap("n", "<leader>tt", "<cmd>lua require'FTerm'.toggle()<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<leader>tr", ":FTermRun ", { noremap = true })
    end,
  },

  {
    "chrisbra/unicode.vim",
    cmd = { "UnicodeName", "UnicodeTable", "UnicodeSearch" },
  },
}
