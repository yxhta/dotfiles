return {
  { "github/copilot.vim", event = "InsertEnter" },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("lsp.lsp-config")
      require("lspconfig.ui.windows").default_options.border = require("lsp.ui").borders
    end,
  },

  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("lsp.none-ls")
    end,
  },

  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    config = function()
      require("fidget").setup({})
    end,
  },

  {
    "onsails/lspkind-nvim",
    lazy = true,
    config = function()
      require("lspkind").init({
        mode = "symbol_text",
        preset = "codicons",
      })
    end,
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
