return {
  {
    "tpope/vim-dadbod",
    cmd = "DB",
  },

  {
    "kristijanhusak/vim-dadbod-ui",
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
      "DBUIRenameBuffer",
      "DBUILastQueryInfo",
    },
    dependencies = {
      "tpope/vim-dadbod",
    },
    init = function()
      require("plugins.dadbod").setup()
    end,
    keys = {
      { "<leader>sd", "<cmd>DBUIToggle<CR>", desc = "Dadbod: Toggle UI" },
      { "<leader>sa", "<cmd>DBUIAddConnection<CR>", desc = "Dadbod: Add connection" },
      { "<leader>sf", "<cmd>DBUIFindBuffer<CR>", desc = "Dadbod: Find buffer" },
    },
  },

  {
    "kristijanhusak/vim-dadbod-completion",
    ft = { "sql", "mysql", "plsql" },
    dependencies = {
      "tpope/vim-dadbod",
    },
  },
}
