local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { "nvim-lua/plenary.nvim",    lazy = true },

    { "nvim-lua/popup.nvim" },

    { "dstein64/vim-startuptime", cmd = "StartupTime" },

    { "nathom/filetype.nvim" },

    --------------------------------------------
    -- LSP, Diagnostics, Snippets, Completion --
    --------------------------------------------
    { 'github/copilot.vim' },

    {
        "neovim/nvim-lspconfig",
        event = { "BufRead", "BufNewFile" },
        lazy = false,
        cmd = "Mason",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup()
            -- require("lsp.server_setup")
            require("lspconfig.ui.windows").default_options.border = vim.g.FloatBorders
            require("lsp.lsp-config")
        end,
    },

    {
        "nvimtools/none-ls.nvim",
        -- event = { "BufRead", "BufNewFile" },
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
        dependencies = "neovim/nvim-lspconfig"
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
            "kdheepak/cmp-latex-symbols",
            "dmitmel/cmp-cmdline-history",
            "andersevenrud/cmp-tmux",
            "quangnguyen30192/cmp-nvim-ultisnips",
        },
        config = function()
            require("plugins.cmp")
        end,
    },

    {
        'akinsho/flutter-tools.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'stevearc/dressing.nvim', -- optional for vim.ui.select
        },
        config = function()
            require("flutter-tools").setup {}
        end
    },

    {
        "SirVer/ultisnips",
        dependencies = "honza/vim-snippets",
        config = function()
            -- vim.opt.rtp:append({ vim.fn.stdpath("data") .. "/site/pack/packer/start/vim-snippets" })
            -- vim.g.UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
            -- vim.g.UltiSnipsJumpForwardTrigger = "<Plug>(ultisnips_jump_forward)"
            -- vim.g.UltiSnipsJumpBackwardTrigger = "<Plug>(ultisnips_jump_backward)"
            -- vim.g.UltiSnipsListSnippets = "<c-x><c-s>"
            -- vim.g.UltiSnipsRemoveSelectModeMappings = 0
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
        keys = "<leader>vv",
        config = function()
            require("plugins.vista")
        end,
    },

    {
        "danymat/neogen",
        config = function()
            require("neogen").setup({})
        end,
        cmd = "Neogen",
    },

    -- -------------------
    -- Syntax and Folds --
    ----------------------

    { "chrisbra/vim-zsh" },

    {
        "andymass/vim-matchup",
        config = function()
            vim.g.matchup_override_vimtex = 1
            vim.g.matchup_matchparen_deferred = 1
            vim.g.matchup_matchparen_offscreen = {
                method = "popup",
            }
        end,
    },

    {
        "chrisbra/csv.vim",
        cmd = "CSVInit",
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPre" },
        dependencies = {
            "nvim-treesitter/playground",
            "nvim-treesitter/nvim-treesitter-refactor",
            "nvim-treesitter/nvim-treesitter-textobjects",
            -- "nvim-treesitter/nvim-treesitter-textsubjects",
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

    -------------------------
    -- File, Fuzzy Finders --
    -------------------------

    {
        'nvim-tree/nvim-tree.lua',
        version = "*",
        lazy = false,
        dependencies = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
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
        lazy = false,
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
            { "nvim-telescope/telescope-fzf-native.nvim" },
            {
                "nvim-telescope/telescope-frecency.nvim",
                config = function()
                    vim.keymap.set(
                        "n",
                        "<leader>fr",
                        require("telescope").extensions.frecency.frecency,
                        { desc = "Telescope: Frecency" }
                    )
                end,
            },
            {
                "nvim-telescope/telescope-file-browser.nvim",
                config = function()
                    require("telescope").load_extension("file_browser")
                end,
            },
        },
        config = function()
            require("plugins.telescope")
        end,
    },

    -------------------------------------------
    -- Colors, Icons, StatusLine, BufferLine --
    -------------------------------------------

    { "rebelot/kanagawa.nvim", branch = "master" },

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

    --------------------------
    -- Editor Utilities, UI --
    --------------------------

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

    {
        "majutsushi/tagbar",
        cmd = { "TagbarToggle" },
        keys = "<F8>",
        config = function()
            vim.api.nvim_set_keymap("n", "<F8>", "<cmd>TagbarToggle<CR>", { noremap = true })
        end,
    },

    {
        "simnalamburt/vim-mundo",
        cmd = { "MundoToggle" },
        keys = "<leader>mu",
        config = function()
            vim.api.nvim_set_keymap("n", "<leader>mu", "<cmd>MundoToggle<CR>", { noremap = true })
        end,
    },

    {
        "numToStr/FTerm.nvim",
        config = function()
            vim.api.nvim_set_keymap("n", "<leader>tt", "<cmd>lua require'FTerm'.toggle()<CR>",
                { noremap = true })
            -- vim.api.nvim_add_r_command("FTermRun", function(cmd)
            --     require("FTerm").run(vim.fn.expandcmd(cmd.args))
            -- end, { nargs = "*", complete = "shellcmd" })
            vim.api.nvim_set_keymap("n", "<leader>tr", ":FTermRun ", { noremap = true })
        end,
    },

    { "moll/vim-bbye",     cmd = "Bdelete" },

    -- { "lambdalisue/suda.vim", cmd = { "SudaRead, SudaWrite" } },

    {
        "chrisbra/unicode.vim",
        cmd = { "UnicodeName", "UnicodeTable", "UnicodeSearch" },
    },

    {
        "goolord/alpha-nvim",
        config = function()
            require("plugins.dashboard")
        end
    },

    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
        end,
        event = "BufEnter",
    },

    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'kyazdani42/nvim-web-devicons', opt = true }
    },

    -------------------
    -- Editing Tools --
    -------------------

    {
        "godlygeek/tabular",
        cmd = { "Tabularize" },
    },

    {
        "junegunn/vim-easy-align",
        config = function()
            vim.cmd("xmap ga <Plug>(EasyAlign)")
        end,
        cmd = "EasyAlign",
        keys = { "x", "ga" },
    },

    {
        "dhruvasagar/vim-table-mode",
        cmd = { "TableModeToggle" },
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
        -- after = { "hop", "nvim-cmp" },
        config = function()
            require("plugins.autopairs")
        end,
    },

    { "wellle/targets.vim" },

    { "michaeljsmith/vim-indent-object" },

    {
        "phaazon/hop.nvim",
        -- as = "hop",
        config = function()
            require("plugins.hop")
        end,
    },

    { "tpope/vim-repeat" }, --, keys = "." })
})
