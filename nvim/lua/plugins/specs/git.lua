return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      require("gitsigns").setup({
        -- 巨大リポジトリでは 1 バッファごとに git diff を回すコストが効いてくる。
        -- 行数上限を明示し、編集中の差分再計算は少し間引く。
        max_file_length = 20000,
        update_debounce = 200,
        attach_to_untracked = false,
      })
    end,
  },

  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewClose",
      "DiffviewFileHistory",
      "DiffviewFocusFiles",
      "DiffviewLog",
      "DiffviewOpen",
      "DiffviewRefresh",
      "DiffviewToggleFiles",
    },
    dependencies = "nvim-lua/plenary.nvim",
  },

  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "Gclog",
      "Gdiffsplit",
      "Gedit",
      "Ggrep",
      "Gread",
      "Gsplit",
      "Gtabedit",
      "Gvdiffsplit",
      "Gwrite",
    },
  },
  {
    "tpope/vim-rhubarb",
    cmd = "GBrowse",
    dependencies = "tpope/vim-fugitive",
  },
}
