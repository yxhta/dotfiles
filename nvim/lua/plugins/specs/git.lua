return {
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		config = function()
			require("gitsigns").setup()
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
