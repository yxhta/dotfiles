local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

-- bootstap
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({
    "git",
    "clone",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  execute("packadd packer.nvim")
end

-- autocompile
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

require("packer").init({
  max_jobs = 50,
})

return require("packer").startup(function(use)
  use({ "wbthomason/packer.nvim" })

  use({ "nvim-lua/plenary.nvim" })

  use({ "nvim-lua/popup.nvim" })

  use({ "lewis6991/impatient.nvim" })

  use({ "dstein64/vim-startuptime" })

  use("nathom/filetype.nvim")

  --------------------------------------------
  -- LSP, Diagnostics, Snippets, Completion --
  --------------------------------------------

  use({
    "neovim/nvim-lspconfig",
    config = function()
      require("lsp.lsp-config")
    end,
  })

  use({ 'williamboman/nvim-lsp-installer' })

  use({
    "jose-elias-alvarez/null-ls.nvim",
    after = "nvim-lspconfig",
    config = function()
      require("lsp.null-ls")
    end,
  })

  use({
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup({})
    end,
  })

  use({
    "onsails/lspkind-nvim",
    config = function()
      require("lspkind").init({
        mode = "symbol_text",
        preset = "codicons",
      })
    end,
  })

  use({
    "SmiteshP/nvim-gps",
    after = { "nvim-treesitter", "lspkind-nvim" },
    config = function()
      local getkind = function(kind)
        local kinds = vim.lsp.protocol.CompletionItemKind
        return kinds[kinds[kind]]:match("^.*%s")
      end
      require("nvim-gps").setup({
        icons = {
          ["class-name"] = getkind("Class"),
          ["function-name"] = getkind("Function"),
          ["method-name"] = getkind("Method"),
          ["container-name"] = getkind("Enum"),
          -- ["tag-name"] = ' '
        },
      })
    end,
  })

  use({
    "hrsh7th/nvim-cmp",
    config = function()
      require("plugins.cmp")
    end,
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      {
        "uga-rosa/cmp-dictionary",
        config = function()
          require("cmp_dictionary").setup({
            dic = {
              ["*"] = "/usr/share/dict/words",
            },
          })
        end,
      },
      "kdheepak/cmp-latex-symbols",
      "dmitmel/cmp-cmdline-history",
      "andersevenrud/cmp-tmux",
      "quangnguyen30192/cmp-nvim-ultisnips",
    },
  })

  use({
    "SirVer/ultisnips",
    requires = "honza/vim-snippets",
    config = function()
      vim.opt.rtp:append({ vim.fn.stdpath("data") .. "/site/pack/packer/start/vim-snippets" })
      vim.g.UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
      vim.g.UltiSnipsJumpForwardTrigger = "<Plug>(ultisnips_jump_forward)"
      vim.g.UltiSnipsJumpBackwardTrigger = "<Plug>(ultisnips_jump_backward)"
      vim.g.UltiSnipsListSnippets = "<c-x><c-s>"
      vim.g.UltiSnipsRemoveSelectModeMappings = 0
    end,
  })

  use({
    "folke/trouble.nvim",
    config = function()
      require("plugins.trouble")
    end,
  })

  use({
    "liuchengxu/vista.vim",
    cmd = "Vista",
    keys = "<leader>vv",
    config = function()
      require("plugins.vista")
    end,
  })
  use({
    "danymat/neogen",
    config = function()
      require("neogen").setup({})
    end,
    cmd = "Neogen",
  })

  -- -------------------
  -- Syntax and Folds --
  ----------------------

  use({ "chrisbra/vim-zsh" })

  use({
    "andymass/vim-matchup",
    config = function()
      vim.g.matchup_override_vimtex = 1
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_offscreen = {
        method = "popup",
      }
    end,
  })

  use({
    "chrisbra/csv.vim",
    cmd = "CSVInit",
  })

  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require("treesitter-config")
    end,
  })

  use({
    "nvim-treesitter/playground",
    after = "nvim-treesitter",
    cmd = "TSPlaygroundToggle",
  })

  use({
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
  })

  use({
    "RRethy/nvim-treesitter-textsubjects",
    after = "nvim-treesitter",
  })

  use({
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("plugins.indent-blankline")
    end,
    event = "BufEnter",
  })

  -------------------------
  -- File, Fuzzy Finders --
  -------------------------

  use({
    "kyazdani42/nvim-tree.lua",
    config = function()
      require("plugins.nvim-tree")
    end,
  })

  use({
    "nvim-telescope/telescope.nvim",
    config = function()
      require("plugins.telescope")
    end,
  })

  use({
    "nvim-telescope/telescope-file-browser.nvim",
    config = function()
      require("telescope").load_extension("file_browser")
    end,
  })

  -- use({
  --     "nvim-telescope/telescope-dap.nvim",
  --     after = { "telescope.nvim", "nvim-dap" },
  --     config = function()
  --         require("telescope").load_extension("dap")
  --     end,
  -- })

  use({
    "nvim-telescope/telescope-fzf-native.nvim",
    after = "telescope.nvim",
    run = "make",
    config = function()
      require("telescope").load_extension("fzf")
    end,
  })

  -------------------------------------------
  -- Colors, Icons, StatusLine, BufferLine --
  -------------------------------------------

  use({ "rebelot/kanagawa.nvim", branch = "master" })

  use({
    "kyazdani42/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup()
    end,
  })

  use({
    "catppuccin/nvim",
    as = "catppuccin",
  })

  use({
    "akinsho/nvim-bufferline.lua",
    event = { "VimEnter" },
    config = function()
      require("plugins.bufferline")
    end,
  })

  --------------------------
  -- Editor Utilities, UI --
  --------------------------

  -- use({
  --     "mfussenegger/nvim-dap",
  --     config = function()
  --         require("dap-config")
  --     end,
  -- })

  -- use({
  --     "jbyuki/one-small-step-for-vimkind",
  --     config = function()
  --         local dap = require("dap")
  --         dap.configurations.lua = {
  --             {
  --                 type = "nlua",
  --                 request = "attach",
  --                 name = "Attach to running Neovim instance",
  --                 host = function()
  --                     local value = vim.fn.input("Host [127.0.0.1]: ")
  --                     if value ~= "" then
  --                         return value
  --                     end
  --                     return "127.0.0.1"
  --                 end,
  --                 port = function()
  --                     local val = tonumber(vim.fn.input("Port: "))
  --                     assert(val, "Please provide a port number")
  --                     return val
  --                 end,
  --             },
  --         }
  --
  --         dap.adapters.nlua = function(callback, config)
  --             callback({ type = "server", host = config.host, port = config.port })
  --         end
  --     end,
  -- })

  -- use({
  --     "rcarriga/vim-ultest",
  --     requires = { "vim-test/vim-test" },
  --     run = ":UpdateRemotePlugins",
  --     config = function()
  --         require("plugins.ultest")
  --     end,
  -- })

  -- use({
  --     "mfussenegger/nvim-dap-python",
  --     after = "nvim-dap",
  --     ft = "python",
  --     config = function()
  --         require("dap-python").setup("~/venvs/debugpy/bin/python")
  --         require("dap-python").test_runner = "pytest"
  --     end,
  -- })

  -- use({
  --     "theHamsta/nvim-dap-virtual-text",
  --     after = "nvim-dap",
  --     config = function()
  --         require("nvim-dap-virtual-text").setup({
  --             enabled = true, -- enable this plugin (the default)
  --             enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
  --             highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
  --             highlight_new_as_changed = true, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
  --             show_stop_reason = true, -- show stop reason when stopped for exceptions
  --             commented = false, -- prefix virtual text with comment string
  --             -- experimental features:
  --             virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
  --             all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
  --             virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
  --             virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
  --         })
  --     end,
  -- })

  -- use({
  --     "rcarriga/nvim-dap-ui",
  --     after = "nvim-dap",
  --     module = "dapui",
  --     config = function()
  --         require("dapui").setup()
  --     end,
  -- })

  use({
    "lewis6991/gitsigns.nvim",
    after = "trouble.nvim",
    config = function()
      require("plugins.gitsigns")
    end,
    event = "BufEnter",
  })

  use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })

  use({ "tpope/vim-fugitive" })

  use({
    "majutsushi/tagbar",
    cmd = { "TagbarToggle" },
    keys = "<F8>",
    config = function()
      vim.api.nvim_set_keymap("n", "<F8>", "<cmd>TagbarToggle<CR>", { noremap = true })
    end,
  })

  use({
    "simnalamburt/vim-mundo",
    cmd = { "MundoToggle" },
    keys = "<leader>mu",
    config = function()
      vim.api.nvim_set_keymap("n", "<leader>mu", "<cmd>MundoToggle<CR>", { noremap = true })
    end,
  })

  use({
    "numToStr/FTerm.nvim",
    config = function()
      vim.api.nvim_set_keymap("n", "<leader>tt", "<cmd>lua require'FTerm'.toggle()<CR>", { noremap = true })
      -- vim.api.nvim_add_user_command("FTermRun", function(cmd)
      --     require("FTerm").run(vim.fn.expandcmd(cmd.args))
      -- end, { nargs = "*", complete = "shellcmd" })
      vim.api.nvim_set_keymap("n", "<leader>tr", ":FTermRun ", { noremap = true })
    end,
  })

  use({ "moll/vim-bbye", cmd = "Bdelete" })

  use({ "lambdalisue/suda.vim", cmd = { "SudaRead, SudaWrite" } })

  use({
    "chrisbra/unicode.vim",
    cmd = { "UnicodeName", "UnicodeTable", "UnicodeSearch" },
  })

  use({ "goolord/alpha-nvim",
    config = function()
      require("plugins.dashboard")
    end
  })

  use({
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
    event = "BufEnter",
  })

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  -------------------
  -- Editing Tools --
  -------------------

  use({
    "godlygeek/tabular",
    cmd = { "Tabularize" },
  })

  use({
    "junegunn/vim-easy-align",
    config = function()
      vim.cmd("xmap ga <Plug>(EasyAlign)")
    end,
    cmd = "EasyAlign",
    keys = { "x", "ga" },
  })

  use({
    "dhruvasagar/vim-table-mode",
    cmd = { "TableModeToggle" },
  })

  use({
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup({ mappings = { extended = true } })
    end,
  })

  use({ "tpope/vim-surround" })

  use({
    "windwp/nvim-autopairs",
    after = { "hop", "nvim-cmp" },
    config = function()
      require("plugins.autopairs")
    end,
    event = "InsertCharPre",
  })

  use({ "wellle/targets.vim" })

  use({ "michaeljsmith/vim-indent-object" })

  use({
    "phaazon/hop.nvim",
    as = "hop",
    config = function()
      require("plugins.hop")
    end,
  })

  use({ "tpope/vim-repeat" }) --, keys = "." })

  ----------
  -- Tmux --
  ----------
  use({
    "benmills/vimux",
    config = function()
      vim.cmd([[
            function! VimuxSlime()
                call VimuxRunCommand(@v, 0)
            endfunction
            ]])
      vim.api.nvim_set_keymap("x", "<leader>vs", '"vy :call VimuxSlime()<CR>', { noremap = true })
      vim.api.nvim_set_keymap("n", "<leader>vp", "<cmd>VimuxPromptCommand<CR>", { noremap = true })
    end,
  })
end)
