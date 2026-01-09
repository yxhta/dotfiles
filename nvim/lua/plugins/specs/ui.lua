return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("colors")
      require("kanagawa").setup({
        transparent = true,
      })
      vim.cmd("colorscheme kanagawa-dragon")
      require("colors").overrides()
    end,
  },

  { "EdenEast/nightfox.nvim" },

  {
    "catppuccin/nvim",
    name = "catppuccin",
  },

  {
    "akinsho/nvim-bufferline.lua",
    event = { "VimEnter" },
    config = function()
      require("plugins.bufferline")
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup()
    end,
  },

  {
    "goolord/alpha-nvim",
    config = function()
      require("plugins.dashboard")
    end,
  },

  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
    event = "BufEnter",
  },
}
