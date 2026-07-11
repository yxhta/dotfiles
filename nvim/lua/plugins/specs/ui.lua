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
      vim.cmd("colorscheme kanagawa")
      require("colors").overrides()
    end,
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
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup()
    end,
  },

  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      require("plugins.dashboard")
    end,
  },

  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
    event = { "BufReadPost", "BufNewFile" },
  },
}
