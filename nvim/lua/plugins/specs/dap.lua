return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("dap-config")
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
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
    config = function()
      require("plugins.dap-go")
    end,
  },
}
