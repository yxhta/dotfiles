if vim.fn.has("nvim-0.12") == 1 then
	-- Keep older plugins working without hitting deprecated vim.tbl_flatten().
	vim.tbl_flatten = function(t)
		local result = {}

		local function flatten(items)
			for i = 1, #items do
				local value = items[i]
				if type(value) == "table" then
					flatten(value)
				elseif value then
					result[#result + 1] = value
				end
			end
		end

		flatten(t)
		return result
	end
end
