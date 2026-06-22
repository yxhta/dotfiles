local null_ls = require("null-ls")

local function exe(name)
	return vim.fn.executable(name) == 1
end

local sources = {}
local function add_if(cond, src)
	if cond then
		table.insert(sources, src)
	end
end

-- Biome を使うプロジェクト（biome.json / biome.jsonc がある）かどうかを
-- 対象ファイルのディレクトリから上方向に探索して判定する。
local function has_biome_config(bufname)
	if not bufname or bufname == "" then
		return false
	end
	local found = vim.fs.find({ "biome.json", "biome.jsonc" }, {
		upward = true,
		path = vim.fs.dirname(bufname),
	})
	return found[1] ~= nil
end

-- Biome プロジェクトでは Biome、それ以外では prettier を使う。
-- runtime_condition はフォーマット実行時にバッファごとに評価されるため、
-- プロジェクトを跨いでも正しく切り替わる。
add_if(
	exe("biome"),
	null_ls.builtins.formatting.biome.with({
		runtime_condition = function(params)
			return has_biome_config(params.bufname)
		end,
	})
)

if exe("prettierd") then
	add_if(
		true,
		null_ls.builtins.formatting.prettierd.with({
			runtime_condition = function(params)
				return not has_biome_config(params.bufname)
			end,
		})
	)
else
	add_if(
		exe("prettier"),
		null_ls.builtins.formatting.prettier.with({
			runtime_condition = function(params)
				return not has_biome_config(params.bufname)
			end,
		})
	)
end

add_if(exe("goimports"), null_ls.builtins.formatting.goimports)
add_if(exe("gofmt"), null_ls.builtins.formatting.gofmt)
add_if(exe("golangci-lint"), null_ls.builtins.diagnostics.golangci_lint)
add_if(exe("staticcheck"), null_ls.builtins.diagnostics.staticcheck)

-- 保存時フォーマット。ts_ls(tsserver) はプロジェクト設定（Biome 等）を無視して
-- 独自スタイルで書き換えてしまうため除外し、none-ls 側のフォーマッタ
-- （Biome / prettier / gofmt 等）のみで整形する。
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local lsp_formatting = function(bufnr)
	vim.lsp.buf.format({
		bufnr = bufnr,
		filter = function(client)
			return client.name == "null-ls"
		end,
		async = false,
	})
end

null_ls.setup({
	sources = sources,
	on_attach = function(client, bufnr)
		if client:supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					lsp_formatting(bufnr)
				end,
			})
		end
	end,
	debug = false,
})
