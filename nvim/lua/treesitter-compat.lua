if vim.fn.has("nvim-0.12") ~= 1 then
  return
end

local query = require("vim.treesitter.query")

local html_script_type_languages = {
  ["importmap"] = "json",
  ["module"] = "javascript",
  ["application/ecmascript"] = "javascript",
  ["text/ecmascript"] = "javascript",
}

local non_filetype_match_injection_language_aliases = {
  ex = "elixir",
  pl = "perl",
  sh = "bash",
  uxn = "uxntal",
  ts = "typescript",
}

local function get_parser_from_markdown_info_string(injection_alias)
  local match = vim.filetype.match({ filename = "a." .. injection_alias })
  return match or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
end

local function capture_node(match, capture_id)
  local capture = match[capture_id]
  if type(capture) == "table" then
    return capture[1]
  end
  return capture
end

query.add_predicate("nth?", function(match, _, _, pred)
  local node = capture_node(match, pred[2])
  local n = tonumber(pred[3])

  if node and n and node:parent() and node:parent():named_child_count() > n then
    return node:parent():named_child(n) == node
  end

  return false
end, { force = true, all = false })

query.add_predicate("is?", function(match, _, bufnr, pred)
  local node = capture_node(match, pred[2])
  local types = { unpack(pred, 3) }

  if not node then
    return true
  end

  local locals = require("nvim-treesitter.locals")
  local _, _, kind = locals.find_definition(node, bufnr)

  return vim.tbl_contains(types, kind)
end, { force = true, all = false })

query.add_predicate("kind-eq?", function(match, _, _, pred)
  local node = capture_node(match, pred[2])
  local types = { unpack(pred, 3) }

  if not node then
    return true
  end

  return vim.tbl_contains(types, node:type())
end, { force = true, all = false })

query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
  local node = capture_node(match, pred[2])
  if not node then
    return
  end

  local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
  local configured = html_script_type_languages[type_attr_value]
  if configured then
    metadata["injection.language"] = configured
    return
  end

  local parts = vim.split(type_attr_value, "/", {})
  metadata["injection.language"] = parts[#parts]
end, { force = true, all = false })

query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
  local node = capture_node(match, pred[2])
  if not node then
    return
  end

  local injection_alias = vim.treesitter.get_node_text(node, bufnr):lower()
  metadata["injection.language"] = get_parser_from_markdown_info_string(injection_alias)
end, { force = true, all = false })

query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
  local capture_id = pred[2]
  local node = capture_node(match, capture_id)
  if not node then
    return
  end

  local capture_metadata = metadata[capture_id]
  local text = vim.treesitter.get_node_text(node, bufnr, { metadata = capture_metadata }) or ""

  metadata[capture_id] = vim.tbl_extend("force", capture_metadata or {}, {
    text = string.lower(text),
  })
end, { force = true, all = false })
