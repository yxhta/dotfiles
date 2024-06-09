local actions = require("telescope.actions")
local themes = require("telescope.themes")
local troubletele = require("trouble.sources.telescope")
local trouble = require("trouble")

require("telescope").setup({
    defaults = {
        dynamic_preview_title = true,
        layout_strategy = "flex",
        file_ignore_patterns = { "node_modules", ".git" },
        path_display = {
            truncate = 1,
        },
        set_env = {
            ["COLORTERM"] = "truecolor",
        }, -- default = nil,
        history = {
            mappings = {
                i = {
                    ["<C-Down>"] = actions.cycle_history_next,
                    ["<C-Up>"] = actions.cycle_history_prev,
                },
            },
        },
        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<Tab>"] = actions.move_selection_previous,
                ["<S-Tab>"] = actions.move_selection_next,
                ["<C-z>"] = actions.toggle_selection,
                ["<C-s>"] = actions.select_horizontal,
                ["<C-x>"] = troubletele.open,
                ["<M-l>"] = function(prompt_bufnr)
                    actions.smart_send_to_loclist(prompt_bufnr)
                    trouble.open("loclist")
                end,
                ["<M-a>"] = actions.toggle_all,
                ["<C-Down>"] = actions.cycle_history_next,
                ["<C-Up>"] = actions.cycle_history_prev,
            },
            n = {
                ["<C-z>"] = actions.toggle_selection,
                ["<C-s>"] = actions.select_horizontal,
                ["<C-x>"] = troubletele.open,
                ["<M-a>"] = actions.toggle_all,
                ["<M-l>"] = function(prompt_bufnr)
                    actions.smart_send_to_loclist(prompt_bufnr)
                    trouble.open("loclist")
                end,
                ["<C-Down>"] = actions.cycle_history_next,
                ["<C-Up>"] = actions.cycle_history_prev,
            },
        },
    },
    pickers = {
        find_files = {
            follow = true,
            theme = "dropdown",
        },
        buffers = {
            sort_mru = true,
        },
        lsp_code_actions = themes.get_cursor(),
        lsp_range_code_actions = themes.get_cursor(),
        lsp_references = {
            timeout = 100000,
        },
        lsp_definitions = {
            timeout = 100000,
        },
        lsp_type_definitions = {
            timeout = 100000,
        },
        lsp_implementations = {
            timeout = 100000,
        },
        lsp_workspace_symbols = {
            timeout = 100000,
        },
        lsp_dynamic_workspace_symbols = {
            timeout = 100000,
        },
    },
    extension = {
        file_browser = {
            hidden = true,
            depth = 2,
        },
    },
})
