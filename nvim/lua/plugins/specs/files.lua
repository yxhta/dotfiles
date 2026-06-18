return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- optional, for file icons
			"MunifTanjim/nui.nvim",
		},
		cmd = "Neotree",
		keys = { "<leader>n", "<leader>nf" },
		-- Load neo-tree eagerly when nvim is started on a directory (e.g. `nvim .`),
		-- so it can hijack netrw before the directory buffer is created.
		init = function()
			if vim.fn.argc(-1) == 1 then
				local stat = vim.uv.fs_stat(vim.fn.argv(0))
				if stat and stat.type == "directory" then
					require("neo-tree")
				end
			end
		end,
		config = function()
			require("neo-tree").setup({
				filesystem = {
					hijack_netrw_behavior = "open_current",
				},
				window = {
					mappings = {
						["o"] = "open",
						-- Move the default "Order by" submenu (was on `o`) to `0`.
						["0"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "0" } },
						["0c"] = { "order_by_created", nowait = false },
						["0d"] = { "order_by_diagnostics", nowait = false },
						["0g"] = { "order_by_git_status", nowait = false },
						["0m"] = { "order_by_modified", nowait = false },
						["0n"] = { "order_by_name", nowait = false },
						["0s"] = { "order_by_size", nowait = false },
						["0t"] = { "order_by_type", nowait = false },
					},
				},
			})
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		enabled = true,
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{
				"nvim-telescope/telescope-file-browser.nvim",
				config = function()
					require("telescope").load_extension("file_browser")
				end,
			},
		},
		config = function()
			require("plugins.telescope")
		end,
	},
}
