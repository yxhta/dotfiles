return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
    },
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
    keys = { "<leader>n", "<leader>nf" },
    config = function()
      require("nvim-tree").setup({})
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    enabled = true,
    lazy = false,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim" },
      {
        "nvim-telescope/telescope-file-browser.nvim",
        config = function()
          require("telescope").load_extension("file_browser")
        end,
      },
      "nvim-telescope/telescope-dap.nvim",
    },
    config = function()
      require("plugins.telescope")

      require("telescope").load_extension("file_browser")
      -- require("telescope").load_extension("dap")
      -- require("telescope").load_extension("fzf")
      -- require("telescope").load_extension("frecency")
      -- require("telescope").load_extension("ui-select")
    end,
  },
}
