require("nvim-treesitter.configs").setup({
    ensure_installed = "all", --  "all" or a list
    ignore_install = {},    -- List of parsers to ignore installing
    highlight = {
        enable = true,      -- false will disable the whole extension
        disable = { "vim" },
        additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            node_decremental = "grN",
            scope_incremental = "grc",
        },
    },
    indent = {
        enable = false,
    },
    matchup = {
        enable = true,
    },
    textobjects = {
        select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["al"] = "@loop.outer",
                ["il"] = "@loop.inner",
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>ss"] = "@parameter.inner",
            },
            swap_previous = {
                ["<leader>sS"] = "@parameter.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer",
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
        lsp_interop = {
            enable = true,
            border = "single",
            peek_definition_code = {
                ["<leader>lg"] = "@block.outer",
                -- ["<leader>lG"] = "@class.outer",
            },
        },
    },
    textsubjects = {
        enable = true,
        keymaps = {
            ["<cr>"] = "textsubjects-smart", -- works in visual mode
        },
    },
    playground = {
        enable = false,
    }
})

require 'treesitter-context'.setup {
    enable = true,                        -- Enable this plugin (Can be enabled/disabled later via commands)
    max_lines = 0,                        -- How many lines the window should span. Values <= 0 mean no limit.
    min_window_height = 0,                -- Minimum editor window height to enable context. Values <= 0 mean no limit.
    line_numbers = true,
    multiline_threshold = 20,             -- Maximum number of lines to show for a single context
    trim_scope = 'outer',                 -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    mode = 'cursor',                      -- Line used to calculate context. Choices: 'cursor', 'topline'
    -- Separator between context and content. Should be a single character string, like '-'.
    -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
    separator = nil,
    zindex = 20,                 -- The Z-index of the context window
    on_attach = nil,             -- (fun(buf: integer): boolean) return false to disable attaching
}
