vim.g.loaded_python3_provider = 0
vim.g.loaded_python_provider = 0

vim.o.termguicolors = true
vim.g.vimsyn_embed = "lPr"
vim.g.tex_flavor = "latex"
vim.o.encoding = "utf-8"
vim.o.modeline = true
vim.o.mouse = "a"
vim.o.errorbells = false
vim.o.visualbell = false
vim.o.history = 1000
vim.o.undolevels = 1000
vim.o.title = true
vim.o.backup = false
vim.o.swapfile = false
vim.o.undofile = true
vim.o.wrap = true
vim.o.tabstop = 4
vim.o.shiftwidth = vim.o.tabstop
vim.o.shiftround = true
vim.o.expandtab = true
vim.o.backspace = "indent,eol,start"
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.copyindent = true
vim.o.number = true
vim.o.showmatch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.smarttab = true
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.hidden = true
vim.o.wildignore = "*.swp,*.bak,*.pyc,*.class"
vim.o.wildmode = "longest,full"
vim.o.wildmenu = true
vim.opt.wildoptions:append({ "pum" })
vim.o.wildcharm = 26
vim.o.wildignorecase = true
vim.o.showcmd = true
vim.o.sidescroll = 1
vim.o.conceallevel = 2
vim.o.pumheight = 15

vim.opt.fillchars:append({
  fold = " ",
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┨",
  vertright = "┣",
  verthoriz = "╋",
})

vim.opt.fillchars:append({ foldopen = "▾", foldsep = "│", foldclose = "▸" })

vim.o.inccommand = "nosplit"
vim.o.showmode = false
vim.o.cmdheight = 1
vim.o.updatetime = 250
vim.o.synmaxcol = 300
vim.o.redrawtime = 1500
vim.opt.shortmess:append({ c = true })
vim.o.showbreak = "↪ "
vim.o.listchars = "tab:|.,trail:_,extends:>,precedes:<,nbsp:~,eol:¬"
vim.o.signcolumn = "yes"
vim.o.splitbelow = true
vim.o.splitright = true

vim.o.dictionary = "/usr/share/dict/words"

function _G.CustomFoldText()
  return vim.fn.getline(vim.v.foldstart) .. " ... " .. vim.fn.getline(vim.v.foldend):gsub("^%s*", "")
end

vim.opt.foldtext = "v:lua.CustomFoldText()"

vim.g.copilot_no_tab_map = true
vim.cmd([[imap <silent><script><expr> <C-j> copilot#Accept("\<CR>")]])

vim.opt.clipboard:append("unnamedplus")
