-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/REDACTED/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/REDACTED/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/REDACTED/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/REDACTED/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/REDACTED/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["Comment.nvim"] = {
    config = { "\27LJ\2\nZ\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\rmappings\1\0\0\1\0\1\rextended\2\nsetup\fComment\frequire\0" },
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/Comment.nvim",
    url = "https://github.com/numToStr/Comment.nvim"
  },
  ["FTerm.nvim"] = {
    config = { "\27LJ\2\n[\0\1\6\0\a\0\v6\1\0\0'\3\1\0B\1\2\0029\1\2\0016\3\3\0009\3\4\0039\3\5\0039\5\6\0B\3\2\0A\1\0\1K\0\1\0\targs\14expandcmd\afn\bvim\brun\nFTerm\frequireú\2\1\0\6\0\14\0\0246\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0005\5\6\0B\0\5\0016\0\0\0009\0\1\0009\0\a\0'\2\b\0003\3\t\0005\4\n\0B\0\4\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\v\0'\4\f\0005\5\r\0B\0\5\1K\0\1\0\1\0\1\fnoremap\2\15:FTermRun \15<leader>tr\1\0\2\rcomplete\rshellcmd\nnargs\6*\0\rFTermRun\26nvim_add_user_command\1\0\1\fnoremap\2)<cmd>lua require'FTerm'.toggle()<CR>\15<leader>tt\6n\20nvim_set_keymap\bapi\bvim\0" },
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/FTerm.nvim",
    url = "https://github.com/numToStr/FTerm.nvim"
  },
  SimpylFold = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/opt/SimpylFold",
    url = "https://github.com/tmhedberg/SimpylFold"
  },
  ["alpha-nvim"] = {
    config = { "\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22plugins.dashboard\frequire\0" },
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/alpha-nvim",
    url = "https://github.com/goolord/alpha-nvim"
  },
  catppuccin = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/catppuccin",
    url = "https://github.com/catppuccin/nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-cmdline"] = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/cmp-cmdline",
    url = "https://github.com/hrsh7th/cmp-cmdline"
  },
  ["cmp-cmdline-history"] = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/cmp-cmdline-history",
    url = "https://github.com/dmitmel/cmp-cmdline-history"
  },
  ["cmp-dictionary"] = {
    config = { "\27LJ\2\nj\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\bdic\1\0\0\1\0\1\6*\26/usr/share/dict/words\nsetup\19cmp_dictionary\frequire\0" },
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/cmp-dictionary",
    url = "https://github.com/uga-rosa/cmp-dictionary"
  },
  ["cmp-latex-symbols"] = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/cmp-latex-symbols",
    url = "https://github.com/kdheepak/cmp-latex-symbols"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lsp-document-symbol"] = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp-document-symbol",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp-document-symbol"
  },
  ["cmp-nvim-lsp-signature-help"] = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp-signature-help",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help"
  },
  ["cmp-nvim-lua"] = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
  },
  ["cmp-nvim-ultisnips"] = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/cmp-nvim-ultisnips",
    url = "https://github.com/quangnguyen30192/cmp-nvim-ultisnips"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  ["cmp-tmux"] = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/cmp-tmux",
    url = "https://github.com/andersevenrud/cmp-tmux"
  },
  ["csv.vim"] = {
    commands = { "CSVInit" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/opt/csv.vim",
    url = "https://github.com/chrisbra/csv.vim"
  },
  ["diffview.nvim"] = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/diffview.nvim",
    url = "https://github.com/sindrets/diffview.nvim"
  },
  ["fidget.nvim"] = {
    config = { "\27LJ\2\n8\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\vfidget\frequire\0" },
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/fidget.nvim",
    url = "https://github.com/j-hui/fidget.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21plugins.gitsigns\frequire\0" },
    load_after = {},
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/opt/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  hop = {
    after = { "nvim-autopairs" },
    loaded = true,
    only_config = true
  },
  ["impatient.nvim"] = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/impatient.nvim",
    url = "https://github.com/lewis6991/impatient.nvim"
  },
  ["indent-blankline.nvim"] = {
    config = { "\27LJ\2\n8\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\29plugins.indent-blankline\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/opt/indent-blankline.nvim",
    url = "https://github.com/lukas-reineke/indent-blankline.nvim"
  },
  ["kanagawa.nvim"] = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/kanagawa.nvim",
    url = "https://github.com/rebelot/kanagawa.nvim"
  },
  ["lspkind-nvim"] = {
    after = { "nvim-gps" },
    loaded = true,
    only_config = true
  },
  neogen = {
    commands = { "Neogen" },
    config = { "\27LJ\2\n8\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\vneogen\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/opt/neogen",
    url = "https://github.com/danymat/neogen"
  },
  ["nord.nvim"] = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/nord.nvim",
    url = "https://github.com/shaunsingh/nord.nvim"
  },
  ["null-ls.nvim"] = {
    config = { "\27LJ\2\n+\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\16lsp.null-ls\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/opt/null-ls.nvim",
    url = "https://github.com/jose-elias-alvarez/null-ls.nvim"
  },
  ["nvim-autopairs"] = {
    config = { "\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22plugins.autopairs\frequire\0" },
    load_after = {},
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/opt/nvim-autopairs",
    url = "https://github.com/windwp/nvim-autopairs"
  },
  ["nvim-bufferline.lua"] = {
    config = { "\27LJ\2\n2\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\23plugins.bufferline\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/opt/nvim-bufferline.lua",
    url = "https://github.com/akinsho/nvim-bufferline.lua"
  },
  ["nvim-cmp"] = {
    after = { "nvim-autopairs" },
    loaded = true,
    only_config = true
  },
  ["nvim-colorizer.lua"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14colorizer\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/opt/nvim-colorizer.lua",
    url = "https://github.com/norcalli/nvim-colorizer.lua"
  },
  ["nvim-dap"] = {
    after = { "nvim-dap-python", "nvim-dap-ui", "telescope-dap.nvim", "nvim-dap-virtual-text" },
    loaded = true,
    only_config = true
  },
  ["nvim-dap-python"] = {
    config = { "\27LJ\2\n~\0\0\3\0\6\0\f6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\0016\0\0\0'\2\1\0B\0\2\2'\1\5\0=\1\4\0K\0\1\0\vpytest\16test_runner\31~/venvs/debugpy/bin/python\nsetup\15dap-python\frequire\0" },
    load_after = {},
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/opt/nvim-dap-python",
    url = "https://github.com/mfussenegger/nvim-dap-python"
  },
  ["nvim-dap-ui"] = {
    config = { "\27LJ\2\n3\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\ndapui\frequire\0" },
    load_after = {},
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/opt/nvim-dap-ui",
    url = "https://github.com/rcarriga/nvim-dap-ui"
  },
  ["nvim-dap-virtual-text"] = {
    config = { "\27LJ\2\n„\1\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\t\15virt_lines\1\15all_frames\1\18virt_text_pos\beol\14commented\1\21show_stop_reason\2\29highlight_new_as_changed\2 highlight_changed_variables\2\21enabled_commands\2\fenabled\2\nsetup\26nvim-dap-virtual-text\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/opt/nvim-dap-virtual-text",
    url = "https://github.com/theHamsta/nvim-dap-virtual-text"
  },
  ["nvim-gps"] = {
    config = { "\27LJ\2\n_\0\1\6\0\6\0\n6\1\0\0009\1\1\0019\1\2\0019\1\3\0018\2\0\0018\2\2\1\18\4\2\0009\2\4\2'\5\5\0D\2\3\0\n^.*%s\nmatch\23CompletionItemKind\rprotocol\blsp\bvim‚\1\1\0\b\0\15\0\0263\0\0\0006\1\1\0'\3\2\0B\1\2\0029\1\3\0015\3\r\0005\4\5\0\18\5\0\0'\a\4\0B\5\2\2=\5\6\4\18\5\0\0'\a\a\0B\5\2\2=\5\b\4\18\5\0\0'\a\t\0B\5\2\2=\5\n\4\18\5\0\0'\a\v\0B\5\2\2=\5\f\4=\4\14\3B\1\2\1K\0\1\0\nicons\1\0\0\19container-name\tEnum\16method-name\vMethod\18function-name\rFunction\15class-name\1\0\0\nClass\nsetup\rnvim-gps\frequire\0\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/opt/nvim-gps",
    url = "https://github.com/SmiteshP/nvim-gps"
  },
  ["nvim-lspconfig"] = {
    after = { "null-ls.nvim" },
    loaded = true,
    only_config = true
  },
  ["nvim-tree.lua"] = {
    config = { "\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22plugins.nvim-tree\frequire\0" },
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/nvim-tree.lua",
    url = "https://github.com/kyazdani42/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    after = { "nvim-treesitter-textsubjects", "nvim-treesitter-textobjects", "nvim-gps", "playground" },
    loaded = true,
    only_config = true
  },
  ["nvim-treesitter-textobjects"] = {
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/opt/nvim-treesitter-textobjects",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects"
  },
  ["nvim-treesitter-textsubjects"] = {
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/opt/nvim-treesitter-textsubjects",
    url = "https://github.com/RRethy/nvim-treesitter-textsubjects"
  },
  ["nvim-web-devicons"] = {
    config = { "\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22nvim-web-devicons\frequire\0" },
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["one-small-step-for-vimkind"] = {
    config = { "\27LJ\2\nZ\0\0\3\0\6\0\n6\0\0\0009\0\1\0009\0\2\0'\2\3\0B\0\2\2\6\0\4\0X\1\1ÄL\0\2\0'\1\5\0L\1\2\0\014127.0.0.1\5\23Host [127.0.0.1]: \ninput\afn\bvimx\0\0\5\0\a\0\f6\0\0\0006\2\1\0009\2\2\0029\2\3\2'\4\4\0B\2\2\0A\0\0\0026\1\5\0\18\3\0\0'\4\6\0B\1\3\1L\0\2\0!Please provide a port number\vassert\vPort: \ninput\afn\bvim\rtonumber@\0\2\6\0\3\0\b\18\2\0\0005\4\0\0009\5\1\1=\5\1\0049\5\2\1=\5\2\4B\2\2\1K\0\1\0\tport\thost\1\0\1\ttype\vserverƒ\1\1\0\5\0\f\0\0166\0\0\0'\2\1\0B\0\2\0029\1\2\0004\2\3\0005\3\4\0003\4\5\0=\4\6\0033\4\a\0=\4\b\3>\3\1\2=\2\3\0019\1\t\0003\2\v\0=\2\n\1K\0\1\0\0\tnlua\radapters\tport\0\thost\0\1\0\3\tname&Attach to running Neovim instance\frequest\vattach\ttype\tnlua\blua\19configurations\bdap\frequire\0" },
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/one-small-step-for-vimkind",
    url = "https://github.com/jbyuki/one-small-step-for-vimkind"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  playground = {
    commands = { "TSPlaygroundToggle" },
    load_after = {},
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/opt/playground",
    url = "https://github.com/nvim-treesitter/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/popup.nvim",
    url = "https://github.com/nvim-lua/popup.nvim"
  },
  ["sqlite.lua"] = {
    after = { "telescope-frecency.nvim" },
    loaded = true,
    only_config = true
  },
  ["suda.vim"] = {
    commands = { "SudaRead, SudaWrite" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/opt/suda.vim",
    url = "https://github.com/lambdalisue/suda.vim"
  },
  tabular = {
    after_files = { "/Users/REDACTED/.local/share/nvim/site/pack/packer/opt/tabular/after/plugin/TabularMaps.vim" },
    commands = { "Tabularize" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/opt/tabular",
    url = "https://github.com/godlygeek/tabular"
  },
  tagbar = {
    commands = { "TagbarToggle" },
    config = { "\27LJ\2\nl\0\0\6\0\a\0\t6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0005\5\6\0B\0\5\1K\0\1\0\1\0\1\fnoremap\2\26<cmd>TagbarToggle<CR>\t<F8>\6n\20nvim_set_keymap\bapi\bvim\0" },
    keys = { { "", "<F8>" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/opt/tagbar",
    url = "https://github.com/majutsushi/tagbar"
  },
  ["targets.vim"] = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/targets.vim",
    url = "https://github.com/wellle/targets.vim"
  },
  ["telescope-dap.nvim"] = {
    config = { "\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\bdap\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/opt/telescope-dap.nvim",
    url = "https://github.com/nvim-telescope/telescope-dap.nvim"
  },
  ["telescope-file-browser.nvim"] = {
    config = { "\27LJ\2\nQ\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\17file_browser\19load_extension\14telescope\frequire\0" },
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/telescope-file-browser.nvim",
    url = "https://github.com/nvim-telescope/telescope-file-browser.nvim"
  },
  ["telescope-frecency.nvim"] = {
    config = { "\27LJ\2\nM\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\rfrecency\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/opt/telescope-frecency.nvim",
    url = "https://github.com/nvim-telescope/telescope-frecency.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    config = { "\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\bfzf\19load_extension\14telescope\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/opt/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope.nvim"] = {
    after = { "telescope-dap.nvim", "telescope-fzf-native.nvim", "telescope-frecency.nvim" },
    loaded = true,
    only_config = true
  },
  ["tokyonight.nvim"] = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/tokyonight.nvim",
    url = "https://github.com/folke/tokyonight.nvim"
  },
  ["trouble.nvim"] = {
    after = { "gitsigns.nvim" },
    loaded = true,
    only_config = true
  },
  ultisnips = {
    config = { "\27LJ\2\nÃ\3\0\0\a\0\18\0$6\0\0\0009\0\1\0009\0\2\0\18\2\0\0009\0\3\0004\3\3\0006\4\0\0009\4\4\0049\4\5\4'\6\6\0B\4\2\2'\5\a\0&\4\5\4>\4\1\3B\0\3\0016\0\0\0009\0\b\0'\1\n\0=\1\t\0006\0\0\0009\0\b\0'\1\f\0=\1\v\0006\0\0\0009\0\b\0'\1\14\0=\1\r\0006\0\0\0009\0\b\0'\1\16\0=\1\15\0006\0\0\0009\0\b\0)\1\0\0=\1\17\0K\0\1\0&UltiSnipsRemoveSelectModeMappings\15<c-x><c-s>\26UltiSnipsListSnippets$<Plug>(ultisnips_jump_backward)!UltiSnipsJumpBackwardTrigger#<Plug>(ultisnips_jump_forward) UltiSnipsJumpForwardTrigger\29<Plug>(ultisnips_expand)\27UltiSnipsExpandTrigger\6g)/site/pack/packer/start/vim-snippets\tdata\fstdpath\afn\vappend\brtp\bopt\bvim\0" },
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/ultisnips",
    url = "https://github.com/SirVer/ultisnips"
  },
  ["unicode.vim"] = {
    commands = { "UnicodeName", "UnicodeTable", "UnicodeSearch" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/opt/unicode.vim",
    url = "https://github.com/chrisbra/unicode.vim"
  },
  ["vim-bbye"] = {
    commands = { "Bdelete" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/opt/vim-bbye",
    url = "https://github.com/moll/vim-bbye"
  },
  ["vim-easy-align"] = {
    commands = { "EasyAlign" },
    config = { "\27LJ\2\n=\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\30xmap ga <Plug>(EasyAlign)\bcmd\bvim\0" },
    keys = { { "", "x" }, { "", "ga" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/opt/vim-easy-align",
    url = "https://github.com/junegunn/vim-easy-align"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-indent-object"] = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/vim-indent-object",
    url = "https://github.com/michaeljsmith/vim-indent-object"
  },
  ["vim-matchup"] = {
    config = { "\27LJ\2\n¢\1\0\0\2\0\6\0\r6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0006\0\0\0009\0\1\0005\1\5\0=\1\4\0K\0\1\0\1\0\1\vmethod\npopup!matchup_matchparen_offscreen matchup_matchparen_deferred\28matchup_override_vimtex\6g\bvim\0" },
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/vim-matchup",
    url = "https://github.com/andymass/vim-matchup"
  },
  ["vim-mundo"] = {
    commands = { "MundoToggle" },
    config = { "\27LJ\2\nq\0\0\6\0\a\0\t6\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0005\5\6\0B\0\5\1K\0\1\0\1\0\1\fnoremap\2\25<cmd>MundoToggle<CR>\15<leader>mu\6n\20nvim_set_keymap\bapi\bvim\0" },
    keys = { { "", "<leader>mu" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/opt/vim-mundo",
    url = "https://github.com/simnalamburt/vim-mundo"
  },
  ["vim-pymol"] = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/vim-pymol",
    url = "https://github.com/jaredsampson/vim-pymol"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  ["vim-snippets"] = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/vim-snippets",
    url = "https://github.com/honza/vim-snippets"
  },
  ["vim-startuptime"] = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/vim-startuptime",
    url = "https://github.com/dstein64/vim-startuptime"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/vim-surround",
    url = "https://github.com/tpope/vim-surround"
  },
  ["vim-table-mode"] = {
    commands = { "TableModeToggle" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/opt/vim-table-mode",
    url = "https://github.com/dhruvasagar/vim-table-mode"
  },
  ["vim-test"] = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/vim-test",
    url = "https://github.com/vim-test/vim-test"
  },
  ["vim-ultest"] = {
    config = { "\27LJ\2\n.\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\19plugins.ultest\frequire\0" },
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/vim-ultest",
    url = "https://github.com/rcarriga/vim-ultest"
  },
  ["vim-zsh"] = {
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/vim-zsh",
    url = "https://github.com/chrisbra/vim-zsh"
  },
  vimux = {
    config = { "\27LJ\2\n‘\2\0\0\6\0\r\0\0216\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\0\0009\0\3\0009\0\4\0'\2\5\0'\3\6\0'\4\a\0005\5\b\0B\0\5\0016\0\0\0009\0\3\0009\0\4\0'\2\t\0'\3\n\0'\4\v\0005\5\f\0B\0\5\1K\0\1\0\1\0\1\fnoremap\2 <cmd>VimuxPromptCommand<CR>\15<leader>vp\6n\1\0\1\fnoremap\2\31\"vy :call VimuxSlime()<CR>\15<leader>vs\6x\20nvim_set_keymap\bapix            function! VimuxSlime()\n                call VimuxRunCommand(@v, 0)\n            endfunction\n            \bcmd\bvim\0" },
    loaded = true,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/start/vimux",
    url = "https://github.com/benmills/vimux"
  },
  ["vista.vim"] = {
    commands = { "Vista" },
    config = { "\27LJ\2\n-\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\18plugins.vista\frequire\0" },
    keys = { { "", "<leader>vv" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/REDACTED/.local/share/nvim/site/pack/packer/opt/vista.vim",
    url = "https://github.com/liuchengxu/vista.vim"
  }
}

time([[Defining packer_plugins]], false)
local module_lazy_loads = {
  ["^dapui"] = "nvim-dap-ui"
}
local lazy_load_called = {['packer.load'] = true}
local function lazy_load_module(module_name)
  local to_load = {}
  if lazy_load_called[module_name] then return nil end
  lazy_load_called[module_name] = true
  for module_pat, plugin_name in pairs(module_lazy_loads) do
    if not _G.packer_plugins[plugin_name].loaded and string.match(module_name, module_pat) then
      to_load[#to_load + 1] = plugin_name
    end
  end

  if #to_load > 0 then
    require('packer.load')(to_load, {module = module_name}, _G.packer_plugins)
    local loaded_mod = package.loaded[module_name]
    if loaded_mod then
      return function(modname) return loaded_mod end
    end
  end
end

if not vim.g.packer_custom_loader_enabled then
  table.insert(package.loaders, 1, lazy_load_module)
  vim.g.packer_custom_loader_enabled = true
end

-- Config for: vimux
time([[Config for vimux]], true)
try_loadstring("\27LJ\2\n‘\2\0\0\6\0\r\0\0216\0\0\0009\0\1\0'\2\2\0B\0\2\0016\0\0\0009\0\3\0009\0\4\0'\2\5\0'\3\6\0'\4\a\0005\5\b\0B\0\5\0016\0\0\0009\0\3\0009\0\4\0'\2\t\0'\3\n\0'\4\v\0005\5\f\0B\0\5\1K\0\1\0\1\0\1\fnoremap\2 <cmd>VimuxPromptCommand<CR>\15<leader>vp\6n\1\0\1\fnoremap\2\31\"vy :call VimuxSlime()<CR>\15<leader>vs\6x\20nvim_set_keymap\bapix            function! VimuxSlime()\n                call VimuxRunCommand(@v, 0)\n            endfunction\n            \bcmd\bvim\0", "config", "vimux")
time([[Config for vimux]], false)
-- Config for: hop
time([[Config for hop]], true)
try_loadstring("\27LJ\2\n+\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\16plugins.hop\frequire\0", "config", "hop")
time([[Config for hop]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\2\n+\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\16plugins.cmp\frequire\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)
-- Config for: telescope-file-browser.nvim
time([[Config for telescope-file-browser.nvim]], true)
try_loadstring("\27LJ\2\nQ\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\17file_browser\19load_extension\14telescope\frequire\0", "config", "telescope-file-browser.nvim")
time([[Config for telescope-file-browser.nvim]], false)
-- Config for: one-small-step-for-vimkind
time([[Config for one-small-step-for-vimkind]], true)
try_loadstring("\27LJ\2\nZ\0\0\3\0\6\0\n6\0\0\0009\0\1\0009\0\2\0'\2\3\0B\0\2\2\6\0\4\0X\1\1ÄL\0\2\0'\1\5\0L\1\2\0\014127.0.0.1\5\23Host [127.0.0.1]: \ninput\afn\bvimx\0\0\5\0\a\0\f6\0\0\0006\2\1\0009\2\2\0029\2\3\2'\4\4\0B\2\2\0A\0\0\0026\1\5\0\18\3\0\0'\4\6\0B\1\3\1L\0\2\0!Please provide a port number\vassert\vPort: \ninput\afn\bvim\rtonumber@\0\2\6\0\3\0\b\18\2\0\0005\4\0\0009\5\1\1=\5\1\0049\5\2\1=\5\2\4B\2\2\1K\0\1\0\tport\thost\1\0\1\ttype\vserverƒ\1\1\0\5\0\f\0\0166\0\0\0'\2\1\0B\0\2\0029\1\2\0004\2\3\0005\3\4\0003\4\5\0=\4\6\0033\4\a\0=\4\b\3>\3\1\2=\2\3\0019\1\t\0003\2\v\0=\2\n\1K\0\1\0\0\tnlua\radapters\tport\0\thost\0\1\0\3\tname&Attach to running Neovim instance\frequest\vattach\ttype\tnlua\blua\19configurations\bdap\frequire\0", "config", "one-small-step-for-vimkind")
time([[Config for one-small-step-for-vimkind]], false)
-- Config for: alpha-nvim
time([[Config for alpha-nvim]], true)
try_loadstring("\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22plugins.dashboard\frequire\0", "config", "alpha-nvim")
time([[Config for alpha-nvim]], false)
-- Config for: ultisnips
time([[Config for ultisnips]], true)
try_loadstring("\27LJ\2\nÃ\3\0\0\a\0\18\0$6\0\0\0009\0\1\0009\0\2\0\18\2\0\0009\0\3\0004\3\3\0006\4\0\0009\4\4\0049\4\5\4'\6\6\0B\4\2\2'\5\a\0&\4\5\4>\4\1\3B\0\3\0016\0\0\0009\0\b\0'\1\n\0=\1\t\0006\0\0\0009\0\b\0'\1\f\0=\1\v\0006\0\0\0009\0\b\0'\1\14\0=\1\r\0006\0\0\0009\0\b\0'\1\16\0=\1\15\0006\0\0\0009\0\b\0)\1\0\0=\1\17\0K\0\1\0&UltiSnipsRemoveSelectModeMappings\15<c-x><c-s>\26UltiSnipsListSnippets$<Plug>(ultisnips_jump_backward)!UltiSnipsJumpBackwardTrigger#<Plug>(ultisnips_jump_forward) UltiSnipsJumpForwardTrigger\29<Plug>(ultisnips_expand)\27UltiSnipsExpandTrigger\6g)/site/pack/packer/start/vim-snippets\tdata\fstdpath\afn\vappend\brtp\bopt\bvim\0", "config", "ultisnips")
time([[Config for ultisnips]], false)
-- Config for: trouble.nvim
time([[Config for trouble.nvim]], true)
try_loadstring("\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20plugins.trouble\frequire\0", "config", "trouble.nvim")
time([[Config for trouble.nvim]], false)
-- Config for: sqlite.lua
time([[Config for sqlite.lua]], true)
try_loadstring("\27LJ\2\nR\0\0\2\0\4\0\0056\0\0\0009\0\1\0'\1\3\0=\1\2\0K\0\1\0$/opt/local/lib/libsqlite3.dylib\21sqlite_clib_path\6g\bvim\0", "config", "sqlite.lua")
time([[Config for sqlite.lua]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22plugins.telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: nvim-dap
time([[Config for nvim-dap]], true)
try_loadstring("\27LJ\2\n*\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\15dap-config\frequire\0", "config", "nvim-dap")
time([[Config for nvim-dap]], false)
-- Config for: vim-ultest
time([[Config for vim-ultest]], true)
try_loadstring("\27LJ\2\n.\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\19plugins.ultest\frequire\0", "config", "vim-ultest")
time([[Config for vim-ultest]], false)
-- Config for: cmp-dictionary
time([[Config for cmp-dictionary]], true)
try_loadstring("\27LJ\2\nj\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\bdic\1\0\0\1\0\1\6*\26/usr/share/dict/words\nsetup\19cmp_dictionary\frequire\0", "config", "cmp-dictionary")
time([[Config for cmp-dictionary]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22treesitter-config\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: lspkind-nvim
time([[Config for lspkind-nvim]], true)
try_loadstring("\27LJ\2\n\\\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\2\tmode\16symbol_text\vpreset\rcodicons\tinit\flspkind\frequire\0", "config", "lspkind-nvim")
time([[Config for lspkind-nvim]], false)
-- Config for: fidget.nvim
time([[Config for fidget.nvim]], true)
try_loadstring("\27LJ\2\n8\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\vfidget\frequire\0", "config", "fidget.nvim")
time([[Config for fidget.nvim]], false)
-- Config for: Comment.nvim
time([[Config for Comment.nvim]], true)
try_loadstring("\27LJ\2\nZ\0\0\4\0\6\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\2B\0\2\1K\0\1\0\rmappings\1\0\0\1\0\1\rextended\2\nsetup\fComment\frequire\0", "config", "Comment.nvim")
time([[Config for Comment.nvim]], false)
-- Config for: nvim-web-devicons
time([[Config for nvim-web-devicons]], true)
try_loadstring("\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22nvim-web-devicons\frequire\0", "config", "nvim-web-devicons")
time([[Config for nvim-web-devicons]], false)
-- Config for: vim-matchup
time([[Config for vim-matchup]], true)
try_loadstring("\27LJ\2\n¢\1\0\0\2\0\6\0\r6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0006\0\0\0009\0\1\0005\1\5\0=\1\4\0K\0\1\0\1\0\1\vmethod\npopup!matchup_matchparen_offscreen matchup_matchparen_deferred\28matchup_override_vimtex\6g\bvim\0", "config", "vim-matchup")
time([[Config for vim-matchup]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\2\n.\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\19lsp.lsp-config\frequire\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)
-- Config for: FTerm.nvim
time([[Config for FTerm.nvim]], true)
try_loadstring("\27LJ\2\n[\0\1\6\0\a\0\v6\1\0\0'\3\1\0B\1\2\0029\1\2\0016\3\3\0009\3\4\0039\3\5\0039\5\6\0B\3\2\0A\1\0\1K\0\1\0\targs\14expandcmd\afn\bvim\brun\nFTerm\frequireú\2\1\0\6\0\14\0\0246\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\4\0'\4\5\0005\5\6\0B\0\5\0016\0\0\0009\0\1\0009\0\a\0'\2\b\0003\3\t\0005\4\n\0B\0\4\0016\0\0\0009\0\1\0009\0\2\0'\2\3\0'\3\v\0'\4\f\0005\5\r\0B\0\5\1K\0\1\0\1\0\1\fnoremap\2\15:FTermRun \15<leader>tr\1\0\2\rcomplete\rshellcmd\nnargs\6*\0\rFTermRun\26nvim_add_user_command\1\0\1\fnoremap\2)<cmd>lua require'FTerm'.toggle()<CR>\15<leader>tt\6n\20nvim_set_keymap\bapi\bvim\0", "config", "FTerm.nvim")
time([[Config for FTerm.nvim]], false)
-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
try_loadstring("\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22plugins.nvim-tree\frequire\0", "config", "nvim-tree.lua")
time([[Config for nvim-tree.lua]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd nvim-treesitter-textobjects ]]
vim.cmd [[ packadd nvim-treesitter-textsubjects ]]
vim.cmd [[ packadd nvim-gps ]]

-- Config for: nvim-gps
try_loadstring("\27LJ\2\n_\0\1\6\0\6\0\n6\1\0\0009\1\1\0019\1\2\0019\1\3\0018\2\0\0018\2\2\1\18\4\2\0009\2\4\2'\5\5\0D\2\3\0\n^.*%s\nmatch\23CompletionItemKind\rprotocol\blsp\bvim‚\1\1\0\b\0\15\0\0263\0\0\0006\1\1\0'\3\2\0B\1\2\0029\1\3\0015\3\r\0005\4\5\0\18\5\0\0'\a\4\0B\5\2\2=\5\6\4\18\5\0\0'\a\a\0B\5\2\2=\5\b\4\18\5\0\0'\a\t\0B\5\2\2=\5\n\4\18\5\0\0'\a\v\0B\5\2\2=\5\f\4=\4\14\3B\1\2\1K\0\1\0\nicons\1\0\0\19container-name\tEnum\16method-name\vMethod\18function-name\rFunction\15class-name\1\0\0\nClass\nsetup\rnvim-gps\frequire\0\0", "config", "nvim-gps")

vim.cmd [[ packadd nvim-dap-virtual-text ]]

-- Config for: nvim-dap-virtual-text
try_loadstring("\27LJ\2\n„\1\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\t\15virt_lines\1\15all_frames\1\18virt_text_pos\beol\14commented\1\21show_stop_reason\2\29highlight_new_as_changed\2 highlight_changed_variables\2\21enabled_commands\2\fenabled\2\nsetup\26nvim-dap-virtual-text\frequire\0", "config", "nvim-dap-virtual-text")

vim.cmd [[ packadd telescope-fzf-native.nvim ]]

-- Config for: telescope-fzf-native.nvim
try_loadstring("\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\bfzf\19load_extension\14telescope\frequire\0", "config", "telescope-fzf-native.nvim")

vim.cmd [[ packadd telescope-dap.nvim ]]

-- Config for: telescope-dap.nvim
try_loadstring("\27LJ\2\nH\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\bdap\19load_extension\14telescope\frequire\0", "config", "telescope-dap.nvim")

vim.cmd [[ packadd telescope-frecency.nvim ]]

-- Config for: telescope-frecency.nvim
try_loadstring("\27LJ\2\nM\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0B\0\2\1K\0\1\0\rfrecency\19load_extension\14telescope\frequire\0", "config", "telescope-frecency.nvim")

vim.cmd [[ packadd null-ls.nvim ]]

-- Config for: null-ls.nvim
try_loadstring("\27LJ\2\n+\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\16lsp.null-ls\frequire\0", "config", "null-ls.nvim")

time([[Sequenced loading]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Neogen lua require("packer.load")({'neogen'}, { cmd = "Neogen", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TagbarToggle lua require("packer.load")({'tagbar'}, { cmd = "TagbarToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Tabularize lua require("packer.load")({'tabular'}, { cmd = "Tabularize", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TableModeToggle lua require("packer.load")({'vim-table-mode'}, { cmd = "TableModeToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file EasyAlign lua require("packer.load")({'vim-easy-align'}, { cmd = "EasyAlign", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file MundoToggle lua require("packer.load")({'vim-mundo'}, { cmd = "MundoToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file UnicodeName lua require("packer.load")({'unicode.vim'}, { cmd = "UnicodeName", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[au CmdUndefined SudaRead, SudaWrite ++once lua require"packer.load"({'suda.vim'}, {}, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file CSVInit lua require("packer.load")({'csv.vim'}, { cmd = "CSVInit", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Vista lua require("packer.load")({'vista.vim'}, { cmd = "Vista", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file UnicodeTable lua require("packer.load")({'unicode.vim'}, { cmd = "UnicodeTable", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file UnicodeSearch lua require("packer.load")({'unicode.vim'}, { cmd = "UnicodeSearch", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TSPlaygroundToggle lua require("packer.load")({'playground'}, { cmd = "TSPlaygroundToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Bdelete lua require("packer.load")({'vim-bbye'}, { cmd = "Bdelete", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

-- Keymap lazy-loads
time([[Defining lazy-load keymaps]], true)
vim.cmd [[noremap <silent> ga <cmd>lua require("packer.load")({'vim-easy-align'}, { keys = "ga", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <F8> <cmd>lua require("packer.load")({'tagbar'}, { keys = "<lt>F8>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <leader>vv <cmd>lua require("packer.load")({'vista.vim'}, { keys = "<lt>leader>vv", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <leader>mu <cmd>lua require("packer.load")({'vim-mundo'}, { keys = "<lt>leader>mu", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> x <cmd>lua require("packer.load")({'vim-easy-align'}, { keys = "x", prefix = "" }, _G.packer_plugins)<cr>]]
time([[Defining lazy-load keymaps]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType python ++once lua require("packer.load")({'nvim-dap-python', 'SimpylFold'}, { ft = "python" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au InsertCharPre * ++once lua require("packer.load")({'nvim-autopairs'}, { event = "InsertCharPre *" }, _G.packer_plugins)]]
vim.cmd [[au VimEnter * ++once lua require("packer.load")({'nvim-bufferline.lua'}, { event = "VimEnter *" }, _G.packer_plugins)]]
vim.cmd [[au BufEnter * ++once lua require("packer.load")({'nvim-colorizer.lua', 'gitsigns.nvim', 'indent-blankline.nvim'}, { event = "BufEnter *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
