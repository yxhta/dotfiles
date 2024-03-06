local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")
local version = vim.version()
dashboard.section.header.val = {
    [[                                 __                 ]],
    [[    ___     ___    ___   __  __ /\_\    ___ ___     ]],
    [[   / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\   ]],
    [[  /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \  ]],
    [[  \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\ ]],
    [[   \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/ ]],
    "",
    "",
    "                 N E O V I M - v " .. version.major .. "." .. version.minor,
    "",
}

dashboard.section.header.opts = {
    hl = "DashboardHeader",
    position = "center",
}

dashboard.section.buttons.val = {
    dashboard.button("<leader>ff", "  Find File", ":Telescope find_files<CR>"),
    dashboard.button("<leader>fr", "  Recents", ":Telescope frecency<CR>"),
    dashboard.button("<leader>fg", "  Find Word", ":Telescope live_grep<CR>"),
    dashboard.button("<leader>en", "  New File", ":enew<CR>"),
    dashboard.button("u", "  Update Plugins", ":Lazy sync<CR>"),
    dashboard.button("s", "  Setting", ":edit $MYVIMRC<CR>"),
    dashboard.button("q", "  Exit", ":exit<CR>"),
}

dashboard.section.footer.val = { "type  :help<Enter>  or  <F1>  for on-line help" }

dashboard.section.footer.opts = {
    hl = "DashboardFooter",
    position = "center"
}

alpha.setup(dashboard.config)
