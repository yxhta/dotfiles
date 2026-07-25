local actions = require("telescope.actions")
local themes = require("telescope.themes")

-- trouble は cmd/keys で遅延ロードされるため、Telescope ロード時に
-- 引き込まず、マッピング実行時に初めて require する。
local function open_with_trouble(prompt_bufnr)
  require("trouble.sources.telescope").open(prompt_bufnr)
end

local function send_to_loclist(prompt_bufnr)
  actions.smart_send_to_loclist(prompt_bufnr)
  require("trouble").open("loclist")
end

-- 除外は fd / rg 側で行う。file_ignore_patterns は Telescope が全エントリに対して
-- Lua パターンマッチを回すため、ファイル数の多いリポジトリでは絞り込みのたびに重くなる。
local ignore_globs = { ".git", "node_modules", "vendor", "dist", "build", "target", ".next", ".venv" }

local function fd_command()
  local cmd = { "fd", "--type", "f", "--hidden", "--follow", "--strip-cwd-prefix" }
  for _, glob in ipairs(ignore_globs) do
    table.insert(cmd, "--exclude")
    table.insert(cmd, glob)
  end
  return cmd
end

local function rg_arguments()
  local args = {
    "rg",
    "--color=never",
    "--no-heading",
    "--with-filename",
    "--line-number",
    "--column",
    "--smart-case",
    "--hidden",
  }
  for _, glob in ipairs(ignore_globs) do
    table.insert(args, "--glob")
    table.insert(args, "!" .. glob .. "/")
  end
  return args
end

require("telescope").setup({
  defaults = {
    dynamic_preview_title = true,
    layout_strategy = "flex",
    vimgrep_arguments = rg_arguments(),
    -- 生成物や巨大ファイルを選択しただけでプレビューが固まらないようにする。
    preview = {
      filesize_limit = 1, -- MB
      timeout = 250, -- ms
      treesitter = true,
    },
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
        ["<C-x>"] = open_with_trouble,
        ["<M-l>"] = send_to_loclist,
        ["<M-a>"] = actions.toggle_all,
        ["<C-Down>"] = actions.cycle_history_next,
        ["<C-Up>"] = actions.cycle_history_prev,
      },
      n = {
        ["<C-z>"] = actions.toggle_selection,
        ["<C-s>"] = actions.select_horizontal,
        ["<C-x>"] = open_with_trouble,
        ["<M-a>"] = actions.toggle_all,
        ["<M-l>"] = send_to_loclist,
        ["<C-Down>"] = actions.cycle_history_next,
        ["<C-Up>"] = actions.cycle_history_prev,
      },
    },
  },
  pickers = {
    find_files = {
      find_command = fd_command(),
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
  extensions = {
    file_browser = {
      hidden = true,
      depth = 2,
    },
  },
})
