return {
  {
    "junegunn/vim-easy-align",
    config = function()
      vim.cmd("xmap ga <Plug>(EasyAlign)")
    end,
    cmd = "EasyAlign",
    keys = { "x", "ga" },
  },

  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup({ mappings = { extended = true } })
    end,
  },

  { "tpope/vim-surround" },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("plugins.autopairs")
    end,
  },

  { "wellle/targets.vim" },

  { "michaeljsmith/vim-indent-object" },

  { "tpope/vim-repeat" },
}
