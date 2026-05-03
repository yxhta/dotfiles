return {
  { "github/copilot.vim" },

  {
    "neovim/nvim-lspconfig",
    event = { "BufRead", "BufNewFile" },
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup()
      local lsp_ui = require("lsp.lsp-config")
      require("lspconfig.ui.windows").default_options.border = lsp_ui.borders
    end,
  },

  {
    "nvimtools/none-ls.nvim",
    lazy = false,
    config = function()
      require("lsp.none-ls")
    end,
  },

  {
    "j-hui/fidget.nvim",
    tag = 'legacy',
    config = function()
      require("fidget").setup({})
    end,
  },

  {
    "onsails/lspkind-nvim",
    config = function()
      require("lspkind").init({
        mode = "symbol_text",
        preset = "codicons",
      })
    end,
  },

  {
    "SmiteshP/nvim-navic",
    enabled = true,
    event = "BufReadPost",
    dependencies = "neovim/nvim-lspconfig",
  },

  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdLineEnter" },
    enabled = true,
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
    },
    config = function()
      require("plugins.cmp")
    end,
  },

  {
    "folke/trouble.nvim",
    cmd = { "Trouble", "TroubleToggle" },
    keys = "<leader>x",
    config = function()
      require("plugins.trouble")
    end,
  },

  {
    "liuchengxu/vista.vim",
    cmd = "Vista",
    keys = { { "<leader>vv", "<cmd>Vista!!<CR>" } },
    config = function()
      require("plugins.vista")
    end,
  },
}
