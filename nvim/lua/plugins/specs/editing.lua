return {
	{
		"junegunn/vim-easy-align",
		config = function()
			vim.cmd("xmap ga <Plug>(EasyAlign)")
		end,
		cmd = "EasyAlign",
		keys = {
			{ "ga", mode = { "n", "x" } },
		},
	},

	{
		"numToStr/Comment.nvim",
		keys = {
			{ "gc", mode = { "n", "x", "o" } },
			{ "gcc", mode = "n" },
		},
		config = function()
			require("Comment").setup({ mappings = { extended = true } })
		end,
	},

	{
		"tpope/vim-surround",
		keys = {
			{ "ys", mode = "n" },
			{ "cs", mode = "n" },
			{ "ds", mode = "n" },
			{ "S", mode = "x" },
		},
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("plugins.autopairs")
		end,
	},

	{ "wellle/targets.vim", event = "VeryLazy" },

	{ "michaeljsmith/vim-indent-object", event = "VeryLazy" },

	{ "tpope/vim-repeat", event = "VeryLazy" },
}
