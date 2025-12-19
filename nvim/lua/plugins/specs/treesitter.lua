return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    dependencies = {
      "nvim-treesitter/playground",
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
      "RRethy/nvim-treesitter-textsubjects",
    },
    config = function()
      require("treesitter-config")
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("ibl").setup()
    end,
    event = "BufReadPost",
  },
}
