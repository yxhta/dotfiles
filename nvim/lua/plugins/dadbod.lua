local M = {}

local function present(value)
	return type(value) == "string" and value ~= ""
end

local function add_env_connection(connections, name, env_name)
	local value = vim.env[env_name]
	if present(value) then
		connections[name] = value
	end
end

function M.setup()
	vim.g.db_ui_use_nerd_fonts = 1
	vim.g.db_ui_show_database_icon = 1
	vim.g.db_ui_win_position = "left"
	vim.g.db_ui_winwidth = 44
	vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/dadbod-ui"
	vim.g.db_ui_tmp_query_location = vim.fn.stdpath("cache") .. "/dadbod-ui"
	vim.g.db_ui_execute_on_save = 0

	local env_connections = {}
	add_env_connection(env_connections, "default", "DATABASE_URL")
	add_env_connection(env_connections, "development", "DEV_DATABASE_URL")
	add_env_connection(env_connections, "test", "TEST_DATABASE_URL")
	add_env_connection(env_connections, "local", "LOCAL_DATABASE_URL")

	if next(env_connections) ~= nil then
		local existing_connections = type(vim.g.dbs) == "table" and vim.g.dbs or {}
		vim.g.dbs = vim.tbl_extend("keep", existing_connections, env_connections)
	end
end

return M
