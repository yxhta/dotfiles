require("dap-go").setup()
local dap = require("dap")

dap.configurations.go = {
  {
    type = "go",
    name = "Debug the golang",
    request = "launch",
    program = "${file}",
    env = {
      DB_USER = "docker",
      DB_PASS = "docker",
      DB_NAME = "sampledb",
    },
  },
  {
    type = "go",
    name = "Debug the golang test",
    request = "launch",
    mode = "test",
    program = "${file}",
  },
  {
    type = "go",
    name = "Debug test (go.mod)",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}",
  },
}
