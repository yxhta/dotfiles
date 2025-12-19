return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      require("gitsigns").setup()
    end,
  },

  { "sindrets/diffview.nvim", dependencies = "nvim-lua/plenary.nvim" },

  { "tpope/vim-fugitive" },
  { "tpope/vim-rhubarb" },
}
