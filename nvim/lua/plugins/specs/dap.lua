return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      "<F5>",
      "<F10>",
      "<F11>",
      "<F12>",
      "<leader>b",
      "<leader>bc",
      "<leader>l",
    },
    config = function()
      require("dap-config")
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    keys = {
      "<leader>d",
      "<leader><leader>df",
    },
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require("dapui").setup({
        controls = {
          enabled = true,
          element = "repl",
          icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "",
            terminate = "",
          },
        },
      })
    end,
  },

  {
    "leoluz/nvim-dap-go",
    keys = {
      "<leader>td",
    },
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      require("plugins.dap-go")
    end,
  },
}
