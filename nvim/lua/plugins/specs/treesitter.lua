return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
    },
    config = function()
      require("treesitter-config")
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("ibl").setup({
        -- 既定の除外リストに bigfile を足す（exclude はマージではなく置き換えのため再掲）。
        exclude = {
          filetypes = {
            "bigfile",
            "alpha",
            "checkhealth",
            "gitcommit",
            "help",
            "lspinfo",
            "man",
            "neo-tree",
            "TelescopePrompt",
            "TelescopeResults",
            "",
          },
          buftypes = { "nofile", "prompt", "quickfix", "terminal" },
        },
      })
    end,
    event = "BufReadPost",
  },
}
