local parser_install_dir = vim.fn.stdpath("data") .. "/site"

local ensure_installed = {
  "bash",
  "c",
  "cmake",
  "cpp",
  "css",
  "diff",
  "dockerfile",
  "git_config",
  "git_rebase",
  "gitcommit",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "nix",
  "python",
  "query",
  "regex",
  "ruby",
  "rust",
  "sql",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

local function setup_context()
  local ok, context = pcall(require, "treesitter-context")
  if not ok then
    return
  end

  context.setup({
    enable = true,
    max_lines = 0,
    min_window_height = 0,
    line_numbers = true,
    multiline_threshold = 20,
    trim_scope = "outer",
    mode = "cursor",
    separator = nil,
    zindex = 20,
    on_attach = nil,
  })
end

local ok, treesitter = pcall(require, "nvim-treesitter")
if ok and type(treesitter.install) == "function" then
  treesitter.setup({
    install_dir = parser_install_dir,
  })

  treesitter.install(ensure_installed)

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
    callback = function(args)
      pcall(vim.treesitter.start, args.buf)
    end,
  })

  setup_context()
  return
end

require("treesitter-compat")

require("nvim-treesitter.configs").setup({
  parser_install_dir = parser_install_dir,
  ensure_installed = ensure_installed,
  auto_install = true,
  ignore_install = {},
  highlight = {
    enable = true,
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
      lookahead = true,
      keymaps = {
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
      set_jumps = true,
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
      },
    },
  },
  textsubjects = {
    enable = true,
    keymaps = {
      ["<cr>"] = "textsubjects-smart",
    },
  },
  playground = {
    enable = false,
  },
})

setup_context()
